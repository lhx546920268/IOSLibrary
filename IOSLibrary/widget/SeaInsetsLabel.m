//
//  SeaTextInsetLabel.m

//

#import "SeaInsetsLabel.h"

@implementation SeaInsetsLabel

- (void)setPaddingTop:(CGFloat)paddingTop
{
    if(_paddingTop != paddingTop){
        _paddingTop = paddingTop;
        [self setNeedsDisplay];
    }
}

- (void)setPaddingLeft:(CGFloat)paddingLeft
{
    if(_paddingLeft != paddingLeft){
        _paddingLeft = paddingLeft;
        [self setNeedsDisplay];
    }
}

- (void)setPaddingRight:(CGFloat)paddingRight
{
    if(_paddingRight != paddingRight){
        _paddingRight = paddingRight;
        [self setNeedsDisplay];
    }
}

- (void)setPaddingBottom:(CGFloat)paddingBottom
{
    if(_paddingBottom != paddingBottom){
        _paddingBottom = paddingBottom;
        [self setNeedsDisplay];
    }
}

- (CGSize)intrinsicContentSize
{
    CGSize size = [super intrinsicContentSize];
    size.width += _paddingLeft + _paddingRight;
    size.height += _paddingTop + _paddingBottom;
    
    return size;
}

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = UIEdgeInsetsMake(_paddingTop, _paddingLeft, _paddingBottom, _paddingRight);
    CGRect drawRect = UIEdgeInsetsInsetRect(rect, insets);
    [super drawTextInRect:drawRect];
}

@end
