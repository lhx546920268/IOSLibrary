//
//  SeaTabBar.m

//

#import "SeaTabBar.h"
#import "SeaTabBarItem.h"
#import "SeaBasic.h"
#import "UIColor+Utils.h"
#import "UIView+SeaAutoLayout.h"

@implementation SeaTabBar

- (instancetype)initWithItems:(NSArray<SeaTabBarItem*>*) items
{
    self = [super init];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        _items = [items copy];
        _selectedIndex = NSNotFound;
        
        SeaTabBarItem *beforeItem = nil;
        for(NSUInteger i = 0;i < _items.count;i ++){
            SeaTabBarItem *item = _items[i];
            [item addTarget:self action:@selector(handleTouchupInside:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
            
            if(beforeItem){
                [item sea_leftToItemRight:beforeItem];
                [item sea_widthToItem:beforeItem];
            }else{
                [item sea_leftToSuperview];
            }
            if(i == _items.count - 1){
                [item sea_rightToSuperview];
            }
            
            [item sea_topToSuperview];
            [item sea_bottomToSuperview];
            beforeItem = item;
        }
        
        _separator = [UIView new];
        _separator.backgroundColor = SeaSeparatorColor;
        _separator.userInteractionEnabled = NO;
        [self addSubview:_separator];
        
        [_separator sea_leftToSuperview];
        [_separator sea_rightToSuperview];
        [_separator sea_topToSuperview];
        [_separator sea_heightToSelf:SeaSeparatorHeight];
    }
    
    return self;
}

#pragma mark- private method

//选中某个按钮
- (void)handleTouchupInside:(SeaTabBarItem*) item
{
    if(item.selected == YES)
        return;
    
    BOOL shouldSelect = YES;
    if([self.delegate respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]){
        shouldSelect = [self.delegate tabBar:self shouldSelectItemAtIndex:[_items indexOfObject:item]];
    }
    
    if(shouldSelect){
        self.selectedIndex = [_items indexOfObject:item];
    }
}

#pragma mark- property

//设置选中的
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if(_selectedIndex != selectedIndex){
        if(_selectedIndex < _items.count){
            SeaTabBarItem *item = [_items objectAtIndex:_selectedIndex];
            item.backgroundColor = [UIColor clearColor];
            item.selected = NO;
        }
        
        _selectedIndex = selectedIndex;
        SeaTabBarItem *item = [_items objectAtIndex:_selectedIndex];
        item.selected = YES;
        if(self.selectedButtonBackgroundColor){
            item.backgroundColor = self.selectedButtonBackgroundColor;
        }
        
        if([self.delegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]){
            [self.delegate tabBar:self didSelectItemAtIndex:_selectedIndex];
        }
    }
}

//设置背景
- (void)setBackgroundView:(UIView *)backgroundView
{
    if(_backgroundView != backgroundView){
        [_backgroundView removeFromSuperview];
        _backgroundView = backgroundView;
        
        if(_backgroundView != nil){
            [self insertSubview:_backgroundView atIndex:0];
            [_backgroundView sea_insetsInSuperview:UIEdgeInsetsZero];
        }
    }
}

- (void)setSelectedButtonBackgroundColor:(UIColor *)selectedButtonBackgroundColor
{
    if(![_selectedButtonBackgroundColor isEqualToColor:selectedButtonBackgroundColor]){
        if(selectedButtonBackgroundColor == nil)
            selectedButtonBackgroundColor = [UIColor clearColor];
        
        _selectedButtonBackgroundColor = selectedButtonBackgroundColor;
        SeaTabBarItem *item = [_items objectAtIndex:_selectedIndex];
        item.backgroundColor = _selectedButtonBackgroundColor;
    }
}

/**设置选项卡边缘值
 *@param badgeValue 边缘值
 *@param index 下标
 */
- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSInteger) index;
{
#if SeaDebug
    NSAssert(index < _items.count, @"SeaTabBar setBadgeValue forIndex, index %d 越界", (int)index);
#endif
    SeaTabBarItem *item = [_items objectAtIndex:index];
    item.badgeValue = badgeValue;
}

@end
