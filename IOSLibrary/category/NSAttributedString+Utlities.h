//
//  NSAttributedString+Utlities.h

//
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (Utlities)

/**获取富文本框大小
 *@param width 每行最大宽度
 *@return 富文本框大小
 */
- (CGSize)boundsWithConstraintWidth:(CGFloat) width;

/**获取coreText 富文本文本框大小
 *@param width 文本框宽度限制
 *@return 文本框大小
 */
- (CGSize)coreTextBoundsWithConstraintWidth:(CGFloat) width;

@end
