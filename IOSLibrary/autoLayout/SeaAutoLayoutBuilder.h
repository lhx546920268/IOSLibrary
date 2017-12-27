//
//  SeaAutoLayoutBuilder.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/15.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///默认约束优先级
static const UILayoutPriority SeaAutoLayoutPriorityDefault = UILayoutPriorityRequired - 1;

/**
 item 可以为 UIView, UILayoutGuide, UIViewController, id<UILayoutSupport>， 比如 UIViewController 中的 topLayoutGuide
 */

///自动布局 构造器
@interface SeaAutoLayoutBuilder : NSObject

#pragma mark- left

/**
 左边距离父视图
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *leftToSuperview;

/**
 左边和某个item左边
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^left)(id item);

/**
 左边和某个item的水平间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^leftToRight)(id item);

/**
 左边父视图中间的水平间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *leftToSuperviewCenterX;

/**
 左边和某个item中间水平间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^leftToCenterX)(id item);

#pragma mark- top

/**
 顶部距离父视图
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *topToSuperview;

/**
 顶部和某个item顶部
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^top)(id item);

/**
 顶部和某个item的垂直间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^topToBottom)(id item);

/**
 顶部父视图中间的垂直间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *topToSuperviewCenterY;

/**
 顶部和某个item中间垂直间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^topToCenterY)(id item);

#pragma mark- right

/**
 右边距离父视图
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *rightToSuperview;

/**
 右边和某个item右边
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^right)(id item);

/**
 右边和某个item的水平间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^rightToLeft)(id item);

/**
 右边父视图中间的水平间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *rightToSuperviewCenterX;

/**
 右边和某个item中间水平间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^rightToCenterX)(id item);

#pragma mark- bottom

/**
 底部距离父视图
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *bottomToSuperview;

/**
 底部和某个item的底部
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^bottom)(id item);

/**
 底部和某个item的垂直距离
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^bottomToTop)(id item);

/**
 底部父视图中间的垂直间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *bottomToSuperviewCenterY;

/**
 底部和某个item中间垂直间距
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^bottomToCenterY)(id item);

#pragma mark- center

/**
 相对于父视图水平居中
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *centerXInSuperview;

/**
 水平居中于某个item
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^centerX)(id item);

/**
 水平居中于某个item的左边
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^centerXToLeft)(id item);

/**
 水平居中于某个item的右边
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^centerXToRight)(id item);

/**
 相对于父视图垂直居中
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *centerYInSuperview;

/**
 垂直居中于某个item
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^centerY)(id item);

/**
 垂直居中于某个item顶部
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^centerYToTop)(id item);

/**
 垂直居中于某个item底部
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^centerYToBottom)(id item);

#pragma mark- width

/**
 设置自身宽度
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^width)(CGFloat width);

/**
 设置宽度等于某个item
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^widthTo)(id item);

#pragma mark- height

/**
 设置自身高度
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^height)(CGFloat height);

/**
 设置高度等于某个item
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^heightTo)(id item);

#pragma mark- ratio

/**
 设置宽高比例 比如 宽是高的2倍 值就为2
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^aspectRatio)(CGFloat ratio);

#pragma mark- relation

/**
 >= = <=
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^relation)(NSLayoutRelation relation);

/**
 等于
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *equal;

/**
 小于或等于
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *lessThanOrEqual;

/**
 大于或等于
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *greaterThanOrEqual;

#pragma mark- constant

/**
 比值，约束为 item1.value = item2.value * multiplier + margin
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^multiplier)(CGFloat multiplier);

/**
 间距 当使用底部和右边约束时，如果要超出父视图，margin使用负数
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^margin)(CGFloat margin);

#pragma mark- priority

/**
 优先级
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^priority)(UILayoutPriority priority);

/**
 UILayoutPriorityRequired 优先级
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *priorityRequired;

/**
 UILayoutPriorityDefaultHigh 优先级
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *priorityHigh;

/**
 UILayoutPriorityDefaultLow 优先级
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *priorityLow;

/**
 构建约束
 */
@property(nonatomic, readonly) NSLayoutConstraint* (^build)(void);

/**
 重置
 */
- (void)reset;

/**
 创建一个构造器 使用单例，会 reset
 
 @param view 要设置约束的view
 @return 构造器
 */
+ (instancetype)builderWithView:(UIView*) view;

@end

