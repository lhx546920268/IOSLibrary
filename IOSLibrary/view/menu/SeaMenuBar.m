//
//  UBMenuBar.m

//

#import "SeaMenuBar.h"
#import "SeaMenuBarItem.h"
#import "SeaNumberBadge.h"
#import "SeaBasic.h"


@interface SeaMenuBar ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

///滚动视图
@property(nonatomic,strong) UICollectionView *collectionView;

/**菜单按钮宽度 当style = SeaMenuBarStyleItemWithRelateTitleInFullScreen 时有效
 */
@property(nonatomic,assign) CGFloat menuItemWidth;

///是否是点击按钮
@property(nonatomic,assign) BOOL isTapButton;

@end

@implementation SeaMenuBar

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        
    }
    
    return self;
}

/**构造方法
 *@param frame 位置大小
 *@param titles 菜单按钮标题，数组元素是 NSString
 *@param style 样式
 *@return 已初始化的 UBMenuBar
 */
- (id)initWithFrame:(CGRect)frame titles:(NSArray*) titles style:(SeaMenuBarStyle) style
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _style = style;
        self.titles = titles;
        [self initialization];
        
    }
    return self;
}

/**构造方法
 *@param frame 位置大小
 *@param itmeInfos 按钮信息 数组元素是 SeaMenuBarItemInfo，设置此值会导致菜单重新加载数据
 *@param style 样式
 *@return 已初始化的 UBMenuBar
 */
- (id)initWithFrame:(CGRect)frame itemInfos:(NSArray*) itmeInfos style:(SeaMenuBarStyle) style
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _style = style;
        self.itmeInfos = itmeInfos;
        [self initialization];
    }
    
    return self;
}

///初始化
- (void)initialization
{
    _titleColor = MainGrayColor;
    _titleFont = [UIFont fontWithName:SeaMainFontName size:13];
    _selectedColor = SeaAppMainColor;
    
    _buttonWidthExtension = 10.0;
    _callDelegateWhenSetSelectedIndex = YES;
    
    
    [self caculateWidth];
    
    switch (_style)
    {
        case SeaMenuBarStyleItemWithRelateTitle :
        {
            _showSeparator = NO;
            _buttonInterval = 5.0;
            _contentInset = UIEdgeInsetsMake(0, 5.0, 0, 5.0);
        }
            break;
        case SeaMenuBarStyleItemWithRelateTitleInFullScreen :
        {
            _showSeparator = YES;
        }
            break;
        default:
            break;
    }
    
    _topSeparatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, SeaSeparatorHeight)];
    _topSeparatorLine.backgroundColor = SeaSeparatorColor;
    [self addSubview:_topSeparatorLine];
    
    _selectedIndex = NSNotFound;
    self.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.scrollsToTop = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[SeaMenuBarItem class] forCellWithReuseIdentifier:@"SeaMenuBarItem"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    CGFloat lineHeight = 2.0;
    _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - lineHeight, _menuItemWidth, lineHeight)];
    _lineView.backgroundColor = _selectedColor;
    [self.collectionView addSubview:_lineView];
    
    //分割线
    _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - SeaSeparatorHeight, self.width, SeaSeparatorHeight)];
    _separatorLine.backgroundColor = SeaSeparatorColor;
    [self addSubview:_separatorLine];
    
    self.selectedIndex = 0;
}

///计算宽度
- (void)caculateWidth
{
    if(! _titleFont)
        return;
    
    _menuItemWidth = (self.width - _contentInset.left - _contentInset.right - (_titles.count - 1) * _buttonInterval) / _titles.count;
    for(SeaMenuItemInfo *info in self.itmeInfos)
    {
        info.itemWidth = [info.title stringSizeWithFont:_titleFont contraintWith:self.width].width + self.buttonWidthExtension + info.icon.size.width;
    }
}


