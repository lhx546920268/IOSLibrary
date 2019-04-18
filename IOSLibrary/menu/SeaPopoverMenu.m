//
//  SeaPopoverMenu.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/30.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaPopoverMenu.h"
#import "UIView+SeaAutoLayout.h"
#import "UIColor+Utils.h"
#import "NSString+Utils.h"
#import "SeaBasic.h"
#import "UIButton+Utils.h"
#import "UIFont+Utils.h"

@implementation SeaPopoverMenuItemInfo

+ (id)infoWithTitle:(NSString*) title icon:(UIImage*) icon
{
    SeaPopoverMenuItemInfo *info = [[SeaPopoverMenuItemInfo alloc] init];
    info.title = title;
    info.icon = icon;
    
    return info;
}

@end

@implementation SeaPopoverMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.selectedBackgroundView = [[UIView alloc] init];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _button.adjustsImageWhenDisabled = NO;
        _button.adjustsImageWhenHighlighted = NO;
        _button.enabled = NO;
        _button.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_button];
        
        _divider = [UIView new];
        _divider.backgroundColor = SeaSeparatorColor;
        [self.contentView addSubview:_divider];
        
        [_button sea_insetsInSuperview:UIEdgeInsetsZero];
        
        [_divider sea_leftToSuperview];
        [_divider sea_rightToSuperview];
        [_divider sea_bottomToSuperview];
        [_divider sea_heightToSelf:SeaSeparatorWidth];
    }
    
    return self;
}


@end

@interface SeaPopoverMenu()<UITableViewDelegate, UITableViewDataSource>

/**
 按钮列表
 */
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SeaPopoverMenu

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.contentInsets = UIEdgeInsetsZero;
        _cellContentInsets = UIEdgeInsetsMake(0, 15, 0, 15);
        _textColor = [UIColor blackColor];
        _font = [UIFont systemFontOfSize:13];
        _selectedBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _rowHeight = 30;
        _separatorColor = SeaSeparatorColor;
        _iconTitleInterval = 0.0;
    }
    
    return self;
}

- (void)initContentView
{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = _rowHeight;
        _tableView.separatorColor = _separatorColor;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        self.contentView = _tableView;
    }
    _tableView.frame = CGRectMake(0, 0, [self getMenuWidth], _menuItemInfos.count * _rowHeight);
}

- (void)reloadData
{
    if(self.tableView){
        _tableView.frame = CGRectMake(0, 0, [self getMenuWidth], _menuItemInfos.count * _rowHeight);
        [self.tableView reloadData];
        [self redraw];
    }
}

///通过标题获取菜单宽度
- (CGFloat)getMenuWidth
{
    if(_menuWidth == 0){
        CGFloat contentWidth = 0;
        for(SeaPopoverMenuItemInfo *info in self.menuItemInfos){
            CGSize size = [info.title sea_stringSizeWithFont:_font contraintWith:UIScreen.screenWidth];
            size.width += 1.0;
            contentWidth = MAX(contentWidth, size.width + info.icon.size.width + _iconTitleInterval);
        }
        
        return contentWidth + _cellContentInsets.left + _cellContentInsets.right;
    }else{
        return _menuWidth;
    }
}

#pragma mark- property

- (void)setTextColor:(UIColor *)textColor
{
    if(![_textColor isEqualToColor:textColor]){
        if(!textColor)
            textColor = [UIColor blackColor];
        _textColor = textColor;
        [self.tableView reloadData];
    }
}

- (void)setFont:(UIFont *)font
{
    if(![_font isEqualToFont:font]){
        if(!font)
            font = [UIFont fontWithName:SeaMainFontName size:13.0];
        _font = font;
        [self.tableView reloadData];
    }
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    if(![_selectedBackgroundColor isEqualToColor:selectedBackgroundColor]){
        if(!selectedBackgroundColor)
            selectedBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _selectedBackgroundColor = selectedBackgroundColor;
        [self.tableView reloadData];
    }
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    if(![_separatorColor isEqualToColor:separatorColor]){
        if(!separatorColor)
            separatorColor = SeaSeparatorColor;
        _separatorColor = separatorColor;
        [self.tableView reloadData];
    }
}

- (void)setSeparatorInsets:(UIEdgeInsets)separatorInsets
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_separatorInsets, separatorInsets)){
        _separatorInsets = separatorInsets;
        [self.tableView reloadData];
    }
}

- (void)setRowHeight:(CGFloat)rowHeight
{
    if(_rowHeight != rowHeight){
        _rowHeight = rowHeight;
        [self reloadData];
    }
}

- (void)setMenuWidth:(CGFloat)menuWidth
{
    if(_menuWidth != menuWidth){
        _menuWidth = menuWidth;
        [self reloadData];
    }
}

- (void)setIconTitleInterval:(CGFloat)iconTitleInterval
{
    if(_iconTitleInterval != iconTitleInterval){
        _iconTitleInterval = iconTitleInterval;
        [self reloadData];
    }
}

- (void)setCellContentInsets:(UIEdgeInsets)cellContentInsets
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_cellContentInsets, cellContentInsets)){
        _cellContentInsets = cellContentInsets;
        [self reloadData];
    }
}

- (void)setMenuItemInfos:(NSArray<SeaPopoverMenuItemInfo *> *)menuItemInfos
{
    if(_menuItemInfos != menuItemInfos){
        _menuItemInfos = menuItemInfos;
        [self reloadData];
    }
}

- (void)setTitles:(NSArray<NSString *> *)titles
{
    if(titles.count == 0){
        return;
    }
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:titles.count];
    for(NSString *title in titles){
        [items addObject:[SeaPopoverMenuItemInfo infoWithTitle:title icon:nil]];
    }
    self.menuItemInfos = items;
}

- (NSArray<NSString*>*)titles
{
    if(_menuItemInfos.count == 0){
        return nil;
    }
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:_menuItemInfos.count];
    for(SeaPopoverMenuItemInfo *info in _menuItemInfos){
        if(info.title == nil){
            [titles addObject:@""];
        }else{
            [titles addObject:info.title];
        }
    }
    return titles;
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuItemInfos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    SeaPopoverMenuCell *cell = [[SeaPopoverMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    if(cell == nil){
        cell = [[SeaPopoverMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectedBackgroundView.backgroundColor = _selectedBackgroundColor;
    cell.button.titleLabel.font = _font;
    [cell.button setTitleColor:_textColor forState:UIControlStateNormal];
    cell.button.tintColor = _textColor;
    cell.button.sea_leftLayoutConstraint.constant = _cellContentInsets.left;
    cell.button.sea_rightLayoutConstraint.constant = _cellContentInsets.right;
    
    SeaPopoverMenuItemInfo *info = [_menuItemInfos objectAtIndex:indexPath.row];
    [cell.button setTitle:info.title forState:UIControlStateNormal];
    [cell.button setImage:info.icon forState:UIControlStateNormal];
    
    cell.divider.hidden = indexPath.row == _menuItemInfos.count - 1;
    cell.divider.backgroundColor = _separatorColor;
    cell.divider.sea_leftLayoutConstraint.constant = _separatorInsets.left;
    cell.divider.sea_rightLayoutConstraint.constant = _separatorInsets.right;
    
    [cell.button sea_setImagePosition:SeaButtonImagePositionLeft margin:_iconTitleInterval];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.delegate respondsToSelector:@selector(popoverMenu:didSelectAtIndex:)]){
        [self.delegate popoverMenu:self didSelectAtIndex:indexPath.row];
    }
    !self.selectHandler ?: self.selectHandler(indexPath.row);
    [self dismissAnimated:YES];
}

@end
