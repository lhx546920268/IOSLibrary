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
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    if(@available(iOS 8.0, *)){
//        url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
//    }else{
//        url = [NSURL URLWithString:@"app-settings:"];
//    }
    
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
    }
}

void makePhoneCall(NSArray<NSString*> *mobiles, BOOL flag)
{
    if(mobiles.count == 0)
        return;
    
    if(flag){
        if(mobiles.count > 1){
            
            SeaAlertController *controller = [SeaAlertController actionSheetWithTitle:nil message:nil otherButtonTitles:mobiles];
            controller.selectionHandler = ^(NSUInteger index){
                
                if(index < mobiles.count){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", mobiles[index]]]];
                }
            };
            [controller show];
            
        }else{
            NSString *mobile = [mobiles firstObject];
            SeaAlertController *controller = [[SeaAlertController alloc] initWithTitle:[NSString stringWithFormat:@"是否拨打 %@", mobile] message:nil icon:nil style:SeaAlertControllerStyleAlert cancelButtonTitle:nil otherButtonTitles:@[@"取消", @"拨打"]];
            controller.selectionHandler = ^(NSUInteger index){
                
                if(index == 1){
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", mobile]]];
                }
            };
            [controller show];
        }
    }else{
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", [mobiles firstObject]]]];
    }
}

BOOL polygonContainsPoint(NSArray<NSValue*> *points, CGPoint point)
{
    if(points.count >= 3){
        //获取x,y 的最大最小值
        CGPoint p = [points[0] CGPointValue];
        CGFloat minX = p.x;
        CGFloat minY = p.y;
        
        CGFloat maxX = p.x;
        CGFloat maxY = p.y;
        
        for(NSInteger i = 1;i < points.count;i ++){
            CGPoint p1 = [points[i] CGPointValue];
            if(p1.x > maxX){
                maxX = p1.x;
            }else if (p1.x < minX){
                minX = p1.x;
            }
            
            if(p1.y > maxY){
                maxY = p1.y;
            }else if (p1.y < minY){
                minY = p1.y;
            }
        }
        
        //超出 最小点和最大点 一定不在多边形范围内
        if(point.x < minX || point.x > maxX || point.y < minY || point.y > maxY){
            return NO;
        }
        
        //从多边形外面任意一点 绘制一条连接要判断的点的线，如果与多边形交叉点数量为 奇数，则在多边形内
        CGPoint point1 = CGPointMake(minX - 5, minY - 5);
        int intersections = 0;
        for(NSInteger i = 0;i < points.count;i ++){
            CGPoint p3 = [points[i] CGPointValue];;
            CGPoint p4;
            if(i == points.count - 1){
                p4 = [points[0] CGPointValue];
            }else{
                p4 = [points[i + 1] CGPointValue];
            }
            
            if(areIntersecting(point1, point, p3, p4)){
                intersections ++;
            }
        }
        
        return intersections % 2 != 0;
    }else if(points.count == 2){
        //只是一条线 判断点是否在这条线上
        CGPoint point1 = [[points firstObject] CGPointValue];
        CGPoint point2 = [[points firstObject] CGPointValue];
        
        CGFloat minX = MIN(point1.x, point2.x);
        CGFloat maxX = MAX(point1.x, point2.x);
        CGFloat minY = MIN(point1.y, point2.y);
        CGFloat maxY = MAX(point1.y, point2.y);
        
        //超出 最小点和最大点
        if(point.x < minX || point.x > maxX || point.y < minY || point.y > maxY){
            return NO;
        }
    
        //直线一般方程 所有直线都满足一般方程
        //https://baike.baidu.com/item/直线的一般式方程/11052424
        CGFloat a = point2.y - point1.y;
        CGFloat b = point1.x - point2.x;
        CGFloat c = (point2.x * point1.y) - (point1.x * point2.y);
        
        CGFloat d = (a * point.x) + (b * point.y) + c;
        return d == 0;
    }
    
    return NO;
}

BOOL areIntersecting(CGPoint point1, CGPoint point2, CGPoint point3, CGPoint point4)
{
    CGFloat d1, d2;
    CGFloat a1, a2, b1, b2, c1, c2;
    
    //直线一般方程 所有直线都满足一般方程
    //https://baike.baidu.com/item/直线的一般式方程/11052424
    a1 = point2.y - point1.y;
    b1 = point1.x - point2.x;
    c1 = (point2.x * point1.y) - (point1.x * point2.y);
    
    //如果 d1 大于0时在线这边，小于0时在线的另一边，所有当 d1 d2 都大于0 或者 都小于0时 它们不交叉
    d1 = (a1 * point3.x) + (b1 * point3.y) + c1;
    d2 = (a1 * point4.x) + (b1 * point4.y) + c1;
    
    if (d1 > 0 && d2 > 0) return NO;
    if (d1 < 0 && d2 < 0) return NO;
    
    // The fact that vector 2 intersected the infinite line 1 above doesn't
    // mean it also intersects the vector 1. Vector 1 is only a subset of that
    // infinite line 1, so it may have intersected that line before the vector
    // started or after it ended. To know for sure, we have to repeat the
    // the same test the other way round. We start by calculating the
    // infinite line 2 in linear equation standard form.
    a2 = point4.y - point3.y;
    b2 = point3.x - point4.x;
    c2 = (point4.x * point3.y) - (point3.x * point4.y);
    
    d1 = (a2 * point1.x) + (b2 * point1.y) + c2;
    d2 = (a2 * point2.x) + (b2 * point2.y) + c2;
    
    if (d1 > 0 && d2 > 0) return NO;
    if (d1 < 0 && d2 < 0) return NO;
    
    //重叠或者相交一个点
    if ((a1 * b2) - (a2 * b1) == 0.0f) return NO;
    
    return YES;
}
