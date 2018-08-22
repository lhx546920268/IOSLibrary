//
//  SeaNetworkActivityView.h

//

#import <UIKit/UIKit.h>

/**
 网络加载指示器
 */
@interface SeaNetworkActivityView : UIView
{
    UIView *_translucentView;
    UIView *_contentView;
    UILabel *_textLabel;
    UIActivityIndicatorView *_activityIndicatorView;
    BOOL _animating;
}

/**
 提示信息
 */
@property(nonatomic,copy) NSString *msg;

/**
 内容视图是否延迟显示 0 不延迟
 */
@property(nonatomic,assign) NSTimeInterval delay;

/**
 内容视图
 */
@property(nonatomic,readonly) UIView *contentView;

/**
 黑色半透明背景视图
 */
@property(nonatomic,readonly) UIView *translucentView;

/**
 提示信息
 */
@property(nonatomic,readonly) UILabel *textLabel;

/**
 加载指示器
 */
@property(nonatomic,readonly) UIActivityIndicatorView *activityIndicatorView;

/**
 是否正在动画
 */
@property(nonatomic,readonly) BOOL animating;

/**
 初始化 子类可自定义自己的实现 可能会调用多次
 */
- (void)initialization;

#pragma mark- animate

/**
 开始动画
 */
- (void)stopAnimating;

/**
 停止动画
 */
- (void)startAnimating;

@end