#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _itmeInfos.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.contentInset;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    switch (_style)
    {
        case SeaMenuBarStyleItemWithRelateTitle :
        {
            SeaMenuItemInfo *info = [_itmeInfos objectAtIndex:indexPath.item];
            return CGSizeMake(info.itemWidth, collectionView.height);
        }
            break;
        case SeaMenuBarStyleItemWithRelateTitleInFullScreen :
        {
            return CGSizeMake(_menuItemWidth, collectionView.height);
        }
            break;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.buttonInterval;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SeaMenuBarItem";
    SeaMenuBarItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    SeaMenuItemInfo *info = [self.itmeInfos objectAtIndex:indexPath.item];
    [item.button setTitleColor:_selectedColor forState:UIControlStateSelected];
    [item.button setTitleColor:_titleColor forState:UIControlStateNormal];
    [item.button.titleLabel setFont:_titleFont];
    item.info = info;
    item.item_selected = self.selectedIndex == indexPath.item;
    item.separator.hidden = !self.showSeparator || indexPath.item == _itmeInfos.count - 1;
    
    return item;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];

    BOOL enable = YES;

    if([self.delegate respondsToSelector:@selector(menuBar:shouldSelectItemAtIndex:)])
    {
        enable = [self.delegate menuBar:self shouldSelectItemAtIndex:indexPath.item];
    }

    if(enable)
    {
        self.isTapButton = YES;
        [self setSelectedIndex:indexPath.item animated:YES];
        self.isTapButton = NO;
    }
}

#pragma mark- property

/**菜单按钮标题，数组元素是 NSString，设置此值会导致菜单重新加载数据
 */
- (void)setTitles:(NSArray *)titles
{
    if(_titles != titles)
    {
        NSMutableArray *infos = [NSMutableArray arrayWithCapacity:titles.count];
        
        for(NSString *title in titles)
        {
            [infos addObject:[SeaMenuItemInfo infoWithTitle:title]];
        }
        self.itmeInfos = infos;
    }
}

/**按钮信息 数组元素是 SeaMenuBarItemInfo，设置此值会导致菜单重新加载数据
 */
- (void)setItmeInfos:(NSArray *)itmeInfos
{
    if(_itmeInfos != itmeInfos)
    {
        _itmeInfos = [itmeInfos copy];
        
        NSMutableArray *titles = [NSMutableArray arrayWithCapacity:_itmeInfos.count];
        for(SeaMenuItemInfo *info in _itmeInfos)
        {
            NSString *title = info.title;
            if(title == nil)
            {
                title = @"";
            }
            [titles addObject:title];
        }
        
        _titles = [titles copy];
        
        [self caculateWidth];
        [self.collectionView reloadData];
        self.selectedIndex = 0;
    }
}

/**是否显示分隔符 default is 'NO'
 */
