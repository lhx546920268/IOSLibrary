//
//  SeaBubbleMenu.m

//

#import "SeaBubbleMenu.h"
#import "SeaBasic.h"

/**气泡与父视图的边距
 */
#define SeaBubbleMenuMargin 10.0

/**气泡按钮内容边距
 */
//#define SeaBubbleMenuContentMargin 15.0

@implementation SeaBubbleMenuOverlay

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    UIView *touchView = [touch view];
    
    if([touchView isEqual:self])
    {
        for(UIView *view in touchView.subviews)
        {
            if([view isKindOfClass:[SeaBubbleMenu class]])
            {
                if([view respondsToSelector:@selector(dismissMenuWithAnimated:)])
                {
                    [(SeaBubbleMenu*) view dismissMenuWithAnimated:YES];
                }
            }
        }
    }
}

@end

@implementation SeaBubbleMenuItemInfo

/**构造方法
 *@param title 标题
 *@param icon 图标
 *@return 已初始化的 SeaBubbleMenuItemInfo
 */
+ (id)infoWithTitle:(NSString*) title icon:(UIImage*) icon
{
    SeaBubbleMenuItemInfo *info = [[SeaBubbleMenuItemInfo alloc] init];
    info.title = title;
    info.icon = icon;
    
    return info;
}

@end



@implementation SeaBubbleMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        self.selectedBackgroundView = [[UIView alloc] init];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _button.adjustsImageWhenDisabled = NO;
        _button.adjustsImageWhenHighlighted = NO;
        _button.enabled = NO;
        _button.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_button];
        
        _line = [[UIView alloc] init];
        _line.userInteractionEnabled = NO;
        [self.contentView addSubview:_line];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _button.frame = CGRectMake(_contentInsets.left, 0, self.contentView.width - _contentInsets.left - _contentInsets.right, self.contentView.height);
    _line.frame = CGRectMake(0, self.contentView.height - SeaSeparatorHeight, self.contentView.width, SeaSeparatorHeight);
}

@end



#pragma mark- menu

@interface SeaBubbleMenu ()<UITableViewDataSource, UITableViewDelegate>

//动画起始位置
@property(nonatomic,assign) CGPoint originalPoint;

//气泡出现的位置
@property(nonatomic,assign) CGRect relatedRect;

/**按钮列表
 */
@property(nonatomic, strong) UITableView *tableView;

@end

@implementation SeaBubbleMenu

#pragma mark- init

- (id)init
{
    self = [super init];
    if(self)
    {
        [self initlalization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initlalization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initlalization];
    }
    
    return self;
}


- (void)initlalization
{
    self.backgroundColor = [UIColor clearColor];
    self.opaque = NO;
    self.clipsToBounds = YES;
    
    _fillColor = [UIColor whiteColor];
    _strokeColor = [UIColor clearColor];
    _strokenLineWidth = 0.0;
    
    _textColor = [UIColor blackColor];
    _selectedTextColor = [UIColor redColor];
    _font = [UIFont fontWithName:SeaMainFontName size:15.0];
    _selectedBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    _selectedIndex = NSNotFound;
    _rowHeight = 40.0;
    _menuWidth = 0;
    
    _separatorColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    _contentInsets = UIEdgeInsetsMake(0, 15.0, 0, 15.0);
    
    _arrowLength = 15.0;
    _arrowAngle = 120.0;
}

#pragma mark- property

/**气泡背景颜色，default is 'whiteColor'
 */
- (void)setFillColor:(UIColor *)fillColor
{
    if(![_fillColor isEqualToColor:fillColor])
    {
        if(fillColor == nil)
            fillColor = [UIColor whiteColor];
        _fillColor = fillColor;
        [self setNeedsDisplay];
    }
}

/**气泡边框颜色，default is 'clearColor'
 */
- (void)setStrokeColor:(UIColor *)strokeColor
{
    if(![_strokeColor isEqualToColor:strokeColor])
    {
        if(strokeColor == nil)
            strokeColor = [UIColor clearColor];
        _strokeColor = strokeColor;
        [self setNeedsDisplay];
    }
}

