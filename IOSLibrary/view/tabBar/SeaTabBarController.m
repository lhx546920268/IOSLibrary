//
//  SeaTabBarViewController.m

//

#import "SeaTabBarController.h"
#import "SeaTabBar.h"
#import "SeaTabBarItem.h"
#import "SeaViewController.h"
#import "SeaBasic.h"

@implementation SeaTabBarItemInfo

/**便利构造方法
 *@return 一个实例
 */
+ (instancetype)infoWithTitle:(NSString*) title normalImage:(UIImage*) normalImage selectedImage:(UIImage*) selectedImage viewController:(UIViewController*) viewControllr
{
    SeaTabBarItemInfo *info = [[SeaTabBarItemInfo alloc] init];
    info.title = title;
    info.normalImage = normalImage;
    info.selectedImage = selectedImage;
    info.viewController = viewControllr;
    
    return info;
}

/**便利构造方法
 *@return 一个实例
 */
+ (instancetype)infoWithTitle:(NSString*) title normalImage:(UIImage*) normalImage viewController:(UIViewController *)viewControllr
{
    SeaTabBarItemInfo *info = [[SeaTabBarItemInfo alloc] init];
    info.title = title;
    info.normalImage = normalImage;
    info.viewController = viewControllr;
    
    return info;
}

@end

@interface SeaTabBarController ()<SeaTabBarDelegate>

/**选中的视图 default is '0'
 */
@property(nonatomic,assign) NSInteger selectedItemIndex;

/**状态栏隐藏
 */
@property(nonatomic,assign) BOOL statusHidden;

/**系统状态栏样式
 */
@property(nonatomic,assign) UIStatusBarStyle statusStyle;

@end

@implementation SeaTabBarController

/**构造方法
 *@param itemInfos 选项卡按钮 数组元素是 SeaTabBarItemInfo
 *@return 一个实例
 */
- (id)initWithItemInfos:(NSArray*) itemInfos
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _itemInfos = [itemInfos copy];
        
        //创建选项卡按钮
        NSMutableArray *tabbarItems = [NSMutableArray arrayWithCapacity:itemInfos.count];
        
        CGFloat width = _width_ / itemInfos.count;
        
        for(NSInteger i = 0;i < itemInfos.count;i ++)
        {
            
            //创建选项卡按钮
            SeaTabBarItemInfo *info = [itemInfos objectAtIndex:i];
            SeaTabBarItem *item = [[SeaTabBarItem alloc] initWithFrame:CGRectMake(i * width, 0, width, _tabBarHeight_) normalImage:info.normalImage selectedImage:info.selectedImage title:info.title];
            [tabbarItems addObject:item];
            
            
            //设置 tabBarController 属性
            UINavigationController *nav = (UINavigationController*)info.viewController;
            
            if([nav isKindOfClass:[UINavigationController class]])
            {
                SeaViewController *vc = [nav.viewControllers firstObject];
                
                if([vc isKindOfClass:[SeaViewController class]])
                {
                    vc.Sea_TabBarController = self;
                    vc.hideTabBar = NO;
                }
            }
            else if([nav isKindOfClass:[SeaViewController class]])
            {
                SeaViewController *vc = (SeaViewController*)nav;
                vc.Sea_TabBarController = self;
                vc.hideTabBar = NO;
            }
        }
        _tabBarItems = [tabbarItems copy];
        
        _selectedIndex = NSNotFound;
        _selectedItemIndex = NSNotFound;
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    UIViewController *vc = self.selectedViewController;
//    
//    if([vc isKindOfClass:[UINavigationController class]])
//    {
//        UINavigationController *nav = (UINavigationController*)vc;
//        vc = [nav.viewControllers lastObject];
//    }
//    
//    if([vc isKindOfClass:[SeaViewController class]])
//    {
//        SeaViewController *sea_vc = (SeaViewController*)vc;
//        [self setTabBarHidden:sea_vc.hideTabBar animated:YES];
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

#pragma mark- dealloc

- (void)dealloc
{
    
}

#pragma mark- public method

/**设置选项卡的状态
 *@param hidden 是否隐藏
 *@param animated 是否动画
 */
