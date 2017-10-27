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

- (void)initlization
{
    self.dashesColor = [UIColor grayColor];
    self.dashesInterval = 5.0;
    self.dashesLength = 10.0;
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


- (void)drawRect:(CGRect)rect
{
    CGFloat lengths[] = {self.dashesLength,self.dashesInterval};
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, self.dashesColor.CGColor);
    
    CGContextSetLineDash(line, 0, lengths, 2);  //画虚线
    CGContextMoveToPoint(line, 0.0, self.frame.size.height / 2);    //开始画线
    CGContextAddLineToPoint(line, self.frame.size.width, self.frame.size.height / 2);
    CGContextStrokePath(line);
}

@end
