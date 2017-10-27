//
//  SeaWebViewController.m

//

#import "SeaWebViewController.h"
#import "SeaProgressView.h"
#import "SeaWebToolBar.h"
#import "SeaTabBarController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SeaImageCacheTool.h"
#import <WebKit/WebKit.h>
#import "SeaBasic.h"

/**自定义UIWebView 中的长按手势
 */
@interface SeaWebLongPressGetureRecognizer : UILongPressGestureRecognizer


@end

@implementation SeaWebLongPressGetureRecognizer

/**设置手势不会因为其他手势而失败
 */
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return NO;
}

@end

/**加载进度构造体
 */
typedef struct
{
    NSInteger loadingCount;       //当前已加载的数量
    NSInteger maxLoadCount;       //最大加载数量
    BOOL interactive;        //用户是否在交互
    float progress; // 加载进度 0.0 ~ 1.0
}SeaWebProgressState;

/**JavaScript 报出页面加载完成
 */
static NSString *const SeaWebViewCompleteURL = @"SeaWebViewProgress:///complete";

/**JavaScript 执行完成回调
 */
typedef void(^JavaScriptCompletionHandler)(id, NSError*);

///UIWebView 长按 UIActionSheet 弹出的按钮标题操作

/**打开新链接
 */
static NSString *const SeaWebViewOpenLink = @"打开";

/**存储图像
 */
static NSString *const SeaWebViewSaveImage = @"存储图像";

/**拷贝链接
 */
static NSString *const SeaWebViewCopyLink = @"拷贝链接";

@interface SeaWebViewController ()<WKNavigationDelegate>
{
    //判断视图滚动方向
    BOOL _beganDrag; //是否开始滚动，防止页面加载完成时scrollViewDidScroll 调用，导致bar隐藏
    CGFloat _contentOffsetY; //起始滚动时的 offset.y
    CGFloat _newContentOffsetY; //最新的 offset.y
}

/**网页视图
 */
@property(nonatomic,readonly) UIWebView *webView;

#ifdef __IPHONE_8_0

/**网页视图，ios8.0新出的api，更高效地显示网页
 */
@property(nonatomic,readonly) WKWebView *wkWebView;

#endif

/**加载指示器
 */
@property(nonatomic,strong) UIActivityIndicatorView *actView;

/**加载进度条
 */
@property(nonatomic,strong) SeaProgressView *progressView;

/**页面加载进度状态
 */
@property(nonatomic,assign) SeaWebProgressState progressState;

/**工具条
 */
@property(nonatomic,strong) SeaWebToolBar *toolBar;

/**bar 是否要隐藏
 */
@property(nonatomic,assign) BOOL hideBar;

/**长按手势
 */
@property(nonatomic,strong) SeaWebLongPressGetureRecognizer *longPressGestureRecognizer;

/**当前长按的位置
 */
@property(nonatomic,assign) CGPoint longPressPoint;

///返回按钮
@property(nonatomic,strong) UIBarButtonItem *backBarButtonItem;

///关闭整个网页按钮
@property(nonatomic,strong) UIBarButtonItem *closeBarButtonItem;

///第一个链接 用来判断是否需要打开商品详情
@property(nonatomic,copy) NSString *firstURL;

@end

@implementation SeaWebViewController

/**构造方法
 *@param url 将要打开的链接
 */
- (id)initWithURL:(NSString*) url
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        if(![NSString isEmpty:url])
        {
            if(![url hasPrefix:@"http://"] && ![url hasPrefix:@"https://"])
            {
                url = [NSString stringWithFormat:@"http://%@",url];
            }
            self.URL = [NSURL URLWithString:url];
        }
        
        self.firstURL = [self.URL absoluteString];
        [self initilization];
    }
    return self;
}

/**构造方法
 *@param htmlString 将要打开的html
 */
- (id)initWithHtmlString:(NSString*) htmlString
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        self.htmlString = htmlString;
        [self initilization];
    }

    return self;
}

