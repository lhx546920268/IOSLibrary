//
//  SeaImageCacheTool.m
//  Sea
//
//
//

#import "SeaImageCacheTool.h"
#import "SeaURLSessionManager.h"
#import "SeaHttpTaskDelegate.h"
#import "SeaFileManager.h"
#import "SeaBasic.h"
#import "SeaMovieCacheTool.h"
#import "SeaHttpTask.h"
#import "NSString+Utils.h"
#import "UIImage+Utils.h"
#import "SeaImageCacheTask.h"
#import "SeaMovieCacheTool.m"

//图片文件后缀
static NSString *const SeaImageCacheToolImageJPG = @"jpg";

//缓存的文件夹
static NSString *const SeaImageCacheDirectory @"SeaImageCache";


@interface SeaImageCacheTool ()<SeaHttpTaskDelegate>
{
    //获取图片队列
    dispatch_queue_t _cacheQueue;
    
    //文件管理器,不能在其他线程中使用defaultManager
    NSFileManager *_fileManager;
}

//下载队列
@property(nonatomic,strong) SeaURLSessionManager *sessionManager;

///失败的URL
@property(nonatomic,strong) NSMutableSet<NSString*> *badURLs;

///正在下载的任务
@property(nonatomic,strong) NSMutableDictionary<NSString*, SeaImageCacheTask*> *downloadTasks;

@end

@implementation SeaImageCacheTool

- (id)init
{
    self = [super init];
    if(self)
    {
        _cacheQueue = dispatch_queue_create("SeaImageCahce", DISPATCH_QUEUE_CONCURRENT);
        
        _fileManager = [[NSFileManager alloc] init];
        _cachePath = [[self getCachePath] copy];
        
        self.sessionManager = [[SeaURLSessionManager alloc] initWithConfiguration:[self defaultURLSessionConfiguration]];
        
        self.downloadTasks = [NSMutableDictionary dictionary];
        
        _diskCacheExpirationTimeInterval = 60 * 60 * 24 * 7;
        
        self.badURLs = [NSMutableSet set];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMemoryWarning:) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        
        
        //添加进入后台和程序终止通知，用于清除已经过时的缓存文件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    }
    return self;
}

//默认配置
- (NSURLSessionConfiguration*)defaultURLSessionConfiguration
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.requestCachePolicy = NSURLRequestUseProtocolCachePolicy;
    configuration.timeoutIntervalForRequest = 30;
    configuration.timeoutIntervalForResource = 30;
    configuration.networkServiceType = NSURLNetworkServiceTypeDefault;
    configuration.allowsCellularAccess = YES;
    configuration.HTTPShouldSetCookies = NO;
    configuration.HTTPShouldUsePipelining = NO;
    
    return configuration;
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

//内存图片
+ (NSCache<NSString*,UIImage*>*)defaultCache
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
    [self cancelAllTasks];
    
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

    [self cancelAllTasks];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- cancel

- (void)cancelDownloadForURLs:(NSArray<NSString*>*) URLs
{
    for(NSString *URL in URLs){
        SeaImageCacheTask *task = [self.downloadTasks objectForKey:URL];
        if(task){
            [task.downloadTask cancel];
            [self.downloadTasks removeObjectForKey:URL];
        }
    }
}

- (void)cancelDownloadForURL:(NSString *)URL target:(id) target
{
    if([NSString isEmpty:URL])
        return;

    SeaImageCacheTask *task = [self.downloadTasks objectForKey:URL];
    if(task){
        SeaImageCacheHandler *handler = nil;
        for(SeaImageCacheHandler *tmp in task.handlers){
            if([tmp.target isEqual:target]){
                handler = tmp;
                break;
            }
        }
        
        if(handler != nil){
            [task.handlers removeObject:handler];
        }
        if(task.handlers.count == 0){
            [task.downloadTask cancel];
            [self.downloadTasks removeObjectForKey:URL];
        }
    }
}

///取消所有任务
- (void)cancelAllTasks
{
    [self.downloadTasks enumerateKeysAndObjectsUsingBlock:^(SeaImageCacheTask *task, NSString *URL, BOOL *stop){
       
        [task.downloadTask cancel];
    }];
    
    [self.downloadTasks removeAllObjects];
}

- (void)addCompletion:(SeaImageCacheCompletionHandler) completion thumbnailSize:(CGSize) size target:(id) target forURL:(NSString*) URL
{
    if([NSString isEmpty:URL] || completion == nil)
        return;

    SeaImageCacheTask *task = [self.downloadTasks objectForKey:URL];
    if(task != nil){
        SeaImageCacheHandler *handler = [task handlerForTarget:target];
        handler.completionHandler = completion;
        handler.thumbnailSize = size;
    }
}

