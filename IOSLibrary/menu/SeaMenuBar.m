//
//  UBMenuBar.m

//

#import "SeaMenuBar.h"
#import "SeaMenuBarItem.h"
#import "SeaNumberBadge.h"
#import "SeaBasic.h"
#import "UIColor+Utils.h"
#import "NSString+Utils.h"
#import "UIFont+Utils.h"
#import "UIView+Utils.h"
#import "NSMutableArray+Utils.h"
#import "NSObject+Utils.h"

@implementation SeaMenuItemInfo

+ (id)infoWithTitle:(NSString*) title
{
    SeaMenuItemInfo *info = [[SeaMenuItemInfo alloc] init];
    info.title = title;
    
    return info;
}

@end

@interface SeaMenuBar ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong) UICollectionView *collectionView;

/**
 菜单按钮宽度 当style = SeaMenuBarStyleFill 时有效
 */
@property(nonatomic,assign) CGFloat fillItemWidth;

/**
 是否是点击按钮
 */
@property(nonatomic,assign) BOOL isTapItem;

/**
 内容宽度
 */
@property(nonatomic,readonly) CGFloat contentWidth;

/**
 是否已经可以计算item
 */
@property(nonatomic,assign) BOOL mesureEnable;

@end

@implementation SeaMenuBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialization];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithTitles:nil];
}

- (instancetype)initWithTitles:(NSArray<NSString*> *)titles
{
    return [self initWithFrame:CGRectZero titles:titles];
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray<NSString*> *) titles
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialization];
        self.titles = titles;
    }
    return self;
}

- (instancetype)initWithItemInfos:(NSArray<SeaMenuItemInfo*> *)itemInfos
{
    return [self initWithFrame:CGRectZero itemInfos:itemInfos];
}

- (instancetype)initWithFrame:(CGRect)frame itemInfos:(NSArray<SeaMenuItemInfo*> *) itemInfos
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialization];
        self.itemInfos = itemInfos;
    }
    
    return self;
}

///初始化
- (void)initialization
{
    self.backgroundColor = [UIColor whiteColor];
    
    _shouldDetectStyleAutomatically = YES;
    _normalTextColor = [UIColor darkGrayColor];
    _normalFont = [UIFont fontWithName:SeaMainFontName size:13];
    _selectedTextColor = SeaAppMainColor;
    _selectedFont = _normalFont;
    
    _itemPadding = 10.0;
    _callDelegateWhenSetSelectedIndex = NO;
    _itemInterval = 5.0;
    _showSeparator = YES;
    
    _indicatorColor = SeaAppMainColor;
    _indicatorHeight = 2.0;
    
    _selectedIndex = 0;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.scrollsToTop = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[SeaMenuBarItem class] forCellWithReuseIdentifier:[SeaMenuBarItem sea_nameOfClass]];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    _indicator = [UIView new];
    _indicator.backgroundColor = self.indicatorColor;
    [self.collectionView addSubview:_indicator];
    
    //分割线
    _bottomSeparator = [UIView new];
    _bottomSeparator.backgroundColor = SeaSeparatorColor;
    [self addSubview:_bottomSeparator];
    
    _topSeparator = [UIView new];
    _topSeparator.backgroundColor = SeaSeparatorColor;
    [self addSubview:_topSeparator];
    
//    [collectionView sea_insetsInSuperview:UIEdgeInsetsZero];
//
//    [_topSeparator sea_leftToSuperview];
//    [_topSeparator sea_rightToSuperview];
//    [_topSeparator sea_topToSuperview];
//    [_topSeparator sea_heightToSelf:SeaSeparatorWidth];
//
//    [_bottomSeparator sea_leftToSuperview];
//    [_bottomSeparator sea_rightToSuperview];
//    [_bottomSeparator sea_bottomToSuperview];
//    [_bottomSeparator sea_heightToSelf:SeaSeparatorWidth];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if(!CGSizeEqualToSize(self.bounds.size, _collectionView.frame.size)){
        _topSeparator.frame = CGRectMake(0, 0, self.width, SeaSeparatorWidth);
        _bottomSeparator.frame = CGRectMake(0, self.height - SeaSeparatorWidth, self.width, SeaSeparatorWidth);
        _collectionView.frame = self.bounds;
        
        self.mesureEnable = YES;
        
        [self reloadData];
        [self layoutIndicatorWithAnimate:NO];
    }
}

