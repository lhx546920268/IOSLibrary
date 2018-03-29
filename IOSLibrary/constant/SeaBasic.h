//
//  base.h
//  IOSLibrary
//
//

//基本信息头文件

#ifndef SeaBase_h
#define SeaBase_h

#import "SeaColorMacro.h"
#import "SeaConstant.h"
#import "SeaSizeMacro.h"
#import "SeaFontMacro.h"

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

///状态栏样式
#define SeaStatusBarStyle [SeaConstant statusBarStyle]

///网络错误
#define SeaBadNetworkText [SeaConstant badNetworkText]


//self的弱引用
#define WeakSelf(parameter) typeof(self) __weak weakSelf = parameter;

//判断是否是3.5寸手机
#define is3_5Inch (SeaScreenHeight == 480)

//判断是否是5.5寸手机
#define is5_5Inch (SeaScreenHeight == 736)

//判断是否是IPhone X
#define isIPhoneX (SeaScreenHeight == 812 && SeaScreenWidth == 375)

//判断是否是4.0寸手机
#define is4_0Inch (SeaScreenHeight == 568 && SeaScreenWidth == 320)

#endif
