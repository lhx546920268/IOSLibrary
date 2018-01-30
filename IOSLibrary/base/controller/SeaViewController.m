//
//  SeaViewController.m

//
//

#import "SeaViewController.h"
#import "UIViewController+Utils.h"
#import "SeaBasic.h"
#import "SeaContainer.h"
#import "SeaTabBarController.h"
#import "UIView+SeaAutoLayout.h"

@interface SeaViewController ()


@end

@implementation SeaViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.sea_statusBarHidden = NO;
        self.sea_iconTintColor = SeaTintColor;
    }
    return self;
}

#pragma mark- 视图消失出现

- (void)loadView
{
    _container = [[SeaContainer alloc] initWithViewController:self];
    self.view = self.container;
}

- (void)setTopView:(UIView *)topView
{
    [_container setTopView:topView];
}

- (void)setTopView:(UIView *)topView height:(CGFloat)height
{
    [_container setTopView:topView height:height];
}

- (UIView*)topView
{
    return _container.topView;
}

- (void)setBottomView:(UIView *)bottomView
{
    [_container setBottomView:bottomView];
}

- (void)setBottomView:(UIView *)bottomView height:(CGFloat)height
{
    [_container setBottomView:bottomView height:height];
}

- (UIView*)bottomView
{
    return _container.bottomView;
}

- (void)setContentView:(UIView *)contentView
{
    [_container setContentView:contentView];
}

- (UIView*)contentView
{
    return _container.contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if(self.navigationController.viewControllers.count > 1){
        self.sea_showBackItem = YES;
    }
}

#pragma mark- UIStatusBar

/**用于 present ViewController 的 statusBar 隐藏状态控制
 */
- (BOOL)prefersStatusBarHidden
{
    return self.sea_statusBarHidden;
}

- (void)viewDidLayoutSubviews
{
    
}

@end
