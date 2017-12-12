//
//  SeaButton.m

//

#import "SeaButton.h"
#import "SeaBasic.h"

@implementation SeaButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _seaButtonType = SeaButtonTypeNumberAndSquare;
        [self initlization];
    }
    return self;
}

/**构造方法
 *@param frame button位置大小
 *@param type button类型
 *@return 一个初始化的 SeaButton对象
 */
- (id)initWithFrame:(CGRect)frame buttonType:(SeaButtonType)type
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _seaButtonType = type;
        [self initlization];
    }
    return self;
}

//数据初始化
- (void)initlization
{
    [self setShowsTouchWhenHighlighted:YES];
    
    switch (_seaButtonType)
    {
        case SeaButtonTypeAdd :
        {
            _contentBounds = CGRectMake(5.0, 5.0, self.width - 10.0, self.height - 10.0);
        }
            break;
        case SeaButtonTypeBookmark :
        {
            
        }
            break;
        case SeaButtonTypeClose :
        {
            
        }
            break;
        case SeaButtonTypeLeftArrow :
        {
            _contentBounds = CGRectMake(self.width - 16.0, self.height - 30.0, 8.0, 15.0);
        }
            break;
        case SeaButtonTypeNumberAndSquare :
        {
            
        }
            break;
        case SeaButtonTypeRefresh :
        {
            
        }
            break;
        case SeaButtonTypeRightArrow :
        {
            _contentBounds = CGRectMake(self.width - 16.0, self.height - 30.0, 8.0, 15.0);
        }
            break;
        case SeaButtonTypeSearch :
        {
            
        }
            break;
        case SeaButtonTypeUpload :
        {
            
        }
            break;
        default:
            break;
    }
    
    self.backgroundColor = [UIColor clearColor];
    _lineColor = [UIColor greenColor];
    _disableLineColor = [UIColor grayColor];
    _lineWidth = 1.2;
    _number = 1;
}

#pragma mark- dealloc

- (void)dealloc
{
    
}

#pragma mark- set property

- (void)setLineColor:(UIColor *)lineColor
{
    if(_lineColor != lineColor)
    {
        _lineColor = lineColor;
        [self setNeedsDisplay];
    }
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    if(_lineWidth != lineWidth)
    {
        _lineWidth = lineWidth;
        [self setNeedsDisplay];
    }
}


- (void)setNumber:(int)number
{
    if(_number != number)
    {
        _number = number;
        if(_number > 99)
        {
            _number = 99;
        }
        [self setNeedsDisplay];
    }
}

- (void)setDisableLineColor:(UIColor *)disableLineColor
{
    if(_disableLineColor != disableLineColor)
    {
        _disableLineColor = disableLineColor;
        [self setNeedsDisplay];
    }
}

- (void)setContentBounds:(CGRect)contentBounds
{
    if(!CGRectEqualToRect(_contentBounds, contentBounds))
    {
        _contentBounds = contentBounds;
        [self setNeedsDisplay];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
    [self setNeedsDisplay];
}

#pragma mark- draw

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置线条颜色和宽度
    UIColor *color = self.enabled ? _lineColor : _disableLineColor;
    CGContextSetStrokeColorWithColor(context, color.CGColor);
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    switch (_seaButtonType)
    {
        case SeaButtonTypeNumberAndSquare :
        {
            [self drawNumberAndSquareAtRect:rect withContext:context];
        }
            break;
        case SeaButtonTypeAdd :
        {
            [self drawAddAtRect:rect withContext:context];
        }
            break;
        case SeaButtonTypeLeftArrow :
        {
            [self drawLeftArrowAtRect:rect withContext:context];
        }
            break;
        case SeaButtonTypeRightArrow :
        {
            [self drawRightArrowAtRect:rect withContext:context];
        }
            break;
        case SeaButtonTypeBookmark :
        {
            [self drawBookmarkAtRect:rect withContext:context];
        }
            break;
        case SeaButtonTypeRefresh :
        {
            [self drawRefreshAtRect:rect withContext:context];
        }
            break;
        case SeaButtonTypeUpload :
        {
            [self drawUploadAtRect:rect withContext:context];
        }
            break;
        case SeaButtonTypeClose :
        {
            [self drawCloseAtRect:rect withContext:context];
        }
            break;
        case SeaButtonTypeSearch :
        {
            [self drawSearchAtRect:rect withContext:context];
        }
            break;
    }
}

