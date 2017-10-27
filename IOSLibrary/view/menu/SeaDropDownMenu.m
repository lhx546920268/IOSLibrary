//
//  SeaDropDownMenu.m
//  Sea
//
//  Created by 罗海雄 on 15/9/16.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import "SeaDropDownMenu.h"
#import "SeaBasic.h"

@implementation SeaDropDownMenuItem

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
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _imageView.contentMode = UIViewContentModeRight;
        [self addSubview:_imageView];
        
        CGFloat height = frame.size.height;
        _separatorLine = [[UIView alloc] initWithFrame:CGRectMake(frame.size.width - _separatorLineWidth_, (frame.size.height - height) / 2.0, _separatorLineWidth_, height)];
        _separatorLine.userInteractionEnabled = NO;
        _separatorLine.backgroundColor = _separatorLineColor_;
        [self addSubview:_separatorLine];
    }
    
    return self;
}

//调整按钮标题位置
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIImage *image = _imageView.image;
    
    CGFloat interval = 3.0;
    CGFloat margin = 5.0;
    
    CGFloat maxWidth = self.width - image.size.width - margin * 2 - interval - _separatorLine.width;
    CGSize size = [_titleLabel.text stringSizeWithFont:_titleLabel.font contraintWith:maxWidth];
    
    CGFloat x = (self.width - size.width - image.size.width - interval - margin * 2) / 2.0 + margin;
    CGRect frame = _titleLabel.frame;
    frame.origin.x = x;
    frame.size.width = size.width;
    _titleLabel.frame = frame;
    
    frame = _imageView.frame;
    frame.size.width = _imageView.image.size.width;
    frame.origin.x = _titleLabel.right + interval;
    _imageView.frame = frame;
}


/**获取默认的三角形指示图标
 *@param color 图标颜色
 *@param size 图标大小
 */
+ (UIImage*)defaultIndicatorWithColor:(UIColor*) color size:(CGSize) size
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floor(size.width), floor(size.height)), NO, SeaImageScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, size.width, 0);
    CGContextAddLineToPoint(context, size.width / 2.0, size.height);
    CGContextAddLineToPoint(context, 0, 0);

    CGContextFillPath(context);
    
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

@end

//cell起始tag
#define SeaDropDownMenuCellStartTag 3402

@interface SeaDropDownMenu ()<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>

/**下拉列表背景
 */
@property(nonatomic,strong) UIView *listBackgroundView;

/**是否正在动画
 */
@property(nonatomic,assign) BOOL isAnimating;

/**阴影
 */
@property(nonatomic,strong) UIView *shadowLine;

@end

@implementation SeaDropDownMenu

/**构造方法
 *@param items 按钮信息，数组元素是 SeaDropDownMenuItem
 */
