//
//  SeaDropDownMenu.m
//  Sea
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

@implementation SeaDropDownMenuItem

- (instancetype)init
{
    self = [super init];
    if(self){
        self.imagePadding = 5.0;
        self.imagePosition = SeaButtonImagePositionRight;
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

@end

@implementation SeaDropDownMenuCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.backgroundColor = [UIColor clearColor];
       
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _button.titleLabel.textAlignment = NSTextAlignmentCenter;
        _button.userInteractionEnabled = NO;
        [self.contentView addSubview:_button];
        
        _separator = [UIView new];
        _separator.userInteractionEnabled = NO;
        _separator.backgroundColor = SeaSeparatorColor;
        [self.contentView addSubview:_separator];
        
        [_button sea_insetsInSuperview:UIEdgeInsetsZero];
        
        [_separator sea_sizeToSelf:CGSizeMake(SeaSeparatorHeight, 15.0)];
        [_separator sea_rightToSuperview];
        [_separator sea_centerInSuperview];
    }
    
    return self;
}

@end

//cell起始tag
#define SeaDropDownMenuCellStartTag 3402

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
    
   
    
    CGFloat width = self.width / _items.count;
    SeaDropDownMenuCell *previousCell = nil;
    for(NSInteger i = 0; i < _items.count;i ++){
        SeaDropDownMenuItem *item = [_items objectAtIndex:i];
        item.itemIndex = i;
        SeaDropDownMenuCell *cell = [[SeaDropDownMenuCell alloc] initWithFrame:CGRectMake(i * width, 0, width, self.height)];
        cell.button.titleLabel.font = _buttonTitleFont;
        [cell.button setTitleColor:_buttonNormalTitleColor forState:UIControlStateNormal];
        [cell.button setTitleColor:_buttonHighlightTitleColor forState:UIControlStateSelected];
        [cell.button setTitle:item.title forState:UIControlStateNormal];
        cell.separator.hidden = i == _items.count - 1;
        
        if(item.titleLists != nil){
            [cell.button setImage:item.normalImage == nil ? icon : item.normalImage forState:UIControlStateNormal];
             [cell.button setImage:item.highlightedImage1 == nil ? highlightIcon : item.highlightedImage1 forState:UIControlStateSelected];
        }else{
            [cell.button setImage:item.normalImage forState:UIControlStateNormal];
            [cell.button setImage:item.highlightedImage1 forState:UIControlStateSelected];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [cell addGestureRecognizer:tap];
        
        cell.tag = i + SeaDropDownMenuCellStartTag;
        
        [self addSubview:cell];
        
        if(previousCell){
            [cell sea_leftToItemRight:previousCell];
            [cell sea_widthToItem:previousCell];
        }else{
            [cell sea_leftToSuperview];
        }
        
        [cell sea_topToSuperview];
        [cell sea_bottomToSuperview];
        if(i == _items.count - 1){
            [cell sea_rightToSuperview];
        }
        
        
        previousCell = cell;
    }
    
    _shadowLine = [UIView new];
    _shadowLine.backgroundColor = _shadowColor
    _shadowLine.userInteractionEnabled = NO;
    [self addSubview:_shadowLine];
    
    [_shadowLine sea_leftToSuperview];
    [_shadowLine sea_rightToSuperview];
    [_shadowLine sea_bottomToSuperview];
    [_shadowLine sea_heightToSelf:SeaSeparatorHeight];
}

- (void)layoutSubviews
{
    [self layoutIndicator];
}

#pragma mark- public method

- (void)closeList
{
    [self handleCancelTap:nil];
}

- (void)deselectItem
{
    [self setCellHighlight:NO forIndex:_selectedIndex];
    _selectedIndex = NSNotFound;
}

- (UIImage*)iconWithColor:(UIColor*) color
{
    return [SeaImageGenerator triangleWithColor:color size:CGSizeMake(10.0, 7.0)];
}

- (SeaDropDownMenuCell*)cellForIndex:(NSInteger) index
{
    return (SeaDropDownMenuCell*)[self viewWithTag:index + SeaDropDownMenuCellStartTag];
}

- (void)setTitle:(NSString*) title forIndex:(NSInteger) index
{
    SeaDropDownMenuCell *cell = [self cellForIndex:index];
    [cell.button setTitle:title forState:UIControlStateNormal];
}

- (void)setCellHighlight:(BOOL) highlight forIndex:(NSInteger) index
{
    if(index >= 0 && index < self.items.count)
    {
        highlight = highlight && _shouldHighlighted;
        
        SeaDropDownMenuCell *cell = [self cellForIndex:index];
        SeaDropDownMenuItem *item = [self.items objectAtIndex:index];
        
        cell.backgroundColor = highlight ? item.highlightedBackgroundColor : [UIColor clearColor];
        cell.button.selected = highlight;
    }
}