//初始化
- (void)initilization
{
    _loadWebContentWhileViewDidLoad = YES;
    _barHideStyle = SeaWebViewBarHideStyleOnlyToolBar;
    self.useWebTitle = YES;
    self.useCumsterLongPressGesture = NO;
}

#pragma mark- property setup

/**将要打开的html
 */
- (void)setHtmlString:(NSString *)htmlString
{
    if(_htmlString != htmlString)
    {
        if(_adjustScreenWhenLoadHtmlString && ![NSString isEmpty:htmlString])
        {
            _htmlString = [[NSString stringWithFormat:@"%@%@", [UIWebView adjustScreenHtmlString], htmlString] copy];
        }
        else
        {
            _htmlString = [htmlString copy];
        }
    }
}

//设置bar的隐藏方式
- (void)setBarHideStyle:(SeaWebViewBarHideStyle)barHideStyle
{
    if(_barHideStyle != barHideStyle)
    {
        _barHideStyle = barHideStyle;
        switch (_barHideStyle)
        {
            case SeaWebViewBarHideStyleNone :
            {
                [self setToolBarHidden:NO animated:NO];
                [self setNavigationBarHidden:NO animated:NO];
            }
                break;
            case SeaWebViewBarHideStyleOnlyNavigationBar :
            {
                [self setToolBarHidden:NO animated:NO];
            }
                break;
            case SeaWebViewBarHideStyleOnlyToolBar :
            {
                [self setNavigationBarHidden:NO animated:NO];
            }
                break;
            default:
                break;
        }

        [self resizeWebViewWithAnimated:NO];
    }
}

//设置自定义手势
- (void)setUseCumsterLongPressGesture:(BOOL)useCumsterLongPressGesture
{
    if(_useCumsterLongPressGesture != useCumsterLongPressGesture)
    {
        _useCumsterLongPressGesture = useCumsterLongPressGesture;
        if(_useCumsterLongPressGesture)
        {
            [self createLongPressGestureRecognizer];
        }
        else
        {
            if(_ios8_0_)
            {
#ifdef __IPHONE_8_0
                [self.wkWebView removeGestureRecognizer:self.longPressGestureRecognizer];
#endif
            }
            else
            {
                [self.webView removeGestureRecognizer:self.longPressGestureRecognizer];
            }
        }
    }
}

//创建长按手势
- (void)createLongPressGestureRecognizer
{
    if(!self.longPressGestureRecognizer && (self.webView || self.wkWebView))
    {
        SeaWebLongPressGetureRecognizer *longPress = [[SeaWebLongPressGetureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];

        if(_ios8_0_)
        {
#ifdef __IPHONE_8_0
            [self.wkWebView addGestureRecognizer:longPress];
#endif
        }
        else
        {
            [self.webView addGestureRecognizer:longPress];
        }

        self.longPressGestureRecognizer = longPress;
    }
}

/**是否显示工具条 default is 'NO'
 */
- (void)setShowToolBar:(BOOL)showToolBar
{
    if(_showToolBar != showToolBar)
    {
        _showToolBar = showToolBar;
        if(_showToolBar && !_toolBar)
        {
            //创建工具条
            SeaWebToolBar *toolBar= [[SeaWebToolBar alloc] initWithWebViewController:self];
            self.toolBar = toolBar;
        }
        [self setHideBar:!_showToolBar];
    }
}

- (void)setUseNavigationGoBackWebPage:(BOOL)useNavigationGoBackWebPage
{
    if(_useNavigationGoBackWebPage != useNavigationGoBackWebPage)
    {
        _useNavigationGoBackWebPage = useNavigationGoBackWebPage;
    }
}

#pragma mark- property readonly

/**是否可以倒退
 */
- (BOOL)canGoBack
{
    BOOL canGoBack = NO;
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        canGoBack = [_wkWebView canGoBack];
#endif
    }
    else
    {
        canGoBack = [_webView canGoBack];
    }

    return canGoBack;
}

/**是否可以前进
 */
