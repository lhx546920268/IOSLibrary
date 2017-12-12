//
//  SeaCountDownButton.h
//  Sea
//
//  Created by 罗海雄 on 15/9/14.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import <UIKit/UIKit.h>

/**倒计时按钮, 必须在 dealloc 中调用 stopCodeTimer，否则会造成内存泄露，使用 initWithFrame 初始化
 */
@interface SeaCountDownButton : UIButton

/**正常时 UIControlStateNormal 按钮背景颜色
 */
@property(nonatomic,retain) UIColor *normalBackgroundColor;

/**倒计时结束回调
 */
@property(nonatomic,copy) void(^countDownDidEndHandler)(void);

/**倒计时 UIControlStateDisable 按钮背景颜色
 */
@property(nonatomic,retain) UIColor *disableBackgroundColor;

/**倒计时长 单位秒，default is '60'
 */
@property(nonatomic,assign) int countdownTimeInterval;

/**正常标题
 */
@property(nonatomic,copy) NSString *normalTitle;

/**倒计时时标题
 */
@property(nonatomic,copy) NSString *disableTitle;

/**是否正在计时
 */
@property(nonatomic,readonly) BOOL timing;

/**开始计时
 */
- (void)startTimer;

/**停止计时
 */
- (void)stopTimer;

@end