/**气泡边框线条宽度 default is '0'，没有线条
 */
- (void)setStrokenLineWidth:(CGFloat)strokenLineWidth
{
    if(_strokenLineWidth != strokenLineWidth)
    {
        if(strokenLineWidth < 0)
            strokenLineWidth = 0;
        _strokenLineWidth = strokenLineWidth;
    }
}

/**字体颜色
 */
- (void)setTextColor:(UIColor *)textColor
{
    if(![_textColor isEqualToColor:textColor])
    {
        if(textColor == nil)
            textColor = [UIColor blackColor];
        _textColor = textColor;
        [self.tableView reloadData];
    }
}

/**选中的字体颜色
 */
- (void)setSelectedTextColor:(UIColor *)selectedTextColor
{
    if(![_selectedTextColor isEqualToColor:selectedTextColor])
    {
        if(selectedTextColor == nil)
            selectedTextColor = [UIColor redColor];
        _selectedTextColor = selectedTextColor;
        if(_selectedIndex < _menuItemInfos.count)
        {
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

/**字体 default is '[UIFont systemFontOfSize:15.0]'
 */
- (void)setFont:(UIFont *)font
{
    if(![_font isEqualToFont:font])
    {
        if(font == nil)
            font = [UIFont fontWithName:SeaMainFontName size:15.0];
        _font = font;
        [self.tableView reloadData];
    }
}

/**选中背景颜色
 */
- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    if(![_selectedBackgroundColor isEqualToColor:selectedBackgroundColor])
    {
        if(selectedBackgroundColor == nil)
            selectedBackgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        _selectedBackgroundColor = selectedBackgroundColor;
        if(_selectedIndex < _menuItemInfos.count)
        {
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

/**选中的下标 default is 'NSNotFound'
 */
- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if(_selectedIndex != selectedIndex)
    {
        _selectedIndex = selectedIndex;
        if(_selectedIndex < _menuItemInfos.count)
        {
            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
        }
    }
}

/**菜单行高 default is '40.0'
 */
- (void)setRowHeight:(CGFloat)rowHeight
{
    if(_rowHeight != rowHeight)
    {
        _rowHeight = rowHeight;
        self.tableView.rowHeight = _rowHeight;
        [self reloadData];
    }
}

/**菜单宽度 default is '0'，会根据按钮标题宽度，按钮图标和 内容边距获取宽度
 */
- (void)setMenuWidth:(CGFloat)menuWidth
{
    if(_menuWidth != menuWidth)
    {
        if(menuWidth < 0)
            menuWidth = 0;
        _menuWidth = menuWidth;
        [self reloadData];
    }
}

/**按钮内容边距
 */
- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_contentInsets, contentInsets))
    {
        _contentInsets = contentInsets;
        [self reloadData];
    }
}

/**分割线颜
 */
- (void)setSeparatorColor:(UIColor *)separatorColor
{
    if(![_separatorColor isEqualToColor:separatorColor])
    {
        _separatorColor = separatorColor;
        [self.tableView reloadData];
    }
}

/**尖角边长
 */
- (void)setArrowLength:(CGFloat)arrowLength
{
    if(_arrowLength != arrowLength)
    {
        _arrowLength = arrowLength;
        [self redraw];
    }
}

/**尖角角度 使用角度
 */
- (void)setArrowAngle:(CGFloat)arrowAngle
{
    if(_arrowAngle != arrowAngle)
    {
        if(arrowAngle < 30)
            arrowAngle = 30;
        if(arrowAngle > 150)
            arrowAngle = 150;
        _arrowAngle = arrowAngle;
        [self redraw];
    }
}

#pragma mark- publick method

/**显示菜单
 *@param view 父视图
 *@param rect 触发菜单的按钮在 父视图中的位置大小，可用UIView 或 UIWindow 中的converRectTo 来转换
 *@param animated 是否动画
 *@param overlay 是否使用点击空白处关闭菜单
 */
- (void)showInView:(UIView *)view relatedRect:(CGRect)rect animated:(BOOL)animated overlay:(BOOL)overlay
{
    self.relatedRect = rect;
    
    if([self.delegate respondsToSelector:@selector(bubbleMenuWillShow:)])
    {
        [self.delegate bubbleMenuWillShow:self];
    }
    
    [self reloadData];
    
    CGRect toFrame = [self setupFrameFromView:view relateRect:rect];

    CGPoint anchorPoint = CGPointZero;

    switch (self.arrowDirection)
    {
        case SeaBubbleMenuArrowDirectionTop :
        {
           anchorPoint.x = (self.originalPoint.x - toFrame.origin.x) / toFrame.size.width;
        }
            break;
        case SeaBubbleMenuArrowDirectionLeft :
        {
            anchorPoint.y = (self.originalPoint.y - toFrame.origin.y) / toFrame.size.height;
        }
            break;
        case SeaBubbleMenuArrowDirectionRight :
        {
            anchorPoint.y = (self.originalPoint.y - toFrame.origin.y) / toFrame.size.height;
            anchorPoint.x = 1.0;
        }
            break;
        case SeaBubbleMenuArrowDirectionBottom :
        {
            anchorPoint.x = (self.originalPoint.x - toFrame.origin.x) / toFrame.size.width;
            anchorPoint.y = 1.0;
        }
            break;
    }

    self.layer.anchorPoint = anchorPoint;
    self.frame = toFrame;
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);

    if(overlay)
    {
        SeaBubbleMenuOverlay *overlayView = [[SeaBubbleMenuOverlay alloc] initWithFrame:view.bounds];
        overlayView.alpha = 0;
        [overlayView addSubview:self];
        [view addSubview:overlayView];
    }
    else
    {
        self.alpha = 0;
        [view addSubview:self];
    }
    
    if(animated)
    {
        [UIView animateWithDuration:0.25 animations:^(void)
         {
             if([self.superview isKindOfClass:[SeaBubbleMenuOverlay class]])
             {
                 self.superview.alpha = 1.0;
             }
             else
             {
                 self.alpha = 1.0;
             }
             self.transform = CGAffineTransformMakeScale(1.0, 1.0);
         }
        completion:^(BOOL finish)
         {
             if([self.delegate respondsToSelector:@selector(bubbleMenuDidShow:)])
             {
                 [self.delegate bubbleMenuDidShow:self];
             }
         }];
    }
    else
    {
        self.frame = toFrame;
        if([self.delegate respondsToSelector:@selector(bubbleMenuDidShow:)])
        {
            [self.delegate bubbleMenuDidShow:self];
        }
    }
}

