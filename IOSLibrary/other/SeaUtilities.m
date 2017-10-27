//
//  SeaUtilities.m
//  Sea

//

#import "SeaUtilities.h"
#import "SeaBasic.h"

/**获取圆上的坐标点
 *@param center 圆心坐标
 *@param radius 圆半径
 *@param arc 要获取坐标的弧度
 */
CGPoint PointInCircle(CGPoint center, CGFloat radius, CGFloat arc)
{
    CGFloat x = center.x + cos(arc) * radius;
    CGFloat y = center.y + sin(arc) * radius;
    
    
    return CGPointMake(x, y);
}

/**获取app名称
 */
NSString* appName()
{
    static NSDictionary *infoStringsDictionary = nil;
    static dispatch_once_t once = 0;
    
    dispatch_once(&once, ^(void){
        
        infoStringsDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"InfoPlist" ofType:@"strings"]];
    });
    
    return [infoStringsDictionary objectForKey:@"CFBundleDisplayName"];
}

/**获取app图标
 */
UIKIT_EXTERN UIImage* appIcon()
{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *iconName = [[dic valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    return [UIImage imageNamed:iconName];
}

/**当前app版本
 */
NSString* appVersion()
{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    
    return [dic objectForKey:@"CFBundleShortVersionString"];
}

/**注册推送通知
 */
void registerRemoteNotification()
{
    //ios 7.0以前和以后注册推送的方法不一样
    UIApplication *application = [UIApplication sharedApplication];
    
    if(![application.delegate respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)])
    {
        NSLog(@"需要在 appDelegate 中实现 'application:didRegisterForRemoteNotificationsWithDeviceToken:'");
        
        //在实现的方法中获取 token
//        NSString *pushToken = [[[[deviceToken description]
//                                 stringByReplacingOccurrencesOfString:@"<" withString:@""]
//                                stringByReplacingOccurrencesOfString:@">" withString:@""]
//                               stringByReplacingOccurrencesOfString:@" " withString:@""];
//        if(![NSString isEmpty:pushToken])
//        {
//            [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:_SeaDeviceToken_];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
    }
    
    if(_ios8_0_ && ![application.delegate respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)])
    {
        NSLog(@"需要在 appDelegate 中实现 'application:didRegisterUserNotificationSettings:'");
        //在方法中调用
        //[application registerForRemoteNotifications];
    }
    
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [application registerUserNotificationSettings:settings];
#endif
    }
    else
    {
#ifdef __IPHONE_8_0
#else
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
#endif
    }
}

/**取消注册推送通知
 */
void unregisterRemoteNotification()
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

/**打开系统设置
 */
void openSystemSettings()
{
    NSURL *url;
    if(_ios8_0_)
    {
        url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    }
    else
    {
        url = [NSURL URLWithString:@"app-settings:"];
    }
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

/**拨打电话
 *@param phoneNumber 电话号码
 *@param flag 是否有弹窗提示
 */
void makePhoneCall(NSString *phoneNumber, BOOL flag)
{
    if([NSString isEmpty:phoneNumber])
        return;
    
    if(flag)
    {
        SeaAlertView *alertView = [[SeaAlertView alloc] initWithTitle:phoneNumber otherButtonTitles:[NSArray arrayWithObjects:@"取消", @"呼叫", nil]];
        alertView.clickHandler = ^(NSInteger buttonIndex){
            
            if(buttonIndex == 1){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]];
            }
        };
        [alertView show];
    }
    else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", phoneNumber]]];
    }
}

/**商品价格格式化
 */
NSString* formatFloatPrice(float price)
{
    if(price != 0)
    {
        NSString *priceStr = [NSString stringWithFormat:@"%.2f", price];
        return [NSString stringWithFormat:@"%@元", priceStr];
    }
    else
    {
        return @"0.00元";
    }
}

/**商品价格格式化
 */
NSString* formatStringPrice(NSString* price)
{
    if([NSString isEmpty:price])
        return @"0.00元";
    return [NSString stringWithFormat:@"%@元", price];
}

/**从格式化的价格中获取商品价格
 */
NSString* priceFromFormatStringPrice(NSString* price)
{
    if(price.length > 1)
    {
        return [price substringFromIndex:1];
    }
    else
    {
        return @"0";
    }
}

/**前往商城首页
 */
void goToMallHome()
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/index.php/wap", SeaNetworkDomainName]]];
}
