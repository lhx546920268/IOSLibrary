//
//  SeaImageCacheTool.m
//  Sea
//
//
//

#import "SeaImageCacheTool.h"
#import "SeaURLConnection.h"
#import "SeaFileManager.h"
#import "SeaBasic.h"
#import "SeaMovieCacheTool.h"

//图片文件后缀
static NSString *const SeaImageCacheToolImageJPGType = @"jpg";

//缓存的文件夹
#define _cahceImageDirectory_ @"cacheImage"


@interface SeaImageCacheTool ()<SeaURLConnectionDelegate>
{
    //获取图片队列
    dispatch_queue_t _cacheQueue;
    
    //正在下载的请求 key是 url value是 SeaURLConnection对象
    NSMutableDictionary *_downloadProgressDic;
    
    //文件管理器,不能在其他线程中使用defaultManager
    NSFileManager *_fileManager;
}

//下载队列
@property(nonatomic,strong) NSOperationQueue *queue;

///失败的URL 数组元素是 NSString
@property(nonatomic,strong) NSMutableSet *badURLs;

@end

@implementation SeaImageCacheTool

- (id)init
{
    self = [super init];
    if(self)
    {
        self.timeoutSeconds = 25.0;
        
        _cacheQueue = dispatch_queue_create("cacheImage", DISPATCH_QUEUE_CONCURRENT);
        
        _fileManager = [[NSFileManager alloc] init];
        _cachePath = [[self getCachePath] copy];
        
        _downloadProgressDic = [[NSMutableDictionary alloc] init];
        
        _diskCacheExpirationTimeInterval = 60 * 60 * 24 * 7;
        
        self.badURLs = [NSMutableSet set];
        self.queue = [[NSOperationQueue alloc] init];
        self.queue.maxConcurrentOperationCount = 6;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        
        //添加进入后台和程序终止通知，用于清除已经过时的缓存文件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

#pragma mark- single instance

/**单例
 */
+ (SeaImageCacheTool*)sharedInstance
{
    static dispatch_once_t pred = 0;
    static SeaImageCacheTool *tool = nil;
    
    dispatch_once(&pred, ^{
        tool = [[SeaImageCacheTool alloc] init];
    });
    
    return tool;
}

//连你圈内存图片
+ (NSCache*) defaultCache
{
    static NSCache *cache = nil;
    if(cache == nil)
    {
        cache = [[NSCache alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            
            [cache removeAllObjects];
        }];
    }
    
    return cache;
}

#pragma mark- 通知

///收到内存警告
- (void)receiveMemoryWarning:(NSNotification*) notification
{
    [_downloadProgressDic removeAllObjects];
    [self.queue cancelAllOperations];
    
    if([self.delegate respondsToSelector:@selector(imageCacheToolDidReceiveMemoryWarning:)])
    {
        [self.delegate imageCacheToolDidReceiveMemoryWarning:self];
    }
}

///程序进入后台
- (void)applicationDidEnterBackground:(NSNotification*) notification
{
    UIApplication *application = [UIApplication sharedApplication];
    
    //使用后台长时间任务
    __block UIBackgroundTaskIdentifier taskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void){
       
        [application endBackgroundTask:taskIdentifier];
    }];
    
    if(taskIdentifier != UIBackgroundTaskInvalid)
    {
        [self clearExpirationCacheImageWithCompletion:^(void){
           
            [application endBackgroundTask:taskIdentifier];
        }];
    }
}

///程序将关闭
- (void)applicationWillTerminate:(NSNotification*) notification
{
    [self clearExpirationCacheImageWithCompletion:nil];
}

#pragma mark- dealloc

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_cacheQueue);
    dispatch_release(_getImageQueue);
#endif

    [_queue cancelAllOperations];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- cancel

/**取消相关下载
 *@param urls 数组元素是url, NSString 对象
 */
- (void)cancelDownloadWithURLs:(NSArray*) urls
{
    for(NSString *url in urls)
    {
        SeaImageCacheToolOperation *operation = [_downloadProgressDic objectForKey:url];
        if(operation != nil)
        {
            operation.requirements = nil;
            [operation.conn cancel];
            [_downloadProgressDic removeObjectForKey:url];
        }
    }
}


/**取消单个下载
 *@param url 正在请求的url
 *@param target 下载图片的对象，如UIImageView
 */