- (id)initWithFrame:(CGRect)frame items:(NSArray*) items
{
    self = [super initWithFrame:frame];
    if(self)
    {
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
    self.shadowColor = _separatorLineColor_;
    _keepHighlightWhenDismissList = YES;
    _shouldHighlighted = YES;
    _shouldShowUnderline = NO;
    _buttonTitleFont = [UIFont fontWithName:MainFontName size:15.0];
    _buttonNormalTitleColor = [UIColor blackColor];
    _buttonHighlightTitleColor = _appMainColor_;
    
    _listTitleFont = _buttonTitleFont;
    _listNormalTitleColor = _buttonNormalTitleColor;
    _listHighLightColor = _buttonHighlightTitleColor;
    
    UIImage *icon = [self iconWithColor:_buttonNormalTitleColor];
    UIImage *highlightIcon = [self iconWithColor:_buttonHighlightTitleColor];
    
    CGFloat width = self.width / _items.count;
    for(NSInteger i = 0; i < _items.count;i ++)
    {
        SeaDropDownMenuItem *item = [_items objectAtIndex:i];
        item.itemIndex = i;
        SeaDropDownMenuCell *cell = [[SeaDropDownMenuCell alloc] initWithFrame:CGRectMake(i * width, 0, width, self.height)];
        cell.titleLabel.font = _buttonTitleFont;
        cell.titleLabel.textColor = _buttonNormalTitleColor;
        cell.titleLabel.text = item.title;
        cell.separatorLine.hidden = i == _items.count - 1;
        
        if(item.titleLists != nil)
        {
            cell.imageView.image = item.normalImage == nil ? icon : item.normalImage;
            cell.imageView.highlightedImage = item.highlightedImage1 == nil ? highlightIcon : item.highlightedImage1;
        }
        else
        {
            cell.imageView.image = item.normalImage;
            cell.imageView.highlightedImage = item.highlightedImage1;
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [cell addGestureRecognizer:tap];
        
        cell.tag = i + SeaDropDownMenuCellStartTag;
        
        [self addSubview:cell];
    }
    
    [self bringSubviewToFront:_shadowLine];
}

#pragma mark- public method

///关闭下拉列表
- (void)closeList
{
    [self handleCancelTap:nil];
}

///取消选中
- (void)deselectItem
{
    [self setCellHighlight:NO forIndex:_selectedIndex];
    _selectedIndex = NSNotFound;
}

/**通过颜色获取按钮指示图标
 */
- (UIImage*)iconWithColor:(UIColor*) color
{
    return [SeaDropDownMenuCell defaultIndicatorWithColor:color size:CGSizeMake(10.0, 7.0)];
}

/**通过下标获取按钮
 */
- (SeaDropDownMenuCell*)cellForIndex:(NSInteger) index
{
    return (SeaDropDownMenuCell*)[self viewWithTag:index + SeaDropDownMenuCellStartTag];
}

/**设置标题
 */
- (void)setTitle:(NSString*) title forIndex:(NSInteger) index
{
    SeaDropDownMenuCell *cell = [self cellForIndex:index];
    cell.titleLabel.text = title;
    [cell setNeedsLayout];
}

/**设置按钮高亮
 */
- (void)setCellHighlight:(BOOL) highlight forIndex:(NSInteger) index
{
    if(index >= 0 && index < self.items.count)
    {
        highlight = highlight && _shouldHighlighted;
        
        SeaDropDownMenuCell *cell = [self cellForIndex:index];
        SeaDropDownMenuItem *item = [self.items objectAtIndex:index];
        
        cell.backgroundColor = highlight ? item.highlightedBackgroundColor : [UIColor clearColor];
        cell.imageView.highlighted = highlight;
        
        cell.titleLabel.textColor = highlight ? _buttonHighlightTitleColor : _buttonNormalTitleColor;
    }
}

///刷新下划线的位置
- (void)updateUnderlinePosition
{
    if(_underLine)
    {
        if(self.selectedIndex != NSNotFound)
        {
            CGFloat margin = 5.0;
            SeaDropDownMenuCell *cell = [self cellForIndex:_selectedIndex];
            [cell layoutIfNeeded];
            CGRect frame = _underLine.frame;
            frame.origin.x = cell.titleLabel.left - margin + cell.left;
            frame.size.width = cell.imageView.right + margin - cell.titleLabel.left;
            
            [UIView animateWithDuration:0.25 animations:^(void){
                
                _underLine.frame = frame;
            }];
            
            _underLine.hidden = !cell.imageView.highlighted;
        }
        else
        {
            _underLine.hidden = YES;
        }
    }
}

#pragma mark- property setup

/**按钮字体
 */
- (void)setButtonTitleFont:(UIFont *)buttonTitleFont
{
    if(![_buttonTitleFont isEqualToFont:buttonTitleFont])
    {
        if(buttonTitleFont == nil)
            buttonTitleFont = [UIFont fontWithName:MainFontName size:15.0];
        
        _buttonTitleFont = buttonTitleFont;
        for(NSInteger i = 0;i < _items.count;i ++)
        {
            SeaDropDownMenuCell *cell = [self cellForIndex:i];
            cell.titleLabel.font = _buttonTitleFont;
            [cell setNeedsLayout];
        }
    }
}

/**按钮字体颜色
 */
- (void)setButtonNormalTitleColor:(UIColor *)buttonNormalTitleColor
{
    if(![_buttonNormalTitleColor isEqualToColor:buttonNormalTitleColor])
    {
        if(buttonNormalTitleColor == nil)
            buttonNormalTitleColor = [UIColor blackColor];
        _buttonNormalTitleColor = buttonNormalTitleColor;
        UIImage *icon = [self iconWithColor:_buttonNormalTitleColor];
        
        for(NSInteger i = 0;i < _items.count;i ++)
        {
            SeaDropDownMenuCell *cell = [self cellForIndex:i];
            if(i != _selectedIndex)
            {
                cell.titleLabel.textColor = _buttonNormalTitleColor;
            }
            
            SeaDropDownMenuItem *item = [_items objectAtIndex:i];
            if(item.titleLists && item.normalImage == nil)
            {
                cell.imageView.image = icon;
            }
        }
    }
}

/**按钮字体高亮颜色
 */
- (void)setButtonHighlightTitleColor:(UIColor *)buttonHighlightTitleColor
{
    if(![_buttonHighlightTitleColor isEqualToColor:buttonHighlightTitleColor])
    {
        if(buttonHighlightTitleColor == nil)
            buttonHighlightTitleColor = _appMainColor_;
        _buttonHighlightTitleColor = buttonHighlightTitleColor;
        
        SeaDropDownMenuCell *cell = [self cellForIndex:_selectedIndex];
        cell.titleLabel.textColor = _buttonHighlightTitleColor;
        UIImage *icon = [self iconWithColor:_buttonHighlightTitleColor];
        
        for(NSInteger i = 0;i < _items.count;i ++)
        {
            SeaDropDownMenuCell *cell = [self cellForIndex:i];
            if(i != _selectedIndex)
            {
                cell.titleLabel.textColor = _buttonNormalTitleColor;
            }
           
            SeaDropDownMenuItem *item = [_items objectAtIndex:i];
            if(item.titleLists && item.highlightedImage1 == nil)
            {
                cell.imageView.highlightedImage = icon;
            }
        }
    }
}

/**阴影颜色
 */
- (void)setShadowColor:(UIColor *)shadowColor
{
    if(![_shadowColor isEqualToColor:shadowColor])
    {
        _shadowColor = shadowColor;
        
        if(!_shadowLine)
        {
            _shadowLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - _separatorLineWidth_, self.width, _separatorLineWidth_)];
            _shadowLine.backgroundColor = [UIColor clearColor];
            _shadowLine.userInteractionEnabled = NO;
            [self addSubview:_shadowLine];
        }
        
        _shadowLine.backgroundColor = _shadowColor;
    }
}