//绘制正方形和数字
- (void)drawNumberAndSquareAtRect:(CGRect) rect withContext:(CGContextRef) context
{
    //设置起点坐标
    CGFloat width = 18.0;
    CGFloat width2 = 5.0;
    CGPoint point = CGPointMake((rect.size.width - width - width2) / 2.0, (rect.size.height - width - width2) / 2.0);
    CGContextMoveToPoint(context, point.x, point.y);
    
    //画第一条线
    CGContextAddLineToPoint(context, point.x + width, point.y);
    //画第二条线
    CGContextAddLineToPoint(context, point.x + width, point.y + width2);
    
    //画第三条线
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x, point.y + width);
    
    //画第四条线
    CGContextAddLineToPoint(context, point.x + width2, point.y + width);
    
    //设置第二个点
    CGPoint point2 = CGPointMake(point.x + width2, point.y + width2);
    CGContextMoveToPoint(context, point2.x, point2.y);
    
    //画第一条线
    CGContextAddLineToPoint(context, point2.x, point2.y + width);
    //画第二条线
    CGContextAddLineToPoint(context, point2.x + width, point2.y + width);
    
    //画第三条线
    CGContextAddLineToPoint(context, point2.x + width, point2.y);
    //画第四条线
    CGContextAddLineToPoint(context, point2.x, point2.y);
    //把线条都绘制出来 必须的
    CGContextStrokePath(context);
    
    //画给定数字
    NSString *numberString = [NSString stringWithFormat:@"%d",_number];
    UIFont *font = [UIFont fontWithName:SeaMainFontName size:14.0];
    CGSize size = [numberString stringSizeWithFont:font contraintWith:SeaScreenWidth];
    
    CGPoint textPoint = CGPointMake(point2.x + (width - size.width) / 2.0, point2.y + (width - size.height) / 2.0);
    

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, _lineColor, NSForegroundColorAttributeName, nil];
    [numberString drawAtPoint:textPoint withAttributes:attributes];

}

//绘制加号
- (void)drawAddAtRect:(CGRect) rect withContext:(CGContextRef) context
{
    CGFloat width = MIN(_contentBounds.size.width, _contentBounds.size.height);
    
    //绘制横线
    CGPoint point = CGPointMake((rect.size.width - width) / 2.0, rect.size.height / 2.0);
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x + width, point.y);
    
    //绘制竖线
    point = CGPointMake(rect.size.width / 2.0, (rect.size.height - width) / 2.0);
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x, point.y + width);
    
    //把线条都绘制出来 必须的
    CGContextStrokePath(context);
}

//绘制左边箭头
- (void)drawLeftArrowAtRect:(CGRect) rect withContext:(CGContextRef) context
{
    CGFloat width = _contentBounds.size.width;
    CGFloat height = _contentBounds.size.height;
    
    CGPoint point = CGPointZero;
    switch (self.contentHorizontalAlignment)
    {
        case UIControlContentHorizontalAlignmentLeft :
            point.x = _lineWidth / 2.0;
            break;
        case UIControlContentHorizontalAlignmentRight :
            point.x = rect.size.width - width;
            break;
        default :
            point.x = (rect.size.width - width) / 2.0;
            break;
    }
    
    switch (self.contentVerticalAlignment)
    {
        case UIControlContentVerticalAlignmentTop :
            point.y = height / 2.0;
            break;
        case UIControlContentVerticalAlignmentBottom :
            point.y = rect.size.height - height;
        default:
            point.y = rect.size.height / 2.0;
            break;
    }
    
    //绘制上边线条
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x + width, (rect.size.height - height) / 2.0);
    
    //绘制下边线条
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x + width, (rect.size.height - height) / 2.0 + height);
    
    CGContextStrokePath(context);
}

//绘制右边箭头
- (void)drawRightArrowAtRect:(CGRect) rect withContext:(CGContextRef) context
{
    CGFloat width = MIN(8.0, rect.size.width / 4.0);
    CGFloat height = MIN(rect.size.height / 2.0, 15.0);
    
    CGPoint point = CGPointMake((rect.size.width - width) / 2.0 + width, rect.size.height / 2.0);
    //绘制上边线条
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x - width, (rect.size.height - height) / 2.0);
    
    //绘制下边线条
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x - width, (rect.size.height - height) / 2.0 + height);
    
    CGContextStrokePath(context);
}

//绘制书签
- (void)drawBookmarkAtRect:(CGRect) rect withContext:(CGContextRef) context
{
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    CGFloat width = 12.0;
    CGFloat height = 18.0;
    
    CGFloat breakWidth = 2.0;
    
    CGPoint point = CGPointMake((rect.size.width - width * 2) / 2.0, (rect.size.height - height) / 2.0);
    //绘制书签左边
    CGContextMoveToPoint(context, point.x, point.y);
    
    //向下绘制
    CGContextAddLineToPoint(context, point.x, point.y + height);
    
    //向右添加线条
    CGContextAddLineToPoint(context, point.x + width - breakWidth, point.y + height);
    CGContextAddLineToPoint(context, point.x + width, point.y + height + breakWidth);
    
    //向上添加线条
    CGContextAddLineToPoint(context, point.x + width, point.y + breakWidth);
    CGContextAddLineToPoint(context, point.x + width - breakWidth, point.y);
    
    //向左添加线条 书签左边完成
    CGContextAddLineToPoint(context, point.x, point.y);
    
    //移动到书签中间
    CGContextMoveToPoint(context, point.x + width, point.y + breakWidth);
    
    //向右添加线条
    CGContextAddLineToPoint(context, point.x + width + breakWidth, point.y);
    CGContextAddLineToPoint(context, point.x + width * 2, point.y);
    
    //向下添加线条
    CGContextAddLineToPoint(context, point.x + width * 2, point.y + height);
    
    //向左添加线条
    CGContextAddLineToPoint(context, point.x + width + breakWidth, point.y + height);
    CGContextAddLineToPoint(context, point.x + width, point.y + height + breakWidth);
    
    CGContextStrokePath(context);
}