- (void)cancelDownloadWithURL:(NSString *)url target:(id) target
{
    if([NSString isEmpty:url])
        return;

    SeaImageCacheToolOperation *operation = [_downloadProgressDic objectForKey:url];
    if(operation != nil)
    {
        SeaImageCacheToolRequirement *requirement = nil;
        for(SeaImageCacheToolRequirement *req in operation.requirements)
        {
            if([req.target isEqual:target])
            {
                requirement = req;
                break;
            }
        }
        
        requirement.completion = nil;
        if(requirement != nil)
        {
            [operation.requirements removeObject:requirement];
        }
        if(operation.requirements.count == 0)
        {
            [operation.conn cancel];
            [_downloadProgressDic removeObjectForKey:url];
        }
    }
}

/**添加下载完成回调
 *@param completion 下载完成回调
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 *@param target 下载图片的对象，如UIImageView
 *@param url 图片路径
 */
- (void)addCompletion:(SeaImageCacheToolCompletionHandler) completion thumbnailSize:(CGSize) size target:(id) target forURL:(NSString*) url
{
    if([NSString isEmpty:url] || completion == nil)
        return;

    SeaImageCacheToolOperation *operation = [_downloadProgressDic objectForKey:url];
    if(operation != nil)
    {
        SeaImageCacheToolRequirement *req = [[SeaImageCacheToolRequirement alloc] init];
        req.completion = completion;
        req.thumbnailSize = size;
        req.target = target;
        [operation.requirements addObject:req];
    }
}

/**添加下载进度回调
 *@param progressHandler 进度回调
 *@param url 图片路径
 *@param target 下载图片的对象，如UIImageView
 */
- (void)addProgressHandler:(SeaImageCacheToolProgressHandler) progressHandler forURL:(NSString *)url target:(id) target
{
    if([NSString isEmpty:url] || progressHandler == nil)
        return;
    
    SeaImageCacheToolOperation *operation = [_downloadProgressDic objectForKey:url];
    if(operation != nil)
    {
        operation.conn.showDownloadProgress = YES;
        for(SeaImageCacheToolRequirement *req in operation.requirements)
        {
            if([req.target isEqual:target])
            {
                req.progressHandler = progressHandler;
                break;
            }
        }
    }
}

/**相关下载是否正在进行中
 *@param url 正在请求的url
 */
- (BOOL)isRequestingWithURL:(NSString*) url
{
    return [_downloadProgressDic objectForKey:url] != nil;
}

#pragma mark- SeaURLConnection delegate

//下载完成
- (void)connectionDidFinishLoading:(SeaURLConnection *)conn
{
    dispatch_async(_cacheQueue, ^(void){
        
        NSString *url = conn.URL;
        
        NSData *data = conn.responseData;
        
        UIImage *image = [UIImage imageWithData:data];
        if(!image && conn.downloadDestinationPath)
        {
            [SeaFileManager deleteOneFile:conn.downloadDestinationPath];
        }
        
        ///链接不是图片
        if(!image)
        {
            @synchronized (self.badURLs)
            {
                [self.badURLs addObject:url];
            }
        }
        
        [self executeWithImage:image url:url fromNetwork:NO];
    });
}

//下载失败
- (void)connectionDidFail:(SeaURLConnection *)conn
{
    ///添加无效的URL，防止继续加载
    if(conn.errorCode != NSURLErrorCancelled
       && conn.errorCode != NSURLErrorTimedOut
       && conn.errorCode != NSURLErrorCannotFindHost
       && conn.errorCode != NSURLErrorCannotConnectToHost
       && conn.errorCode != NSURLErrorNetworkConnectionLost
       && conn.errorCode != NSURLErrorNotConnectedToInternet
       && conn.errorCode != NSURLErrorDataNotAllowed
       && conn.errorCode != NSURLErrorInternationalRoamingOff)
    {
        @synchronized (self.badURLs)
        {
            [self.badURLs addObject:conn.URL];
        }
    }
    
    NSString *url = conn.URL;
    [self executeWithImage:nil url:url fromNetwork:NO];
}

- (void)connectionDidUpdateProgress:(SeaURLConnection *)conn
{
    NSString *url = conn.URL;
    
    SeaImageCacheToolOperation *operation = [_downloadProgressDic objectForKey:url];
    for(SeaImageCacheToolRequirement *req in operation.requirements)
    {
        if(req.progressHandler != nil)
        {
            req.progressHandler(conn.downloadProgress);
        }
    }
}

#pragma mark- private method

//MD5 处理url
- (NSString*)pathForURL:(NSString*) url
{
    NSString *fileName = [SeaFileManager fileNameForURL:url suffix:SeaImageCacheToolImageJPGType];
    
    return [self.cachePath stringByAppendingPathComponent:fileName];
}

/**缩略图在内存中的key
 */
- (NSString*)thumbnailKeyInMemoryForURL:(NSString*) url size:(CGSize) size
{
    url = [url stringByAppendingFormat:@"-w%.f-h%.f", size.width, size.height];
    
    return url;
}

