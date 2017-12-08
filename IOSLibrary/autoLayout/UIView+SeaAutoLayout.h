//
//  UIView+SeaAutoLayout.h
//  Sea
//
//  Created by 罗海雄 on 2017/11/1.
//

#import <UIKit/UIKit.h>

///autoLayout 计算大小方式
typedef NS_ENUM(NSInteger, SeaAutoLayoutCalculateType)
{
    ///计算宽度 需要给定高度
    SeaAutoLayoutCalculateTypeWidth = 0,
    
    ///计算高度 需要给定宽度
    SeaAutoLayoutCalculateTypeHeight = 1,
    
    ///计算大小，可给最大宽度和高度
    SeaAutoLayoutCalculateTypeSize = 2,
};


/**
 自动布局 所有约束都会添加到视图中
 @warning 在使用约束之前必须添加到父视图，所有视图必须具有相同的superview
 */
@interface UIView (SeaAutoLayout)

#pragma mark- center

/**
 相对于父视图居中
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInSuperview;

/**
 相对于父视图居中
 @param constants x,y 轴增量
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInSuperviewWithConstants:(CGPoint) constants;

/**
 相对于某个view居中
 @param view 对应的view
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInView:(UIView*) view;

/**
 相对于父视水平图居中
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInSuperview;

/**
 相对于父视水平图居中
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInSuperviewWithConstant:(CGFloat) constant;

/**
 相对于某个view水平居中
 @param view 对应的view
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInView:(UIView*) view;

/**
 相对于某个view居中
 @param view 对应的view
 @param constants x,y 轴增量
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInView:(UIView*) view constants:(CGPoint) constants;

/**
 相对于某个view水平居中
 @param view 对应的view
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInView:(UIView*) view constant:(CGFloat) constant;

/**
 相对于父视图垂直居中
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInSuperviewWithConstant:(CGFloat) constant;

/**
 相对于父视图垂直居中
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInSuperview;

/**
 相对于某个view垂直居中
 @param view 对应的view
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInView:(UIView *)view;

/**
 相对于某个view垂直居中
 @param view 对应的view
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInView:(UIView*) view constant:(CGFloat) constant;

#pragma mark- insets

/**
 设置在父视图中的 上左下右约束
 @param insets 上左下右约束值
 @return 生成的约束，约束index与 insets对应，即 top，left, bottom, right 约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_insetsInSuperview:(UIEdgeInsets) insets;

/**
 设置在某个视图中的 上左下右约束
 @param insets 上左下右约束值
 @param view 对应的视图
 @return 生成的约束，约束index与 insets对应，即 top，left, bottom, right 约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_insets:(UIEdgeInsets) insets inView:(UIView*) view;

#pragma mark- top

/**
 设置与父视图的top一样
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToSuperview;

/**
 设置与父视图top的间距
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToSuperview:(CGFloat) margin;

/**
 设置与某个视图的top一样
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToView:(UIView*) view;

/**
 设置与某个视图的top一样
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToView:(UIView*) view margin:(CGFloat) margin;

/**
 设置与某个视图的top一样
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToView:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个视图下面，即两个视图间的垂直距离为0
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToViewBottom:(UIView*) view;

/**
 设置上面距离某个视图下面的约束，即两个视图间的垂直距离
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToViewBottom:(UIView*) view margin:(CGFloat) margin;

/**
 设置上面距离某个视图下面的约束，即两个视图间的垂直距离
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToViewBottom:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

#pragma mark- left

/**
 设置与父视图的left一样
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToSuperview;

/**
 设置与父视图left的间距
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToSuperview:(CGFloat) margin;

/**
 设置与某个视图的left一样
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToView:(UIView*) view;

/**
 设置与某个视图的left一样
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToView:(UIView*) view margin:(CGFloat) margin;

/**
 设置与某个视图的left一样
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToView:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个视图右边，即两个视图间的水平距离为0
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToViewRight:(UIView*) view;

/**
 设置左边距离某个视图右边的约束，即两个视图间的水平距离
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToViewRight:(UIView*) view margin:(CGFloat) margin;

/**
 设置左边距离某个视图右边的约束，即两个视图间的水平距离
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToViewRight:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

#pragma mark- bottom

/**
 设置与父视图的bottom一样
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToSuperview;

/**
 设置与父视图bottom的间距
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToSuperview:(CGFloat) margin;

/**
 设置与某个视图的bottom一样
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToView:(UIView*) view;

/**
 设置与某个视图的bottom一样
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToView:(UIView*) view margin:(CGFloat) margin;

/**
 设置与某个视图的bottom一样
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToView:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个视图上面，即两个视图间的垂直距离为0
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToViewTop:(UIView*) view;

/**
 设置下面距离某个视图上面的约束，即两个视图间的垂直距离
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToViewTop:(UIView*) view margin:(CGFloat) margin;

/**
 设置下面距离某个视图上面的约束，即两个视图间的垂直距离
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToViewTop:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

#pragma mark- right

/**
 设置与父视图的right一样
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToSuperview;

/**
 设置与父视图right的间距
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToSuperview:(CGFloat) margin;

/**
 设置与某个视图的right一样
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToView:(UIView*) view;

/**
 设置与某个视图的right一样
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToView:(UIView*) view margin:(CGFloat) margin;

/**
 设置与某个视图的right一样
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToView:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个视图左边，即两个视图间的水平距离为0
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToViewLeft:(UIView*) view;

/**
 设置右边距离某个视图左边的约束，即两个视图间的水平距离
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToViewLeft:(UIView*) view margin:(CGFloat) margin;

/**
 设置右边距离某个视图左边的约束，即两个视图间的水平距离
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToViewLeft:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

#pragma mark- size

/**
 设置约束大小
 @param size 大小
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_sizeToSelf:(CGSize) size;

/**
 设置相宽度约束
 @param width 宽度
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToSelf:(CGFloat) width;

/**
 设置高度约束
 @param height 高度
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToSelf:(CGFloat) height;

/**
 设置宽度约束等于某个视图
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToView:(UIView*) view;

/**
 设置高度约束等于某个视图
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToView:(UIView*) view;

/**
 设置相对于某个视图的宽度约束
 @param view 对应的视图
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToView:(UIView*) view constant:(CGFloat) constant;

/**
 设置相对于某个视图的高度约束
 @param view 对应的视图
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToView:(UIView*) view constant:(CGFloat) constant;

/**
 设置相对于某个视图的宽度约束
 @param view 对应的视图
 @param multiplier 比值
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToView:(UIView*) view multiplier:(CGFloat) multiplier;

/**
 设置相对于某个视图的高度约束
 @param view 对应的视图
 @param multiplier 比值
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToView:(UIView*) view multiplier:(CGFloat) multiplier;

/**
 设置相对于某个视图的宽度约束
 @param view 对应的视图
 @param multiplier 比值
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToView:(UIView*) view multiplier:(CGFloat) multiplier constant:(CGFloat) constant;

/**
 设置相对于某个视图的高度约束
 @param view 对应的视图
 @param multiplier 比值
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToView:(UIView*) view multiplier:(CGFloat) multiplier constant:(CGFloat) constant;

/**
 设置宽高比例
 @param ratio 比例值  比如 宽是高的2倍 值就为2
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_aspectRatio:(CGFloat) ratio;

#pragma mark- 获取约束 constraint

/**
 清空约束
 */
- (void)sea_removeAllContraints;

/**
 @warning 根据 item1.attribute1 = multiplier × item2.attribute2 + constant
 以下约束只根据 item1 和 attribute1 来获取
 */

/**
 获取高度约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_heightLayoutConstraint;

/**
 获取宽度约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_widthLayoutConstraint;

/**
 获取左边距约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_leftLayoutConstraint;

/**
 获取右边距约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_rightLayoutConstraint;

/**
 获取顶部距约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_topLayoutConstraint;

/**
 获取底部距约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_bottomLayoutConstraint;

/**
 获取水平居中约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_centerXLayoutConstraint;

/**
 获取垂直居中约束 返回当前优先级最高的
 */
@property (nonatomic,readonly) NSLayoutConstraint *sea_centerYLayoutConstraint;

#pragma mark- AutoLayout 计算大小

/**根据给定的 size 计算当前view的大小，要使用auto layout
 *@param fitsSize 大小范围 0 则不限制范围
 *@param type 计算方式
 *@return view 大小
 */
- (CGSize)sea_sizeThatFits:(CGSize) fitsSize type:(SeaAutoLayoutCalculateType) type;

@end
