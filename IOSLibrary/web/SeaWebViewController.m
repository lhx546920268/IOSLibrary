//
//  SeaWebViewController.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/8.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaWebViewController.h"
#import "SeaProgressView.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "SeaImageCacheTool.h"
#import "SeaBasic.h"
#import "UIView+SeaAutoLayout.h"
#import "UIViewController+Utils.h"
#import "NSString+Utils.h"
#import "UIWebView+Utils.h"
#import "UIViewController+Utils.h"

/**自定义UIWebView 中的长按手势
 */
@interface SeaWebLongPressGetureRecognizer : UILongPressGestureRecognizer


@end

@implementation SeaWebLongPressGetureRecognizer

/**
 设置手势不会因为其他手势而失败
 */
- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer
{
    return NO;
}

@end

/**JavaScript 执行完成回调
 */
typedef void(^JavaScriptCompletionHandler)(id, NSError*);

///WebView 长按 UIActionSheet 弹出的按钮标题操作

/**打开新链接
 */
static NSString *const SeaWebViewOpenLink = @"打开";

/**存储图像
 */
static NSString *const SeaWebViewSaveImage = @"存储图像";

/**拷贝链接
 */
static NSString *const SeaWebViewCopyLink = @"拷贝链接";

@interface SeaWebViewController ()<UIActionSheetDelegate>

/**加载进度条
 */
@property(nonatomic,strong) SeaProgressView *progressView;

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

@end

@implementation SeaWebViewController

- (id)initWithURL:(NSString*) URL
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        if(![NSString isEmpty:URL]){
            if(![URL hasPrefix:@"http://"] && ![URL hasPrefix:@"https://"]){
                URL = [NSString stringWithFormat:@"http://%@", URL];
            }
            self.URL = [NSURL URLWithString:URL];
        }
        
        _originalURL = [URL copy];
        [self initilization];
    }
    return self;
}

- (id)initWithHtmlString:(NSString*) htmlString
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        self.htmlString = htmlString;
        [self initilization];
    }
    
    return self;
}

//初始化
- (void)initilization
{
    self.useWebTitle = YES;
    self.useCumsterLongPressGesture = NO;
}

#pragma mark- property

- (void)setHtmlString:(NSString *)htmlString
{
    if(_htmlString != htmlString && ![_htmlString isEqualToString:htmlString]){
        if(_adjustScreenWhenLoadHtmlString && ![NSString isEmpty:htmlString]){
            _htmlString = [[NSString stringWithFormat:@"%@%@", [UIWebView adjustScreenHtmlString], htmlString] copy];
        }else{
            _htmlString = [htmlString copy];
        }
    }
}

//设置自定义手势
- (void)setUseCumsterLongPressGesture:(BOOL)useCumsterLongPressGesture
{
    if(_useCumsterLongPressGesture != useCumsterLongPressGesture){
        _useCumsterLongPressGesture = useCumsterLongPressGesture;
        if(_useCumsterLongPressGesture){
            [self createLongPressGestureRecognizer];
        }else{
            [self.webView removeGestureRecognizer:self.longPressGestureRecognizer];
        }
    }
}

//创建长按手势
- (void)createLongPressGestureRecognizer
{
    if(!self.longPressGestureRecognizer && (self.webView || self.webView)){
        SeaWebLongPressGetureRecognizer *longPress = [[SeaWebLongPressGetureRecognizer alloc] initWithTarget:self action:@selector(longPressHandler:)];
        
        [self.webView addGestureRecognizer:longPress];
        self.longPressGestureRecognizer = longPress;
    }
}

- (void)setUseNavigationGoBackWebPage:(BOOL)useNavigationGoBackWebPage
{
    if(_useNavigationGoBackWebPage != useNavigationGoBackWebPage){
        _useNavigationGoBackWebPage = useNavigationGoBackWebPage;
    }
}

#pragma mark- web control

- (BOOL)canGoBack
{
    return [_webView canGoBack];;
}

