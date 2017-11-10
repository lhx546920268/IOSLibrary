//
//  UBGridronMenu.m

//

#import "SeaGridronMenu.h"
#import "SeaBasic.h"

#define _startTag_ 1300

@interface SeaGridronMenu ()

//行数
@property(nonatomic,assign) NSInteger row;

@end

@implementation SeaGridronMenu

/**构造方法
 *@param frame 位置大小 高度会根据 标题数量调整
 *@param infos 按钮信息 数组元素是 SeaMenuItemInfo对象
 *@return 已初始化的 SeaGridronMenu
 */
- (id)initWithFrame:(CGRect)frame infos:(NSArray*) infos
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
        _gridLineColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        _gridLineWidth = 0.5;
        _titleColor = [UIColor blackColor];
        _titleFont = [UIFont fontWithName:SeaMainFontName size:15.0];
        _titleHightlightColor = [UIColor blueColor];
        _countPerRow = 4;
        _menuItemHeight = 35.0;
        
        //行数和列数
        NSInteger row = 0;
        NSInteger column = 0;
        CGFloat width = frame.size.width / _countPerRow;
        
        for(NSInteger i = 0;i < infos.count;i ++)
        {
            SeaMenuItemInfo *info = [infos objectAtIndex:i];
            if(i % _countPerRow == 0)
            {
                row ++;
                column = 0;
            }
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:info.title forState:UIControlStateNormal];
            [btn setTitleColor:_titleColor forState:UIControlStateNormal];
            [btn setTitleColor:_titleHightlightColor forState:UIControlStateHighlighted];
            [btn setImage:info.icon forState:UIControlStateNormal];
            [btn setBackgroundImage:info.backgroundImage forState:UIControlStateNormal];
            btn.titleLabel.font = _titleFont;
            btn.tag = _startTag_ + i;
            btn.frame = CGRectMake(width * column, (row - 1) * _menuItemHeight, width, _menuItemHeight);
            [btn addTarget:self action:@selector(buttonDidSelect:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            column ++;
        }
        self.row = row;
        
        self.height = row * _menuItemHeight;
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, _gridLineWidth);
    CGContextSetStrokeColorWithColor(ctx, _gridLineColor.CGColor);
    
    //绘制横线
    for(NSInteger i = 0;i <= _row;i ++)
    {
        CGContextMoveToPoint(ctx, 0, _menuItemHeight * i);
        CGContextAddLineToPoint(ctx, rect.size.width, _menuItemHeight * i);
    }
    
    //绘制纵线
    CGFloat width = rect.size.width / _countPerRow;
    for(NSInteger i = 1;i < _countPerRow;i ++)
    {
        CGContextMoveToPoint(ctx, i * width, 0);
        CGContextAddLineToPoint(ctx, i * width, rect.size.height);
    }
    
    CGContextStrokePath(ctx);
}

#pragma mark- property

#pragma mark- private method

//选择菜单按钮

- (void)buttonDidSelect:(UIButton*) btn
{
    if([self.delegate respondsToSelector:@selector(gridronMenu:didSelectItemAtIndex:)])
    {
        [self.delegate gridronMenu:self didSelectItemAtIndex:btn.tag - _startTag_];
    }
}

@end
