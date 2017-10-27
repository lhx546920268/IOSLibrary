//
//  SeaTextInsetLabel.m

//

#import "SeaTextInsetLabel.h"

@implementation SeaTextInsetLabel

- (void)setInsets:(UIEdgeInsets)insets
{
    if(UIEdgeInsetsEqualToEdgeInsets(insets, _insets))
        return;
    _insets = insets;
    [self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect
{
    CGRect drawRect = UIEdgeInsetsInsetRect(rect, self.insets);
    [super drawTextInRect:drawRect];
}

@end
