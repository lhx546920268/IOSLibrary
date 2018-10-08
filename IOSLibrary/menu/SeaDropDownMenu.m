//
//  SeaDropDownMenu.m
//  IOSLibrary
//
//  Created by 罗海雄 on 15/9/16.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import "SeaDropDownMenu.h"
#import "SeaBasic.h"
#import "NSString+Utils.h"
#import "UIView+Utils.h"
#import "UIImage+Utils.h"
#import "UIFont+Utils.h"
#import "UIColor+Utils.h"
#import "NSMutableArray+Utils.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaImageGenerator.h"

@interface SeaDropDownMenuItem()

///当前显示的图标
@property(nonatomic, strong) UIImage *currentImage;

@end

@implementation SeaDropDownMenuItem

- (instancetype)init
{
    self = [super init];
    if(self){
        self.iconPadding = 5.0;
        self.iconPosition = SeaDropDownMenuIconPositionRight;
    }
    
    return self;
}

- (NSString*)title
{
    if(_title.length == 0)
    {
        return [_titleLists firstObject];
    }
    
    return _title;
}

- (UIImage*)displayIconWithTick:(BOOL) tick
{
    if(tick){
        if(self.highlightedImage2){
            return self.highlightedImage1 == self.currentImage ? self.highlightedImage2 : self.highlightedImage1;
        }else{
            return self.highlightedImage1;
        }
    }else{
        return self.normalImage;
    }
}

@end

@interface SeaDropDownMenuCell()

///标题约束
@property(nonatomic, strong) NSLayoutConstraint *titleRightToSuperConstraint;
@property(nonatomic, strong) NSLayoutConstraint *titleLeftToSuperConstraint;
@property(nonatomic, strong) NSLayoutConstraint *titleLeftToIconRightConstraint;

///图标约束
@property(nonatomic, strong) NSLayoutConstraint *iconLeftToSuperConstraint;
@property(nonatomic, strong) NSLayoutConstraint *iconRightToSuperConstraint;
@property(nonatomic, strong) NSLayoutConstraint *iconLeftToTitleRightConstraint;

@end

@implementation SeaDropDownMenuCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
       
        UIView *contentView = [UIView new];
        [self.contentView addSubview:contentView];
        
        _titleLabel = [UILabel new];
        [_titleLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
        [contentView addSubview:_titleLabel];
        
        _imageView = [UIImageView new];
        [_imageView setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
        [contentView addSubview:_imageView];
        _ctView = contentView;
        
        _separator = [UIView new];
        _separator.userInteractionEnabled = NO;
        _separator.backgroundColor = SeaSeparatorColor;
        [self.contentView addSubview:_separator];
        
        [_separator sea_sizeToSelf:CGSizeMake(SeaSeparatorWidth, 15.0)];
        [_separator sea_rightToSuperview];
        [_separator sea_centerInSuperview];
        
        [contentView sea_centerXInSuperview];
        [contentView sea_topToSuperview];
        [contentView sea_bottomToSuperview];
        contentView.sea_alb.leftToSuperview.greaterThanOrEqual.margin(8).build();
        contentView.sea_alb.rightToSuperview.greaterThanOrEqual.margin(8).build();
        
        self.titleLeftToSuperConstraint = _titleLabel.sea_alb.leftToSuperview.build();
        [_titleLabel sea_centerYInSuperview];

        [_imageView sea_centerYInSuperview];
        self.iconRightToSuperConstraint = [_imageView sea_rightToSuperview];
        self.iconLeftToTitleRightConstraint = _imageView.sea_alb.leftToRight(_titleLabel).build();
        
        self.iconPadding = 5.0;
    }
    
    return self;
}

- (void)setIconPosition:(SeaDropDownMenuIconPosition)iconPosition
{
    if(_iconPosition != iconPosition){
        _iconPosition = iconPosition;
        
        BOOL left = _iconPosition == SeaDropDownMenuIconPositionLeft;
        if(!self.iconLeftToSuperConstraint){
            self.iconLeftToSuperConstraint = [_imageView sea_leftToSuperview];
            self.titleRightToSuperConstraint = [_titleLabel sea_rightToSuperview];
            self.titleLeftToIconRightConstraint = [_titleLabel sea_leftToItemRight:_imageView margin:_iconPadding];
        }
        
        self.titleLeftToSuperConstraint.active = !left;
        self.iconLeftToTitleRightConstraint.active = !left;
        self.iconRightToSuperConstraint.active = !left;
        
        self.iconLeftToSuperConstraint.active = left;
        self.titleLeftToIconRightConstraint.active = left;
        self.titleRightToSuperConstraint.active = left;
    }
}