///刷新数据
- (void)reloadData
{
    if(self.mesureEnable){
        [self mesureItems];
        [self.collectionView reloadData];
    }
}

///测量item
- (void)mesureItems
{
    if(!self.mesureEnable)
        return;
    
    CGFloat totalWidth = 0;
    int i = 0;
    for(SeaMenuItemInfo *info in self.itemInfos){
        info.itemWidth = [info.title sea_stringSizeWithFont:_normalFont].width + self.itemPadding;
        if(info.icon != nil){
            info.itemWidth += info.icon.size.width + info.iconPadding;
        }
        
        totalWidth += info.itemWidth;
        if(i != self.itemInfos.count){
            totalWidth += self.itemInterval;
        }
        i ++;
    }
    
    if(self.shouldDetectStyleAutomatically){
        _style = totalWidth > self.contentWidth ? SeaMenuBarStyleFit : SeaMenuBarStyleFill;
    }
    _fillItemWidth = self.contentWidth / self.itemInfos.count;
    
    !self.measureCompletionHandler ?: self.measureCompletionHandler();
}

///内容宽度
- (CGFloat)contentWidth
{
    return (self.width - _contentInset.left - _contentInset.right);
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(!self.mesureEnable){
        return 0;
    }
    return _itemInfos.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.contentInset;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch(_style){
        case SeaMenuBarStyleFit : {
            SeaMenuItemInfo *info = [_itemInfos objectAtIndex:indexPath.item];
            return CGSizeMake(info.itemWidth, collectionView.height);
        }
            break;
        case SeaMenuBarStyleFill :{
            return CGSizeMake(_fillItemWidth, collectionView.height);
        }
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return _style == SeaMenuBarStyleFill ? 0 : self.itemInterval;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaMenuBarItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:[SeaMenuBarItem sea_nameOfClass] forIndexPath:indexPath];
    
    SeaMenuItemInfo *info = [self.itemInfos objectAtIndex:indexPath.item];
    [item.button setTitleColor:_selectedTextColor forState:UIControlStateSelected];
    [item.button setTitleColor:_normalTextColor forState:UIControlStateNormal];
    [item.button.titleLabel setFont:_selectedIndex == indexPath.item ? _selectedFont : _normalFont];
    item.info = info;
    item.tick = self.selectedIndex == indexPath.item;
    item.separator.hidden = !self.showSeparator || indexPath.item == _itemInfos.count - 1 || _style == SeaMenuBarStyleFit;
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaMenuItemInfo *info = self.itemInfos[indexPath.item];
    if(info.customView){
        if([self.delegate respondsToSelector:@selector(menuBar:willDisplayCustomView:atIndex:)]){
            [self.delegate menuBar:self willDisplayCustomView:info.customView atIndex:indexPath.item];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    BOOL enable = YES;

    if([self.delegate respondsToSelector:@selector(menuBar:shouldSelectItemAtIndex:)]){
        enable = [self.delegate menuBar:self shouldSelectItemAtIndex:indexPath.item];
    }

    if(enable){
        self.isTapItem = YES;
        [self setSelectedIndex:indexPath.item animated:YES];
        self.isTapItem = NO;
    }
}

#pragma mark- property

- (void)setTitles:(NSArray *)titles
{
    if(_titles != titles){
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:titles.count];
        
        for(NSString *title in titles){
            [infos addObject:[SeaMenuItemInfo infoWithTitle:title]];
        }
        self.itemInfos = infos;
    }
}

- (void)setItemInfos:(NSArray *)itmeInfos
{
    if(_itemInfos != itmeInfos){
        _itemInfos = [itmeInfos copy];
        
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:_itemInfos.count];
        for(SeaMenuItemInfo *info in _itemInfos){
            NSString *title = info.title;
            if(title == nil){
                title = @"";
            }
            [titles addObject:title];
        }
        
        _titles = [titles copy];
        
        [self reloadData];
        self.selectedIndex = 0;
    }
}

- (void)setShowSeparator:(BOOL)showSeparator
{
    if(_showSeparator != showSeparator){
        _showSeparator = showSeparator;
        [self.collectionView reloadData];
    }
}

- (void)setNormalTextColor:(UIColor *) color
{
    if(color == nil)
        color = [UIColor darkGrayColor];
    
    if(![_normalTextColor isEqualToColor:color]){
        _normalTextColor = color;
        [self.collectionView reloadData];
    }
}

