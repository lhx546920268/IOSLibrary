//
//  SeaAlertView.h
//  Sea
//
//  Created by 罗海雄 on 15/8/5.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaAlertView;

/**警告框代理
 */
@protocol SeaAlertViewDelegate <NSObject>

/**点击警告框按钮
 *@param buttonIndex 按钮下标
 */
- (void)alertView:(SeaAlertView*) alertView didClickAtIndex:(NSInteger) buttonIndex;

@end

/**警告框
 */
@interface SeaAlertView : UIView

@property(nonatomic,weak) id<SeaAlertViewDelegate> delegate;

/**标题颜色 default is 'blackColor'
 */
@property(nonatomic,strong) UIColor *titleColor;

/**按钮字体
 */
@property(nonatomic, strong) UIFont *butttonFont;

/**按钮字体颜色
 */
@property(nonatomic, strong) UIColor *buttonTextColor;

/**红色按钮下标 default is 'NSNotFound' ，表示没有红色按钮
 */
@property(nonatomic,assign) NSInteger destructiveButtonIndex;

/**点击回调
 */
@property(nonatomic,copy) void(^clickHandler)(NSInteger buttonIndex);

/**设置按钮颜色
 */
- (void)setButtonTitleColor:(UIColor*) color forIndex:(NSInteger) index;

/**按钮字体大小
 */
- (void)setButtontitleFont:(UIFont*)font forIndex:(NSInteger)index;

/**获取点击按钮的标题
 */
- (NSString*)buttonTitleForIndex:(NSInteger) index;

/**构造方法
 *@param title 标题
 *@param otherButtonTitles 按钮标题，数组元素是 NSString
 */
- (id)initWithTitle:(NSString*) title otherButtonTitles:(NSArray*) otherButtonTitles;

/**显示
 */
- (void)show;

/**消失
 */
- (void)dismiss;

@end