- (BOOL)canGoForward
{
    return [_webView canGoForward];
}

- (NSURL*)currentURL
{
    return _webView.URL;
}

- (void)goBack
{
    [_webView goBack];
}

- (void)goForward
{
    [_webView goForward];
}

- (void)reload
{
    [_webView reload];
}

///关闭网页
- (void)closeWebPage
{
    [super sea_back];
}

///返回
- (void)sea_back
{
    if(self.useNavigationGoBackWebPage && [self canGoBack]){
        [self goBack];
        
        if(!self.closeBarButtonItem){
            self.closeBarButtonItem = [[self class] sea_barItemWithTitle:@"关闭" target:self action:@selector(closeWebPage)];
            
            if([self.closeBarButtonItem.customView isKindOfClass:[UIButton class]]){
                [(UIButton*)self.closeBarButtonItem.customView setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
            }
            
            self.backBarButtonItem = self.navigationItem.leftBarButtonItem;
            if(!self.backBarButtonItem){
                self.backBarButtonItem = [self sea_setLeftItemWithTitle:@"关闭" action:@selector(sea_back)];
            }
            
            self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:self.backBarButtonItem, self.closeBarButtonItem, nil];
        }
    }else{
        [super sea_back];
    }
}

#pragma mark- dealloc

- (void)dealloc
{
    _webView.scrollView.delegate = nil;
    [_webView removeObserver:self forKeyPath:@"title"];
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark- 加载视图

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initWebView];
    [self loadWebContent];
}

/**初始化webView
 */
- (void)initWebView
{
    //加载进度条条
    UIView *contentView = [UIView new];
    self.contentView = contentView;
    
    SeaProgressView *progressView = [[SeaProgressView alloc] initWithStyle:SeaProgressViewStyleStraightLine];
    progressView.progressColor = SeaWebProgressColor;
    progressView.trackColor = [UIColor clearColor];
    [contentView addSubview:progressView];
    self.progressView = progressView;
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:[self webViewConfiguration]];
    if(@available(iOS 9.0, *)){
        _webView.allowsLinkPreview = NO;
    }
    _webView.allowsBackForwardNavigationGestures = YES;
    _webView.navigationDelegate = self;
    _webView.scrollView.backgroundColor = [UIColor clearColor];
    _webView.backgroundColor = [UIColor clearColor];
    [_webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:nil];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [contentView insertSubview:_webView belowSubview:progressView];
    
    [progressView sea_leftToSuperview];
    [progressView sea_rightToSuperview];
    [progressView sea_topToSuperview];
    [progressView sea_heightToSelf:2.5];
    
    [_webView sea_insetsInSuperview:UIEdgeInsetsZero];
    
    if(self.useCumsterLongPressGesture){
        [self createLongPressGestureRecognizer];
    }
}