- (void)setNormalFont:(UIFont *) font
{
    if(font == nil)
        font = [UIFont fontWithName:SeaMainFontName size:13.0];
    if(![_normalFont isEqualToFont:font]){
        _normalFont = font;
        
        [self mesureItems];
        [self.collectionView reloadData];
        [self layoutIndicatorWithAnimate:NO];
    }
}

- (void)setSelectedTextColor:(UIColor *) color
{
    if(color == nil)
        color = SeaAppMainColor;
    
    if(![_selectedTextColor isEqualToColor:color]){
        _selectedTextColor = color;
        [self.collectionView reloadData];
    }
}

- (void)setSelectedFont:(UIFont *) font
{
    if(font == nil)
        font = [UIFont fontWithName:SeaMainFontName size:13.0];
    if(![_selectedFont isEqualToFont:font]){
        _selectedFont = font;
        
        [self.collectionView reloadData];
    }
}

- (void)setItemInterval:(CGFloat)buttonInterval
{
    if(_itemInterval != buttonInterval){
        _itemInterval = buttonInterval;
        
        if(_style == SeaMenuBarStyleFit){
            [self.collectionView reloadData];
            [self layoutIndicatorWithAnimate:NO];
        }
    }
}

- (void)setItemPadding:(CGFloat) padding
{
    if(_itemPadding != padding){
        CGFloat oldPadding = _itemPadding;
        _itemPadding = padding;
        
        for(SeaMenuItemInfo *info in self.itemInfos){
            info.itemWidth += _itemPadding - oldPadding;
        }
        
        [self.collectionView reloadData];
        [self layoutIndicatorWithAnimate:NO];
    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_contentInset, contentInset)){
        _contentInset = contentInset;
        [self.collectionView reloadData];
        [self layoutIndicatorWithAnimate:NO];
    }
}

