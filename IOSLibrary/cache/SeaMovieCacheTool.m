//
//  SeaMovieCacheTool.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaMovieCacheTool.h"
#import <AVFoundation/AVFoundation.h>
#import "SeaImageCacheTool.h"
#import "NSString+Utilities.h"
#import "SeaBasic.h"

@interface SeaMovieCacheTool ()
{
    //队列
    dispatch_queue_t _cacheQueue;
    
    //文件管理器,不能在其他线程中使用defaultManager
    NSFileManager *_fileManager;
}

///正在请求的 key 是 URL，value是 SeaMovieCacheToolOperation
@property(nonatomic,strong) NSMutableDictionary *downloadProgressDic;

///请求队列
@property(nonatomic,strong) NSOperationQueue *queue;

/**时间缓存路径
 */
@property(nonatomic,copy) NSString *cachePath;

/**缓存图片保存在本地的最大时间，default is '60 * 60 * 24 * 7'，一周
 */
@property(nonatomic,assign) NSTimeInterval diskCacheExpirationTimeInterval;



@end

@implementation SeaMovieCacheTool

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.downloadProgressDic = [NSMutableDictionary dictionary];
        self.queue = [[NSOperationQueue alloc] init];
        
        _cacheQueue = dispatch_queue_create("cacheMovie", DISPATCH_QUEUE_CONCURRENT);
        
        _fileManager = [[NSFileManager alloc] init];
        _diskCacheExpirationTimeInterval = 60 * 60 * 24 * 7;
        self.cachePath = [self getCachePath];
        
        //添加进入后台和程序终止通知，用于清除已经过时的缓存文件
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    }
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark- 单例

/**缓存单例
 */
+ (instancetype)sharedInstance
{
    static dispatch_once_t once = 0;
    static SeaMovieCacheTool *tool = nil;
    
    dispatch_once(&once, ^(void){
       
        tool = [[SeaMovieCacheTool alloc] init];
    });
    
    return tool;
}

/**保存在内存中的时间 key 是视频路径，value 是NSString对象
 */
+ (NSCache*)defaultCache
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

- (void)applicationDidEnterBackground:(NSNotification*) notification
{
    UIApplication *application = [UIApplication sharedApplication];
    
    //使用后台长时间任务
    __block UIBackgroundTaskIdentifier taskIdentifier = [application beginBackgroundTaskWithExpirationHandler:^(void){
        
        [application endBackgroundTask:taskIdentifier];
    }];
    
    if(taskIdentifier != UIBackgroundTaskInvalid)
    {
        [self clearExpirationCacheMovieInfoWithCompletion:^(void){
            
            [application endBackgroundTask:taskIdentifier];
        }];
    }
}

- (void)applicationWillTerminate:(NSNotification*) notification
{
    [self clearExpirationCacheMovieInfoWithCompletion:nil];
}

/**判断某个请求是否已存在
 *@param URL 视频路径
 *@return 是否已存在
 */
- (BOOL)isRequestingWithURL:(NSString*) URL
{
    if(!URL)
        return NO;
    
    return [self.downloadProgressDic objectForKey:URL] != nil;
}

/**取消某个请求
 *@param URL 视频路径
 *@param target 获取视频信息的对象，如UIImageView
 */
- (void)cancelRequestWithURL:(NSString*) URL target:(id) target
{
    if(!URL)
        return;
    
    SeaMovieCacheToolOperation *operation = [self.downloadProgressDic objectForKey:URL];
    
    if(operation != nil)
    {
        SeaMovieCacheToolRequirement *requirement = nil;
        for(SeaMovieCacheToolRequirement *req in operation.requirements)
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
            [operation.blockOperation cancel];
            [self.downloadProgressDic removeObjectForKey:URL];
        }
    }
}

/**添加下载完成回调
 *@param requirement 要求
 *@param URL 视频路径
 */
- (void)addRequirement:(SeaMovieCacheToolRequirement*) requirement forURL:(NSString*) URL
{
    if([NSString isEmpty:URL] || requirement == nil)
        return;
    
    SeaImageCacheToolOperation *operation = [_downloadProgressDic objectForKey:URL];
    if(operation != nil)
    {
        [operation.requirements addObject:requirement];
    }
}

/**获取视频信息
 *@param URL 视频路径
 *@param requirement 要求
 */
- (void)getMovieWithURL:(NSString*) URL requirement:(SeaMovieCacheToolRequirement*) requirement
{
    if([NSString isEmpty:URL] || [self isRequestingWithURL:URL])
        return;
    
    SeaMovieCacheToolOperation *operation = [[SeaMovieCacheToolOperation alloc] init];
    if(requirement)
    {
        [operation.requirements addObject:requirement];
    }
    
    [self.downloadProgressDic setObject:operation forKey:URL];
    
    dispatch_async(_cacheQueue, ^(void){
        
        ///从内存获取
        NSString *time = [[SeaMovieCacheTool defaultCache] objectForKey:URL];
        if(!time)
        {
            NSString *path = [self pathForURL:URL];
            
            //获取本地缓存时间
            NSError *error = nil;
            time = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
        }
        
        if(time)
        {
            UIImage *image = [[SeaImageCacheTool sharedInstance] imageFromMemoryWithURL:URL thumbnailSize:requirement.thumbnailSize];
            if(!image)
            {
                image = [[SeaImageCacheTool sharedInstance] imageFromCacheWithURL:URL thumbnailSize:requirement.thumbnailSize];
            }
            
            [self executeWithImage:image time:time URL:URL];
        }
        else
        {
            //从网络上加载
            dispatch_main_async_safe(^(void){
                
                [self getMovieInfoWithURL:URL requirement:requirement];
            });
        }
    });
}

