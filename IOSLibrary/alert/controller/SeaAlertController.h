//
//  SeaAlertController.h
//  AKYP
//
//  Created by 罗海雄 on 16/1/25.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///弹窗样式
typedef NS_ENUM(NSInteger, SeaAlertControllerStyle)
{
    ///UIActionSheet 样式
    SeaAlertControllerStyleActionSheet = 0,
    
    ///UIAlertView 样式
    SeaAlertControllerStyleAlert = 1
};

///弹窗按钮样式
@interface SeaAlertAction : NSObject

///是否可以点击 default is 'YES'
@property(nonatomic,assign) BOOL enable;

///字体 如果没有，则使用默认字体 default is 'nil'
@property(nonatomic,strong) UIFont *font;

///字体颜色 如果没有，则使用默认字体颜色 default is 'nil'
@property(nonatomic,strong) UIColor *textColor;

///按钮标题
@property(nonatomic,copy) NSString *title;

/**
 *  构造方法
 *  @param title 按钮标题
 *  @return 一个实例
 */
+ (instancetype)alertActionWithTitle:(NSString*) title;

@end

///弹窗控制器 AlertView 和 ActionSheet的整合
@interface SeaAlertController : UIViewController

///样式
@property(nonatomic,readonly) SeaAlertControllerStyle style;

/**取消按钮字体
 */
@property(nonatomic, strong) UIFont *cancelButtonFont;

/**取消按钮字体颜色
 */
@property(nonatomic, strong) UIColor *cancelButtonTextColor;

/**主题颜色
 */
@property(nonatomic, strong) UIColor *mainColor;

/**标题字体
 */
@property(nonatomic, strong) UIFont *titleFont;

/**标题字体颜色
 */
@property(nonatomic, strong) UIColor *titleTextColor;

///标题对其方式
@property(nonatomic, assign) NSTextAlignment titleTextAlignment;

///信息字体
@property(nonatomic, strong) UIFont *messageFont;

///信息字体颜色
@property(nonatomic, strong) UIColor *messageTextColor;

///信息对其方式
@property(nonatomic, assign) NSTextAlignment messageTextAlignment;

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

/**具有警示意义的按钮 下标，default is ’NSNotFound‘，表示没有这个按钮
 */
@property(nonatomic, assign) NSUInteger destructiveButtonIndex;

///高亮背景
@property(nonatomic, strong) UIColor *highlightedBackgroundColor;

///按钮无法点击时的字体颜色
@property(nonatomic, strong) UIColor *disableButtonTextColor;

///是否关闭弹窗当点击某一个按钮的时候 default is 'YES'
@property(nonatomic, assign) BOOL dismissWhenSelectButton;

///按钮样式，数组元素是 SeaAlertAction，不包含actionSheet 的取消按钮
@property(nonatomic, readonly, copy) NSArray *alertActions;

///点击回调 index 按钮下标 包含取消按钮 actionSheet 从上到下， alert 从左到右
@property(nonatomic,copy) void(^selectionHandler)(NSInteger index);

/**
 *  构造方法
 *  @param title             标题 NSString 或者 NSAttributedString
 *  @param message           信息 NSString 或者 NSAttributedString
 *  @param style             样式
 *  @param cancelButtonTitle 取消按钮 default is ‘取消’
 *  @param otherButtonTitles      按钮，必须是字符串NSString，必须以nil结束，否则会崩溃
 *  @return 一个实例
 */
- (instancetype)initWithTitle:(id) title
                      message:(id) message
                        style:(SeaAlertControllerStyle) style
            cancelButtonTitle:(NSString *) cancelButtonTitle
            otherButtonTitles:(NSString*) otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  显示在window.rootViewController
 */
- (void)show;

/**
 *  可显示在其他视图
 *  @param viewController 要显示的位置
 */
- (void)showInViewController:(UIViewController*) viewController;

/**
 *  关闭弹窗
 */
- (void)close;

///更新某个按钮 不包含actionSheet 的取消按钮
- (void)reloadWithButtonIndex:(NSInteger) buttonIndex;

@end