- (BOOL)canGoForward
{
    BOOL canGoForward = NO;
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        canGoForward = [_wkWebView canGoForward];
#endif
    }
    else
    {
        canGoForward = [_webView canGoForward];
    }

    return canGoForward;
}

- (NSString*)curURL
{
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        return [_wkWebView.URL absoluteString];
#endif
    }
    else
    {
        return [_webView curURL];
    }
}

#pragma mark- web function

/**后退
 */
- (void)goBack
{
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        [_wkWebView goBack];
#endif
    }
    else
    {
        [_webView goBack];
    }
}

/**前进
 */
- (void)goForward
{
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        [_wkWebView goForward];
#endif
    }
    else
    {
        [_webView goForward];
    }
}

/**刷新
 */
- (void)reload
{
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        [_wkWebView reload];
#endif
    }
    else
    {
        [_webView reload];
    }
}

///关闭网页
- (void)closeWebPage
{
    [super back];
}

///返回
- (void)back
{
    if(self.useNavigationGoBackWebPage && [self canGoBack])
    {
        [self goBack];

        if(!self.closeBarButtonItem)
        {
            self.closeBarButtonItem = [self barButtonItemWithTitle:@"关闭" icon:nil action:@selector(closeWebPage)];

            if([self.closeBarButtonItem.customView isKindOfClass:[UIButton class]])
            {
                [(UIButton*)self.closeBarButtonItem.customView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            }

            if(!self.backBarButtonItem)
            {
                self.backBarButtonItem = self.leftBarButtonItem;
                if(!self.backBarButtonItem)
                {
                    self.backBarButtonItem = [self barButtonItemWithTitle:@"返回" icon:nil action:@selector(back)];
                }
                self.backBarButtonItem.customView.width -= 5.0;
            }

            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:self.backBarButtonItem, self.closeBarButtonItem, nil];
        }
    }
    else
    {
        [super back];
    }
}

#pragma mark- dealloc

- (void)dealloc
{
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0

        _wkWebView.scrollView.delegate = nil;
        [_wkWebView removeObserver:self forKeyPath:@"title"];
        [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
#endif
    }
    else
    {
        _webView.scrollView.delegate = nil;
        [_webView clean];
    }
}

#pragma mark- 加载视图

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.hidesBottomBarWhenPushed = YES;

    [self initWebView];
    if(self.loadWebContentWhileViewDidLoad)
    {
        [self loadWebContent];
    }
}

/**初始化webView
 */
- (void)initWebView
{
    //加载进度条条
    SeaProgressView *progressView = [[SeaProgressView alloc] initWithFrame:CGRectMake(0, 0, _width_, 2.5) style:SeaProgressViewStyleStraightLine];
    progressView.progressColor = _UIKitTintColor_;
    progressView.trackColor = [UIColor clearColor];
    [self.view addSubview:progressView];
    self.progressView = progressView;


    CGRect frame = CGRectMake(0, 0, _width_, self.contentHeight);
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        _wkWebView = [[WKWebView alloc] initWithFrame:frame];
        _wkWebView.scrollView.delegate = self;
        _wkWebView.navigationDelegate = self;
        [_wkWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
        [_wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
        [self.view insertSubview:_wkWebView belowSubview:progressView];
#endif
    }
    else
    {
        //创建浏览器
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.scrollView.delegate = self;
        _webView.delegate = self;
        _webView.scalesPageToFit = YES;
        [self.view insertSubview:_webView belowSubview:progressView];
    }

    if(self.useCumsterLongPressGesture)
    {
        [self createLongPressGestureRecognizer];
    }
}

/**加载网页
 */
- (void)loadWebContent
{
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        if(self.URL)
        {
            [_wkWebView loadRequest:[NSURLRequest requestWithURL:self.URL]];
        }
        else if(self.htmlString)
        {
            [_wkWebView loadHTMLString:self.htmlString baseURL:nil];
        }
#endif
    }
    else
    {
        if(self.URL)
        {
            [_webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
        }
        else if(self.htmlString)
        {
            [_webView loadHTMLString:self.htmlString baseURL:nil];
            self.htmlString = nil;
        }
    }
}

#pragma mark- kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        if([keyPath isEqualToString:@"estimatedProgress"])
        {
            [self setProgress:_wkWebView.estimatedProgress];
            if(_wkWebView.estimatedProgress == 1.0)
            {
                [self cancelLongPressGesture];
                [self adjustFontPercent];
            }
            [self.toolBar refreshToolBar];
        }
        else if ([keyPath isEqualToString:@"title"])
        {
            if(self.useWebTitle)
            {
                self.title = _wkWebView.title;
            }
        }
#endif
    }
}

