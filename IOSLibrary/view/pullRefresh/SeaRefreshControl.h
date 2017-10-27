//
//  SeaRefreshControl.h

//

#import "SeaDataControl.h"

/**下拉刷新圆形动画视图，用户下拉时会根据下拉的程度绘制圆形，且圆形会保留异步空白的弧度，用于旋转动画
 */
@interface SeaRefreshCircle : UIView

/**下拉进度 default is '0', 范围 0 ~ 1.0
 */
@property (nonatomic, assign) float progress;

@end


/**下拉刷新控制视图
 */
@interface SeaRefreshControl : SeaDataControl

/**加载完成的提示信息 default is '刷新成功'
 */
@property(nonatomic,copy) NSString *finishText;

/**刷新控制的状态信息视图
 */
@property(nonatomic,readonly) UILabel *statusLabel;

/**最后的刷新时间
 */
@property(nonatomic,readonly) UILabel *lastUpdatedLabel;


/**保存在 NSUserDefaults 中的最后刷新时间的key值，default is 'SeaRefreshControl_LastRefresh'
 */
@property(nonatomic,copy) NSString *lastUpdateDateKey;

/**下拉进度圆环
 */
@property(nonatomic,readonly) SeaRefreshCircle *circle;

/**刷新logo
 */
@property(nonatomic,readonly) UIImageView *logo;

/**刷新指示器
 */
@property(nonatomic,readonly) UIActivityIndicatorView *indicatorView;

/**是否进行下拉刷新
 */
@property (assign,nonatomic) BOOL isRefresh;

/**更新刷新时间
 */
- (void)refreshLastUpdatedDate;


@end

