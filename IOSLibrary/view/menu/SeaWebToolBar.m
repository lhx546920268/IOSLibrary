//
//  SeaWebToolBar.m

//

#import "SeaWebToolBar.h"
#import "SeaWebViewController.h"
#import "SeaButton.h"
#import "SeaBasic.h"

@interface SeaWebToolBar ()

//浏览器
@property(nonatomic,weak) SeaWebViewController *webViewController;

//分享
@property(nonatomic,strong) SeaButton *shareButton;

//系统默认的蓝色
#define _UIKitTintColor_ [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0]

@end

@implementation SeaWebToolBar

/**构造方法
 *@param webViewController 浏览器
 *@return 一个实例
 */
- (id)initWithWebViewController:(SeaWebViewController*)  webViewController
{
    self = [super init];
    if(self)
    {
        self.webViewController = webViewController;
        
        //创建工具条按钮
        NSMutableArray *items = [NSMutableArray arrayWithCapacity:4];
        
        CGFloat width = 64.0;

        CGFloat height = self.webViewController.toolBarHeight;
        
        //后退按钮
        SeaButton *btn = [[SeaButton alloc] initWithFrame:CGRectMake(0, 0, width, height) buttonType:SeaButtonTypeLeftArrow];
        btn.lineColor = _UIKitTintColor_;
        [btn addTarget:self action:@selector(backword:) forControlEvents:UIControlEventTouchUpInside];
        self.backwordButton = btn;
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.backwordButton];
        [items addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [items addObject:item];
        
        //前进按钮
        btn = [[SeaButton alloc] initWithFrame:CGRectMake(0, 0, width, height) buttonType:SeaButtonTypeRightArrow];
        btn.lineColor = _UIKitTintColor_;
        [btn addTarget:self action:@selector(forwrod:) forControlEvents:UIControlEventTouchUpInside];
        self.forwrodButton = btn;
        
        item = [[UIBarButtonItem alloc] initWithCustomView:self.forwrodButton];
        [items addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [items addObject:item];
        
        //刷新按钮
        btn = [[SeaButton alloc] initWithFrame:CGRectMake(0, 0, width, height) buttonType:SeaButtonTypeRefresh];
        btn.lineColor = _UIKitTintColor_;
        [btn addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventTouchUpInside];
        self.refreshButton = btn;
        
        item = [[UIBarButtonItem alloc] initWithCustomView:self.refreshButton];
        [items addObject:item];
        
        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        [items addObject:item];
        
        //分享按钮
//        btn = [[SeaButton alloc] initWithFrame:CGRectMake(0, 0, width, height) buttonType:SeaButtonTypeUpload];
//        btn.lineColor = _UIKitTintColor_;
//        [btn addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
//        self.shareButton = btn;
//        
//        item = [[UIBarButtonItem alloc] initWithCustomView:self.shareButton];
//        [items addObject:item];
//        
//        item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//        [items addObject:item];
        
        _toolBar = [[UIToolbar alloc] init];
        [_toolBar setItems:items];
        _toolBar.translatesAutoresizingMaskIntoConstraints = NO;
        
        
        [self.webViewController.view addSubview:_toolBar];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_toolBar);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_toolBar]-0-|" options:0 metrics:nil views:views];
        [self.webViewController.view addConstraints:constraints];
        constraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:[_toolBar(%f)]-0-|", _toolBarHeight_] options:0 metrics:nil views:views];
        [self.webViewController.view addConstraints:constraints];
        
        [self refreshToolBar];
    }
    return self;
}

/**设置toolBar的隐藏状态
 */
- (void)setToolBarHidden:(BOOL) hidden animate:(BOOL) flag
{
    self.toolBarHidden = hidden;
    CATransform3D transform = CATransform3DIdentity;
    if(hidden)
    {
        transform = CATransform3DMakeTranslation(0, _toolBarHeight_, 0);
    }
    
    if(!hidden)
    {
        self.toolBar.hidden = hidden;
    }
    
    if(flag)
    {
        [UIView animateWithDuration:0.25 animations:^(void){
            
            self.toolBar.layer.transform = transform;
        }completion:^(BOOL finish){
            
            self.toolBar.hidden = hidden;
        }];
    }
    else
    {
        self.toolBar.layer.transform = transform;
        self.toolBar.hidden = hidden;
    }
}

#pragma mark- dealloc

- (void)dealloc
{
    self.webViewController.navigationController.toolbarHidden = YES;
}

//#pragma mark- public method
//
//- (UIToolbar*)toolBar
//{
//    return self.webViewController.navigationController.toolbar;
//}

//刷新工具条功能
- (void)refreshToolBar
{
    self.backwordButton.enabled = self.webViewController.canGoBack;
    self.forwrodButton.enabled = self.webViewController.canGoForward;
}

#pragma mark- private method

//后退
- (void)backword:(SeaButton*) btn
{
    [self.webViewController goBack];
    [self refreshToolBar];
}

//前进
- (void)forwrod:(SeaButton*) btn
{
    [self.webViewController goForward];
    [self refreshToolBar];
}

//刷新
- (void)refresh:(SeaButton*) btn
{
    [self.webViewController reload];
}

//分享
- (void)share:(SeaButton*) btn
{
    
}

@end