///调整下划线位置
- (void)layoutIndicator
{
    if(_indicator){
        if(self.selectedIndex != NSNotFound){
            CGFloat margin = 5.0;
            SeaDropDownMenuCell *cell = [self cellForIndex:_selectedIndex];
            [cell layoutIfNeeded];
            
            [UIView animateWithDuration:0.25 animations:^(void){
                
                _indicator.sea_leftLayoutConstraint.constant = cell.button.left - margin + cell.left;
                _indicator.sea_widthLayoutConstraint.constant = cell.button.right + margin - cell.button.left;
                [_indicator layoutIfNeeded];
            }];
            
            _indicator.hidden = !cell.button.selected;
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
        for(NSInteger i = 0;i < _items.count;i ++){
            SeaDropDownMenuCell *cell = [self cellForIndex:i];
            cell.button.titleLabel.font = _buttonTitleFont;
            [cell setNeedsLayout];
        }
    }
}

- (void)setButtonNormalTitleColor:(UIColor *)buttonNormalTitleColor
{
    if(![_buttonNormalTitleColor isEqualToColor:buttonNormalTitleColor]){
        if(buttonNormalTitleColor == nil)
            buttonNormalTitleColor = [UIColor blackColor];
        _buttonNormalTitleColor = buttonNormalTitleColor;
        UIImage *icon = [self iconWithColor:_buttonNormalTitleColor];
        
        for(NSInteger i = 0;i < _items.count;i ++){
            SeaDropDownMenuCell *cell = [self cellForIndex:i];
            [cell.button setTitleColor:_buttonNormalTitleColor forState:UIControlStateNormal];
            
            SeaDropDownMenuItem *item = [_items objectAtIndex:i];
            if(item.titleLists && item.normalImage == nil){
                [cell.button setImage:icon forState:UIControlStateNormal];
            }
        }
    }
}


- (void)setButtonHighlightTitleColor:(UIColor *)buttonHighlightTitleColor
{
    if(![_buttonHighlightTitleColor isEqualToColor:buttonHighlightTitleColor]){
        if(buttonHighlightTitleColor == nil)
            buttonHighlightTitleColor = SeaAppMainColor;
        _buttonHighlightTitleColor = buttonHighlightTitleColor;
        
        UIImage *icon = [self iconWithColor:_buttonHighlightTitleColor];
        
        for(NSInteger i = 0;i < _items.count;i ++){
            SeaDropDownMenuCell *cell = [self cellForIndex:i];
            [cell.button setTitleColor:_buttonHighlightTitleColor forState:UIControlStateSelected];
           
            SeaDropDownMenuItem *item = [_items objectAtIndex:i];
            if(item.titleLists && item.highlightedImage1 == nil){
                [cell.button setImage:icon forState:UIControlStateSelected];
            }
        }
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
        [self setCellHighlight:_shouldHighlighted forIndex:_selectedIndex];
    }
}

- (void)setShouldShowIndicator:(BOOL)shouldShowUnderline
{
    if(_shouldShowIndicator != shouldShowUnderline){
        _shouldShowIndicator = shouldShowUnderline;
        if(_shouldShowIndicator){
            CGFloat height = 2.0;
            _indicator = [UIView new];
            _indicator.backgroundColor = SeaAppMainColor;
            _indicator.userInteractionEnabled = NO;
            [self addSubview:_indicator];
            
            [_indicator sea_heightToSelf:2.0];
            [_indicator sea_widthToSelf:0];
            [_indicator sea_bottomToSuperview];
            [_indicator sea_leftToSuperview];
            
            [self layoutIndicator];
        }else{
            [_indicator removeFromSuperview];
            _indicator = nil;
        }
    }
}

#pragma mark- 选中

//点击菜单按钮
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    NSInteger index = tap.view.tag - SeaDropDownMenuCellStartTag;
    self.selectedIndex = index;
}

