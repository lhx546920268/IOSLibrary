//
//  NSAttributedString+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/27.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (Utils)

/**获取富文本框大小
 *@param width 每行最大宽度
 *@return 富文本框大小
 */
- (CGSize)sea_boundsWithConstraintWidth:(CGFloat) width;

/**获取coreText 富文本文本框大小
 *@param width 文本框宽度限制
 *@return 文本框大小
 */
- (CGSize)sea_coreTextBoundsWithConstraintWidth:(CGFloat) width;


@end
