//
//  SeaGridPasswordLabel.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**网格视图
 */
@interface SeaGridPasswordLabel : UIView

/**设置字符
 */
@property(nonatomic,strong) NSString *string;

/**初始化
 *@param count 字符数量
 */
- (id)initWithFrame:(CGRect)frame count:(int) count;

@end