#pragma mark- UIWebView delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(![self shouldOpenURL:request.URL.absoluteString])
    {
        return NO;
    }

    BOOL shouldStart = YES;

    //通过添加的侦听器 判断页面是否加载完成了
    if ([request.URL.absoluteString isEqualToString:SeaWebViewCompleteURL])
    {
        [self setProgress:1.0];
        return NO;
    }

    //如果 URL 包含一个 碎片跳转，如作者标签，判断它是否关联当前的页面。
    //如果 是在同一个页面跳转，不显示加载进度条
    BOOL isFragmentJump = NO;
    if (request.URL.fragment)
    {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }

    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];

    //是否是http请求
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];

    if (shouldStart && !isFragmentJump && isHTTP && isTopLevelNavigation)
    {
        //保存当前请求的 url
        self.URL = [request URL];
        [self resetProgress];
    }

    return shouldStart;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    [self.toolBar refreshToolBar];
    [self handelRequestCompletion];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

    if(self.useWebTitle)
    {
        self.title = self.webView.title;
    }
    [self.toolBar refreshToolBar];
    [self handelRequestCompletion];
    [self cancelLongPressGesture];
    [self adjustFontPercent];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];

    //添加请求数量
    _progressState.loadingCount++;

    //设置最大请求数量
    _progressState.maxLoadCount = MAX(_progressState.maxLoadCount, _progressState.loadingCount);

    if(self.progressState.progress < 0.1)
    {
        [self setProgress:0.1];
    }

    [self.toolBar refreshToolBar];
}

#pragma mark- WKNavigation delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if([self shouldOpenURL:navigationAction.request.URL.absoluteString])
    {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
    else
    {
        decisionHandler(WKNavigationActionPolicyCancel);
    }
}

#pragma mark- UIScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _contentOffsetY = scrollView.contentOffset.y;
    _beganDrag = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_beganDrag)
        return;
    //判断视图滚动方向
    _newContentOffsetY = scrollView.contentOffset.y;

    if(_newContentOffsetY > _contentOffsetY && scrollView.contentSize.height > _newContentOffsetY + scrollView.frame.size.height)
    {
        //向上滚
        self.hideBar = YES;
    }
    else if(_newContentOffsetY < _contentOffsetY)
    {
        //向下滚
        self.hideBar = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _beganDrag = NO;
}


//设置是否隐藏 导航栏和工具条
- (void)setHideBar:(BOOL)hideBar
{
    if(_hideBar != hideBar)
    {
        _hideBar = hideBar;
        switch (_barHideStyle)
        {
            case SeaWebViewBarHideStyleAll :
            {
                [self setToolBarHidden:self.hideBar animated:YES];
                [self setNavigationBarHidden:self.hideBar animated:YES];
            }
                break;
            case SeaWebViewBarHideStyleOnlyNavigationBar :
            {
                [self setNavigationBarHidden:self.hideBar animated:YES];
            }
                break;
            case SeaWebViewBarHideStyleOnlyToolBar :
            {
                [self setToolBarHidden:self.hideBar animated:YES];
            }
                break;
            default:
                break;
        }

        [self resizeWebViewWithAnimated:YES];
    }
}

#pragma mark- progress handle

//重设进度
- (void)resetProgress
{
    self.hideBar = NO;
    [self setProgress:0.0];
    _progressState.loadingCount = 0;
    _progressState.maxLoadCount = 0;
    _progressState.interactive = NO;
}

