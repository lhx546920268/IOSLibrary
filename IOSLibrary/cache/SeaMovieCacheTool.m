//
//  SeaMovieCacheTool.m
//  SuYan
//
//  Created by 罗海雄 on 16/4/25.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import "SeaMovieCacheTool.h"
#import <AVFoundation/AVFoundation.h>
#import "SeaImageCacheTool.h"
#import "NSString+Utils.h"
#import "SeaBasic.h"
#import "SeaDataBase.h"
#import "FMDB.h"
#import "NSDate+Utils.h"
#import "SeaMovieCacheTask.h"
#import "UIImage+Utils.h"

@implementation SeaMovieCacheInfo

- (NSString*)formatDuration
{
    return [SeaMovieCacheTool format:self.duration];
}

- (instancetype)initWithDuration:(long long) duration image:(UIImage*) image
{
    self = [super init];
    if(self){
        _duration = duration;
        _firstImage = image;
    }
    
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    SeaMovieCacheInfo *info = [[SeaMovieCacheInfo allocWithZone:zone] initWithDuration:self.duration image:self.firstImage];
    
    return info;
}

@end

@interface SeaMovieCacheTool ()
{
    //队列
    dispatch_queue_t _cacheQueue;
}

///下载任务
@property(nonatomic,strong) NSMutableDictionary<NSString*, SeaMovieCacheTask*> *downloadTasks;

///下载队列队列
@property(nonatomic,strong) NSOperationQueue *queue;

///失败的URL
@property(nonatomic,strong) NSMutableSet<NSString*> *badURLs;

@end

@implementation SeaMovieCacheTool

- (instancetype)init
{
    self = [super init];
    if(self){
        self.downloadTasks = [NSMutableDictionary dictionary];
        self.queue = [NSOperationQueue new];
        self.badURLs = [NSMutableSet set];
        
        _cacheQueue = dispatch_queue_create("cacheMovie", DISPATCH_QUEUE_CONCURRENT);
    }
    
    return self;
}

- (void)dealloc
{
#if !OS_OBJECT_USE_OBJC
    dispatch_release(_cacheQueue);
#endif
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
       
        tool = [SeaMovieCacheTool new];
    });
    
    return tool;
}

/**保存在内存中视频缓存信息
 */
+ (NSCache<NSString*, SeaMovieCacheInfo*>*)defaultCache
{
    static NSCache *cache = nil;
    if(cache == nil){
        cache = [[NSCache alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidReceiveMemoryWarningNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
            
            [cache removeAllObjects];
        }];
    }
    
    return cache;
}

#pragma mark- task

- (BOOL)isDownloadingForURL:(NSString *)URL
{
    if([NSString isEmpty:URL])
        return NO;
    
    return [self.downloadTasks objectForKey:URL] != nil;
}

- (void)cancelDownloadForURL:(NSString *)URL target:(id)target
{
    if([NSString isEmpty:URL])
        return;
    
    SeaMovieCacheTask *task = [self.downloadTasks objectForKey:URL];
    
    if(task){
        SeaMovieCacheHandler *handler = nil;
        for(SeaMovieCacheHandler *tmp in task.handlers){
            if([tmp.target isEqual:target]){
                handler = tmp;
                break;
            }
        }

        if(!handler){
            [task.handlers removeObject:handler];
        }
        if(task.handlers.count == 0){
            [task.operation cancel];
            [self.downloadTasks removeObjectForKey:URL];
        }
    }
}

- (void)addCompletion:(SeaMovieCacheCompletionHandler) completion thumbnailSize:(CGSize) size target:(id) target forURL:(NSString*) URL
{
    if([NSString isEmpty:URL] || !completion)
        return;
    
    SeaMovieCacheTask *task = [self.downloadTasks objectForKey:URL];
    if(task){
        SeaMovieCacheHandler *handler = [task handlerForTarget:target];
        handler.completionHandler = completion;
        handler.thumbnailSize = size;
    }
}

