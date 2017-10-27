//
//  SeaScrollViewCell.m

//

#import "SeaScrollViewCell.h"

@interface SeaScrollViewCell ()

@end

@implementation SeaScrollViewCell

- (void)setEnableGesture:(BOOL)enableGesture
{
    if(_enableGesture != enableGesture)
    {
        _enableGesture = enableGesture;
        self.tapGesture.enabled = _enableGesture;
    }
}

/**添加点击事件
 */
- (void)addTarget:(id) target action:(SEL)action
{
    if(!self.tapGesture)
    {
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
        [self addGestureRecognizer:_tapGesture];
    }
}

/**移除点击事件
 */
- (void)removeTarget:(id) target action:(SEL)action
{
    [self removeGestureRecognizer:self.tapGesture];
    _tapGesture = nil;
}

@end