//设置加载进度
- (void)setProgress:(float) progress
{
    if(progress > _progressState.progress || progress == 0.0 || _webView == nil)
    {
        _progressState.progress = progress;
        self.progressView.progress = _progressState.progress;
    }
}

//增加进度条进度
- (void)incrementLoadProgress
{
    float progress          = self.progressView.progress;
    float maxProgress       = _progressState.interactive ? 0.9 : 0.5;
    float remainingPercent  = (float)_progressState.loadingCount / (float)_progressState.maxLoadCount;
    float increment         = (maxProgress - progress) * remainingPercent;
    progress                = fmin((progress + increment), maxProgress);

    [self setProgress:progress];
}

//页面加载完成
- (void)handelRequestCompletion
{
    //减少当前的请求数量
    _progressState.loadingCount--;

    //更新进度条
    [self incrementLoadProgress];

    //获取 Javascript 的加载状态
    NSString *readyState = [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];

    //interactive 是指页面加载到已经允许用户交互
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive)
    {
        _progressState.interactive = YES;

        //增加一个Javascript侦听器，页面加载完成时通知我们
        NSString *waitForCompleteJS = [NSString stringWithFormat:
                                       @"window.addEventListener('load',function() { "
                                       @"var iframe = document.createElement('iframe');"
                                       @"iframe.style.display = 'none';"
                                       @"iframe.src = '%@';"
                                       @"document.body.appendChild(iframe);"
                                       @"}, false);", SeaWebViewCompleteURL];

        [self.webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];

        //设置导航栏标题
        self.title = self.webView.title;
    }

    //判断页面是否重定向了
    BOOL isNotRedirect = self.URL && [self.URL isEqual:self.webView.request.URL];

    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect)
    {
        [self setProgress:1.0];
    }
}

#pragma mark- bar handle

//设置导航栏的隐藏状态
- (void)setNavigationBarHidden:(BOOL) hidden animated:(BOOL) flag
{
    [self.Sea_TabBarController setStatusBarHidden:hidden];
    [self.navigationController setNavigationBarHidden:hidden animated:flag];
}

//设置工具条的隐藏状态
- (void)setToolBarHidden:(BOOL) hidden animated:(BOOL) flag
{
    [self.toolBar setToolBarHidden:hidden animate:flag];
}

//重新设置webView 的 frame
- (void)resizeWebViewWithAnimated:(BOOL) flag
{
    UIView *webView = _ios8_0_ ? self.wkWebView : self.webView;

    CGRect frame = webView.frame;
    frame.size.height = self.contentHeight - ((self.showToolBar && !self.toolBar.toolBarHidden) ? _toolBarHeight_ : 0);

    if(flag)
    {
        [UIView animateWithDuration:0.25 animations:^(void){

            webView.frame = frame;
        }];
    }
    else
    {
        webView.frame = frame;
    }
}

#pragma mark- longPress handler

/**网页的长按手势
 */
- (void)longPressHandler:(UILongPressGestureRecognizer*) longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        CGPoint point = [longPress locationInView:longPress.view];
        self.longPressPoint = point;

        //加载JS代码
        NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

        [self evaluateJavaScript:jsCode completionHandler:^(id result, NSError *error){

            //获取长按位置的html元素标签
            [self getLongPressHtmlElementWithCompletionHandler:^(id result, NSError *error){

                if([result isKindOfClass:[NSString class]])
                {
                    NSString *tags = result;
                    NSMutableArray *buttonTitles = [NSMutableArray array];

                    [self getLongPressHrefWithCompletionHandler:^(id result, NSError *error){

                        NSString *title = nil;
                        //判断是否是 a标签
                        if ([tags rangeOfString:@",A,"].location != NSNotFound)
                        {
                            [buttonTitles addObject:SeaWebViewOpenLink];
                            [buttonTitles addObject:SeaWebViewCopyLink];

                            if([result isKindOfClass:[NSString class]])
                            {
                                title = result;
                            }
                        }

                        if ([tags rangeOfString:@",IMG,"].location != NSNotFound)
                        {
                            //判断是否是图片
                            [buttonTitles addObject:SeaWebViewSaveImage];
                        }

                        if(buttonTitles.count > 0)
                        {
                            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                            for(NSString *str in buttonTitles)
                            {
                                [actionSheet addButtonWithTitle:str];
                            }

                            [actionSheet showInView:self.view];
                        }
                    }];
                }
            }];
        }];
    }
}

