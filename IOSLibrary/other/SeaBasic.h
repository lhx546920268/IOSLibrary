//
//  base.h
//  Sea
//
//

#import "SeaUtlities.h"
#import "SeaUtilities.h"
#import "SeaViewControllerHeaders.h"
#import "SeaViewHeaders.h"
#import "SeaCacheCrash.h"
#import "SeaAlbumAssetsViewController.h"
#import "SeaImageCropViewController.h"
#import "SeaImageBrowser.h"
#import "SeaDetectVersion.h"
#import "SeaHttpRequest.h"
#import "SeaNetworkQueue.h"
#import "SeaFileManager.h"
#import "SeaImageCacheTool.h"
#import "SeaUserDefaults.h"
#import "ChineseToPinyin.h"
#import "SeaBasicInitialization.h"
#import "SeaPresentTransitionDelegate.h"
#import "SeaPartialPresentTransitionDelegate.h"

//基本信息头文件

#ifndef SeaBase_h
#define SeaBase_h

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
#define _width_ MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)
#define _height_ MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width)


//选项卡高度
#define _tabBarHeight_ 49.0

//导航栏高度
#define _navigationBarHeight_ 44.0

//状态栏高度
#define _statusHeight_ 20.0

//工具条高度
#define _toolBarHeight_ 44.0

//视图主要背景颜色
#define _SeaViewControllerBackgroundColor_ [SeaBasicInitialization sea_backgroundColor]

/**按钮背景颜色
 */
#define WMButtonBackgroundColor [SeaBasicInitialization sea_buttonBackgroundColor]

/**不能点击的按钮背景颜色
 */
#define WMButtonDisableBackgroundColor [UIColor colorFromHexadecimal:@"b3b3b3"]



//app主色调
#define _appMainColor_ [SeaBasicInitialization sea_appMainColor]

//导航栏背景颜色
#define _navigationBarBackgroundColor_ [SeaBasicInitialization sea_navigationBarColor]

///状态栏样式
#define WMStatusBarStyle [SeaBasicInitialization sea_statusBarStyle]

///导航栏tintColor
#define WMTintColor [SeaBasicInitialization sea_tintColor]

///按钮标题颜色
#define WMButtonTitleColor [SeaBasicInitialization sea_buttonTitleColor]

//网络状态不好加载数据失败提示信息
#define _alertMsgWhenBadNetwork_ [SeaBasicInitialization sea_alertMsgWhenBadNetwork]

//分割线颜色
#define _separatorLineColor_ [SeaBasicInitialization sea_separatorLineColor]
#define _separatorLineWidth_ [SeaBasicInitialization sea_separatorLineWidth]

//主要字体名称
#define MainFontName [SeaBasicInitialization sea_mainFontName]

//数字字体、英文字体
#define MainNumberFontName [SeaBasicInitialization sea_mainNumberFontName]


//主题黄色
#define WMYellowColor [UIColor colorWithRed:251.0 / 255.0 green:182.0 / 255.0 blue:43.0 / 255.0 alpha:1.0]

//主要字体颜色
#define MainLightGrayColor [UIColor colorWithRed:153.0 / 255.0 green:153.0 / 255.0 blue:153.0 / 255.0 alpha:1.0] ///#999999
#define MainDeepGrayColor [UIColor colorWithRed:51.0 / 255.0 green:51.0 / 255.0 blue:51.0 / 255.0 alpha:1.0] ///#333333
#define MainGrayColor [SeaBasicInitialization sea_mainTextColor]///#666666
#define MainTextColor MainGrayColor

///状态橙色
#define WMOrangeColor [UIColor colorFromHexadecimal:@"f8a20f"] 

//灰色背景颜色
#define MainDefaultBackColor [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1.0]

//字体大小
#define MainFontSize22 (25.0 / 3.0) ///22号字体
#define MainFontSize30 (33.0 / 3.0) ///30号字体
#define MainFontSize34 (37.0 / 3.0) ///34号字体
#define MainFontSize36 (39.0 / 3.0) ///36号字体
#define MainFontSize46 (49.0 / 3.0) ///46号字体
#define MainFontSize40 (43.0 / 3.0) ///40号字体
#define MainFontSize50 (53.0 / 3.0) ///50号字体
#define MainFontSize56 (59 / 3.0) ///56号字体