- (void)setTabBarHidden:(BOOL) hidden animated:(BOOL) animated
{
    if(hidden == self.tabBar.hidden)
        return;
    
    CGRect frame = self.tabBar.frame;
    frame.origin.y = hidden ? self.view.height : self.view.height - frame.size.height;
    
    if(animated)
    {
        if(!hidden)
        {
            self.tabBar.hidden = hidden;
        }
        [UIView animateWithDuration:0.25 animations:^(void){
            
            self.tabBar.frame = frame;
        }completion:^(BOOL finish){
            self.tabBar.hidden = hidden;
        }];
    }
    else
    {
        self.tabBar.frame = frame;
        self.tabBar.hidden = hidden;
    }
}

/**设置选项卡边缘值
 *@param badgeValue 边缘值
 *@param index 下标
 */
- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSInteger) index
{
    [self.tabBar setBadgeValue:badgeValue forIndex:index];
}

/**当前显示的ViewController
 */
- (UIViewController*)selectedViewController
{
    return [self showedViewConroller];
}

///获取当前要显示的ViewController
- (UIViewController*)showedViewConroller
{
    if(_selectedItemIndex < _itemInfos.count)
    {
        SeaTabBarItemInfo *info = [_itemInfos objectAtIndex:_selectedItemIndex];
        return info.viewController;
    }
    
    return nil;
}

#pragma mark- 加载视图

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _tabBar = [[SeaTabBar alloc] initWithFrame:CGRectMake(0, self.view.height - _tabBarHeight_, _width_, _tabBarHeight_) items:self.tabBarItems];
    _tabBar.delegate = self;
    [self.view addSubview:_tabBar];
    
    self.selectedIndex = 0;
}

#pragma mark- SeaTabBar delegate

- (void)tabBar:(SeaTabBar *)tabBar didSelectItemAtIndex:(NSInteger)index
{
    self.selectedItemIndex = index;
}

- (BOOL)tabBar:(SeaTabBar *)tabBar shouldSelectItemAtIndex:(NSInteger)index
{
    BOOL should = [self selectedViewController] != nil;
    if([self.delegate respondsToSelector:@selector(sea_tabBarController:shouldSelectAtIndex:)])
    {
        should = [self.delegate sea_tabBarController:self shouldSelectAtIndex:index];
    }
    
    return should;
}

#pragma mark- property setup

//设置选中的
- (void)setSelectedItemIndex:(NSInteger)selectedItemIndex
{
    if(_selectedItemIndex != selectedItemIndex)
    {
        ///以前的viewController
        UIViewController *oldViewController = [self showedViewConroller];
        
        _selectedItemIndex = selectedItemIndex;
        UIViewController *viewController = [self showedViewConroller];
        
        if(viewController)
        {
            //移除以前的viewController
            if(oldViewController)
            {
                [oldViewController.view removeFromSuperview];
                [oldViewController removeFromParentViewController];
            }
            
            [viewController willMoveToParentViewController:self];
            [self addChildViewController:viewController];
            [self.view insertSubview:viewController.view belowSubview:self.tabBar];
            self.view.backgroundColor = viewController.view.backgroundColor;
            [viewController didMoveToParentViewController:self];
        }
        
        _selectedIndex = selectedItemIndex;
    }
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(_selectedIndex != selectedIndex)
    {
        _selectedIndex = selectedIndex;
        self.tabBar.selectedIndex = _selectedIndex;
    }
}

#pragma mark- statusBar 

/**设置状态栏的隐藏状态
 */
- (void)setStatusBarHidden:(BOOL)hidden
{
    self.statusHidden = hidden;
    [self setNeedsStatusBarAppearanceUpdate];
}

/**设置状态栏样式
 */
- (void)setStatusBarStyle:(UIStatusBarStyle) style
{
    self.statusStyle = style;
    [self setNeedsStatusBarAppearanceUpdate];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return self.statusStyle;
}

- (BOOL)prefersStatusBarHidden
{
    return self.statusHidden;
}

/**获取指定的viewController
 *@param index 下标
 */
- (UIViewController*)viewControllerForIndex:(NSInteger) index
{
    if(index < _itemInfos.count)
    {
        SeaTabBarItemInfo *info = [_itemInfos objectAtIndex:index];
        return info.viewController;
    }
    
    return nil;

}

@end