/**获取视频信息
 *@param URL 视频路径
 */
- (void)getMovieInfoWithURL:(NSString*) URL requirement:(SeaMovieCacheToolRequirement*) requirement
{
    NSBlockOperation *operaton = [NSBlockOperation blockOperationWithBlock:^(void){
       
        NSDictionary *opts = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:AVURLAssetPreferPreciseDurationAndTimingKey];

        NSURL *url = [[NSURL alloc] initWithString:URL];
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:opts];
        
        ///获取第一帧图片
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        generator.maximumSize = requirement.firstImageMaxSize;
        
        NSError *error = nil;
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(1, 2) actualTime:NULL error:&error];
        UIImage *image = [UIImage imageWithCGImage: img];
        
        NSString *time = nil;
        if(image)
        {
            image = [[SeaImageCacheTool sharedInstance] cacheImage:image withURL:URL thumbnailSize:requirement.thumbnailSize saveToMemory:YES];
            
            ///获取视频时长
            time = [NSString stringWithFormat:@"%lld", asset.duration.value / asset.duration.timescale];
            [[SeaMovieCacheTool defaultCache] setObject:time forKey:URL];
            
            NSString *path = [self pathForURL:URL];
            
            NSData *data = [time dataUsingEncoding:NSUTF8StringEncoding];
            [_fileManager createFileAtPath:path contents:data attributes:nil];
        }
        
        [self executeWithImage:image time:time URL:URL];
    }];
    
    [self.queue addOperation:operaton];
}

//执行加载完回调
- (void)executeWithImage:(UIImage*) image time:(NSString*) time URL:(NSString*) URL
{
    if(!URL)
        return;
    dispatch_main_async_safe(^(void){
        
        SeaMovieCacheToolOperation *operation = [_downloadProgressDic objectForKey:URL];
        if(operation != nil)
        {
            for(SeaMovieCacheToolRequirement *req in operation.requirements)
            {
                !req.completion ?: req.completion([time doubleValue], image);
            }
        }
        [_downloadProgressDic removeObjectForKey:URL];
    });
}

#pragma mark- path

/**获取缓存文件路径
 *@return 缓存路径
 */
- (NSString*)getCachePath
{
    NSString *cache = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    NSString *circle = [cache stringByAppendingPathComponent:@"cacheMovieInfo"];
    
    BOOL isDir;
    BOOL exist = [_fileManager fileExistsAtPath:circle isDirectory:&isDir];
    
    if(!(exist && isDir))
    {
        NSError *error = nil;
        if(![_fileManager createDirectoryAtPath:circle withIntermediateDirectories:YES attributes:nil error:&error])
        {
            NSLog(@"创建视频时间缓存文件夹失败 %@",error);
            return nil;
        }
    }
    
    return circle;
}

//MD5 处理url
- (NSString*)pathForURL:(NSString*) url
{
    NSString *fileName = [SeaFileManager fileNameForURL:url suffix:@"txt"];
    
    return [self.cachePath stringByAppendingPathComponent:fileName];
}

#pragma mark- 清除缓存信息

/**清除已过期的缓存视频信息
 *@param completion 清除完成回调
 */
- (void)clearExpirationCacheMovieInfoWithCompletion:(void(^)(void)) completion
{
    dispatch_block_t block = ^(void)
    {
        NSError *error = nil;
        
        NSString *path = [[SeaMovieCacheTool sharedInstance] getCachePath];
        
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
            NSLog(@"清空缓存视频信息失败");
        }
        
        if(completion)
        {
            dispatch_main_async_safe(completion);
        }
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

#pragma mark- format

/**格式化视频时间
 *@param timeInterval 视频时间长度
 *@return 类似 01:30:30 的视频时长
 */
+ (NSString*)formatMovieTime:(NSTimeInterval) timeInterval
{
    long long result = timeInterval / 60;
    int second = (int)((long long)timeInterval % 60);
    int minute = (int) result % 60;
    int hour = (int)(result / 60);
    
    return hour > 0 ? [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second] : [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

#pragma mark- clear

/**清除视频缓存
 *@param completion 清除完成回调
 */
- (void)clearMovieCacheWithCompletion:(void(^)(void)) completion
{
    dispatch_block_t block = ^(void)
    {
        NSError *error = nil;
        
        NSString *path = [[SeaMovieCacheTool sharedInstance] getCachePath];
        [_fileManager removeItemAtPath:path error:&error];
        
        if(error)
        {
            NSLog(@"清空缓存视频失败");
        }
        
        //重新创建缓存文件夹
        [self getCachePath];
        
        if(completion)
        {
            dispatch_main_async_safe(completion);
        }
    };
    
    if([[NSThread currentThread] isMainThread])
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
    }
    else
    {
        block();
    }
    
}

@end
