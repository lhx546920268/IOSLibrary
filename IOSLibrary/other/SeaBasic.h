//
//  base.h
//  IOSLibrary
//
//

//基本信息头文件

#ifndef SeaBase_h
#define SeaBase_h

#import "SeaColorMacro.h"
#import "SeaFontMacro.h"
#import "SeaSizeMacro.h"

//发布(release)的项目不打印日志
#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#define SeaDebug 1
#else
#define NSLog(...) {}
#define SeaDebug 0
#endif


//不需要在主线程上使用 dispatch_get_main_queue
#define dispatch_main_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_main_queue(), block);\
}

//获取当前系统版本
#define _ios11_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 11.0)
#define _ios10_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
#define _ios9_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0)
#define _ios8_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
#define _ios7_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
#define _ios6_1_ ([[UIDevice currentDevice].systemVersion floatValue] >= 6.1)
#define _ios6_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)
#define _ios5_1_ ([[UIDevice currentDevice].systemVersion floatValue] >= 5.1)
#define _ios5_0_ ([[UIDevice currentDevice].systemVersion floatValue] >= 5.0)


//网络状态不好加载数据失败提示信息
#define SeaAlertMsgWhenBadNetwork [SeaBasicInitialization sea_alertMsgWhenBadNetwork]

///状态栏样式
#define SeaStatusBarStyle [SeaBasicInitialization sea_statusBarStyle]

//self的弱引用
#define WeakSelf(parameter) typeof(self) __weak weakSelf = parameter;

//判断是否是3.5寸手机
#define is3_5Inch (SeaScreenHeight == 480)

//判断是否是5.5寸手机
#define is5_5Inch (SeaScreenHeight == 736)

//判断是否是4.0寸手机
#define is4_0Inch (SeaScreenHeight == 568 && SeaScreenWidth == 320)

#endif