/**是否需要高亮 default is 'YES'
 */
- (void)setShouldHighlighted:(BOOL)shouldHighlighted
{
    if(_shouldHighlighted != shouldHighlighted)
    {
        _shouldHighlighted = shouldHighlighted;
        [self setCellHighlight:_shouldHighlighted forIndex:_selectedIndex];
    }
}

/**是否需要显示高亮下划线 default is 'NO'
 */
- (void)setShouldShowUnderline:(BOOL)shouldShowUnderline
{
    if(_shouldShowUnderline != shouldShowUnderline)
    {
        _shouldShowUnderline = shouldShowUnderline;
        if(_shouldShowUnderline)
        {
            CGFloat height = 2.0;
            _underLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - height, 0, height)];
            _underLine.backgroundColor = _appMainColor_;
            _underLine.userInteractionEnabled = NO;
            [self addSubview:_underLine];
            [self updateUnderlinePosition];
        }
        else
        {
            [_underLine removeFromSuperview];
            _underLine = nil;
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
    
    [self updateUnderlinePosition];
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
    [UIView animateWithDuration:_animatedDuration_ animations:^(void){
        
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
        [UIView animateWithDuration:_animatedDuration_ animations:^(void){
            
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
        
        [UIView animateWithDuration:_animatedDuration_ animations:^(void){
            
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
    [self updateUnderlinePosition];
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
        
        cell.accessoryView = [[UIImageView alloc] initWithImage:self.indicatorImage];
        cell.accessoryView.contentMode = UIViewContentModeCenter;
    }
    
    SeaDropDownMenuItem *item = [_items objectAtIndex:_selectedIndex];
    
    cell.textLabel.font = _listTitleFont;
    cell.accessoryView.hidden = item.selectedIndex != indexPath.row;
    cell.textLabel.text = [item.titleLists objectAtIndex:indexPath.row];
    cell.imageView.image = [item.iconLists objectAtNotBeyondIndex:indexPath.row];
    
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