- (void)movieInfoForURL:(NSString*) URL thumbnailSize:(CGSize) size completion:(SeaMovieCacheCompletionHandler) completion target:(id) target
{
    if([NSString isEmpty:URL] || [self isDownloadingForURL:URL])
        return;
    
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
    
    
    SeaMovieCacheTask *task = [SeaMovieCacheTask new];
    SeaMovieCacheHandler *handler = [SeaMovieCacheHandler new];
    handler.target = target;
    handler.completionHandler = completion;
    handler.thumbnailSize = size;
    [task.handlers addObject:handler];
    
    [self.downloadTasks setObject:task forKey:URL];
    
    dispatch_async(_cacheQueue, ^(void){
        
        //获取本地缓存时间
        BOOL exist = NO;
        long long duration = [[SeaMovieDurationDataBase sharedInstance] durationForURL:URL];
        if(duration > 0){
            UIImage *image = [[SeaImageCacheTool sharedInstance] imageFromDiskForURL:URL thumbnailSize:CGSizeZero];
            if(image){
                SeaMovieCacheInfo *info = [[SeaMovieCacheInfo alloc] initWithDuration:duration image:image];
                
                [self executeWithInfo:info URL:URL];
                exist = YES;
            }
        }
        
        if(!exist){
            //从网络上加载
            dispatch_main_async_safe(^(void){
                
                [self downloadMovieInfoForURL:URL];
            });
        }
    });
}

/**获取视频信息
 *@param URL 视频路径
 */
- (void)downloadMovieInfoForURL:(NSString*) URL
{
    SeaMovieCacheTask *task = [self.downloadTasks objectForKey:URL];
    NSBlockOperation *operaton = [NSBlockOperation blockOperationWithBlock:^(void){
       
        NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];

        NSURL *url = [NSURL URLWithString:URL];
        if(!url){
            @synchronized (self.badURLs){
                [self.badURLs addObject:URL];
            }
            [self executeWithInfo:nil URL:URL];
            return;
        }
        AVURLAsset *asset = [AVURLAsset URLAssetWithURL:url options:opts];
        
        ///获取第一帧图片
        AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
        generator.appliesPreferredTrackTransform = YES;
        generator.maximumSize = CGSizeZero;
        

        SeaMovieCacheInfo *info = nil;
        NSError *error = nil;
        CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(1, 2) actualTime:NULL error:&error];
        UIImage *image = [UIImage imageWithCGImage:img];
        
        if(image){
            
            image = [[SeaImageCacheTool sharedInstance] saveImageToDisk:image forURL:URL thumbnailSize:CGSizeZero saveToMemory:NO];
            
            ///获取视频时长
            long long duration = asset.duration.value / asset.duration.timescale;

            info = [[SeaMovieCacheInfo alloc] initWithDuration:duration image:image];
            [[SeaMovieCacheTool defaultCache] setObject:info forKey:URL];
            [[SeaMovieDurationDataBase sharedInstance] insertDuration:duration URL:URL];
        }
        [self executeWithInfo:info URL:URL];
    }];
    task.operation = operaton;
    
    [self.queue addOperation:operaton];
}

//执行加载完回调
- (void)executeWithInfo:(SeaMovieCacheInfo*) info URL:(NSString*) URL
{
    if(!URL)
        return;
    dispatch_main_async_safe(^(void){
        
        SeaMovieCacheTask *task = [self.downloadTasks objectForKey:URL];
        if(task){
            for(SeaMovieCacheHandler *handler in task.handlers){
                if(info){
                    SeaMovieCacheInfo *cacheInfo = [self movieInfoFromMemoryForURL:URL thumbnailSize:handler.thumbnailSize];
                    if(cacheInfo == nil){
                        cacheInfo = [self saveInfoToMemory:info thumbnailSize:handler.thumbnailSize forURL:URL];
                    }
                    
                    !handler.completionHandler ?: handler.completionHandler(cacheInfo);
                }else{
                    NSLog(@"%@  图片读取失败", URL);
                    !handler.completionHandler ?: handler.completionHandler(nil);
                }
            }
        }
        [self.downloadTasks removeObjectForKey:URL];
    });
}

