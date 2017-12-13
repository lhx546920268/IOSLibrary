//
//  SeaViewController.m

//
//

#import "SeaViewController.h"
#import "UIViewController+Utils.h"
#import "SeaBasic.h"
#import "SeaContainer.h"
#import "SeaTabBarController.h"

@interface SeaViewController ()


@end

@implementation SeaViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.statusBarHidden = NO;
        self.sea_hideTabBar = YES;
        self.iconTintColor = SeaTintColor;
    }
    return self;
}


#pragma mark- 视图消失出现

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    SeaTabBarController *tabBarController = self.sea_tabBarController;
    if(tabBarController)
    {
        [tabBarController setTabBarHidden:self.sea_hideTabBar animated:YES];
    }
}

- (void)loadView
{
    _container = [[SeaContainer alloc] init];
    self.view = self.container;
}

- (void)setTopView:(UIView *)topView
{
    [_container setTopView:topView];
}

- (UIView*)topView
{
    return _container.topView;
}

- (void)setBottomView:(UIView *)bottomView
{
    [_container setBottomView:bottomView];
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
}

#pragma mark- UIStatusBar

/**用于 present ViewController 的 statusBar 隐藏状态控制
 */
- (BOOL)prefersStatusBarHidden
{
    return self.sea_statusBarHidden;
}

@end