/**关闭菜单
 *@param animated 是否动画
 */
- (void)dismissMenuWithAnimated:(BOOL)animated
{
    if([self.delegate respondsToSelector:@selector(bubbleMenuWillDismiss:)])
    {
        [self.delegate bubbleMenuWillDismiss:self];
    }
    
    if(animated)
    {
        [UIView animateWithDuration:0.25 animations:^(void)
         {
             if([self.superview isKindOfClass:[SeaBubbleMenuOverlay class]])
             {
                 self.superview.alpha = 0;
             }
             else
             {
                 self.alpha = 0;
             }
             self.transform = CGAffineTransformMakeScale(0.1, 0.1);
         }completion:^(BOOL finish)
         {
             if([self.delegate respondsToSelector:@selector(bubbleMenuDidDismissed:)])
             {
                 [self.delegate bubbleMenuDidDismissed:self];
             }
             if([self.superview isKindOfClass:[SeaBubbleMenuOverlay class]])
             {
                 UIView *superView = self.superview;
                 [self removeFromSuperview];
                 [superView removeFromSuperview];
             }
             else
             {
                 [self removeFromSuperview];
             }
         }];
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(bubbleMenuDidDismissed:)])
        {
            [self.delegate bubbleMenuDidDismissed:self];
        }
        
        if([self.superview isKindOfClass:[SeaBubbleMenuOverlay class]])
        {
            UIView *superView = self.superview;
            [self removeFromSuperview];
            [superView removeFromSuperview];
        }
        else
        {
            [self removeFromSuperview];
        }
    }
}