- (SeaMovieCacheInfo*)movieInfoFromMemoryForURL:(NSString*) URL thumbnailSize:(CGSize) size
{
    NSCache *cache = [SeaMovieCacheTool defaultCache];
    if(!CGSizeEqualToSize(size, CGSizeZero)){
        URL = [self thumbnailKeyInMemoryForURL:URL size:size];
    }
    
    return [cache objectForKey:URL];
}

/**缩略图在内存中的key
 */
- (NSString*)thumbnailKeyInMemoryForURL:(NSString*) url size:(CGSize) size
{
    url = [url stringByAppendingFormat:@"-w%.f-h%.f", size.width, size.height];
    
    return url;
}

- (SeaMovieCacheInfo*)saveInfoToMemory:(SeaMovieCacheInfo*) info thumbnailSize:(CGSize) size forURL:(NSString*) URL
{
    if(!info || [NSString isEmpty:URL])
        return nil;
   
    NSCache *cache = [SeaMovieCacheTool defaultCache];
    if(!CGSizeEqualToSize(size, CGSizeZero)){
        //缓存缩略图
        URL = [self thumbnailKeyInMemoryForURL:URL size:size];
        
        UIImage *thumbnail = [info.firstImage sea_aspectFillWithSize:size];
        
        if(thumbnail){
            info = [[SeaMovieCacheInfo alloc] initWithDuration:info.duration image:info.firstImage];
            [cache setObject:info forKey:URL];
        }
    }
    else{
        [cache setObject:info forKey:URL];
    }
    return info;
}

#pragma mark- format

+ (NSString*)format:(long long) duration
{
    long long result = duration / 60;
    int second = (int)((long long)duration % 60);
    int minute = (int) result % 60;
    int hour = (int)(result / 60);
    
    return hour > 0 ? [NSString stringWithFormat:@"%02d:%02d:%02d", hour, minute, second] : [NSString stringWithFormat:@"%02d:%02d", minute, second];
}

@end


@implementation SeaMovieDurationDataBase

+ (instancetype)sharedInstance
{
    static dispatch_once_t once = 0;
    static SeaMovieDurationDataBase *dataBase = nil;
    
    dispatch_once(&once, ^(void){
        
        dataBase = [SeaMovieDurationDataBase new];
    });
    
    return dataBase;
}

- (instancetype)init
{
    self = [super init];
    if(self){
        
        [[SeaDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
            
            //创建视频数据表
            if(![db executeUpdate:@"create table if not exists video_cache(id integer primary key autoincrement,url text,duration integer,cache_time TIMESTAMP default (datetime('now','localtime')))"]){
                NSLog(@"创建视频缓存表失败");
            }
        }];
    }
    
    return self;
}

- (BOOL)insertDuration:(long long) duration URL:(NSString*) URL
{
    if([NSString isEmpty:URL])
        return NO;
    __block BOOL result = NO;
    [[SeaDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
       
        result = [db executeUpdate:@"insert into video_cache(duration, url) values(?,?)", @(duration), URL];
    }];
    
    return result;
}

- (BOOL)deleteCachesEarlierOrEqualDate:(NSDate*) date
{
    if(!date)
        return NO;
    
    __block BOOL result = NO;
    [[SeaDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
       
        result = [db executeUpdate:@"delete from video_cache where datetime(cache_time)<=datetime(%@)", [NSDate sea_timeFromDate:date format:SeaDateFormatYMdHms]];
    }];
    
    return result;
}

- (long long)durationForURL:(NSString*) URL
{
    if([NSString isEmpty:URL])
        return -1;
    
    __block long long duration = -1;
    
    [[SeaDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
       
        FMResultSet *rs = [db executeQueryWithFormat:@"select duration from video_cache where url='%@'", URL];
        while ([rs next]) {
            duration = [rs longLongIntForColumn:@"duration"];
            break;
        }
    }];
    
    return duration;
}

- (void)clear
{
    [[SeaDataBase sharedInstance].dbQueue inDatabase:^(FMDatabase *db){
       
        [db executeUpdate:@"delete from video_cache"];
    }];
}

@end


