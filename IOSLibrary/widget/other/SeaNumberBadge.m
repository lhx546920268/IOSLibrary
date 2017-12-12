//
//  SeaNumberBadge.m

//
//

#import "SeaNumberBadge.h"
#import "SeaBasic.h"

@implementation SeaNumberBadge

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialization];
    }
    
    return self;
}

- (void)initialization
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    
    self.fillColor = [UIColor redColor];
    self.strokeColor = [UIColor clearColor];
    self.textColor = [UIColor whiteColor];
    self.font = [UIFont fontWithName:SeaMainFontName size:13.0];
    self.point = NO;
    self.pointRadius = 5.0;
    self.pointCenter = CGPointMake(self.frame.size.width / 2.0, self.frame.size.height / 2.0);
    self.hiddenWhenZero = YES;
    self.maxNum = 99;
    self.hidden = YES;
}

- (void)dealloc
{
    
}

- (void)drawRect:(CGRect)rect
{
    if(_point)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, self.fillColor.CGColor);
        CGContextAddArc(context, _pointCenter.x, _pointCenter.y, self.pointRadius, 0, 2.0 * M_PI, YES);
        CGContextFillPath(context);
    }
    else
    {
        CGRect viewBounds = self.bounds;
        
        CGContextRef curContext = UIGraphicsGetCurrentContext();
        
        NSString *numberString = self.value;
        
        CGSize numberSize = [numberString stringSizeWithFont:self.font contraintWith:CGFLOAT_MAX];
        
        CGPathRef badgePath = [self newBadgePathForTextSize:numberSize];
        
        CGRect badgeRect = CGPathGetBoundingBox(badgePath);
        
        badgeRect.origin.x = 0;
        badgeRect.origin.y = 0;
        badgeRect.size.width = ceil( badgeRect.size.width );
        badgeRect.size.height = ceil( badgeRect.size.height );
        
        
        CGContextSaveGState( curContext );
        CGContextSetFillColorWithColor( curContext, self.fillColor.CGColor );
        CGContextSetStrokeColorWithColor(curContext, self.strokeColor.CGColor);
        
        CGPoint ctm = CGPointZero;
        ctm = CGPointMake( round((viewBounds.size.width - badgeRect.size.width) / 2.0), round((viewBounds.size.height - badgeRect.size.height) /2.0) );
        
        if(numberString.length >= 3)
        {
            ctm.x -= 3.0;
        }
        
        CGContextTranslateCTM( curContext, ctm.x, ctm.y);
        
        
        CGContextBeginPath( curContext );
        CGContextAddPath( curContext, badgePath );
        CGContextClosePath( curContext );
        CGContextDrawPath( curContext, kCGPathFillStroke );
        
        
        CGContextRestoreGState( curContext );
        CGPathRelease(badgePath);
        
        CGContextSaveGState( curContext );
        CGContextSetFillColorWithColor( curContext, self.textColor.CGColor );
        
        CGPoint textPt = CGPointMake( ctm.x + (badgeRect.size.width - numberSize.width) / 2.0 , ctm.y + (badgeRect.size.height - numberSize.height) / 2.0 );
        

        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:self.font, NSFontAttributeName, self.textColor, NSForegroundColorAttributeName, nil];
        [numberString drawAtPoint:textPt withAttributes:attributes];

        
        
        CGContextRestoreGState( curContext );
    }
}


- (CGPathRef)newBadgePathForTextSize:(CGSize)inSize
{
    CGFloat expand = self.value.length >= 4 ? 0 : 2.0;
    CGFloat arcRadius = ceil((inSize.height + expand) / 2.0);
    
    CGFloat badgeWidthAdjustment = inSize.width - inSize.height / 2.0;
    CGFloat badgeWidth = 2.0 * arcRadius;
    
    if ( badgeWidthAdjustment > 0.0 )
    {
        badgeWidth += badgeWidthAdjustment;
    }
    
    
    CGMutablePathRef badgePath = CGPathCreateMutable();
    
    CGPathMoveToPoint( badgePath, NULL, arcRadius, 0 );
    CGPathAddArc( badgePath, NULL, arcRadius, arcRadius, arcRadius, 3.0 * M_PI_2, M_PI_2, YES);
    CGPathAddLineToPoint( badgePath, NULL, badgeWidth - arcRadius, 2.0 * arcRadius);
    CGPathAddArc( badgePath, NULL, badgeWidth - arcRadius, arcRadius, arcRadius, M_PI_2, 3.0 * M_PI_2, YES);
    CGPathAddLineToPoint( badgePath, NULL, arcRadius, 0 );
    
    return badgePath;
    
}

#pragma mark- private method

- (void)setPoint:(BOOL)point
{
    if(_point != point)
    {
        _point = point;
        [self setNeedsDisplay];
    }
}

- (void)setValue:(NSString *)value
{
    if(_value != value)
    {
        if([NSString isEmpty:value])
            value = @"0";
        
        if([value isNumText])
        {
            NSInteger num = [value integerValue];
            if(num < 0)
                num = 0;
            if(num <= self.maxNum)
            {
                _value = [[NSString stringWithFormat:@"%d", (int)num] copy];
            }
            else
            {
                _value = [[NSString stringWithFormat:@"%d+", self.maxNum] copy];
            }
            self.hidden = self.hiddenWhenZero && num == 0;
        }
        else
        {
            _value = [value copy];
        }
        
        
        [self setNeedsDisplay];
    }
}

@end