- (void)addProgressHandler:(SeaImageCacheProgressHandler) progressHandler forURL:(NSString *)URL target:(id) target
{
    if([NSString isEmpty:URL] || progressHandler == nil)
        return;
    
    SeaImageCacheTask *task = [self.downloadTasks objectForKey:URL];
    if(task != nil){
        SeaImageCacheHandler *handler = [task handlerForTarget:target];
        handler.progressHandler = progressHandler;
    }
}

- (BOOL)isDownloadingForURL:(NSString*) URL
{
    return [self.downloadTasks objectForKey:URL] != nil;
}

#pragma mark- SeaHttpTaskDelegate

//下载完成
- (void)URLSessionDownloadTask:(NSURLSessionDownloadTask *)downloadTask didCompleteWithURL:(NSURL *)URL error:(NSInteger)error
{
    NSString *url = [downloadTask.originalRequest.URL absoluteString];
    if(error == SeaHttpErrorCodeNoError){
        dispatch_async(_cacheQueue, ^(void){
            
            NSData *data = [NSData dataWithContentsOfURL:URL options:NSDataReadingUncached error:nil];
            UIImage *image = [UIImage imageWithData:data];
            
            ///链接不是图片
            if(!image){
                @synchronized (self.badURLs){
                    [self.badURLs addObject:url];
                }
            }
            
            [self executeWithImage:image URL:url];
        });
    }else{
        ///添加无效的URL，防止继续加载
        if(error != NSURLErrorCancelled
           && error != NSURLErrorTimedOut
           && error != NSURLErrorCannotFindHost
           && error != NSURLErrorCannotConnectToHost
           && error != NSURLErrorNetworkConnectionLost
           && error != NSURLErrorNotConnectedToInternet
           && error != NSURLErrorDataNotAllowed
           && error != NSURLErrorInternationalRoamingOff){
            @synchronized (self.badURLs){
                [self.badURLs addObject:url];
            }
        }

        [self executeWithImage:nil URL:url];
    }
}


- (void)URLSessionTask:(NSURLSessionTask *)task didUpdateDownloadProgress:(NSProgress *)progress
{
    NSString *URL = [task.originalRequest.URL absoluteString];
    
    SeaImageCacheTask *task = [self.downloadTasks objectForKey:URL];
    for(SeaImageCacheHandler *handler in task.handlers){
        !handler.progressHandler ?: handler.progressHandler(progress.fractionCompleted);
    }}

#pragma mark- private method

//MD5 处理
- (NSString*)pathForURL:(NSString*) URL
{
    NSString *fileName = [SeaFileManager fileNameForURL:URL suffix:SeaImageCacheToolImageJPG];
    
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
- (void)executeWithImage:(UIImage*) image URL:(NSString*) URL
{
    if(!url)
        return;
    dispatch_main_async_safe(^(void){
        
        SeaImageCacheTask *task = [self.downloadTasks objectForKey:URL];
        if(task != nil){
            for(SeaImageCacheHandler *handler in task.handlers){
                if(image){
                    UIImage *ret = [self imageFromMemoryForURL:URL thumbnailSize:handler.thumbnailSize];
                    if(ret == nil){
                        ret = [self saveImageToMemory:image thumbnailSize:handler.thumbnailSize forURL:URL];
                    }
                    
                    !handler.completionHandler ?: handler.completionHandler(ret);
                }else{
                    NSLog(@"%@  图片读取失败", url);
                    !handler.completionHandler ?: handler.completionHandler(nil);
                }
            }
        }
        [self.downloadTasks removeObjectForKey:URL];
    });
}

#pragma mark- 获取图片

/**
 下载图片

 @param URL 图片路径
 */
- (void)downloadImageWithURL:(NSString*) URL
{
    SeaImageCacheTask *task = [self.downloadTasks objectForKey:URL];
    
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithURL:URL destinationPath:[self pathForURL:URL] completion:nil];
    task.downloadTask = downloadTask;
    [self.sessionManager addDelegate:self forTask:downloadTask];
    
    [downloadTask resume];
}

- (UIImage*)imageFromDiskForURL:(NSString*) URL thumbnailSize:(CGSize) size
{
    NSString *imagePath = nil;
    NSString *thumbnailKey = nil;
    
    UIImage *image = nil;
    
    imagePath = [self pathForURL:URL];
    //判断是否使用缩略图
    if(!CGSizeEqualToSize(size, CGSizeZero)){
        thumbnailKey = [self thumbnailKeyInMemoryForURL:URL size:size];
    }
    
    //获取本地缓存图片
    NSError *error = nil;
    NSData *data = [NSData dataWithContentsOfFile:imagePath options:NSDataReadingUncached error:&error];
    
    if(data == nil)
        return image;
    
    image = [UIImage imageWithData:data];
    
    //使用缩略图
    if(thumbnailKey){
        //生成缩略图
        image = [image sea_aspectFillWithSize:size];
    }
    
    //保存在内存
    if(image){
        NSCache *cache = [SeaImageCacheTool defaultCache];
        if(thumbnailKey)
        {
            [cache setObject:image forKey:thumbnailKey];
        }
        else if(imagePath)
        {
            [cache setObject:image forKey:URL];
        }
    }
    
    return image;
}

