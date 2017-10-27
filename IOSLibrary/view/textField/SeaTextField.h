//
//  SeaTextField.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/9.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///输入补全位置
typedef NS_ENUM(NSInteger, SeaTextFieldRepairPosition)
{
    ///前面
    SeaTextFieldRepairPositionFront = 0,
    
    ///后面
    SeaTextFieldRepairPositionBack = 1,
};

/**自定义单行输入框
 */
@interface SeaTextField : UITextField

///输入补全字符串 default is 'nil'
@property(nonatomic,copy) NSString *repairString;

///补全位置 default is 'SeaTextFieldRepairPositionFront'
@property(nonatomic,assign) SeaTextFieldRepairPosition repairPosition;

@end