/**获取长按位置的图像链接
 */
- (void)getLongPressImageURLWithCompletionHandler:(JavaScriptCompletionHandler) completionHandler
{
    CGPoint point = self.longPressPoint;
    [self evaluateJavaScript:[NSString stringWithFormat:@"MyAppGetLinkSRCAtPoint(%i,%i);",(int)point.x,(int)point.y] completionHandler:completionHandler];
}

/**获取长按位置的a标签链接
 */
- (void)getLongPressHrefWithCompletionHandler:(JavaScriptCompletionHandler) completionHandler
{
    CGPoint point = self.longPressPoint;
    [self evaluateJavaScript:[NSString stringWithFormat:@"MyAppGetLinkHREFAtPoint(%i,%i);",(int)point.x,(int)point.y] completionHandler:completionHandler];
}

/**获取长按位置的html元素标签
 */
- (void)getLongPressHtmlElementWithCompletionHandler:(JavaScriptCompletionHandler) completionHandler
{
    CGPoint point = self.longPressPoint;
    [self evaluateJavaScript:[NSString stringWithFormat:@"MyAppGetHTMLElementsAtPoint(%i,%i);",(int)point.x,(int)point.y] completionHandler:completionHandler];
}

/**执行JavaScript
 */
- (void)evaluateJavaScript:(NSString *)javaScriptString completionHandler:(JavaScriptCompletionHandler)completionHandler
{
    if(_ios8_0_)
    {
#ifdef __IPHONE_8_0
        [self.wkWebView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
#endif
    }
    else
    {
        NSString *result = [self.webView stringByEvaluatingJavaScriptFromString:javaScriptString];
        if(completionHandler)
        {
            completionHandler(result,nil);
        }
    }
}

#pragma mark- JavaScript

/**取消长按手势
 */
- (void)cancelLongPressGesture
{
    //取消系统的长按手势
    if(self.useCumsterLongPressGesture)
    {
        [self evaluateJavaScript:
         @"document.body.style.webkitTouchCallout='none';"
         @"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    }
}

///调整字体比例
- (void)adjustFontPercent
{
    if(_fontPercent)
    {
        [self evaluateJavaScript:[NSString stringWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%@'", _fontPercent] completionHandler:nil];
    }
}

#pragma mark- UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];

    if([title isEqualToString:SeaWebViewOpenLink])
    {
        //打开链接
        self.URL = [NSURL URLWithString:actionSheet.title];
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    }
    else if ([title isEqualToString:SeaWebViewCopyLink])
    {
        //拷贝链接
        if(![NSString isEmpty:actionSheet.title])
        {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setValue:actionSheet.title forPasteboardType:(NSString*)kUTTypePlainText];
        }
    }
    else if ([title isEqualToString:SeaWebViewSaveImage])
    {
        //存储图像
        [self getLongPressImageURLWithCompletionHandler:^(id result, NSError *error){

            NSString *imageURL = result;
            if([imageURL isKindOfClass:[NSString class]] && ![NSString isEmpty:imageURL])
            {
                SeaImageCacheTool *imageCache = [SeaImageCacheTool sharedInstance];
                [imageCache getImageWithURL:imageURL thumbnailSize:CGSizeZero completion:^(UIImage *image, BOOL fromNetwork){
                    if(image)
                    {
                        UIImageWriteToSavedPhotosAlbum(image, nil, NULL, NULL);
                        [imageCache removeCacheImageWithURL:[NSArray arrayWithObject:imageURL]];
                    }
                } target:self];
            }
        }];
    }
}

#pragma mark- 页面是否可以打开

- (BOOL)shouldOpenURL:(NSString*) url
{

    return YES;
}

@end