//设计稿比例
#define WMDesignScale (_width_ / 414.0)


/**域名
 */
static NSString *const SeaNetworkDomainName = @"http://119.23.18.14";
//static NSString *const SeaNetworkDomainName = @"www.mstore.com";

/**所有网络请求的路径
 */
static NSString *const SeaNetworkRequestURL = @"http://119.23.18.14/index.php/topapi";
//static NSString *const SeaNetworkRequestURL = @"http://www.mstore.com/index.php/mobile/";

/**网络请求签名token
 */
static NSString *const SeaNetworkSignatureToken = @"a1017b2bab5d97e1aa54f10a9d5678940a3cdf0a7b631836845531d67d64ec0c";
//static NSString *const SeaNetworkECStoreSignatureToken = @"4277dbfc102513aeeda6e950c69d2152ad453f45be3bdc42aba9d4f01ce20a3";

//图片没加载前默认背景颜色
#define _SeaImageBackgroundColorBeforeDownload_ [UIColor colorFromHexadecimal:@"e6e6e6"]

//self的弱引用
#define WeakSelf(parameter) typeof(self) __weak weakSelf = parameter;

//获取模型
#define kModelKey @"modelKey"
//获取控制器
#define kControllerKey @"controllerKey"

//http请求返回的JSON数据字段
#define WMHttpSuccess 0 //请求成功，结果的值
#define WMHttpData @"data" //返回的数据
#define WMHttpMessage @"msg" //结果信息
#define WMHttpNeedLogin @"need_login" //需要登录
#define WMHttpFail @"fail" //请求失败 结果值
#define WMHtppErrorCode @"errorcode" ///错误码

#define WMHttpMethod @"method" //借口验证方法参数

#define WMHttpPageIndex @"page_no" //翻页页码
#define WMHttpPageIndexStartingValue 1 //翻页起始值
#define WMHttpPageSize @"page_size" //翻页每页数量
#define WMHttpRequestWaiting @"请稍后.."
#define WMHttpPageSizeGood 20 //每页商品数量
#define WMHttpLogInOutTimeCode 10001 //登录超时

#define WMHttpAuthCode @"auth" ///授权码


//勿扰模式
#define WuDaYaoMoShiKey @"WuDaYaoMoShiKey"

//系统默认的蓝色
#define _UIKitTintColor_ [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0]

///主题颜色 透明
#define AppMainTransparentColor [UIColor colorFromHexadecimal:@"e9e5ef"]

///主题红色
#define WMRedColor [UIColor colorFromHexadecimal:@"f73030"]

//绿色
#define WMGreenColor [UIColor colorFromHexadecimal:@"6ec5bf"]
#define WMDeepGreenColor [UIColor colorFromHexadecimal:@"1fb5ad"]
#define WMGreenTransparentColor [UIColor colorFromHexadecimal:@"e9f9f9"]

//粉红色
#define WMPinkColor [UIColor colorFromHexadecimal:@"e30083"]
#define WMPinkTransparentColor [UIColor colorFromHexadecimal:@"fad7eb"]

//蓝色
#define WMBlueColor [UIColor colorFromHexadecimal:@"138dc6"]
#define WMBlueTransparentColor [UIColor colorFromHexadecimal:@"7fd2fa"]

/**红色长按钮样式
 */
#define WMLongButtonTitleFont [UIFont fontWithName:MainFontName size:16.0] ///标题字体
#define WMLongButtonHeight 45.0 ///按钮高度
#define WMLongButtonCornerRaidus (5.0) ///圆角


//动画时间
#define _animatedDuration_ 0.25

//apns 推送设备token 保存在NSUserDefaults中
#define _SeaDeviceToken_ @"SeaDeviceToken"

//判断是否是3.5寸手机
#define is3_5Inch (_height_ == 480)

//判断是否是5.5寸手机
#define is5_5Inch (_height_ == 736)

//判断是否是4.0寸手机
#define is4_0Inch (_height_ == 568 && _width_ == 320)

#endif
