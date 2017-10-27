//
//  UITableViewCell+Utilities.m

//

#import "UITableViewCell+Utilities.h"

@implementation UITableViewCell (Utilities)

/**设置箭头
 */
- (void)setAccessoryWithImage:(UIImage*) image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    self.accessoryView = imageView;
}

/**设置默认箭头
 */
- (void)setDefaultArrow
{
    [self setAccessoryWithImage:[UIImage imageNamed:@"arrow_gray"]];
}

@end
