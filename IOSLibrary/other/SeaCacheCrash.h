//
//  SeaCacheCrash.h
//  Sea
//
//  Created by 罗海雄 on 15/8/10.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import <Foundation/Foundation.h>

/**捕获崩溃异常
 */

/**异常捕获回调方法
 * 在 Appdelegate 中的 - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
   设置 NSSetUncaughtExceptionHandler(&uncacheExceptionHandler);
 */
void uncacheExceptionHandler(NSException *exception);

