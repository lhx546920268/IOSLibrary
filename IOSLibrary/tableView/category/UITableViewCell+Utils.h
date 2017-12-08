//
//  UITableViewCell+Utils.h

//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Utils)

/**设置箭头
 */
- (void)setAccessoryWithImage:(UIImage*) image;

/**设置默认箭头
 */
- (void)setAccessoryWithImageName:(NSString*) imageName;

@end
