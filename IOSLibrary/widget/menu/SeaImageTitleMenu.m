//
//  SeaImageTitleMenu.m

//

#import "SeaImageTitleMenu.h"
#import "SeaImageTitleMenuItem.h"
#import "SeaBasic.h"

#define _startTag_ 200

@interface SeaImageTitleMenu ()


@end

@implementation SeaImageTitleMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
    }
    return self;
}

/**构造方法 图标的数量要和标题的数量一致
 *@param images 图标 数组元素是UIImage
 *@param titles 标题 数组元素是NSString
 *@return 一个初始化的 SeaImageTitleMenu
 */
- (id)initWithFrame:(CGRect)frame images:(NSArray*) images titles:(NSArray*) titles
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
        self.images = images;
        self.titles = titles;
        [self reloadData];
    }
    return self;
}

- (void)initialization
{
    self.insets = UIEdgeInsetsMake(8.0, 0, 0, 0);
    self.titleFont = [UIFont systemFontOfSize:13];
    self.titleColor = [UIColor blackColor];
    self.numberOfColumns = 4;
    self.itemHeight = 80.0;
}

#pragma mark- dealloc

- (void)dealloc
{
    self.delegate = nil;

}

#pragma mark- property

- (void)setTitleFont:(UIFont *)titleFont
{
    if(titleFont == nil)
        titleFont = [UIFont fontWithName:SeaMainFontName size:13.0];
    if(titleFont != _titleFont)
    {
        _titleFont = titleFont;
        
        for(NSInteger i = 0;i < MIN(self.titles.count, self.images.count);i ++)
        {
            SeaImageTitleMenuItem *item = (SeaImageTitleMenuItem*)[self viewWithTag:_startTag_ + i];
            item.titleLabel.font = _titleFont;
        }
    }
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if(titleColor == nil)
        titleColor = [UIColor blackColor];
    if(![_titleColor isEqualToColor:titleColor])
    {
        _titleColor = titleColor;
        for(NSInteger i = 0;i < MIN(self.titles.count, self.images.count);i ++)
        {
            SeaImageTitleMenuItem *item = (SeaImageTitleMenuItem*)[self viewWithTag:_startTag_ + i];
            item.titleLabel.textColor = _titleColor;
        }
    }
}

#pragma mark- public method

/**重新加载数据
 */
- (void)reloadData
{
    for(UIView *view in self.subviews)
    {
        [view removeFromSuperview];
    }
    
    
    CGFloat width = self.width / _numberOfColumns;
    NSInteger count = MIN(_images.count, _titles.count);
    NSInteger row = 0;
    NSInteger column = 0;
    
    for(NSInteger i = 0;i < count;i ++)
    {
        if(i % _numberOfColumns == 0)
        {
            row ++;
            column = 0;
        }
        
        UIImage *image = [_images objectAtIndex:i];
        NSString *title = [_titles objectAtIndex:i];
        
        UIEdgeInsets insets = UIEdgeInsetsZero;
        if(row == 1)
        {
            insets = self.insets;
        }
        
        SeaImageTitleMenuItem *item = [[SeaImageTitleMenuItem alloc] initWithFrame:CGRectMake(column * width, (row - 1) * _itemHeight, width, _itemHeight) image:image title:title insets:insets];
        item.tag = i + _startTag_;
        item.index = i;
        item.titleLabel.font = self.titleFont;
        item.titleLabel.textColor = self.titleColor;
        [item addTarget:self action:@selector(menuItemDidSelect:)];
        [self addSubview:item];
        
        column ++;
    }
    
    self.height = row * _itemHeight;
}

/**获取按钮
 */
- (SeaImageTitleMenuItem*)menuItemForIndex:(NSInteger) index
{
    return (SeaImageTitleMenuItem*)[self viewWithTag:_startTag_ + index];
}

#pragma mark- private method

//选择菜单按钮
- (void)menuItemDidSelect:(SeaImageTitleMenuItem*) menuItem
{
    if([self.delegate respondsToSelector:@selector(imageTitleMenu:didSelectItemAtIndex:)])
    {
        [self.delegate imageTitleMenu:self didSelectItemAtIndex:menuItem.index];
    }
}

@end
