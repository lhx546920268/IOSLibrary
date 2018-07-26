//
//  SeaToast.h

//

#import <UIKit/UIKit.h>

///提示框位置
typedef NS_ENUM(NSInteger, SeaToastGravity){
    
    ///上
    SeaToastGravityTop = 0,
    
    ///下
    SeaToastGravityBottom,
    
    ///垂直居中
    SeaToastGravityVertical,
};

///通用的提示框样式 默认使用单例
@interface SeaToastStyle : NSObject

/**
 显示持续时间 default is '1.5'
 */
@property(nonatomic,assign) NSTimeInterval duration;

/**
 距离父视图的边距 default is (30, 30, 30, 30)
 */
@property(nonatomic,assign) UIEdgeInsets superEdgeInsets;

/**
 内容边距 default is (20, 20, 20, 20)
 */
@property(nonatomic,assign) UIEdgeInsets contentEdgeInsets;

/**
 位置 default is 'SeaToastGravityVertical'
 */
@property(nonatomic,assign) SeaToastGravity gravity;

/**
 偏移量 default is '0'
 */
@property(nonatomic,assign) CGFloat offset;

/**
 图标和文字的间距 default is '5'
 */
@property(nonatomic,assign) CGFloat verticalSpace;

/**
 最小大小 default is (80, 20)
 */
@property(nonatomic,assign) CGSize minimumSize;

/**
 字体
 */
@property(nonatomic, strong) UIFont *font;

/**
 文字颜色
 */
@property(nonatomic, strong) UIColor *textColor;

/**
 背景颜色
 */
@property(nonatomic, strong) UIColor *backgroundColor;

/**
 单例
 */
+ (instancetype)sharedInstance;

@end

/**
 信息提示框
 */
@interface SeaToast : UIView

/**
 样式 默认使用单例
 */
@property(nonatomic, strong) SeaToastStyle *style;

/**
 设置文字信息
 */
@property(nonatomic,copy) NSString *text;

/**
 设置图标
 */
@property(nonatomic,strong) UIImage *icon;

/**
 是否需要移除父视图 当提示框消失后 default is 'YES'
 */
@property(nonatomic,assign) BOOL shouldRemoveOnDismiss;

/**
 提示隐藏回调
 */
@property(nonatomic,copy) void(^dismissHanlder)(void);

/**
 显示
 */
- (void)show;

/**
 隐藏
 */
- (void)dismiss;

@end
