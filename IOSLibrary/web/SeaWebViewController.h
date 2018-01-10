//
//  SeaWebViewController.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/8.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaViewController.h"

@class WKWebView;

@interface SeaWebViewController : SeaViewController

/**网页视图，ios8.0新出的api，更高效地显示网页
 */
@property(nonatomic,readonly) WKWebView *webView;


/**
 是否使用导航栏回退网页 default is 'NO'
 */
@property(nonatomic,assign) BOOL useNavigationGoBackWebPage;

/**
 是否可以倒退
 */
@property(nonatomic,readonly) BOOL canGoBack;

/**
 是否可以前进
 */
@property(nonatomic,readonly) BOOL canGoForward;

/**
 是否使用自定义的长按手势 default is 'NO'
 */
@property(nonatomic,assign) BOOL useCumsterLongPressGesture;

/**
 当前链接
 */
@property(nonatomic,readonly) NSURL *currentURL;

/**
 第一个链接
 */
@property(nonatomic,readonly) NSString *originalURL;

/**
 将要打开的链接
 */
@property(nonatomic,copy) NSURL *URL;

/**
 将要打开的html
 */
@property(nonatomic,copy) NSString *htmlString;

/**
 是否直接加载内容当viewDidLoad default is 'YES'
 */
@property(nonatomic,assign) BOOL loadWebContentWhileViewDidLoad;

/**
 是否使用 web里面的标题，使用会self.title 替换成web的标题，default is 'YES'
 */
@property(nonatomic,assign) BOOL useWebTitle;

/**
 载入htmlString 是否根据屏幕适配 default is 'NO'
 */
@property(nonatomic,assign) BOOL adjustScreenWhenLoadHtmlString;

/**
 构造方法
 *@param URL 将要打开的链接
 *@return 一个实例
 */
- (id)initWithURL:(NSString*) URL;

/**
 构造方法
 *@param htmlString 将要打开的html
 *@return 一个实例
 */
- (id)initWithHtmlString:(NSString*) htmlString;

/**后退
 */
- (void)goBack;

/**前进
 */
- (void)goForward;

/**刷新
 */
- (void)reload;

/**加载网页
 */
- (void)loadWebContent;

/**
 是否应该打开某个链接 default is 'YES'
 */
- (BOOL)shouldOpenURL:(NSURL*) URL;

@end
