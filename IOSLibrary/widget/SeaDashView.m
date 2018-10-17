//
//  UBDashView.m

//

#import "SeaDashView.h"

@implementation SeaDashView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       [self initlization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initlization];
    }
    
    return self;
}

- (void)setIsVertical:(BOOL)isVertical
{
    if(_isVertical != isVertical){
        _isVertical = isVertical;
        [self setNeedsDisplay];
    }
}

- (void)initlization
{
    _lineWidth = 1;
    _shape = SeaDashShapeLine;
    if(!self.dashesColor){
        self.dashesColor = [UIColor grayColor];
    }
    
    if(self.dashesInterval == 0){
        self.dashesInterval = 5.0;
    }
    
    if(self.dashesLength == 0){
        self.dashesLength = 10.0;
    }
    self.backgroundColor = [UIColor clearColor];
}

- (void)setDashesColor:(UIColor *)dashesColor
{
    if(_dashesColor != dashesColor)
    {
        _dashesColor = dashesColor;
        [self setNeedsDisplay];
    }
}

- (void)setDashesInterval:(CGFloat)dashesInterval
{
    if(_dashesInterval != dashesInterval)
    {
        _dashesInterval = dashesInterval;
        [self setNeedsDisplay];
    }
}

- (void)setDashesLength:(CGFloat)dashesLength
{
    if(_dashesLength != dashesLength)
    {
        _dashesLength = dashesLength;
        [self setNeedsDisplay];
    }
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    if(_lineWidth != lineWidth){
        _lineWidth = lineWidth;
        [self setNeedsDisplay];
    }
}

- (void)setCornerRadius:(CGFloat)cornerRadius
{
    if(_cornerRadius != cornerRadius){
        _cornerRadius = cornerRadius;
        if(self.shape != SeaDashShapeLine){
            [self setNeedsDisplay];
        }
    }
}

- (void)setShape:(SeaDashShape)shape
{
    if(_shape != shape){
        _shape = shape;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGFloat lengths[] = {self.dashesLength, self.dashesInterval};
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, self.dashesColor.CGColor);
    CGContextSetLineWidth(context, self.lineWidth);
    
    CGContextSetLineDash(context, 0, lengths, 2);  //画虚线
    switch (_shape) {
        case SeaDashShapeLine : {
            if(_isVertical){
                CGContextMoveToPoint(context, rect.size.width / 2, 0);    //开始画线
                CGContextAddLineToPoint(context, rect.size.width / 2.0, rect.size.height);
            }else{
                CGContextMoveToPoint(context, 0.0, rect.size.height / 2);    //开始画线
                CGContextAddLineToPoint(context, rect.size.width, rect.size.height / 2);
            }
        }
            break;
        case SeaDashShapeRect : {
            CGContextAddPath(context, [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.lineWidth / 2, self.lineWidth / 2, rect.size.width - self.lineWidth, rect.size.height - self.lineWidth) cornerRadius:self.cornerRadius].CGPath);
        }
            break;
    }
    CGContextStrokePath(context);
}

@end
