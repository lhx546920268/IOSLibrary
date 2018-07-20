//
//  SeaRefreshControl.h

//

#import "SeaDataControl.h"

/**
 下拉刷新圆形动画视图，用户下拉时会根据下拉的程度绘制圆形，且圆形会保留异步空白的弧度，用于旋转动画
 */
@interface SeaRefreshCircle : UIView

/**
 下拉进度 default is '0', 范围 0 ~ 1.0
 */
@property (nonatomic, assign) float progress;

@end

/**
 下拉刷新控制视图
 */
@interface SeaRefreshControl : SeaDataControl

/**
 加载完成的提示信息 default is '刷新成功'
 */
@property(nonatomic,copy) NSString *finishText;

@end