- (UIImage*)imageFromMemoryForURL:(NSString*) URL thumbnailSize:(CGSize) size
{
    NSCache *cache = [SeaImageCacheTool defaultCache];
    NSString *key = URL;
    
    //判断是否使用缩略图
    if(!CGSizeEqualToSize(size, CGSizeZero)){
        key = [self thumbnailKeyInMemoryForURL:URL size:size];
    }
    
    return [cache objectForKey:key];
}

- (void)imageForURL:(NSString*) URL thumbnailSize:(CGSize) size completion:(SeaImageCacheCompletionHandler) completion target:(id) target
{
    if([NSString isEmpty:URL]){
        !completion ?: completion(nil);
        return;
    }
    
    //该图片正在下载，合并下载任务
    if([self isDownloadingForURL:URL]){
        [self addCompletion:completion thumbnailSize:size target:target forURL:URL];
        return;
    }
    
    ///无效的URL不重新加载
    @synchronized (self.badURLs){
        if([self.badURLs containsObject:URL]){
            !completion ?: completion(nil);
            return;
        }
    }
    
    SeaImageCacheTask *task = [SeaImageCacheTask new];
    SeaImageCacheHandler *handler = [SeaImageCacheHandler new];
    handler.thumbnailSize = size;
    handler.completionHandler = completion;
    handler.target = target;
    [task.handlers addObject:handler];
    
    [self.downloadTasks setObject:task forKey:URL];
    
    dispatch_async(_cacheQueue, ^(void){

        NSString *imagePath = [self pathForURL:URL];
        
        //获取本地缓存图片
        NSError *error = nil;
        NSData *data = [NSData dataWithContentsOfFile:imagePath options:NSDataReadingUncached error:&error];

        UIImage *image = [UIImage imageWithData:data];
        if(image){
            [self executeWithImage:image URL:URL];
        }
        else{
            //从网络上加载
            [self downloadImageWithURL:URL];
        }
    });
}

- (UIImage*)saveImageToDisk:(UIImage*) image forURL:(NSString*) URL thumbnailSize:(CGSize) size saveToMemory:(BOOL) flag
{
    if(image == nil || [NSString isEmpty:URL])
        return nil;
    
    UIImage *ret = nil;
    if(flag){
       ret = [self saveImageToMemory:image thumbnailSize:size forURL:URL];
    }
    
    dispatch_async(_cacheQueue,  ^(void){
        NSString *imagePath = [self pathForURL:url];
        
        //获取图片的透明通道，判断图片是否是png
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(image.CGImage);
        BOOL imageIsPng = !(alphaInfo == kCGImageAlphaNone ||
                            alphaInfo == kCGImageAlphaNoneSkipFirst ||
                            alphaInfo == kCGImageAlphaNoneSkipLast);
        
        NSData *data = nil;
        //缓存原图
        if(imageIsPng){
            data = UIImagePNGRepresentation(image);
        }
        else{
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        
        [_fileManager createFileAtPath:imagePath contents:data attributes:nil];
    });
    
    return ret;
}

- (void)saveImageFileToDisk:(NSString*) imageFile forURL:(NSString*) URL
{
    if(![imageFile isKindOfClass:[NSString class]] || [NSString isEmpty:URL])
        return;
    
    dispatch_async(_cacheQueue, ^(void){
        NSString *imagePath = [self pathForURL:URL];
        [_fileManager moveItemAtPath:imageFile toPath:imagePath error:nil];
    });
}

- (UIImage*)saveImageToMemory:(UIImage*) image thumbnailSize:(CGSize) size forURL:(NSString*) URL
{
    if(!image || [NSString isEmpty:URL])
        return nil;
     NSCache *cache = [SeaImageCacheTool defaultCache];
    if(!CGSizeEqualToSize(size, CGSizeZero)){
        //缓存缩略图
        URL = [self thumbnailKeyInMemoryForURL:URL size:size];
        
        UIImage *thumbnail = [image sea_aspectFillWithSize:size];
        
        if(thumbnail){
            [cache setObject:thumbnail forKey:URL];
        }
        image = thumbnail;
    }
    else{
        [cache setObject:image forKey:URL];
    }
    
    return image;
}

/**保存图片到本地
 *@param imageData 要缓存的图片数据
 *@path 缓存路径
 */
- (void)saveImageData:(NSData*) imageData withPath:(NSString*) path
{
    if(imageData.length == 0)
        return;
    
    dispatch_async(_cacheQueue, ^(void){
         [_fileManager createFileAtPath:path contents:imageData attributes:nil];
    });
}

/**获取图片缓存文件路径
 *@return 图片缓存路径
 */
- (NSString*)getCachePath
{
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cache = [cache stringByAppendingPathComponent:SeaImageCacheDirectory];
    
    BOOL isDir;
    BOOL exist = [_fileManager fileExistsAtPath:cache isDirectory:&isDir];
    
    if(!(exist && isDir)){
        NSError *error = nil;
        if(![_fileManager createDirectoryAtPath:cache withIntermediateDirectories:YES attributes:nil error:&error]){
            NSLog(@"创建缓存文件夹失败 %@",error);
            return nil;
        }
    }
    
    return cache;
}

#pragma mark- clear cache

- (void)removeCacheImageForURLs:(NSArray<NSString*>*) URLs
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        for(NSString *URL in URLs){
            NSString *imagePath = [self pathForURL:URL];
            if(imagePath){
                [_fileManager removeItemAtPath:imagePath error:nil];
            }
            NSCache *cache = [SeaImageCacheTool defaultCache];
            [cache removeObjectForKey:URL];
        }
    });
}