- (WKWebViewConfiguration*)webViewConfiguration
{
    WKUserContentController *userContentController = [WKUserContentController new];
    if(self.shouldCloseSystemLongPressGesture || self.useCumsterLongPressGesture){
        //禁止长按弹出 UIMenuController 相关
        //禁止选择 css 配置相关
        NSString *css = @"('body{-webkit-user-select:none;-webkit-user-drag:none;}')";
        //css 选中样式取消
        NSMutableString *javaScript = [NSMutableString new];
        [javaScript appendString:@"var style = document.createElement('style');"];
        [javaScript appendString:@"style.type = 'text/css';"];
        [javaScript appendFormat:@"var cssContent = document.createTextNode%@;", css];
        [javaScript appendString:@"style.appendChild(cssContent);"];
        [javaScript appendString:@"document.body.appendChild(style);"];
        [javaScript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
        [javaScript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
        
        WKUserScript *script = [[WKUserScript alloc] initWithSource:javaScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [userContentController addUserScript:script];
    }
    
    WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
    configuration.userContentController = userContentController;
    
    return configuration;
}

- (void)loadWebContent
{
    if(self.URL){
        [_webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    }else if(self.htmlString){
        [_webView loadHTMLString:self.htmlString baseURL:nil];
    }
}

#pragma mark- kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"estimatedProgress"])
    {
        [self setProgress:_webView.estimatedProgress];
    }else if ([keyPath isEqualToString:@"title"]){
        if(self.useWebTitle){
            self.title = _webView.title;
        }
    }
}

#pragma mark- WKNavigation delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    if([self shouldOpenURL:navigationAction.request.URL]){
        decisionHandler(WKNavigationActionPolicyAllow);
    }else{
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    
}

#pragma mark WKUIDelegate

- (BOOL)webView:(WKWebView *)webView shouldPreviewElement:(WKPreviewElementInfo *)elementInfo NS_AVAILABLE_IOS(10.0)
{
    return NO;
}

#pragma mark- progress handle

//重设进度
- (void)resetProgress
{
    [self setProgress:0.0];
}

//设置加载进度
- (void)setProgress:(float) progress
{
    self.progressView.progress = progress;
}

#pragma mark- longPress handler

/**网页的长按手势
 */
- (void)longPressHandler:(UILongPressGestureRecognizer*) longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan){
        CGPoint point = [longPress locationInView:longPress.view];
        self.longPressPoint = point;
        
        //加载JS代码
        NSString *path = [[NSBundle mainBundle] pathForResource:@"JSTools" ofType:@"js"];
        NSString *jsCode = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        [self evaluateJavaScript:jsCode completionHandler:^(id result, NSError *error){
            
            //获取长按位置的html元素标签
            [self getLongPressHtmlElementWithCompletionHandler:^(id result, NSError *error){
                
                if([result isKindOfClass:[NSString class]]){
                    NSString *tags = result;
                    NSMutableArray *buttonTitles = [NSMutableArray array];
                    
                    [self getLongPressHrefWithCompletionHandler:^(id result, NSError *error){
                        
                        NSString *title = nil;
                        //判断是否是 a标签
                        if ([tags rangeOfString:@",A,"].location != NSNotFound){
                            [buttonTitles addObject:SeaWebViewOpenLink];
                            [buttonTitles addObject:SeaWebViewCopyLink];
                            
                            if([result isKindOfClass:[NSString class]]){
                                title = result;
                            }
                        }
                        
                        if([tags rangeOfString:@",IMG,"].location != NSNotFound){
                            //判断是否是图片
                            [buttonTitles addObject:SeaWebViewSaveImage];
                        }
                        
                        if(buttonTitles.count > 0){
                            UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:nil, nil];
                            for(NSString *str in buttonTitles){
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
    [self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];
}

#pragma mark- UIActionSheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:SeaWebViewOpenLink]){
        //打开链接
        self.URL = [NSURL URLWithString:actionSheet.title];
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
    }else if ([title isEqualToString:SeaWebViewCopyLink]){
        //拷贝链接
        if(![NSString isEmpty:actionSheet.title]){
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            [pasteboard setValue:actionSheet.title forPasteboardType:(NSString*)kUTTypePlainText];
        }
    }else if ([title isEqualToString:SeaWebViewSaveImage]){
        //存储图像
        [self getLongPressImageURLWithCompletionHandler:^(id result, NSError *error){
            
            NSString *imageURL = result;
            if([imageURL isKindOfClass:[NSString class]] && ![NSString isEmpty:imageURL]){
                SeaImageCacheTool *imageCache = [SeaImageCacheTool sharedInstance];
                [imageCache imageForURL:imageURL thumbnailSize:CGSizeZero completion:^(UIImage *image){
                    if(image){
                        UIImageWriteToSavedPhotosAlbum(image, nil, NULL, NULL);
                        [imageCache removeCacheImageForURLs:[NSArray arrayWithObject:imageURL]];
                    }
                } target:self];
            }
        }];
    }
}

#pragma mark- 页面是否可以打开

- (BOOL)shouldOpenURL:(NSURL*) URL
{
    return YES;
}


@end
