//
//  SeaTabBarViewController.m

//

#import "SeaTabBarController.h"
#import "SeaTabBar.h"
#import "SeaTabBarItem.h"
#import "SeaViewController.h"
#import "SeaBasic.h"
#import "UIViewController+Utils.h"
#import "UIView+Utils.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaContainer.h"
#import "UIColor+Utils.h"

@implementation SeaTabBarItemInfo

+ (instancetype)infoWithTitle:(NSString*) title normalImage:(UIImage*) normalImage viewController:(UIViewController *)viewControllr
{
    return [self infoWithTitle:title normalImage:normalImage selectedImage:nil viewController:viewControllr];
}

+ (instancetype)infoWithTitle:(NSString*) title normalImage:(UIImage*) normalImage selectedImage:(UIImage*) selectedImage viewController:(UIViewController*) viewControllr
{
    SeaTabBarItemInfo *info = [[SeaTabBarItemInfo alloc] init];
    info.title = title;
    if(!selectedImage){
        ///ios7 的 imageAssets 不支持 Template
        if(normalImage.renderingMode != UIImageRenderingModeAlwaysTemplate){
            normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
    }
    info.normalImage = normalImage;
    info.selectedImage = selectedImage;
    info.viewController = viewControllr;
    
    return info;
}

@end

@interface SeaTabBarController ()<SeaTabBarDelegate>

/**
 选中的视图 default is '0'
 */
@property(nonatomic,assign) NSUInteger selectedItemIndex;

@end

@implementation SeaTabBarController
{
    SeaTabBar *_tabBar;
}

- (id)initWithItemInfos:(NSArray<SeaTabBarItemInfo*>*) itemInfos
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        _itemInfos = [itemInfos copy];
        
        //创建选项卡按钮
        NSMutableArray *tabbarItems = [NSMutableArray arrayWithCapacity:itemInfos.count];
        
        for(NSInteger i = 0;i < itemInfos.count;i ++){
            
            //创建选项卡按钮
            SeaTabBarItemInfo *info = [itemInfos objectAtIndex:i];
            SeaTabBarItem *item = [SeaTabBarItem new];
            item.textLabel.text = info.title;
            item.imageView.image = info.normalImage;
            [tabbarItems addObject:item];
        }
        _tabBarItems = [tabbarItems copy];
        
        _selectedIndex = NSNotFound;
        _selectedItemIndex = NSNotFound;
    }
    
    return self;
}

#pragma mark- public method

- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSInteger) index
{
    [self.tabBar setBadgeValue:badgeValue forIndex:index];
}

- (UIViewController*)selectedViewController
{
    return [self showedViewConroller];
}

- (UIViewController*)showedViewConroller
{
    if(_selectedItemIndex < _itemInfos.count){
        SeaTabBarItemInfo *info = [_itemInfos objectAtIndex:_selectedItemIndex];
        return info.viewController;
    }
    
    return nil;
}

#pragma mark- 加载视图

- (SeaTabBar*)tabBar
{
    if(!_tabBar){
        _tabBar = [[SeaTabBar alloc] initWithItems:self.tabBarItems];
        _tabBar.delegate = self;
    }
    return _tabBar;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.normalColor = [UIColor grayColor];
    self.selectedColor = SeaAppMainColor;
    self.font = [UIFont fontWithName:SeaMainFontName size:11];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.container.safeLayoutGuide = SeaSafeLayoutGuideBottom;

    [self.view addSubview:self.tabBar];
    [self setBottomView:self.tabBar height:SeaTabBarHeight];
    
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
    if([self.delegate respondsToSelector:@selector(sea_tabBarController:shouldSelectAtIndex:)]){
        should = [self.delegate sea_tabBarController:self shouldSelectAtIndex:index];
    }
    
    return should;
}

#pragma mark- property setup

- (void)setNormalColor:(UIColor *)normalColor
{
    if(![_normalColor isEqualToColor:normalColor]){
        if(!normalColor)
            normalColor = [UIColor grayColor];
        _normalColor = normalColor;
        for(NSUInteger i = 0;i < self.tabBarItems.count;i ++){
            if(i != _selectedItemIndex){
                SeaTabBarItem *item = self.tabBarItems[i];
                item.imageView.tintColor = normalColor;
                item.textLabel.textColor = normalColor;
            }
        }
    }
}

- (void)setSelectedColor:(UIColor *)selectedColor
{
    if(![_selectedColor isEqualToColor:selectedColor]){
        _selectedColor = selectedColor;
        if(!_selectedColor)
            _selectedColor = SeaAppMainColor;
        if(_selectedItemIndex < self.tabBarItems.count){
            SeaTabBarItem *item = self.tabBarItems[_selectedItemIndex];
            item.imageView.tintColor = _selectedColor;
            item.textLabel.textColor = _selectedColor;
        }
    }
}

- (void)setFont:(UIFont *)font
{
    if(![_font isEqual:font]){
        if(!font)
            font = [UIFont fontWithName:SeaMainFontName size:11.0];
        _font = font;
        for(NSUInteger i = 0;i < self.tabBarItems.count;i ++){
            SeaTabBarItem *item = self.tabBarItems[i];
            item.textLabel.font = _font;
        }
    }
}

//设置item 选中
- (void)setSelected:(BOOL) selected forIndex:(NSUInteger) index
{
    if(index < self.tabBarItems.count){
        SeaTabBarItem *item = self.tabBarItems[index];
        SeaTabBarItemInfo *info = self.itemInfos[index];
        
        if(selected){
            item.imageView.tintColor = self.selectedColor;
            item.textLabel.textColor = self.selectedColor;
            
            if(info.selectedImage){
                item.imageView.image = info.selectedImage;
            }
        }else{
            item.imageView.tintColor = self.normalColor;
            item.textLabel.textColor = self.normalColor;
            
            item.imageView.image = info.normalImage;
        }
    }
}

//设置选中的
- (void)setSelectedItemIndex:(NSUInteger)selectedItemIndex
{
    if(_selectedItemIndex != selectedItemIndex){
        ///以前的viewController
        UIViewController *oldViewController = [self showedViewConroller];
        [self setSelected:NO forIndex:_selectedItemIndex];
        
        _selectedItemIndex = selectedItemIndex;
        UIViewController *viewController = [self showedViewConroller];
        [self setSelected:YES forIndex:_selectedItemIndex];
        
        if(viewController){
            //移除以前的viewController
            if(oldViewController){
                [oldViewController.view removeFromSuperview];
                [oldViewController removeFromParentViewController];
            }
            
            [viewController willMoveToParentViewController:self];
            [self addChildViewController:viewController];
            self.contentView = viewController.view;
            self.view.backgroundColor = viewController.view.backgroundColor;
            [viewController didMoveToParentViewController:self];
            [self.view bringSubviewToFront:self.tabBar];
        }
        
        _selectedIndex = selectedItemIndex;
    }
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if(_selectedIndex != selectedIndex){
        _selectedIndex = selectedIndex;
        self.tabBar.selectedIndex = _selectedIndex;
    }
}

- (UIViewController*)viewControllerForIndex:(NSUInteger) index
{
    if(index < _itemInfos.count){
        SeaTabBarItemInfo *info = [_itemInfos objectAtIndex:index];
        return info.viewController;
    }
    
    return nil;
}

- (SeaTabBarItem*)itemForIndex:(NSUInteger) index
{
    return self.tabBar.items[index];
}

@end