- (void)clearCacheImageWithCompletion:(void (^)(void))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        NSError *error = nil;
        
        [[SeaMovieCacheTool sharedInstance] clearMovieCacheWithCompletion:nil];
        
        NSString *path = [[SeaImageCacheTool sharedInstance] getCachePath];
        [_fileManager removeItemAtPath:path error:&error];
        
        if(error){
            NSLog(@"清空缓存图片失败");
        }
        
        //重新创建缓存文件夹
        [self getCachePath];
        
        if(completion){
            dispatch_main_async_safe(completion);
        }
    });
}

/**清除已过期的缓存图片
 *@param completion 清除完成回调
 */
- (void)clearExpirationCacheImageWithCompletion:(void(^)(void)) completion
{
    dispatch_block_t block = ^(void){
        NSError *error = nil;

        NSString *path = [[SeaImageCacheTool sharedInstance] getCachePath];
        
        NSArray *resourceKeys = [NSArray arrayWithObjects:NSURLContentModificationDateKey, nil];
        NSDirectoryEnumerator *enumerator = [_fileManager enumeratorAtURL:[NSURL fileURLWithPath:path isDirectory:YES] includingPropertiesForKeys:resourceKeys options:NSDirectoryEnumerationSkipsHiddenFiles errorHandler:NULL];
        
        
        //要删除的图片
        NSMutableArray *URLsToDelete = [NSMutableArray array];
        
        //过期时间
        NSDate *expirationDate = [NSDate dateWithTimeIntervalSinceNow:- _diskCacheExpirationTimeInterval];
        
        //获取已过期的图片
        for(NSURL *URL in enumerator){
            NSDictionary *dic = [url resourceValuesForKeys:resourceKeys error:nil];
            
            if([[expirationDate laterDate:[dic objectForKey:NSURLContentModificationDateKey]] isEqualToDate:expirationDate]){
                [URLsToDelete addObject:URL];
            }
        }

        //删除已过期的图片
        for(NSURL *URL in URLsToDelete){
          //  NSLog(@"%@", url);
            [_fileManager removeItemAtURL:URL error:nil];
        }
        
        [[SeaMovieDurationDataBase sharedInstance] deleteCachesEarlierOrEqualDate:expirationDate];
        
        if(error){
            NSLog(@"清空缓存图片失败");
        }
        
        if(completion){
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
    dispatch_block_t block = ^(void){
        NSString *path = [[SeaImageCacheTool sharedInstance] getCachePath];

        unsigned long long fileSize = 0;
        
        if([_fileManager fileExistsAtPath:path]){
            NSArray *subPaths = [_fileManager subpathsAtPath:path];
            
            for(NSString *subPath in subPaths){
                NSDictionary *dic = [_fileManager attributesOfItemAtPath:[path stringByAppendingPathComponent:subPath] error:nil];
                fileSize += [dic fileSize];
            }
        }
        
        if(completion){
            dispatch_main_async_safe(^(void){
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
    if(bytes > 1024){
        long long kb = bytes / 1024;
        if(kb > 1024){
            long long mb = kb / 1024;
            if(mb > 1024){
                long long gb = mb / 1024;
                if(gb > 1024){
                    return [NSString stringWithFormat:@"%0.2LfT", (long double)gb / 1024.0];
                }else{
                    return [NSString stringWithFormat:@"%0.2LfG", (long double)mb / 1024.0];
                }
            }
            else{
                return [NSString stringWithFormat:@"%0.2LfM", (long double)kb / 1024.0];
            }
        }
        else{
            return [NSString stringWithFormat:@"%lldK", kb];
        }
    }else{
        return [NSString stringWithFormat:@"%lld字节", bytes];
    }
}

@end
