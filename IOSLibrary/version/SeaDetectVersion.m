//
//  SeaDetectVersion.m
//  Sea

//

#import "SeaDetectVersion.h"
#import "SeaBasic.h"

//最新检测时间
#define _detectVersionTime_ @"detectVersionTime"

//检测间隔 秒
#define _detectInterval_ 60 * 60 * 6

//在appstore的信息 的请求路径
static NSString *const appStoreURL = @"http://itunes.apple.com/lookup?";

//请求参数
static NSString *const appID = @"id";

//appId值 可以登录 iTunes connect 查看 appId
static NSString *const appIDValue = @"1";

//最新版本号 key
static NSString *const appVersionKey = @"version";

//更新路径 key
static NSString *const appURL = @"trackViewUrl";

//本地版本号key
static NSString *const appLocalVersion = @"CFBundleShortVersionString";

@interface SeaDetectVersion ()<NSURLConnectionDataDelegate>

//http链接
@property(nonatomic,strong) NSURLConnection *connection;

//返回的数据
@property(nonatomic,strong) NSMutableData *receiveData;

/**新版本更新路径
 */
@property(nonatomic,copy) NSString *trackViewUrl;

/**当前版本
 */
@property(nonatomic,copy) NSString *localVersion;

/**最新版本
 */
@property(nonatomic,copy) NSString *newestVersion;

@end

@implementation SeaDetectVersion

- (void)dealloc
{
    [_connection cancel];
}

#pragma mark- public method

/**检测版本 如果上一次检测距离现在没有超过 版本检测的时间间隔
 *@param immediate 是否马上检测是否有新版本
 *@return 是否进行版本检测
 */
- (BOOL)detectVersionImmediately:(BOOL)immediate
{
    if(immediate || [self isNeedToDetect])
    {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@=%@", appStoreURL, appID, appIDValue]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:40];
        
        NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        self.connection = conn;
        
        return YES;
    }
    else
    {
        return NO;
    }
}

/**取消检测
 */
- (void)cancel
{
    [self.connection cancel];
    self.connection = nil;
}

//是否已超过时间间隔
- (BOOL)isNeedToDetect
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *lastTime = [defaults objectForKey:_detectVersionTime_];
    
    if([NSDate compareTime:lastTime beyondTimeIntervalFromNow:_detectInterval_])
    {
        NSString *currentTime = [NSDate getCurrentTime];
        [defaults setObject:currentTime forKey:_detectVersionTime_];
        return YES;
    }
    
    return NO;
}

#pragma mark- NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    self.receiveData = nil;
    [self.connection cancel];
    self.connection = nil;
    
    if(self.completionHandler)
    {
        self.completionHandler(self.trackViewUrl, self.localVersion, self.newestVersion);
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.receiveData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.receiveData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(self.receiveData != nil)
    {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:self.receiveData options:NSJSONReadingMutableContainers error:nil];
        
        if([dic isKindOfClass:[NSDictionary class]])
        {
            NSArray *resArray = [dic objectForKey:@"results"];
            
            NSDictionary *localDic = [[NSBundle mainBundle] infoDictionary];
            
            self.localVersion = [localDic sea_stringForKey:appLocalVersion];
            
            if(resArray.count > 0)
            {
                NSDictionary *valueDic = [resArray firstObject];
                self.newestVersion = [valueDic sea_stringForKey:appVersionKey];
                
                if(![self isNeedUpdate])
                {
                    self.trackViewUrl = nil;
                }
                else
                {
                    self.trackViewUrl = [valueDic sea_stringForKey:appURL];
                }
            }
        }
    }
   
    if(self.completionHandler)
    {
        self.completionHandler(self.trackViewUrl, self.localVersion, self.newestVersion);
    }
}

#define _versionInterval_ @"."

//是否需要更新版本
- (BOOL)isNeedUpdate
{
    NSArray *localArray = [self.localVersion componentsSeparatedByString:_versionInterval_];
    NSArray *newArray = [self.newestVersion componentsSeparatedByString:_versionInterval_];
    
    if(localArray.count != newArray.count)
        return YES;
    
    BOOL need = NO;
    
    for(NSInteger i = 0; i < localArray.count && i < newArray.count;i ++)
    {
        NSInteger local = [[localArray objectAtIndex:i] integerValue];
        NSInteger newVersion = [[newArray objectAtIndex:i] integerValue];
        
        if(local < newVersion)
        {
            need = YES;
            break;
        }
        else if(local > newVersion)
        {
            break;
        }
    }
    return need;
}

@end