//执行图片加载完回调
- (void)executeWithImage:(UIImage*) image url:(NSString*) url fromNetwork:(BOOL) fromNetwork
{
    if(!url)
        return;
    dispatch_main_async_safe(^(void){
        
        SeaImageCacheToolOperation *operation = [_downloadProgressDic objectForKey:url];
        if(operation != nil)
        {
            for(SeaImageCacheToolRequirement *req in operation.requirements)
            {
                if(image)
                {
                    UIImage *ret = [self imageFromMemoryWithURL:url thumbnailSize:req.thumbnailSize];
                    if(ret == nil)
                    {
                        ret = [self cacheImage:image thumbnailSize:req.thumbnailSize forURL:url];
                    }
                    
                    req.completion(ret, fromNetwork);
                }
                else
                {
                    NSLog(@"%@  图片读取失败", url);
                    req.completion(nil,fromNetwork);
                }
            }
        }
        [_downloadProgressDic removeObjectForKey:url];
    });
}

#pragma mark- 获取图片

/**下载图片
 *@param url 图片路径
 */
- (void)downloadImageWithURL:(NSString*) url
{
    SeaURLRequest *request = [SeaURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData imeoutInterval:self.timeoutSeconds];
    
    SeaURLConnection *conn = [[SeaURLConnection alloc] initWithDelegate:self request:request];
    
    SeaImageCacheToolOperation *operation = [_downloadProgressDic objectForKey:url];
    
    operation.conn = conn;
  
    conn.downloadTemporayPath = [SeaFileManager getTemporaryFile];
    conn.downloadDestinationPath = [self pathForURL:url];
 
    [self.queue addOperation:conn];
}

/**通过图片路径获取本地缓存图片，如果没有则返回nil
 *@param url 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 */
- (UIImage*)imageFromCacheWithURL:(NSString*) url thumbnailSize:(CGSize) size
{
    NSString *imagePath = nil;
    NSString *thumbnailKey = nil;
    
    UIImage *image = nil;
    
    imagePath = [self pathForURL:url];
    //判断是否使用缩略图
    if(!CGSizeEqualToSize(size, CGSizeZero))
    {
        thumbnailKey = [self thumbnailKeyInMemoryForURL:url size:size];
    }
    
    //获取本地缓存图片
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:imagePath options:NSDataReadingUncached error:&error];
    
    if(data == nil)
        return image;
    
    image = [UIImage imageWithData:data];
    
    //使用缩略图
    if(thumbnailKey)
    {
        //生成缩略图
        image = [image aspectFillThumbnailWithSize:size];
    }
    
    //保存在内存
    if(image)
    {
        NSCache *cache = [SeaImageCacheTool defaultCache];
        if(thumbnailKey)
        {
            [cache setObject:image forKey:thumbnailKey];
        }
        else if(imagePath)
        {
            [cache setObject:image forKey:url];
        }
    }
    
    return image;
}

/**通过图片路径获取内存图片，如果没有则返回nil
 *@param url 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 */
- (UIImage*)imageFromMemoryWithURL:(NSString*) url thumbnailSize:(CGSize) size
{
    NSCache *cache = [SeaImageCacheTool defaultCache];
    NSString *key = url;
    
    //判断是否使用缩略图
    if(!CGSizeEqualToSize(size, CGSizeZero))
    {
        key = [self thumbnailKeyInMemoryForURL:url size:size];
    }
    
    return [cache objectForKey:key];
}

/**获取图片 先在内存中获取，没有则在缓存文件中查找，没有才通过http请求下载图片
 *@param url 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不使用缩略图
 *@param completion 图片加载完成回调
 *@param target 下载图片的对象，如UIImageView
 */
- (void)getImageWithURL:(NSString*) url thumbnailSize:(CGSize) size completion:(SeaImageCacheToolCompletionHandler) completion target:(id) target
{
    if([NSString isEmpty:url] || [_downloadProgressDic objectForKey:url])
        return;
    
    ///无效的URL不重新加载
    @synchronized (self.badURLs)
    {
        if([self.badURLs containsObject:url])
        {
            !completion ?: completion(nil, NO);
            return;
        }
    }
    
    SeaImageCacheToolOperation *operation = [[SeaImageCacheToolOperation alloc] init];
    SeaImageCacheToolRequirement *requirement = [[SeaImageCacheToolRequirement alloc] init];
    requirement.thumbnailSize = size;
    requirement.completion = completion;
    requirement.target = target;
    [operation.requirements addObject:requirement];
    
    [_downloadProgressDic setObject:operation forKey:url];
    
    dispatch_async(_cacheQueue, ^(void){

        NSString *imagePath = [self pathForURL:url];
        
        //获取本地缓存图片
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:imagePath options:NSDataReadingUncached error:&error];

        UIImage *image = [UIImage imageWithData:data];
        if(image)
        {
            [self executeWithImage:image url:url fromNetwork:NO];
        }
        else
        {
            //从网络上加载
            [self downloadImageWithURL:url];
        }
    });
}

