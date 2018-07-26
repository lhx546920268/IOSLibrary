//
//  SeaDataControl.h

//

#import <UIKit/UIKit.h>

///刷新回调
typedef void(^SeaDataControlHandler)(void);

/**
 UIScrollView 的滚动位置
 */
static NSString *const SeaDataControlOffset = @"contentOffset";

/**
 滑动状态
 */
typedef NS_ENUM(NSInteger, SeaDataControlState)
{
    ///正在滑动
    SeaDataControlPulling = 0,
    
    ///状态正常，用户没有滑动
    SeaDataControlNormal,
    
    ///正在加载
    SeaDataControlLoading,
    
    ///到达临界点
    SeaDataControlReachCirticalPoint,
    
    ///没有数据了
    SeaDataControlStateNoData,
};

/**
 下拉刷新和上拉加载的基类
 */
@interface SeaDataControl : UIView

/**
 关联的 scrollView
 */
@property(nonatomic,readonly,weak) UIScrollView *scrollView;

/**
 触发的临界点 default is 下拉刷新 60，上拉加载 45
 */
@property(assign,nonatomic) CGFloat criticalPoint;

/**
 原来的内容 缩进
 */
@property(nonatomic,assign) UIEdgeInsets originalContentInset;

/**
 刷新回调 子类不需要调用这个
 */
@property(nonatomic,copy) SeaDataControlHandler handler;

/**
 加载延迟 default is '0.25'
 */
@property(nonatomic,assign) NSTimeInterval loadingDelay;

/**
 停止延迟 default is '0.25'
 */
@property(nonatomic,assign) NSTimeInterval stopDelay;

/**
 下拉状态，很少需要主动设置该值
 */
@property(nonatomic,assign) SeaDataControlState state;

/*
 *是否正在动画
 */
@property(nonatomic,assign) BOOL animating;

/**
 是否需要scrollView 停止响应点击事件 当加载中 default is 'NO'
 */
@property(nonatomic,assign) BOOL shouldDisableScrollViewWhenLoading;

/**
 构造方法
 *@param scrollView x
 *@return 一个实例，frame和 scrollView的frame一样
 */
- (id)initWithScrollView:(UIScrollView*) scrollView;

/**
 开始加载
 */
- (void)startLoading NS_REQUIRES_SUPER;

/**
 停止加载 外部调用 默认延迟刷新UI
 */
- (void)stopLoading;

/**
 已经开始加载 默认调用回调
 */
- (void)onStartLoading NS_REQUIRES_SUPER;

/**
 已经停止加载 默认 恢复 insets动画
 */
- (void)onStopLoading NS_REQUIRES_SUPER;

/**
 刷新状态改变 子类可通过这个改变UI
 */
- (void)onStateChange:(SeaDataControlState) state NS_REQUIRES_SUPER;

@end