- (void)setShowSeparator:(BOOL)showSeparator
{
    if(_showSeparator != showSeparator)
    {
        _showSeparator = showSeparator;
        [self.collectionView reloadData];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.collectionView.frame = self.bounds;
}

//设置按钮标题颜色
- (void)setTitleColor:(UIColor *)titleColor
{
    if(titleColor == nil)
        titleColor = [UIColor blackColor];
    
    if(![_titleColor isEqualToColor:titleColor])
    {
        _titleColor = titleColor;
        [self.collectionView reloadData];
    }
}

//设置标题字体
- (void)setTitleFont:(UIFont *)titleFont
{
    if(titleFont == nil)
        titleFont = [UIFont fontWithName:SeaMainFontName size:15.0];
    if(![_titleFont isEqualToFont:titleFont])
    {
        _titleFont = titleFont;
        
        [self caculateWidth];
        [self.collectionView reloadData];
        [self layoutLineWithAnimate:NO];
    }
}

/**菜单按钮 选中颜色 default is 'SeaAppMainColor'，设置也会改变 lineView 颜色
 */
- (void)setSelectedColor:(UIColor *)selectedColor
{
    if(selectedColor == nil)
        selectedColor = SeaAppMainColor;
    
    if(![_selectedColor isEqualToColor:selectedColor])
    {
        _selectedColor = selectedColor;
        [self.collectionView reloadData];
        _lineView.backgroundColor = _selectedColor;
    }
}

/**按钮间隔 default is '0'
 */
- (void)setButtonInterval:(CGFloat)buttonInterval
{
    if(_buttonInterval != buttonInterval)
    {
        _buttonInterval = buttonInterval;
        _menuItemWidth = (self.width - _contentInset.left - _contentInset.right - (_titles.count - 1) * _buttonInterval) / _titles.count;
        [self.collectionView reloadData];
        [self layoutLineWithAnimate:NO];
    }
}

/**按钮宽度延伸 defautl is '10.0'
 */
- (void)setButtonWidthExtension:(CGFloat)buttonWidthExtension
{
    if(_buttonWidthExtension != buttonWidthExtension)
    {
        CGFloat previousExtension = _buttonWidthExtension;
        _buttonWidthExtension = buttonWidthExtension;
        
        for(SeaMenuItemInfo *info in self.itmeInfos)
        {
            info.itemWidth += _buttonWidthExtension - previousExtension;
        }
        
        [self.collectionView reloadData];
        [self layoutLineWithAnimate:NO];
    }
}

- (void)setContentInset:(UIEdgeInsets)contentInset
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_contentInset, contentInset))
    {
        _contentInset = contentInset;
        [self.collectionView reloadData];
        [self layoutLineWithAnimate:NO];
    }
}

#pragma mark- public method

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(_selectedIndex == selectedIndex || selectedIndex >= self.itmeInfos.count)
        return;
    [self setSelectedIndex:selectedIndex animated:NO];
}