/**缓存图片
 *@param image 要缓存的图片
 *@param url 图片路径
 *@param size 缩略图大小，如果值为CGSizeZero 表明不缓存缩略图
 *@param flag 是否需要保存到内存中
 *@return 如果保存在内存，则返回对应的图片，否则返回nil
 */
- (UIImage*)cacheImage:(UIImage*) image withURL:(NSString*) url thumbnailSize:(CGSize) size saveToMemory:(BOOL) flag
{
    if(image == nil || [NSString isEmpty:url])
        return nil;
    
    UIImage *ret = nil;
    if(flag)
    {
       ret = [self cacheImage:image thumbnailSize:size forURL:url];
    }
    
    dispatch_block_t block = ^(void)
    {
        NSString *imagePath = [self pathForURL:url];
        
        //获取图片的透明通道，判断图片是否是png
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(image.CGImage);
        BOOL imageIsPng = !(alphaInfo == kCGImageAlphaNone ||
                                           alphaInfo == kCGImageAlphaNoneSkipFirst ||
                                           alphaInfo == kCGImageAlphaNoneSkipLast);
        
        NSData *data = nil;
        //缓存原图
        if(imageIsPng)
        {
            data = UIImagePNGRepresentation(image);
        }
        else
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
        [_fileManager createFileAtPath:imagePath contents:data attributes:nil];
    };
    
    dispatch_async(_cacheQueue, block);
    
    return ret;
}

/**缓存图片文件
 *@param imageFile 要缓存的图片文件
 *@param url 图片路径
 */
- (void)cacheImageFile:(NSString*) imageFile withURL:(NSString*) url
{
    if(![imageFile isKindOfClass:[NSString class]] || [NSString isEmpty:url])
        return;
    
    
    dispatch_block_t block = ^(void)
    {
        NSString *imagePath = [self pathForURL:url];
        [_fileManager moveItemAtPath:imageFile toPath:imagePath error:nil];
    };
    
    dispatch_async(_cacheQueue, block);
}

/**保存图片到内存
 *@param image 要保存的图片
 *@param size 缩略图大小
 *@param url 图片路径
 *@return 保存后的图片
 */
- (UIImage*)cacheImage:(UIImage*) image thumbnailSize:(CGSize) size forURL:(NSString*) url
{
     NSCache *cache = [SeaImageCacheTool defaultCache];
    if(!CGSizeEqualToSize(size, CGSizeZero))
    {
        //缓存缩略图
        url = [self thumbnailKeyInMemoryForURL:url size:size];
        
        UIImage *thumbnail = [image aspectFillThumbnailWithSize:size];
        
        
        if(thumbnail)
        {
            [cache setObject:thumbnail forKey:url];
        }
        image = thumbnail;
    }
    else
    {
        [cache setObject:image forKey:url];
    }
    
    return image;
}

/**保存图片到本地
 *@param imageData 要缓存的图片数据
 *@path 缓存路径
 */
- (void)cacheImageData:(NSData*) imageData withPath:(NSString*) path
{
    if(imageData.length == 0)
        return;
    
    dispatch_block_t block = ^(void)
    {
        [_fileManager createFileAtPath:path contents:imageData attributes:nil];
    };
    
    dispatch_async(_cacheQueue, block);
}

/**获取图片缓存文件路径
 *@return 图片缓存路径
 */
- (NSString*)getCachePath
{
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *circle = [cache stringByAppendingPathComponent:_cahceImageDirectory_];
    
    BOOL isDir;
    BOOL exist = [_fileManager fileExistsAtPath:circle isDirectory:&isDir];
    
    // NSLog(@"%@ 存在%d,%d", circle, exist, isDir);
    
    if(!(exist && isDir))
    {
        NSError *error = nil;
        if(![_fileManager createDirectoryAtPath:circle withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"创建缓存文件夹失败 %@",error);
            return nil;
        }
    }
    
    return circle;
}

#pragma mark- clear cache

/**删除图片缓存
 *@param urls 数组元素是 网络图片路径 NSString对象
 */
