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
- (void)setAccessoryWithImageName:(NSString*) imageName
{
    [self setAccessoryWithImage:[UIImage imageNamed:imageName]];
}

@end