- (void)setIndicatorHeight:(CGFloat)indicatorHeight
{
    if(_indicatorHeight != indicatorHeight){
        _indicatorHeight = indicatorHeight;
        _indicator.height = _indicatorHeight;
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    if(![_indicatorColor isEqualToColor:indicatorColor]){
        _indicatorColor = indicatorColor;
        _indicator.backgroundColor = _indicatorColor;
    }
}

#pragma mark- public method

- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    [self setSelectedIndex:selectedIndex animated:NO];
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex animated:(BOOL) flag
{
    if(selectedIndex >= self.itemInfos.count)
        return;
    
    if(_selectedIndex == selectedIndex && (_isTapItem || _callDelegateWhenSetSelectedIndex)){
        if([self.delegate respondsToSelector:@selector(menuBar:didSelectHighlightedItemAtIndex:)]){
            [self.delegate menuBar:self didSelectHighlightedItemAtIndex:selectedIndex];
        }
        return;
    }
    
    if(_selectedIndex == selectedIndex)
        return;
    
    //取消以前的选中状态
    SeaMenuBarItem *item = [self itemForIndex:_selectedIndex];
    item.tick = NO;
    
    NSInteger previousIndex = _selectedIndex;
    _selectedIndex = selectedIndex;
    
    [self layoutIndicatorWithAnimate:flag];
    [self scrollToVisibleRectWithAnimate:flag];
    
    if(previousIndex < self.itemInfos.count && ( _isTapItem || _callDelegateWhenSetSelectedIndex)){
        if([self.delegate respondsToSelector:@selector(menuBar:didDeselectItemAtIndex:)]){
            [self.delegate menuBar:self didDeselectItemAtIndex:previousIndex];
        }
    }
    
    if(_isTapItem || _callDelegateWhenSetSelectedIndex){
        if([self.delegate respondsToSelector:@selector(menuBar:didSelectItemAtIndex:)]){
            [self.delegate menuBar:self didSelectItemAtIndex:_selectedIndex];
        }
    }
}

///获取下划线x轴位置
- (CGFloat)indicatorXForIndex:(NSUInteger) index
{
    SeaMenuBarItem *item = [self itemForIndex:index];
    SeaMenuItemInfo *info = [self.itemInfos objectAtIndex:index];
    
    CGFloat x = 0;
    if(!CGRectEqualToRect(CGRectZero, item.frame)){
        x = item.left + (item.width - info.itemWidth) / 2.0;
    }else{
        switch (_style) {
            case SeaMenuBarStyleFit :
                x = _contentInset.left;
                for(NSInteger i = 0;i < index;i ++){
                    info = [self.itemInfos objectAtIndex:i];
                    x += info.itemWidth + self.itemInterval;
                }
                break;
            case SeaMenuBarStyleFill :
                x = _contentInset.left + (_fillItemWidth - info.itemWidth) / 2;;
                for(NSInteger i = 0;i < index;i ++){
                    x += _fillItemWidth;
                }
                break;
        }
    }
    return x;
}

///设置下划线的位置
- (void)layoutIndicatorWithAnimate:(BOOL) flag
{
    if(!self.mesureEnable)
        return;
    SeaMenuBarItem *item = [self itemForIndex:_selectedIndex];
    item.tick = YES;
    CGRect frame = _indicator.frame;

    frame.origin.x = [self indicatorXForIndex:_selectedIndex];
    frame.size.height = self.indicatorHeight;
    frame.origin.y = self.height - self.indicatorHeight;
    
    SeaMenuItemInfo *info = [self.itemInfos objectAtIndex:_selectedIndex];
    frame.size.width = info.itemWidth;
    
    if(flag){
        [UIView animateWithDuration:0.25 animations:^(void){
            
            self->_indicator.frame = frame;
        }];
    }else{
        _indicator.frame = frame;
    }
}

- (void)setPercent:(float) percent forIndex:(NSUInteger) index
{
    if(!self.mesureEnable)
        return;
    
#if SeaDebug
    NSAssert(index < self.itemInfos.count, @"SeaMenuBar setPercent: forIndex:，index %ld 已越界", (long)index);
#endif
    if(percent > 1.0){
        percent = 1.0;
    }else if(percent < 0){
        percent = 0;
    }
    
    CGRect frame = _indicator.frame;

    CGFloat x = [self indicatorXForIndex:_selectedIndex];
    CGFloat offset = percent * ([self indicatorXForIndex:index] - x);

    SeaMenuItemInfo *info1 = [self.itemInfos objectAtIndex:_selectedIndex];
    SeaMenuItemInfo *info2 = [self.itemInfos objectAtIndex:index];
    
    frame.origin.x = x + offset;
    frame.size.width = info1.itemWidth + (info2.itemWidth - info1.itemWidth) * percent;
    _indicator.frame = frame;
}

///滚动到可见位置
- (void)scrollToVisibleRectWithAnimate:(BOOL) flag
{
    if(_selectedIndex >= self.itemInfos.count || _style != SeaMenuBarStyleFit || !self.mesureEnable)
        return;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:flag];
}

- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSUInteger) index
{
#if SeaDebug
    NSAssert(index < self.itemInfos.count, @"SeaMenuBar setBadgeValue: forIndex:，index %ld 已越界", (long)index);
#endif
    
    SeaMenuItemInfo *info = [self.itemInfos objectAtIndex:index];
    info.badgeNumber = badgeValue;
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)setTitle:(NSString*) title forIndex:(NSUInteger) index
{
#if SeaDebug
    NSAssert(index < self.itemInfos.count, @"SeaMenuBar setIcon: forIndex:，index %ld 已越界", (long)index);
#endif
    
    SeaMenuItemInfo *info = [self.itemInfos objectAtIndex:index];
    info.title = title;
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)setIcon:(UIImage*) icon forIndex:(NSUInteger) index
{
#if SeaDebug
    NSAssert(index < self.itemInfos.count, @"SeaMenuBar setIcon: forIndex:，index %ld 已越界", (long)index);
#endif
    
    SeaMenuItemInfo *info = [self.itemInfos objectAtIndex:index];
    info.icon = icon;
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]];
}

- (void)setSelectedIcon:(UIImage*) icon forIndex:(NSUInteger) index
{
#if SeaDebug
    NSAssert(index < self.itemInfos.count, @"SeaMenuBar setSelectedIcon: forIndex:，index %ld 已越界", (long)index);
#endif
    
    SeaMenuItemInfo *info = [self.itemInfos objectAtIndex:index];
    info.selectedIcon = icon;
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]];
}

///通过下标获取按钮
- (id)itemForIndex:(NSUInteger) index
{
    if(index >= _itemInfos.count || !self.mesureEnable)
        return nil;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewCell *item = (SeaMenuBarItem*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if(item == nil){
        item = [self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    }
    
    return item;
}

@end