- (void)removeCacheImageWithURL:(NSArray*) urls
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        for(NSString *url in urls)
        {
            NSString *imagePath = [self pathForURL:url];
            if(imagePath)
            {
                [_fileManager removeItemAtPath:imagePath error:nil];
            }
            NSCache *cache = [SeaImageCacheTool defaultCache];
            [cache removeObjectForKey:url];
        }
    });
}


/**清除所有的缓存图片
 *@param completion 清除完成回调
 */

- (void)clearCacheImageWithCompletion:(void (^)(void))completion
{
    dispatch_block_t block = ^(void)
    {
        NSError *error = nil;
        
        [[SeaMovieCacheTool sharedInstance] clearMovieCacheWithCompletion:nil];
        
        NSString *path = [[SeaImageCacheTool sharedInstance] getCachePath];
        [_fileManager removeItemAtPath:path error:&error];
        
        if(error)
        {
            NSLog(@"清空缓存图片失败");
        }
        
        //重新创建缓存文件夹
        [self getCachePath];
        
        if(completion)
        {
            dispatch_main_async_safe(completion);
        }
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

/**清除已过期的缓存图片
 *@param completion 清除完成回调
 */
- (void)clearExpirationCacheImageWithCompletion:(void(^)(void)) completion
{
    dispatch_block_t block = ^(void)
    {
        NSError *error = nil;

        NSString *path = [[SeaImageCacheTool sharedInstance] getCachePath];
        
        NSArray *resourceKeys = [NSArray arrayWithObjects:NSURLContentModificationDateKey, nil];
        NSDirectoryEnumerator *enumerator = [_fileManager enumeratorAtURL:[NSURL fileURLWithPath:path isDirectory:YES] includingPropertiesForKeys:resourceKeys options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
        
        
        //要删除的图片
        NSMutableArray *urlsToDelete = [NSMutableArray array];
        
        //过期时间
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:- _diskCacheExpirationTimeInterval];
        
        //获取已过期的图片
        for(NSURL *url in enumerator)
        {
            NSDictionary *dic = [url resourceValuesForKeys:resourceKeys error:nil];
           // NSLog(@"%@", url);
            
            if([[expirationDate laterDate:[dic objectForKey:NSURLContentModificationDateKey]] isEqualToDate:expirationDate])
            {
                [urlsToDelete addObject:url];
            }
        }
        
        NSLog(@"begin delete");
        //删除已过期的图片
        for(NSURL *url in urlsToDelete)
        {
          //  NSLog(@"%@", url);
            [_fileManager removeItemAtURL:url error:nil];
        }
        
        if(error)
        {
            NSLog(@"清空缓存图片失败");
        }
        
        if(completion)
        {
            dispatch_main_async_safe(completion);
        }
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

#pragma mark- 计算缓存大小

/**计算缓存大小
 *@param completion 计算完成回调 size,缓存大小，字节
 */
- (void)caculateCacheSizeWithCompletion:(void(^)(unsigned long long size)) completion
{
    dispatch_block_t block = ^(void)
    {
        NSString *path = [[SeaImageCacheTool sharedInstance] getCachePath];

        unsigned long long fileSize = 0;
        
        
        if([_fileManager fileExistsAtPath:path])
        {
            NSArray *subPaths = [_fileManager subpathsAtPath:path];
            
            for(NSString *subPath in subPaths)
            {
                NSDictionary *dic = [_fileManager attributesOfItemAtPath:[path stringByAppendingPathComponent:subPath] error:nil];

                fileSize += [dic fileSize];
            }
        }
        
        NSLog(@"缓存大小%lld", fileSize);
        
        if(completion)
        {
            dispatch_main_async_safe(^(void)
            {
                completion(fileSize);
            });
        }
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}


#pragma mark- Class method

/**把字节格式化
 *@param bytes 要格式化的字节
 *@return 大小字符串，如 1.1M
 */
+ (NSString*)formatBytes:(long long) bytes
{
    if(bytes > 1024)
    {
        long long kb = bytes / 1024;
        if(kb > 1024)
        {
            long long mb = kb / 1024;
            if(mb > 1024)
            {
                long long gb = mb / 1024;
                if(gb > 1024)
                {
                    return [NSString stringWithFormat:@"%0.2LfT", (long double)gb / 1024.0];
                }
                else
                {
                    return [NSString stringWithFormat:@"%0.2LfG", (long double)mb / 1024.0];
                }
            }
            else
            {
                return [NSString stringWithFormat:@"%0.2LfM", (long double)kb / 1024.0];
            }
        }
        else
        {
            return [NSString stringWithFormat:@"%lldK", kb];
        }
    }
    else
    {
        return [NSString stringWithFormat:@"%lld字节", bytes];
    }
}

@end
