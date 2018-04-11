//
//  SeaTools.m
//  Sea

//

#import "SeaTools.h"
#import "NSString+Utils.h"
#import "SeaAlertController.h"

CGPoint pointInCircle(CGPoint center, CGFloat radius, CGFloat arc)
{
    CGFloat x = center.x + cos(arc) * radius;
    CGFloat y = center.y + sin(arc) * radius;
    
    
    return CGPointMake(x, y);
}

NSString* appName()
{
    static NSDictionary *infoStringsDictionary = nil;
    static dispatch_once_t once = 0;
    
    dispatch_once(&once, ^(void){
        
        infoStringsDictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"InfoPlist" ofType:@"strings"]];
    });
    
    NSString *name = [infoStringsDictionary objectForKey:@"CFBundleDisplayName"];
    if([NSString isEmpty:name]){
        name = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    }
    
    return name;
}

UIImage* appIcon()
{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    NSString *iconName = [[dic valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    
    return [UIImage imageNamed:iconName];
}

NSString* appVersion()
{
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary];
    
    return [dic objectForKey:@"CFBundleShortVersionString"];
}


void registerRemoteNotification()
{
    //ios 7.0以前和以后注册推送的方法不一样
    UIApplication *application = [UIApplication sharedApplication];
    
    if(![application.delegate respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]){
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
    
    if(![application.delegate respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)]){
        NSLog(@"需要在 appDelegate 中实现 'application:didRegisterUserNotificationSettings:'");
        //在方法中调用
        //[application registerForRemoteNotifications];
    }
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    [application registerUserNotificationSettings:settings];
}

void unregisterRemoteNotification()
{
    [[UIApplication sharedApplication] unregisterForRemoteNotifications];
}

void openSystemSettings()
{
    NSURL *url;
    if(@available(iOS 8.0, *)){
        url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    }else{
        url = [NSURL URLWithString:@"app-settings:"];
    }
    
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

void makePhoneCall(NSString *mobile, BOOL flag)
{
    if([NSString isEmpty:mobile])
        return;
    
    if(flag){
        SeaAlertController *controller = [[SeaAlertController alloc] initWithTitle:[NSString stringWithFormat:@"%@", mobile] message:nil icon:nil style:SeaAlertControllerStyleAlert cancelButtonTitle:nil otherButtonTitles:@[@"取消", @"拨打"]];
        controller.selectionHandler = ^(NSUInteger index){
          
            if(index == 1){
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", mobile]]];
            }
        };
        [controller show];
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", mobile]]];
    }
}