//改变选中
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(selectedIndex < 0)
        selectedIndex = 0;
    if(selectedIndex > _items.count - 1)
        selectedIndex = _items.count - 1;
    
    if(_selectedIndex != selectedIndex)
    {

        SeaDropDownMenuItem *item = [_items objectAtIndex:selectedIndex];

        ///判断是否可以点击
        BOOL enable = YES;
        if([self.delegate respondsToSelector:@selector(dropDownMenu:shouldSelectItem:)])
        {
            enable = [self.delegate dropDownMenu:self shouldSelectItem:item];
        }

        if(!enable)
            return;

        [self setCellHighlight:NO forIndex:_selectedIndex];
        _selectedIndex = selectedIndex;
        [self setCellHighlight:YES forIndex:_selectedIndex];

        
        if([self.delegate respondsToSelector:@selector(dropDownMenu:didSelectItem:)])
        {
            [self.delegate dropDownMenu:self didSelectItem:item];
        }
        
        
        //显示下拉菜单
        if(item.titleLists.count > 0)
        {
            BOOL show = NO;
            if([self.delegate respondsToSelector:@selector(dropDownMenu:shouldShowListInItem:)])
            {
                show = [self.delegate dropDownMenu:self shouldShowListInItem:item];
            }
            if(show)
            {
                [self showList];
            }
            else
            {
                [self dismissList];
            }
        }
        else
        {
            [self dismissList];
        }
    }
    else
    {
        SeaDropDownMenuItem *item = [_items objectAtIndex:_selectedIndex];
        if(item.titleLists.count > 0)
        {
            //判断下拉的菜单是否已显示
            if(self.tableView.superview != nil)
            {
                [self handleCancelTap:nil];
            }
            else
            {
                [self showList];
            }
        }
        else
        {
            ///两个高亮图片来回切换
            if(item.highlightedImage2)
            {
                SeaDropDownMenuCell *cell = [self cellForIndex:_selectedIndex];

                cell.imageView.highlighted = NO;
                if([cell.imageView.highlightedImage isEqual:item.highlightedImage1])
                {
                    cell.imageView.highlightedImage = item.highlightedImage2;
                }
                else
                {
                    cell.imageView.highlightedImage = item.highlightedImage1;
                }

                cell.imageView.highlighted = YES && _shouldHighlighted;

                if([self.delegate respondsToSelector:@selector(dropDownMenu:didSelectItem:)])
                {
                    [self.delegate dropDownMenu:self didSelectItem:item];
                }
            }
            else
            {
                [self handleCancelTap:nil];
            }
        }
    }
    
    [self layoutIndicator];
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
        
        _listBackgroundView.alpha = 0;
        _tableView.height = 0;
    }completion:^(BOOL finish){
        
        self.isAnimating = NO;
        [_listBackgroundView removeFromSuperview];
        [_tableView removeFromSuperview];
    }];
}

//显示下拉菜单
- (void)showList
{
    _listShowing = YES;
    
    if(!self.tableView)
    {
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
    
    if(item.highlightedBackgroundColor != nil)
    {
        self.tableView.backgroundColor = item.highlightedBackgroundColor;
    }
    else
    {
        self.tableView.backgroundColor = [UIColor whiteColor];
    }
    [self.tableView reloadData];
    
    self.isAnimating = YES;
    if(self.tableView.superview != nil)
    {
        [UIView animateWithDuration:0.25 animations:^(void){
            
            self.tableView.height = MIN(_tableView.rowHeight * item.titleLists.count, self.listMaxHeight == 0 ? self.tableView.superview.height - _tableView.top : self.listMaxHeight);

        }completion:^(BOOL finish){
           
            self.isAnimating = NO;
            self.tableView.scrollEnabled = self.tableView.contentSize.height > self.tableView.height;
        }];
    }
    else
    {
        UIView *superview = self.listSuperview;
        _tableView.top = 0;
        
        CGFloat y = self.bottom;
        if([self.delegate respondsToSelector:@selector(YAsixAtListInDropDwonMenu:)])
        {
            y = [self.delegate YAsixAtListInDropDwonMenu:self];
        }
        
        if(superview == nil)
        {
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
            
            _listBackgroundView.alpha = 1.0;
            _tableView.height = MIN(_tableView.rowHeight * item.titleLists.count, self.listMaxHeight == 0 ? self.tableView.superview.height - _tableView.top : self.listMaxHeight);
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
    [self layoutIndicator];
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.items.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width / self.items.count, collectionView.height);
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SeaMenuBarItem";
    SeaMenuBarItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    SeaMenuItemInfo *info = [self.itemInfos objectAtIndex:indexPath.item];
    [item.button setTitleColor:_selectedTextColor forState:UIControlStateSelected];
    [item.button setTitleColor:_normalTextColor forState:UIControlStateNormal];
    [item.button.titleLabel setFont:_selectedIndex == indexPath.item ? _selectedFont : _normalFont];
    item.info = info;
    item.tick = self.selectedIndex == indexPath.item;
    item.separator.hidden = !self.showSeparator || indexPath.item == _itemInfos.count - 1 || _style == SeaMenuBarStyleFit;
    
    return item;
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
    
    if(item.selectedIndex == indexPath.row)
    {
        cell.textLabel.textColor = _listHighLightColor;
    }
    else
    {
        cell.textLabel.textColor = _listNormalTitleColor;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SeaDropDownMenuItem *item = [_items objectAtIndex:_selectedIndex];
    item.selectedIndex = indexPath.row;
    
    if([self.delegate respondsToSelector:@selector(dropDownMenu:didSelectItemWithSecondMenu:)])
    {
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
    if(CGRectContainsPoint(_tableView.frame, point))
    {
        return NO;
    }
    
    return YES;
}

@end