/**设置选中的菜单按钮
 *@param selectedIndex 菜单按钮下标
 *@param flag 是否动画
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex animated:(BOOL) flag
{
    if(selectedIndex >= self.itmeInfos.count)
        return;
    
    if(_selectedIndex == selectedIndex)
    {
        if([self.delegate respondsToSelector:@selector(menuBar:didSelectHighlightedItemAtIndex:)])
        {
            [self.delegate menuBar:self didSelectHighlightedItemAtIndex:selectedIndex];
        }
        
        return;
    }
    
    
    //取消以前的选中状态
    SeaMenuBarItem *item = [self itemForIndex:_selectedIndex];
    item.item_selected = NO;
    
    _selectedIndex = selectedIndex;
    
    [self layoutLineWithAnimate:flag];
    
    switch (_style)
    {
        case SeaMenuBarStyleItemWithRelateTitle :
        {
            [self scrollToVisibleRectWithAnimate:flag];
        }
            break;
            
        default:
            break;
    }
    
    if(_isTapButton || _callDelegateWhenSetSelectedIndex)
    {
        if([self.delegate respondsToSelector:@selector(menuBar:didSelectItemAtIndex:)])
        {
            [self.delegate menuBar:self didSelectItemAtIndex:_selectedIndex];
        }
    }
}

///设置下划线的位置
- (void)layoutLineWithAnimate:(BOOL) flag
{
    SeaMenuBarItem *item = [self itemForIndex:_selectedIndex];
    item.item_selected = YES;
    SeaMenuItemInfo *info = [self.itmeInfos objectAtIndex:_selectedIndex];
    CGRect frame = _lineView.frame;
    
    frame.origin.x = item.left + (item.width - info.itemWidth) / 2.0;
    
    if(_selectedIndex == 0 && item.left == 0)
    {
        frame.origin.x += _contentInset.left;
    }
    
    frame.size.width = info.itemWidth;
    
    if(flag)
    {
        [UIView animateWithDuration:0.25 animations:^(void){
            
            _lineView.frame = frame;
        }];
    }
    else
    {
        _lineView.frame = frame;
    }
}

///滚动到可见位置
- (void)scrollToVisibleRectWithAnimate:(BOOL) flag
{
//    if(self.collectionView.contentSize.width <= self.collectionView.width)
//        return;
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
//    NSArray *visibles = [self.collectionView indexPathsForVisibleItems];
//    visibles = [visibles sortedArrayUsingComparator:^(id obj1, id obj2){
//        
//        NSIndexPath *indexPath1 = obj1;
//        NSIndexPath *indexPath2 = obj2;
//        
//        if(indexPath1.item > indexPath2.item)
//        {
//            return NSOrderedDescending;
//        }
//        else
//        {
//            return NSOrderedAscending;
//        }
//    }];
//    
//    if(visibles.count > 2)
//    {
//        NSIndexPath *indexPath = [visibles objectAtIndex:visibles.count - 2];
//        if(_selectedIndex == indexPath.item)
//        {
//            indexPath = [visibles lastObject];
//            NSLog(@"%ld, %ld", _selectedIndex, indexPath.item);
//            
//            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:flag];
//        }
//        else
//        {
//            indexPath = [visibles objectAtIndex:1];
//            if(_selectedIndex == indexPath.item)
//            {
//                [self.collectionView scrollToItemAtIndexPath:[visibles firstObject] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:flag];
//            }
//            else
//            {
//                indexPath = [visibles lastObject];
//                if(_selectedIndex == indexPath.item)
//                {
//                    if(indexPath.row + 1 < _titles.count)
//                    {
//                        indexPath = [NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0];
//                    }
//                    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:flag];
//                }
//                else
//                {
//                    indexPath = [visibles firstObject];
//                    
//                    if(_selectedIndex == indexPath.row)
//                    {
//                        if(indexPath.row - 1 >= 0)
//                        {
//                            indexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0];
//                        }
//                        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:flag];
//                    }
//                }
//            }
//        }
//    }
//    else if(visibles.count > 0)
//    {
//        NSIndexPath *indexPath = [visibles lastObject];
//        if(_selectedIndex == indexPath.item)
//        {
//            if(indexPath.row + 1 < _titles.count)
//            {
//                indexPath = [NSIndexPath indexPathForItem:indexPath.row + 1 inSection:0];
//            }
//            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:flag];
//        }
//        else
//        {
//            indexPath = [visibles firstObject];
//            
//            if(_selectedIndex == indexPath.item)
//            {
//                if(indexPath.row - 1 >= 0)
//                {
//                    indexPath = [NSIndexPath indexPathForItem:indexPath.row - 1 inSection:0];
//                }
//                
//                [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:flag];
//            }
//        }
//    }
//    else if(_selectedIndex < [self.collectionView numberOfItemsInSection:0])
//    {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:_selectedIndex inSection:0];
//        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:flag];
//    }
}

/**设置按钮边缘数字
 *@param badgeValue 边缘数字，大于99会显示99+，小于等于0则隐藏
 *@param index 按钮下标
 */
- (void)setBadgeValue:(NSString*) badgeValue forIndex:(NSInteger) index
{
#if SeaDebug
    NSAssert(index < self.itmeInfos.count, @"SeaMenuBar setBadgeValue: forIndex:，index 已越界");
#endif
    
    SeaMenuItemInfo *info = [self.itmeInfos objectAtIndex:index];
    info.badgeNumber = badgeValue;
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]];
}

/**改变按钮图标
 *@param icon 按钮图标
 *@param index 按钮下标
 */
- (void)setIcon:(UIImage*) icon forIndex:(NSInteger) index
{
#if SeaDebug
    NSAssert(index < self.itmeInfos.count, @"SeaMenuBar setBadgeValue: forIndex:，index 已越界");
#endif
    
    SeaMenuItemInfo *info = [self.itmeInfos objectAtIndex:index];
    info.icon = icon;
    
    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:index inSection:0]]];
}

///通过下标获取按钮
- (id)itemForIndex:(NSInteger) index
{
    if(index >= _itmeInfos.count)
        return nil;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    UICollectionViewCell *item = (SeaMenuBarItem*)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if(item == nil)
    {
        item = [self collectionView:self.collectionView cellForItemAtIndexPath:indexPath];
    }
    
    return item;
}

@end
