//
//  SeaAlertController.h
//  AKYP
//
//  Created by 罗海雄 on 16/1/25.
//  Copyright (c) 2016年 罗海雄. All rights reserved.
//

#import "UIViewController+Dialog.h"
#import "SeaViewController.h"

///弹窗样式
typedef NS_ENUM(NSUInteger, SeaAlertControllerStyle)
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

///图标
@property(nonatomic,strong) UIImage *icon;

///图片和标题的间隔 default is '5.0'
@property(nonatomic,assign) CGFloat spacing;

/**
 构造方法
 @param title 按钮标题
 @return 一个实例
 */
+ (instancetype)alertActionWithTitle:(NSString*) title;

/**
 构造方法
 @param title 按钮标题
 @param icon 按钮图标
 @return 一个实例
 */
+ (instancetype)alertActionWithTitle:(NSString*) title icon:(UIImage*) icon;

@end

/**
 弹窗样式
 */
@interface SeaAlertStyle : NSObject<NSCopying>

/**
 整个内容边距
 */
@property(nonatomic,assign) UIEdgeInsets contentInsets;

/**
 圆角
 */
@property(nonatomic,assign) CGFloat cornerRadius;

/**
 文字和图标和父视图的间距
 */
@property(nonatomic,assign) UIEdgeInsets textInsets;

/**
 内容垂直间距
 */
@property(nonatomic,assign) CGFloat verticalSpacing;

/**
 actionSheet 取消按钮和 内容视图的间距
 */
@property(nonatomic,assign) CGFloat cancelButtonVerticalSpacing;

/**
 actionSheet 取消按钮和 内容视图的背景颜色
 */
@property(nonatomic, strong) UIColor *spacingBackgroundColor;

/**
 取消按钮字体
 */
@property(nonatomic, strong) UIFont *cancelButtonFont;

/**
 取消按钮字体颜色
 */
@property(nonatomic, strong) UIColor *cancelButtonTextColor;

/**
 主题颜色
 */
@property(nonatomic, strong) UIColor *mainColor;

/**
 标题字体
 */
@property(nonatomic, strong) UIFont *titleFont;

/**
 标题字体颜色
 */
@property(nonatomic, strong) UIColor *titleTextColor;

/**
 标题对其方式
 */
@property(nonatomic, assign) NSTextAlignment titleTextAlignment;

/**
 信息字体
 */
@property(nonatomic, strong) UIFont *messageFont;

/**
 信息字体颜色
 */
@property(nonatomic, strong) UIColor *messageTextColor;

/**
 信息对其方式
 */
@property(nonatomic, assign) NSTextAlignment messageTextAlignment;

/**
 按钮高度 alert 45 actionSheet 50
 */
@property(nonatomic, assign) CGFloat buttonHeight;

/**
 按钮字体
 */
@property(nonatomic, strong) UIFont *butttonFont;

/**
 按钮字体颜色
 */
@property(nonatomic, strong) UIColor *buttonTextColor;

/**
 警示按钮字体
 */
@property(nonatomic, strong) UIFont *destructiveButtonFont;

/**
 警示按钮字体颜色
 */
@property(nonatomic, strong) UIColor *destructiveButtonTextColor;

/**
 警示按钮背景颜色
 */
@property(nonatomic, strong) UIColor *destructiveButtonBackgroundColor;

/**
 高亮背景
 */
@property(nonatomic, strong) UIColor *highlightedBackgroundColor;

/**
 按钮无法点击时的字体颜色
 */
@property(nonatomic, strong) UIColor *disableButtonTextColor;

/**
 alert 单例
 */
+ (instancetype)alertInstance;

/**
 actionSheet 单例
 */
+ (instancetype)actionSheetInstance;

@end

/**
 弹窗控制器 AlertView 和 ActionSheet的整合
 @warning 在显示show前设置好属性
 */
@interface SeaAlertController : SeaViewController

/**
 样式
 */
@property(nonatomic, readonly) SeaAlertControllerStyle style;

/**
 弹窗样式 默认使用单例
 */
@property(nonatomic, strong) SeaAlertStyle *alertStyle;

/**
 具有警示意义的按钮 下标，default is ’NSNotFound‘，表示没有这个按钮
 */
@property(nonatomic, assign) NSUInteger destructiveButtonIndex;

/**
 是否关闭弹窗当点击某一个按钮的时候 default is 'YES'
 */
@property(nonatomic, assign) BOOL dismissWhenSelectButton;

/**
 按钮 不包含actionSheet 的取消按钮
 */
@property(nonatomic, readonly, copy) NSArray<SeaAlertAction*> *alertActions;

/**
 点击回调 index 按钮下标 包含取消按钮 actionSheet 从上到下， alert 从左到右
 */
@property(nonatomic,copy) void(^selectionHandler)(NSUInteger index);

+ (instancetype)alertWithTitle:(id) title message:(id) message cancelButtonTitle:(NSString*) cancelButtonTitle otherButtonTitles:(NSArray<NSString*>*) otherButtonTitles;

+ (instancetype)actionSheetWithTitle:(id) title message:(id) message otherButtonTitles:(NSArray<NSString*>*) otherButtonTitles;

/**
 实例化一个弹窗
 @param title 标题 NSString 或者 NSAttributedString
 @param message 信息 NSString 或者 NSAttributedString
 @param icon 图标
 @param style 样式
 @param cancelButtonTitle 取消按钮 default is ‘取消’
 @param otherButtonTitles 按钮
 @return 一个实例
 */
- (instancetype)initWithTitle:(id) title
                      message:(id) message
                         icon:(UIImage*) icon
                        style:(SeaAlertControllerStyle) style
            cancelButtonTitle:(NSString *) cancelButtonTitle
            otherButtonTitles:(NSArray<NSString*>*) otherButtonTitles;

/**
 实例化一个弹窗
 @param title 标题 NSString 或者 NSAttributedString
 @param message 信息 NSString 或者 NSAttributedString
 @param icon 图标
 @param style 样式
 @param cancelButtonTitle 取消按钮 default is ‘取消’
 @param actions 按钮
 @return 一个实例
 */
- (instancetype)initWithTitle:(id) title
                      message:(id) message
                         icon:(UIImage*) icon
                        style:(SeaAlertControllerStyle) style
            cancelButtonTitle:(NSString *) cancelButtonTitle
            otherButtonActions:(NSArray<SeaAlertAction*>*) actions;

/**
 更新某个按钮 不包含actionSheet 的取消按钮
 */
- (void)reloadButtonForIndex:(NSUInteger) index;

/**
 通过下标回去按钮标题
 */
- (NSString*)buttonTitleForIndex:(NSUInteger) index;

/**
 显示弹窗
 */
- (void)show;

/**
 隐藏弹窗
 */
- (void)dismiss;

@end
