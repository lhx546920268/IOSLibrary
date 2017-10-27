//
//  UIButton+utilities.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/30.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (utilities)

/**设置按钮的图片位于文本右边
 *@param interval 按钮与标题的间隔
 */
- (void)setButtonIconToRightWithInterval:(CGFloat) interval;

/**设置按钮的图片位于标题上方
 *@param interval 按钮与标题的间隔
 */
- (void)setButtonIconToTopAndTitleBottomWithInterval:(CGFloat) interval;


@end