- (void)setIconPadding:(CGFloat)iconPadding
{
    if(_iconPadding != iconPadding){
        _iconPadding = iconPadding;
        
        self.titleLeftToIconRightConstraint.constant = _iconPadding;
        self.iconLeftToTitleRightConstraint.constant = _iconPadding;
    }
}

@end

@interface SeaDropDownMenu ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

/**下拉列表背景
 */
@property(nonatomic,strong) UIView *listBackgroundView;

/**是否正在动画
 */
@property(nonatomic,assign) BOOL isAnimating;

/**阴影
 */
@property(nonatomic,strong) UIView *shadowLine;

@property(nonatomic,strong) UICollectionView *collectionView;

/**
 默认三角形
 */
@property(nonatomic, strong) UIImage *icon;

/**
 默认三角形 高亮
 */
@property(nonatomic, strong) UIImage *highlightedIcon;

/**
 是否已经可以计算item
 */
@property(nonatomic,assign) BOOL mesureEnable;

/**
 内容宽度
 */
@property(nonatomic,readonly) CGFloat contentWidth;


@end

@implementation SeaDropDownMenu

- (instancetype)initWithItems:(NSArray<SeaDropDownMenuItem*> *) items
{
    return [self initWithFrame:CGRectZero items:items];
}

- (instancetype)initWithFrame:(CGRect)frame items:(NSArray<SeaDropDownMenuItem*> *) items
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor whiteColor];
        _items = items;
        _selectedIndex = NSNotFound;
        [self intialization];
    }
    
    return self;
}

