//
//  base.h
//  Sea
//
//

//基本信息头文件

#ifndef SeaBase_h
#define SeaBase_h

#import "SeaBasicInitialization.h"

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

//手机屏幕的宽度和高度
#define SeaScreenWidth MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define SeaScreenHeight MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width)

//视图主要背景颜色
#define SeaViewControllerBackgroundColor [SeaBasicInitialization sea_backgroundColor]

/**按钮背景颜色
 */
#define SeaButtonBackgroundColor [SeaBasicInitialization sea_buttonBackgroundColor]

///按钮标题颜色
#define SeaButtonTitleColor [SeaBasicInitialization sea_buttonTitleColor]

/**不能点击的按钮背景颜色
 */
#define SeaButtonDisableBackgroundColor [UIColor colorFromHexadecimal:@"b3b3b3"]

///app主色调
#define SeaAppMainColor [SeaBasicInitialization sea_appMainColor]

///导航栏背景颜色
#define SeaNavigationBarBackgroundColor [SeaBasicInitialization sea_navigationBarColor]

///导航栏标题颜色
#define SeaNavigationBarTitleColor [SeaBasicInitialization sea_navigationBarTitleColor]

///导航栏标题字体
#define SeaNavigationBarTitleFont [SeaBasicInitialization sea_navigationBarTitleFont]

///状态栏样式
#define SeaStatusBarStyle [SeaBasicInitialization sea_statusBarStyle]

///导航栏tintColor
#define SeaTintColor [SeaBasicInitialization sea_tintColor]

//网络状态不好加载数据失败提示信息
#define SeaAlertMsgWhenBadNetwork [SeaBasicInitialization sea_alertMsgWhenBadNetwork]

//分割线颜色
#define SeaSeparatorColor [SeaBasicInitialization sea_separatorLineColor]
#define SeaSeparatorHeight [SeaBasicInitialization sea_separatorLineWidth]

//主要字体名称
#define SeaMainFontName [SeaBasicInitialization sea_SeaMainFontName]

//数字字体、英文字体
#define SeaMainNumberFontName [SeaBasicInitialization sea_SeaMainNumberFontName]

//图片没加载前默认背景颜色
#define SeaImageBackgroundColorBeforeDownload [UIColor colorFromHexadecimal:@"e6e6e6"]

//self的弱引用
#define WeakSelf(parameter) typeof(self) __weak weakSelf = parameter;

//系统默认的蓝色
#define UIKitTintColor [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0]

//判断是否是3.5寸手机
#define is3_5Inch (SeaScreenHeight == 480)

//判断是否是5.5寸手机
#define is5_5Inch (SeaScreenHeight == 736)

//判断是否是4.0寸手机
#define is4_0Inch (SeaScreenHeight == 568 && SeaScreenWidth == 320)

///大小自适应
static const CGFloat SeaWrapContent = -1;

//选项卡高度
static const CGFloat SeaTabBarHeight = 49.0;

//状态栏高度
static const CGFloat SeaStatusHeight = 20.0;

//工具条高度
static const CGFloat SeaToolBarHeight = 44.0;

#endif
