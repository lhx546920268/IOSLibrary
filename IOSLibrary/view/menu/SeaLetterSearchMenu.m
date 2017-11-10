//
//  SeaLetterSearchMenu.m

//

#import "SeaLetterSearchMenu.h"
#import "SeaBasic.h"

//菜单按钮高度
#define _SeaLetterSearchMenuItemHeight_ 14.0

@implementation SeaLetterSearchMenu

/**构造方法
 *@param titles 标题信息 数组元素是 NSString
 */
- (id)initWithFrame:(CGRect)frame menuTitles:(NSArray*) titles
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.titles = titles;
    }
    return self;
}

#pragma mark- dealloc

- (void)dealloc
{
    self.target = nil;
}

#pragma mark- property

- (void)setTitles:(NSArray *)titles
{
    if(_titles != titles)
    {
        _titles = titles;
        [self reloadData];
    }
}

- (void)setTitleColor:(UIColor *)titleColor
{
    if(titleColor == nil)
        titleColor = [UIColor grayColor];
    if(![_titleColor isEqualToColor:titleColor])
    {
        _titleColor = titleColor;
        for(NSInteger i = 1;i <= _titles.count;i ++)
        {
            UILabel *label = (UILabel*)[self viewWithTag:i];
            label.textColor = _titleColor;
        }
    }
}

//重新加载
- (void)reloadData
{
    NSInteger count = _titles.count;
    CGFloat height = _SeaLetterSearchMenuItemHeight_ * count;
    CGFloat y = (self.frame.size.height - height) / 2.0;
    
    _titleColor = [UIColor grayColor];
    for(int i = 0;i < count;i ++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, y + _SeaLetterSearchMenuItemHeight_ * i, self.frame.size.width, _SeaLetterSearchMenuItemHeight_)];
        label.tag = i + 1;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:SeaMainNumberFontName size:13.0];
        label.backgroundColor = [UIColor clearColor];
        
        NSString *title = [_titles objectAtIndex:i];
        if(title.length > 1)
            title = [title substringToIndex:1];
        label.text = title;
        
        label.textColor = _titleColor;
        [self addSubview:label];
    }
}

#pragma mark- public method

/**添加字母选择方法
 */
- (void)addTarget:(id) target action:(SEL)action
{
    self.target = target;
    self.selector = action;
}

#pragma mark- touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *view = touch.view;
    if(view.tag > 0 && view.tag <= _titles.count)
    {
        self.toucheString = [(UILabel*)view text];
        if(self.target != nil && self.selector != nil)
        {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [self.target performSelector:self.selector];
#pragma clang diagnostic pop
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    int tag = point.y / _SeaLetterSearchMenuItemHeight_;
    if(tag > _titles.count || tag <= 0)
        return;
    
    UILabel *label = (UILabel*)[self viewWithTag:tag];
    self.toucheString = label.text;
    if(self.target != nil && self.selector != nil)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector];
#pragma clang diagnostic pop
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(self.target != nil && self.selector != nil)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector];
#pragma clang diagnostic pop
    }
    
}

@end