//初始化
- (void)intialization
{
    _shadowColor = SeaSeparatorColor;
    _keepHighlightWhenDismissList = YES;
    _shouldHighlighted = YES;
    _shouldShowIndicator = NO;
    _indicatorHeight = 2.0;
    _indicatorColor = SeaAppMainColor;
    _buttonTitleFont = [UIFont fontWithName:SeaMainFontName size:15.0];
    _buttonNormalTitleColor = [UIColor blackColor];
    _buttonHighlightTitleColor = SeaAppMainColor;
    
    _listTitleFont = _buttonTitleFont;
    _listNormalTitleColor = _buttonNormalTitleColor;
    _listHighLightColor = _buttonHighlightTitleColor;
    
    self.icon = [self iconWithColor:_buttonNormalTitleColor];
    self.highlightedIcon = [self iconWithColor:_buttonHighlightTitleColor];
    
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
    [collectionView registerClass:[SeaDropDownMenuCell class] forCellWithReuseIdentifier:@"SeaDropDownMenuCell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    [collectionView sea_insetsInSuperview:UIEdgeInsetsZero];
    
    _shadowLine = [UIView new];
    _shadowLine.backgroundColor = _shadowColor;
    _shadowLine.userInteractionEnabled = NO;
    [self addSubview:_shadowLine];
    
    [_shadowLine sea_leftToSuperview];
    [_shadowLine sea_rightToSuperview];
    [_shadowLine sea_bottomToSuperview];
    [_shadowLine sea_heightToSelf:SeaSeparatorWidth];
}

- (void)layoutSubviews
{
    self.mesureEnable = YES;
    [self layoutIndicatorAnimate:NO];
    [self.collectionView reloadData];
}

///内容宽度
- (CGFloat)contentWidth
{
    return self.collectionView.width;
}


#pragma mark- public method

- (void)closeList
{
    [self handleCancelTap:nil];
}

- (void)deselectItem
{
    if(_selectedIndex < self.items.count){
        NSUInteger selectedIndex = _selectedIndex;
        _selectedIndex = NSNotFound;
        [self reloadItemAtIndex:selectedIndex];
    }
}

- (UIImage*)iconWithColor:(UIColor*) color
{
    return [SeaImageGenerator triangleWithColor:color size:CGSizeMake(10.0, 7.0)];
}

- (SeaDropDownMenuCell*)cellForIndex:(NSUInteger) index
{
    return (SeaDropDownMenuCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

- (void)setTitle:(NSString*) title forIndex:(NSUInteger) index
{
    if(index >= self.items.count)
        return;
    SeaDropDownMenuItem *item = [self.items objectAtIndex:index];
    item.title = title;
    [self reloadItemAtIndex:index];
}

- (void)reloadItemAtIndex:(NSUInteger) index
{
    if(index < self.items.count){
        [UIView setAnimationsEnabled:NO];
        [self.collectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:index inSection:0]]];
        [UIView setAnimationsEnabled:YES];
    }
}

///调整下划线位置
- (void)layoutIndicatorAnimate:(BOOL) animate
{
    if(!self.mesureEnable)
        return;
    if(_indicator){
        if(self.selectedIndex != NSNotFound){
            CGFloat margin = 5.0;
            SeaDropDownMenuCell *cell = [self cellForIndex:_selectedIndex];
            [cell layoutIfNeeded];
            CGRect frame = self.indicator.frame;
            frame.origin.x = self.contentWidth / self.items.count * _selectedIndex + cell.ctView.left - margin;
            frame.origin.y = self.height - _indicatorHeight;
            frame.size.height = _indicatorHeight;
            frame.size.width = cell.ctView.width + margin * 2;
            
            if(animate && !CGRectEqualToRect(_indicator.frame, CGRectZero)){
                [UIView animateWithDuration:0.25 animations:^(void){
                    
                    self.indicator.frame = frame;
                }];
            }else{
                _indicator.frame = frame;
            }
            _indicator.hidden = !self.shouldHighlighted;
        }else{
            _indicator.hidden = YES;
        }
    }
}

#pragma mark- property

- (void)setButtonTitleFont:(UIFont *)buttonTitleFont
{
    if(![_buttonTitleFont isEqualToFont:buttonTitleFont]){
        if(buttonTitleFont == nil)
            buttonTitleFont = [UIFont fontWithName:SeaMainFontName size:15.0];
        
        _buttonTitleFont = buttonTitleFont;
        [self.collectionView reloadData];
    }
}

- (void)setButtonNormalTitleColor:(UIColor *)buttonNormalTitleColor
{
    if(![_buttonNormalTitleColor isEqualToColor:buttonNormalTitleColor]){
        if(buttonNormalTitleColor == nil)
            buttonNormalTitleColor = [UIColor blackColor];
        _buttonNormalTitleColor = buttonNormalTitleColor;
        
        self.icon = [self iconWithColor:_buttonNormalTitleColor];
        [self.collectionView reloadData];
    }
}

- (void)setButtonHighlightTitleColor:(UIColor *)buttonHighlightTitleColor
{
    if(![_buttonHighlightTitleColor isEqualToColor:buttonHighlightTitleColor]){
        if(buttonHighlightTitleColor == nil)
            buttonHighlightTitleColor = SeaAppMainColor;
        _buttonHighlightTitleColor = buttonHighlightTitleColor;
        
        self.highlightedIcon = [self iconWithColor:_buttonHighlightTitleColor];
        [self.collectionView reloadData];
    }
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    if(![_shadowColor isEqualToColor:shadowColor]){
        _shadowColor = shadowColor;
        _shadowLine.backgroundColor = _shadowColor;
    }
}

- (void)setShouldHighlighted:(BOOL)shouldHighlighted
{
    if(_shouldHighlighted != shouldHighlighted){
        _shouldHighlighted = shouldHighlighted;
        [self reloadItemAtIndex:_selectedIndex];
    }
}

- (void)setShouldShowIndicator:(BOOL)shouldShowUnderline
{
    if(_shouldShowIndicator != shouldShowUnderline){
        _shouldShowIndicator = shouldShowUnderline;
        if(_shouldShowIndicator){
            _indicator = [UIView new];
            _indicator.backgroundColor = SeaAppMainColor;
            _indicator.userInteractionEnabled = NO;
            _indicator.hidden = YES;
            [self addSubview:_indicator];
            
            [self layoutIndicatorAnimate:NO];
        }else{
            [_indicator removeFromSuperview];
            _indicator = nil;
        }
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

#pragma mark- 选中

//改变选中
- (void)setSelectedIndex:(NSUInteger)selectedIndex
{
    if(selectedIndex > _items.count - 1)
        selectedIndex = _items.count - 1;
    
    if(_selectedIndex != selectedIndex){
        SeaDropDownMenuItem *item = [_items objectAtIndex:selectedIndex];

        ///判断是否可以点击
        BOOL enable = YES;
        if([self.delegate respondsToSelector:@selector(dropDownMenu:shouldSelectItem:)]){
            enable = [self.delegate dropDownMenu:self shouldSelectItem:item];
        }

        if(!enable)
            return;

        NSUInteger oldIndex = _selectedIndex;
        _selectedIndex = selectedIndex;
        
        [self reloadItemAtIndex:oldIndex];
        [self reloadItemAtIndex:_selectedIndex];

        if([self.delegate respondsToSelector:@selector(dropDownMenu:didSelectItem:)]){
            [self.delegate dropDownMenu:self didSelectItem:item];
        }
        
        //显示下拉菜单
        if(item.titleLists.count > 0){
            BOOL show = NO;
            if([self.delegate respondsToSelector:@selector(dropDownMenu:shouldShowListInItem:)]){
                show = [self.delegate dropDownMenu:self shouldShowListInItem:item];
            }
            
            if(show){
                [self showList];
            }else{
                [self dismissList];
            }
        }else{
            [self dismissList];
        }
    }else{
        SeaDropDownMenuItem *item = [_items objectAtIndex:_selectedIndex];
        if(item.titleLists.count > 0){
            //判断下拉的菜单是否已显示
            if(self.tableView.superview != nil){
                [self handleCancelTap:nil];
            }else{
                [self showList];
            }
        }else{
            ///两个高亮图片来回切换
            if(item.highlightedImage2){
                
                [self reloadItemAtIndex:_selectedIndex];
                if([self.delegate respondsToSelector:@selector(dropDownMenu:didSelectItem:)]){
                    [self.delegate dropDownMenu:self didSelectItem:item];
                }
            }else{
                [self handleCancelTap:nil];
            }
        }
    }
    
    [self layoutIndicatorAnimate:YES];
}

- (void)setIsAnimating:(BOOL)isAnimating
{
    if(_isAnimating != isAnimating)
    {
        _isAnimating = isAnimating;
        self.userInteractionEnabled = !_isAnimating;
    }
}

//关闭下拉菜单
- (void)dismissList
{
    if(self.tableView.superview == nil)
        return;
    
    _listShowing = NO;
    self.isAnimating = YES;
    [UIView animateWithDuration:0.25 animations:^(void){
        
        self.listBackgroundView.alpha = 0;
        self.tableView.height = 0;
    }completion:^(BOOL finish){
        
        self.isAnimating = NO;
        [self.listBackgroundView removeFromSuperview];
        [self.tableView removeFromSuperview];
    }];
}

//显示下拉菜单
- (void)showList
{
    _listShowing = YES;
    
    if(!self.tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 45.0;
        _tableView.scrollEnabled = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _listBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _listBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        //  _listBackgroundView.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCancelTap:)];
        tap.delegate = self;
        [_listBackgroundView addGestureRecognizer:tap];
    }
    
    SeaDropDownMenuItem *item = [_items objectAtIndex:_selectedIndex];
    
    if(item.highlightedBackgroundColor != nil){
        self.tableView.backgroundColor = item.highlightedBackgroundColor;
    }else{
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    [self.tableView reloadData];
    
    self.isAnimating = YES;
    if(self.tableView.superview != nil){
        [UIView animateWithDuration:0.25 animations:^(void){
            
            self.tableView.height = MIN(self.tableView.rowHeight * item.titleLists.count, self.listMaxHeight == 0 ? self.tableView.superview.height - self.tableView.top : self.listMaxHeight);

        }completion:^(BOOL finish){
           
            self.isAnimating = NO;
            self.tableView.scrollEnabled = self.tableView.contentSize.height > self.tableView.height;
        }];
    }else{
        UIView *superview = self.listSuperview;
        _tableView.top = 0;
        
        CGFloat y = self.bottom;
        if([self.delegate respondsToSelector:@selector(YAsixAtListInDropDwonMenu:)]){
            y = [self.delegate YAsixAtListInDropDwonMenu:self];
        }
        
        if(superview == nil){
            superview = self.superview;
        }
        
        _tableView.top = y;
        CGRect frame = superview.frame;
        frame.origin.y = y;
        frame.origin.x = superview.left;
        frame.size.width = superview.width;
        frame.size.height -= y;
        _listBackgroundView.frame = frame;
        [superview addSubview:_listBackgroundView];
        _tableView.width = superview.width;
        [superview addSubview:_tableView];
        
        [UIView animateWithDuration:0.25 animations:^(void){
            
            self.listBackgroundView.alpha = 1.0;
            self.tableView.height = MIN(self.tableView.rowHeight * item.titleLists.count, self.listMaxHeight == 0 ? self.tableView.superview.height - self.tableView.top : self.listMaxHeight);
        }
        completion:^(BOOL finish)
        {
            self.tableView.scrollEnabled = self.tableView.contentSize.height > self.tableView.height;
            self.isAnimating = NO;
        }];
    }
}

//关闭
- (void)handleCancelTap:(UITapGestureRecognizer*) tap
{
    [self dismissList];
    
    if(_selectedIndex < self.items.count)
    {
        SeaDropDownMenuItem *item = [self.items objectAtIndex:_selectedIndex];
        BOOL keep = _keepHighlightWhenDismissList;
        if([self.delegate respondsToSelector:@selector(dropDownMenu:shouldKeepHighlightWhenDismissListInItem:)])
        {
            keep = [self.delegate dropDownMenu:self shouldKeepHighlightWhenDismissListInItem:item];
        }
            
        if(!keep)
        {
            [self deselectItem];
            if([self.delegate respondsToSelector:@selector(dropDownMenu:didDeselectItem:)])
            {
                [self.delegate dropDownMenu:self didDeselectItem:item];
            }
        }
    }
    [self layoutIndicatorAnimate:NO];
}


#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(!self.mesureEnable){
        return 0;
    }
    return self.items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width / self.items.count, collectionView.height);
}

- (__kindof UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SeaDropDownMenuCell";
    SeaDropDownMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    SeaDropDownMenuItem *item = [_items objectAtIndex:indexPath.item];
    item.itemIndex = indexPath.item;
   
    BOOL tick = indexPath.item == _selectedIndex;
    cell.titleLabel.font = _buttonTitleFont;
    cell.titleLabel.textColor = tick ? _buttonHighlightTitleColor : _buttonNormalTitleColor;
    cell.titleLabel.text = item.title;
    cell.separator.hidden = indexPath.item == _items.count - 1;
    
    UIImage *icon = [item displayIconWithTick:tick];
    if(item.titleLists && !icon){
        icon = tick ? self.highlightedIcon : self.icon;
    }
    
    cell.imageView.image = icon;
    item.currentImage = icon;
    
    cell.iconPosition = item.iconPosition;
    cell.iconPadding = item.iconPadding;
    cell.contentView.backgroundColor = indexPath.item == self.selectedIndex ? item.highlightedBackgroundColor : [UIColor clearColor];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    self.selectedIndex = indexPath.item;
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    SeaDropDownMenuItem *item = [_items objectAtIndex:_selectedIndex];
    return item.titleLists.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        
        cell.accessoryView = [[UIImageView alloc] initWithImage:self.listIndicatorImage];
        cell.accessoryView.contentMode = UIViewContentModeCenter;
    }
    
    SeaDropDownMenuItem *item = [_items objectAtIndex:_selectedIndex];
    
    cell.textLabel.font = _listTitleFont;
    cell.accessoryView.hidden = item.selectedIndex != indexPath.row;
    cell.textLabel.text = [item.titleLists objectAtIndex:indexPath.row];
    cell.imageView.image = [item.iconLists sea_objectAtIndex:indexPath.row];
    
    if(item.selectedIndex == indexPath.row){
        cell.textLabel.textColor = _listHighLightColor;
    }else{
        cell.textLabel.textColor = _listNormalTitleColor;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SeaDropDownMenuItem *item = [_items objectAtIndex:_selectedIndex];
    item.selectedIndex = indexPath.row;
    
    if([self.delegate respondsToSelector:@selector(dropDownMenu:didSelectItemWithSecondMenu:)]){
        [self.delegate dropDownMenu:self didSelectItemWithSecondMenu:item];
    }
    
    [self.tableView reloadData];
    
    [self setTitle:[item.titleLists objectAtIndex:indexPath.row] forIndex:_selectedIndex];
    
    [self handleCancelTap:nil];
}


#pragma mark- UIGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:_listBackgroundView];
    point.y += _listBackgroundView.top;
    if(CGRectContainsPoint(_tableView.frame, point)){
        return NO;
    }
    
    return YES;
}

@end
