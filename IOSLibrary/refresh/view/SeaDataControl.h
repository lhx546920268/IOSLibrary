//
//  SeaDataControl.h

//

#import <UIKit/UIKit.h>

///刷新回调
typedef void(^SeaDataControlHandler)(void);

/**UIScrollView 的滚动位置
 */
static NSString *const SeaDataControlOffset = @"contentOffset";

/**滑动状态
 */
typedef NS_ENUM(NSInteger, SeaDataControlState)
{
    SeaDataControlPulling = 0, //正在滑动
    SeaDataControlNormal, //状态正常，用户没有滑动
    SeaDataControlLoading, ///正在加载
    SeaDataControlReachCirticalPoint, ///到达临界点
    SeaDataControlStateNoData, ///没有数据了
};

/**下拉刷新和上拉加载的基类
 */
@interface SeaDataControl : UIView

/**关联的 scrollView
 */
@property(nonatomic,readonly,weak) UIScrollView *scrollView;

/**原来的内容 缩进
 */
@property(nonatomic,assign) UIEdgeInsets originalContentInset;

/**刷新回调
 */
@property(nonatomic,copy) SeaDataControlHandler handler;

/**加载延迟 default is '0.25'
 */
@property(nonatomic,assign) NSTimeInterval refreshDelay;

/**停止延迟 default is '0.25'
 */
@property(nonatomic,assign) NSTimeInterval stopDelay;

/**下拉状态，很少需要主动设置该值
 */
@property(nonatomic,assign) SeaDataControlState state;

/**是否正在动画
 */
@property(nonatomic,assign) BOOL animating;

/**是否需要scrollView 停止响应点击事件 当加载中 default is 'YES'
 */
@property(nonatomic,assign) BOOL shouldDisableScrollViewWhenLoading;

/**构造方法
 *@param scrollView x
 *@return 一个实例，frame和 scrollView的frame一样
 */
- (id)initWithScrollView:(UIScrollView*) scrollView;

/**用于后台主动刷新
 */
- (void)beginRefresh;

/**数据加载完成
 */
- (void)didFinishedLoading;

@end