//绘制刷新
- (void)drawRefreshAtRect:(CGRect) rect withContext:(CGContextRef) context
{
    //圆心和半径
    CGPoint point = CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0);
    CGFloat radius = 10.0;
    
    //画个圆弧
    CGContextAddArc(context, point.x, point.y, radius, 0, 2 * M_PI - M_PI_2, NO);
    
    //画箭头
    CGFloat width = 5.0;
    CGFloat height = 3.0;
    point = CGPointMake(point.x + width / 2.0, rect.size.height / 2.0 - radius);
    
    CGContextMoveToPoint(context, point.x - width, point.y - height);
    CGContextAddLineToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x - width, point.y + height);
    CGContextStrokePath(context);
}

//绘制上传
- (void)drawUploadAtRect:(CGRect) rect withContext:(CGContextRef) context
{
    //正方形边长
    CGFloat width = 18.0;
    
    CGFloat padding = 4.0;
    
    //画正方形
    CGPoint point = CGPointMake((rect.size.width - width) / 2.0, (rect.size.height - width) / 2.0 + padding);
    
    //第一条线
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x, point.y + width);
    
    //第二条线
    CGContextAddLineToPoint(context, point.x + width, point.y + width);
    
    //第三条线
    CGContextAddLineToPoint(context, point.x + width, point.y);
    
    //画第四第五条线，中间空着
    CGContextAddLineToPoint(context, point.x + (width - padding) / 2.0 + padding, point.y);
    CGContextMoveToPoint(context, point.x + (width - padding) / 2.0, point.y);
    CGContextAddLineToPoint(context, point.x, point.y);
    
    
    //移动到矩形中心
    CGPoint center = CGPointMake(point.x + width / 2.0, point.y + width / 2.0);
    CGContextMoveToPoint(context, center.x, center.y);
    
    //箭头终点
    CGPoint end = CGPointMake(center.x, MAX(0, center.y - width));
    CGContextAddLineToPoint(context, end.x, end.y);
    
    //箭头高度
    CGFloat arrowHeight = 5.0;
    
    //画指向上的箭头
    CGContextAddLineToPoint(context, end.x - padding / 2.0, end.y + arrowHeight);
    CGContextMoveToPoint(context, end.x, end.y);
    CGContextAddLineToPoint(context, end.x + padding / 2.0, end.y + arrowHeight);
    
    CGContextStrokePath(context);
}

//绘制关闭按钮
- (void)drawCloseAtRect:(CGRect) rect withContext:(CGContextRef) context
{
    CGFloat width = 10.0;
    
    //绘制斜杠
    CGPoint point = CGPointZero;
    
    switch (self.contentHorizontalAlignment)
    {
        case UIControlContentHorizontalAlignmentLeft :
            point.x = 0;
            break;
        case UIControlContentHorizontalAlignmentRight :
            point.x = rect.size.width - width;
            break;
        default :
            point.x = (rect.size.width - width) / 2.0;
            break;
    }
    
    switch (self.contentVerticalAlignment)
    {
        case UIControlContentVerticalAlignmentTop :
            point.y = 0;
            break;
        case UIControlContentVerticalAlignmentBottom :
            point.y = rect.size.height - width;
        default:
            point.y = (rect.size.height - width) / 2.0;
            break;
    }
    
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x + width, point.y + width);
    
    //绘制反斜杠
    point = CGPointMake(point.x + width, point.y);
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x - width, point.y + width);
    
    //把线条都绘制出来 必须的
    CGContextStrokePath(context);
}

//绘制搜索按钮
- (void)drawSearchAtRect:(CGRect) rect withContext:(CGContextRef) context
{
    CGFloat radius = 6.0;
    
    //斜杆的连接点
    CGPoint point = CGPointMake(rect.size.width / 2.0 + radius / 2.0, rect.size.height / 2.0 + radius / 2.0);
    
    //绘制圆圈
    CGPoint center = CGPointMake(point.x - radius * cos(M_PI_4), point.y - radius * cos(M_PI_4));
    CGContextAddArc(context, center.x, center.y, radius, 0, M_PI * 2, 0);
    
    //绘制斜杆
    CGFloat rot = 7.0;
    CGContextMoveToPoint(context, point.x, point.y);
    CGContextAddLineToPoint(context, point.x + rot * sin(M_PI_4), point.y + rot * sin(M_PI_4));
    
    //把线条都绘制出来 必须的
    CGContextStrokePath(context);
}

@end
