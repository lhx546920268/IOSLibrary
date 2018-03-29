//
//  SeaCacheCrash.m
//  IOSLibrary
//
//  Created by 罗海雄 on 15/8/10.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import "SeaCacheCrash.h"


/**
 异常捕获回调方法
 */
void uncacheExceptionHandler(NSException *exception)
{
    
#ifdef __OPTIMIZE__
    
#else
    
    // 异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    // 出现异常的原因
    NSString *reason = [exception reason];
    
    // 异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    
    NSLog(@"%@", exceptionInfo);
    
#endif
}

