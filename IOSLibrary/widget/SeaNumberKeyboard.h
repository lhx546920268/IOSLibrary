//
//  SeaNumberKeyboard.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/23.
//  Copyright (c) 2015年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///数字键盘
@interface SeaNumberKeyboard : UIView

///关联的textField
@property(nonatomic,weak) UITextField *textField;

///字符输入限制 default is 'NSNotFound' 无限制
@property(nonatomic,assign) NSInteger inpuLimitMax;


/**初始化方法，必须通过该方法初始化
 *@param otherButtonTittle 左下角按钮标题
 *@return 已设置好frame 的实例
 */
- (instancetype)initWithotherButtonTittle:(NSString*) otherButtonTittle;

@end
