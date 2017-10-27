//
//  SeaActionSheet.h
//  Sea
//
//  Created by 罗海雄 on 15/8/5.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaActionSheet;

/**底部弹窗代理
 */
@protocol SeaActionSheetDelegate <NSObject>

/**点击某个按钮
 *@param index 按钮下标
 */
- (void)actionSheet:(SeaActionSheet*) actionSheet didSelectAtIndex:(NSInteger) index;

@end

/**底部弹窗
 */
@interface SeaActionSheet : UIView

/**主题颜色
 */
@property(nonatomic, strong) UIColor *mainColor;

/**标题字体
 */
@property(nonatomic, strong) UIFont *titleFont;

/**标题字体颜色
 */
@property(nonatomic, strong) UIColor *titleTextColor;

/**按钮字体
 */
@property(nonatomic, strong) UIFont *butttonFont;

/**按钮字体颜色
 */
@property(nonatomic, strong) UIColor *buttonTextColor;

/**警示按钮字体
 */
@property(nonatomic, strong) UIFont *destructiveButtonFont;

/**警示按钮字体颜色
 */
@property(nonatomic, strong) UIColor *destructiveButtonTextColor;

/**取消按钮字体
 */
@property(nonatomic, strong) UIFont *cancelButtonFont;

/**取消按钮字体颜色
 */
@property(nonatomic, strong) UIColor *cancelButtonTextColor;

/**具有警示意义的按钮 下标，default is ’NSNotFound‘，表示没有这个按钮
 */
@property(nonatomic, assign) NSUInteger destructiveButtonIndex;

@property(nonatomic, weak) id<SeaActionSheetDelegate> delegate;

/**构造方法
 *@param title 顶部标题
 *@param delegate 弹窗代理
 *@param cancelButtonTitle 取消按钮标题
 *@param otherButtonTitles 其他按钮标题，数组元素是 NSString
 *@return 一个实例
 */
- (id)initWithTitle:(NSString*) title delegate:(id<SeaActionSheetDelegate>)delegate cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSArray*) otherButtonTitles;

/**显示
 */
- (void)showInView:(UIView*) view;

/**关闭
 */
- (void)dismiss;

@end