//通过标题获取菜单宽度
- (CGFloat)getMenuWidth
{
   if(_menuWidth == 0)
   {
       CGFloat contentWidth = 0;
       for(SeaBubbleMenuItemInfo *info in self.menuItemInfos)
       {
           CGSize size = [info.title stringSizeWithFont:_font contraintWith:SeaScreenWidth];
           contentWidth = MAX(contentWidth, size.width + info.icon.size.width);
       }
       
       return contentWidth + _contentInsets.left + _contentInsets.right;
   }
    else
    {
        return _menuWidth;
    }
}

/**重新加载按钮信息
 */
- (void)reloadData
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = _rowHeight;
        _tableView.separatorColor = _separatorColor;
        _tableView.rowHeight = _rowHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.layer.cornerRadius = 8.0;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.layer.masksToBounds = YES;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        [self addSubview:_tableView];
    }
    
    _tableView.frame = CGRectMake(0, _contentInsets.top, [self getMenuWidth], _menuItemInfos.count * _rowHeight + _contentInsets.top + _contentInsets.bottom);
    
    [self setNeedsDisplay];
    [self.tableView reloadData];
    
    if(_selectedIndex < _menuItemInfos.count)
    {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    }
}

/**重新绘制
 */
- (void)redraw
{
    UIView *superView = self.superview;
    if([superView isKindOfClass:[SeaBubbleMenuOverlay class]])
    {
        superView = superView.superview;
    }
    self.frame = [self setupFrameFromView:superView relateRect:self.relatedRect];
    [self setNeedsDisplay];
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuItemInfos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    SeaBubbleMenuCell *cell = [[SeaBubbleMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[SeaBubbleMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.contentInsets = self.contentInsets;
    cell.selectedBackgroundView.backgroundColor = _selectedBackgroundColor;
    cell.button.titleLabel.font = _font;
    [cell.button setTitleColor:_textColor forState:UIControlStateNormal];
    
    SeaBubbleMenuItemInfo *info = [_menuItemInfos objectAtIndex:indexPath.row];
    [cell.button setTitle:info.title forState:UIControlStateNormal];
    [cell.button setImage:info.icon forState:UIControlStateNormal];
    
    if(_selectedIndex == indexPath.row)
    {
        [cell.button setTitleColor:_selectedTextColor forState:UIControlStateNormal];
    }
    
    cell.line.backgroundColor = _separatorColor;
    cell.line.hidden = _menuItemInfos.count - 1 == indexPath.row;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(_selectedIndex == indexPath.row)
        return;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.delegate respondsToSelector:@selector(bubbleMenu:didSelectedAtIndex:)])
    {
        [self.delegate bubbleMenu:self didSelectedAtIndex:indexPath.row];
    }
    [self dismissMenuWithAnimated:YES];
}

#pragma mark- private method

//设置菜单的位置
- (CGRect)setupFrameFromView:(UIView*) view relateRect:(CGRect) rect
{
    CGSize contentSize = self.tableView.bounds.size;
    
    CGFloat relateX = rect.origin.x;
    CGFloat relateY = rect.origin.y;
    CGFloat relateWidth = rect.size.width;
    CGFloat relateHeight = rect.size.height;
    
    CGFloat superWidth = view.frame.size.width;
    CGFloat superHeight = view.frame.size.height;
    
    CGFloat margin = SeaBubbleMenuMargin;
    CGFloat scale = 2.0 / 3.0;
    
    CGRect resultRect;
    
    //边角宽度
    CGFloat angle = _arrowAngle / 2.0 / 180.0 * M_PI;
    CGFloat arrowWidth = sin(angle) * _arrowLength;
    CGFloat arrowHeight = cos(angle) * _arrowLength;
    
    if((superHeight - (relateY + relateHeight)) * scale > contentSize.height)
    {
        _arrowDirection = SeaBubbleMenuArrowDirectionTop;
        
        CGFloat x = relateX + relateWidth * 0.5 - contentSize.width * 0.5;
        x = x < margin ? margin : x;
        x = x + margin + contentSize.width > superWidth ? superWidth - contentSize.width - margin : x;
        CGFloat y = relateY + relateHeight + margin;
        
        resultRect = CGRectMake(x, y, contentSize.width, contentSize.height + arrowHeight);
        _arrowPoint = CGPointMake(relateX - x + relateWidth * 0.5, 0);
        self.originalPoint = CGPointMake(x + self.arrowPoint.x, y);
        self.tableView.top = arrowHeight;
    }
    else if((superHeight - (relateY + relateHeight)) * scale < contentSize.height)
    {
        _arrowDirection = SeaBubbleMenuArrowDirectionBottom;
        
        CGFloat x = relateX + relateWidth * 0.5 - contentSize.width * 0.5;
        x = x < margin ? margin : x;
        x = x + margin + contentSize.width > superWidth ? superWidth - contentSize.width - margin : x;
        CGFloat y = relateY - margin - contentSize.height - arrowHeight;
        
        resultRect = CGRectMake(x, y, contentSize.width, contentSize.height + arrowHeight);
        _arrowPoint = CGPointMake(relateX - x + relateWidth * 0.5, resultRect.size.height);
        self.originalPoint = CGPointMake(x + self.arrowPoint.x, y + resultRect.size.height);
    }
    else
    {
        if(superWidth - (relateX + relateWidth) < contentSize.width)
        {
            _arrowDirection = SeaBubbleMenuArrowDirectionRight;
            
            CGFloat x = relateX - margin - contentSize.width - arrowWidth;
            CGFloat y = relateY + relateHeight * 0.5 - contentSize.height * 0.5;
            y = y < margin ? margin : y;
            y = y + margin + contentSize.height > superHeight ? superHeight - contentSize.height - margin : y;
            
            resultRect = CGRectMake(x, y, contentSize.width + arrowHeight, contentSize.height);
            _arrowPoint = CGPointMake(resultRect.size.width, relateY - y + relateHeight * 0.5);
            self.originalPoint = CGPointMake(x + resultRect.size.width, y + self.arrowPoint.y);
        }
        else
        {
            _arrowDirection = SeaBubbleMenuArrowDirectionLeft;
            
            CGFloat x = relateX + relateWidth + margin;
            CGFloat y = relateY + relateHeight * 0.5 - contentSize.height * 0.5;
            y = y < margin ? margin : y;
            y = y + margin + contentSize.height > superHeight ? superHeight - contentSize.height - margin : y;
            
            resultRect = CGRectMake(x, y, contentSize.width + arrowHeight, contentSize.height);
            _arrowPoint = CGPointMake(0, relateY - y + relateHeight * 0.5);
            self.originalPoint = CGPointMake(x, y + self.arrowPoint.y);
            self.tableView.left = arrowWidth;
        }
    }
    
    return resultRect;
}

#pragma mark- draw menu

- (void)drawRect:(CGRect)rect
{
    //边角宽度
    CGFloat angle = _arrowAngle / 2.0 / 180.0 * M_PI;
    CGFloat arrowWidth = sin(angle) * _arrowLength;
    CGFloat arrowHeight = cos(angle) * _arrowLength;
    
    CGRect rectangular;
    CGFloat lineWidth = _strokenLineWidth;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //设置绘制属性
    CGFloat radius = arrowHeight / cos(M_PI / 3.0) / 2.0; //尖角圆弧
    CGFloat cornerRadius = self.tableView.layer.cornerRadius;//矩形圆角
    CGContextSetStrokeColorWithColor(context, _strokeColor.CGColor);
    CGContextSetFillColorWithColor(context, _fillColor.CGColor);
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    //设置位置
    CGPoint arrowPoint1;
    CGPoint arrowPoint2;
    
    switch (self.arrowDirection)
    {
        case SeaBubbleMenuArrowDirectionTop :
        {
            arrowPoint1 = CGPointMake(self.arrowPoint.x - arrowWidth * 0.5, self.arrowPoint.y + arrowHeight);
            arrowPoint2 = CGPointMake(self.arrowPoint.x + arrowWidth * 0.5, self.arrowPoint.y + arrowHeight);
            rectangular = CGRectMake(lineWidth, arrowHeight, self.bounds.size.width - lineWidth * 2.0, self.bounds.size.height - arrowHeight - lineWidth);
           
            CGFloat rectangularBottom = rectangular.size.height + rectangular.origin.y;///矩形 height + y
            CGFloat rectangularRight = rectangular.origin.x + rectangular.size.width; ///矩形 width + x
            
            
            //绘制尖角左边
            CGContextMoveToPoint(context, _arrowPoint.x, _arrowPoint.y + lineWidth);
            CGContextAddLineToPoint(context, _arrowPoint.x - radius / 4.0, _arrowPoint.y + radius / 2.0);
            CGContextAddArcToPoint(context, arrowPoint1.x, arrowPoint1.y, arrowPoint1.x - radius / 2.0, arrowPoint1.y, radius);
            
            //绘制圆角矩形
            //向左边连接
            CGContextAddLineToPoint(context, rectangular.origin.x + cornerRadius, rectangular.origin.y);
            
            //绘制左边圆角
            CGContextAddArcToPoint(context, rectangular.origin.x, rectangular.origin.y, rectangular.origin.x, cornerRadius + rectangular.origin.y, cornerRadius);
            
            //向下连接
            CGContextAddLineToPoint(context, rectangular.origin.x, rectangularBottom - cornerRadius);
            //绘制左下角圆角
            CGContextAddArcToPoint(context, rectangular.origin.x, rectangularBottom, rectangular.origin.x + cornerRadius, rectangularBottom, cornerRadius);
            
            //向右边连接
            CGContextAddLineToPoint(context, rectangularRight - cornerRadius, rectangularBottom);
            //绘制右下角圆角
            CGContextAddArcToPoint(context, rectangularRight, rectangularBottom, rectangularRight, rectangularBottom - cornerRadius, cornerRadius);
            
            //向上连接
            CGContextAddLineToPoint(context, rectangularRight, rectangular.origin.y + cornerRadius);
            //绘制右上角圆角
            CGContextAddArcToPoint(context, rectangularRight, rectangular.origin.y, rectangularRight - cornerRadius, rectangular.origin.y, cornerRadius);
            
            //向尖角右下角连接
            CGContextAddLineToPoint(context, arrowPoint2.x + radius / 2.0, arrowPoint2.y);
            
            //绘制尖角右边
            CGContextAddArcToPoint(context, arrowPoint2.x, arrowPoint2.y, _arrowPoint.x + radius / 4.0, _arrowPoint.y + radius / 2.0, radius);
            CGContextAddLineToPoint(context, _arrowPoint.x, _arrowPoint.y + lineWidth);
        }
            break;
        case SeaBubbleMenuArrowDirectionBottom :
        {
            arrowPoint1 = CGPointMake(self.arrowPoint.x - arrowWidth * 0.5, self.arrowPoint.y - arrowHeight);
            arrowPoint2 = CGPointMake(self.arrowPoint.x + arrowWidth * 0.5, self.arrowPoint.y - arrowHeight);
            rectangular = CGRectMake(lineWidth, 0, self.bounds.size.width - lineWidth * 2.0, self.bounds.size.height - arrowHeight - lineWidth);
            
            CGFloat rectangularBottom = rectangular.size.height + rectangular.origin.y;///矩形 height + y
            CGFloat rectangularRight = rectangular.origin.x + rectangular.size.width; ///矩形 width + x
            
            
            //绘制尖角 左边
            CGContextMoveToPoint(context, _arrowPoint.x, _arrowPoint.y - lineWidth);
            CGContextAddLineToPoint(context, _arrowPoint.x - radius / 4.0, _arrowPoint.y - radius / 2.0);
            CGContextAddArcToPoint(context, arrowPoint1.x, arrowPoint1.y, arrowPoint1.x - radius / 2.0, arrowPoint1.y, radius);
            
            //绘制圆角矩形
            //向左边连接
            CGContextAddLineToPoint(context, rectangular.origin.x + cornerRadius, rectangularBottom);
            
            //绘制左下角圆角
            CGContextAddArcToPoint(context, rectangular.origin.x, rectangularBottom, rectangular.origin.x, rectangularBottom - cornerRadius, cornerRadius);
            
            //向上连接
            CGContextAddLineToPoint(context, rectangular.origin.x, rectangular.origin.y + cornerRadius);
            //绘制左上角角圆角
            CGContextAddArcToPoint(context, rectangular.origin.x, rectangular.origin.y, rectangular.origin.x + cornerRadius, rectangular.origin.y, cornerRadius);
            
            //向右边连接
            CGContextAddLineToPoint(context, rectangularRight - cornerRadius, rectangular.origin.y);
            //绘制右上角圆角
            CGContextAddArcToPoint(context, rectangularRight, rectangular.origin.y, rectangularRight, rectangular.origin.y + cornerRadius, cornerRadius);
            
            //向下连接
            CGContextAddLineToPoint(context, rectangularRight, rectangularBottom - cornerRadius);
            //绘制右下角圆角
            CGContextAddArcToPoint(context, rectangularRight, rectangularBottom, rectangularRight - cornerRadius, rectangularBottom, cornerRadius);
            
            //向尖角右上角连接
            CGContextAddLineToPoint(context, arrowPoint2.x + radius / 2.0, arrowPoint2.y);
            
            //绘制尖角右边
            CGContextAddArcToPoint(context, arrowPoint2.x, arrowPoint2.y, _arrowPoint.x + radius / 4.0, _arrowPoint.y - radius / 2.0, radius);
            CGContextAddLineToPoint(context, _arrowPoint.x, _arrowPoint.y - lineWidth);
        }
            break;
        case SeaBubbleMenuArrowDirectionLeft :
        {
            arrowPoint1 = CGPointMake(self.arrowPoint.x + arrowHeight, self.arrowPoint.y - arrowWidth * 0.5);
            arrowPoint2 = CGPointMake(self.arrowPoint.x + arrowHeight, self.arrowPoint.y + arrowWidth * 0.5);
            rectangular = CGRectMake(arrowHeight, lineWidth, self.bounds.size.width - lineWidth - arrowHeight, self.bounds.size.height - lineWidth * 2);
           
            CGFloat rectangularBottom = rectangular.size.height + rectangular.origin.y;///矩形 height + y
            CGFloat rectangularRight = rectangular.origin.x + rectangular.size.width; ///矩形 width + x
            
            //绘制尖角下面
            CGContextMoveToPoint(context, _arrowPoint.x + lineWidth, _arrowPoint.y);
            CGContextAddLineToPoint(context, _arrowPoint.x + radius / 2.0, _arrowPoint.y + radius / 4.0);
            CGContextAddArcToPoint(context, arrowPoint1.x, arrowPoint1.y, arrowPoint1.x, arrowPoint1.y + radius / 2.0, radius);
            
            //绘制圆角矩形
            //向下连接
            CGContextAddLineToPoint(context, rectangular.origin.x , rectangularBottom - cornerRadius);
            
            //绘制左下角圆角
            CGContextAddArcToPoint(context, rectangular.origin.x, rectangularBottom, rectangular.origin.x + cornerRadius, rectangularBottom, cornerRadius);
            
            //向右连接
            CGContextAddLineToPoint(context, rectangularRight - cornerRadius, rectangularBottom);
            //绘制右下角圆角
            CGContextAddArcToPoint(context, rectangularRight, rectangularBottom, rectangularRight, rectangularBottom - cornerRadius, cornerRadius);
            

            //向上连接
            CGContextAddLineToPoint(context, rectangularRight, rectangular.origin.y + cornerRadius);
            //绘制右上角圆角
            CGContextAddArcToPoint(context, rectangularRight, rectangular.origin.y, rectangularRight - cornerRadius, rectangular.origin.y, cornerRadius);
            
            //向左连接
            CGContextAddLineToPoint(context, rectangular.origin.x + cornerRadius, rectangular.origin.y);
            //绘制左上角圆角
            CGContextAddArcToPoint(context, rectangular.origin.x, rectangular.origin.y, rectangular.origin.x, rectangular.origin.y + cornerRadius, cornerRadius);
            
            
            
            //向尖角上面连接
            CGContextAddLineToPoint(context, arrowPoint2.x, arrowPoint2.y - radius / 2.0);
            
            //绘制尖角右边
            CGContextAddArcToPoint(context, arrowPoint2.x, arrowPoint2.y, _arrowPoint.x + radius / 2.0, _arrowPoint.y - radius / 4.0, radius);
            CGContextAddLineToPoint(context, _arrowPoint.x, _arrowPoint.y + lineWidth);
        }
            break;
        case SeaBubbleMenuArrowDirectionRight :
        {
            arrowPoint1 = CGPointMake(self.arrowPoint.x - arrowHeight, self.arrowPoint.y - arrowWidth * 0.5);
            arrowPoint2 = CGPointMake(self.arrowPoint.x - arrowHeight, self.arrowPoint.y + arrowWidth * 0.5);
            rectangular = CGRectMake(0, lineWidth, self.bounds.size.width - lineWidth - arrowHeight, self.bounds.size.height - lineWidth * 2);
            
            CGFloat rectangularBottom = rectangular.size.height + rectangular.origin.y;///矩形 height + y
            CGFloat rectangularRight = rectangular.origin.x + rectangular.size.width; ///矩形 width + x
            
            //绘制尖角下面
            CGContextMoveToPoint(context, _arrowPoint.x + lineWidth, _arrowPoint.y);
            CGContextAddLineToPoint(context, _arrowPoint.x - radius / 2.0, _arrowPoint.y + radius / 4.0);
            CGContextAddArcToPoint(context, arrowPoint1.x, arrowPoint1.y, arrowPoint1.x, arrowPoint1.y + radius / 2.0, radius);
            
            //绘制圆角矩形
            //向右下连接
            CGContextAddLineToPoint(context, rectangularRight - cornerRadius, rectangularBottom);
            //绘制右下角圆角
            CGContextAddArcToPoint(context, rectangularRight, rectangularBottom, rectangularRight, rectangularBottom - cornerRadius, cornerRadius);
            
            //向左连接
            CGContextAddLineToPoint(context, rectangularRight, rectangularBottom - cornerRadius);
            
            //绘制左下角圆角
            CGContextAddArcToPoint(context, rectangular.origin.x, rectangularBottom, rectangular.origin.x + cornerRadius, rectangularBottom, cornerRadius);
 
            //向左上连接
            CGContextAddLineToPoint(context, rectangular.origin.x + cornerRadius, rectangular.origin.y);
            //绘制左上角圆角
            CGContextAddArcToPoint(context, rectangular.origin.x, rectangular.origin.y, rectangular.origin.x, rectangular.origin.y + cornerRadius, cornerRadius);
            
            //向上连接
            CGContextAddLineToPoint(context, rectangularRight, rectangular.origin.y + cornerRadius);
            //绘制右上角圆角
            CGContextAddArcToPoint(context, rectangularRight, rectangular.origin.y, rectangularRight - cornerRadius, rectangular.origin.y, cornerRadius);
            
     
            
            //向尖角上面连接
            CGContextAddLineToPoint(context, arrowPoint2.x, arrowPoint2.y - radius / 2.0);
            
            //绘制尖角右边
            CGContextAddArcToPoint(context, arrowPoint2.x, arrowPoint2.y, _arrowPoint.x - radius / 2.0, _arrowPoint.y - radius / 4.0, radius);
            CGContextAddLineToPoint(context, _arrowPoint.x, _arrowPoint.y + lineWidth);
        }
            break;
        default:
            break;
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
