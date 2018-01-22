//
//  UIView+SeaAutoLayout.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/11/1.
//

#import <UIKit/UIKit.h>
#import "SeaAutoLayoutBuilder.h"

/**
 item 可以为 UIView, UILayoutGuide, UIViewController, id<UILayoutSupport>， 比如 UIViewController 中的 topLayoutGuide
 */

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
 @param offset x,y 轴增量
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInSuperviewWithOffset:(CGPoint) offset;

/**
 相对于某个item居中
 @param item 对应的item
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInItem:(id) item;

/**
 相对于父视水平图居中
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInSuperview;

/**
 相对于父视水平图居中
 @param offset 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInSuperviewWithOffset:(CGFloat) offset;

/**
 相对于某个item水平居中
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInItem:(id) item;

/**
 相对于某个item居中
 @param item 对应的item
 @param offset x,y 轴增量
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInItem:(id) item offset:(CGPoint) offset;

/**
 相对于某个item水平居中
 @param item 对应的item
 @param offset 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInItem:(id) item offset:(CGFloat) offset;

/**
 相对于父视图垂直居中
 @param offset 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInSuperviewWithOffset:(CGFloat) offset;

/**
 相对于父视图垂直居中
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInSuperview;

/**
 相对于某个item垂直居中
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInItem:(id)item;

/**
 相对于某个item垂直居中
 @param item 对应的item
 @param offset 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInItem:(id) item offset:(CGFloat) offset;

/**
 相对于某个item的左边水平居中
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInItemLeft:(id) item;

/**
 相对于某个item的右边水平居中
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInItemRight:(id) item;

/**
 相对于某个item的顶部垂直居中
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInItemTop:(id) item;

/**
 相对于某个item的底部垂直居中
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInItemBottom:(id) item;

#pragma mark- insets

/**
 设置在父视图中的 上左下右约束
 @param insets 上左下右约束值
 @return 生成的约束，约束index与 insets对应，即 top，left, bottom, right 约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_insetsInSuperview:(UIEdgeInsets) insets;

/**
 设置在某个item中的 上左下右约束
 @param insets 上左下右约束值
 @param item 对应的item
 @return 生成的约束，约束index与 insets对应，即 top，left, bottom, right 约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_insets:(UIEdgeInsets) insets inItem:(id) item;

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
 设置与某个item的top一样
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItem:(id) item;

/**
 设置与某个item的top一样
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItem:(id) item margin:(CGFloat) margin;

/**
 设置与某个item的top一样
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个item下面，即两个item间的垂直距离为0
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItemBottom:(id) item;

/**
 设置上面距离某个item下面的约束，即两个item间的垂直距离
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItemBottom:(id) item margin:(CGFloat) margin;

/**
 设置上面距离某个item下面的约束，即两个item间的垂直距离
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItemBottom:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个item中间位置的下面
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItemCenterY:(id) item;

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
 设置与某个item的left一样
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItem:(id) item;

/**
 设置与某个item的left一样
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItem:(id) item margin:(CGFloat) margin;

/**
 设置与某个item的left一样
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个item右边，即两个item间的水平距离为0
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItemRight:(id) item;

/**
 设置左边距离某个item右边的约束，即两个item间的水平距离
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItemRight:(id) item margin:(CGFloat) margin;

/**
 设置左边距离某个item右边的约束，即两个item间的水平距离
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItemRight:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个item中间位置的右边
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItemCenterX:(id) item;

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
 设置与某个item的bottom一样
 @param item 对应的 item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItem:(id) item;

/**
 设置与某个item的bottom一样
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItem:(id) item margin:(CGFloat) margin;

/**
 设置与某个item的bottom一样
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个item上面，即两个item间的垂直距离为0
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItemTop:(id) item;

/**
 设置下面距离某个item上面的约束，即两个item间的垂直距离
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItemTop:(id) item margin:(CGFloat) margin;

/**
 设置下面距离某个item上面的约束，即两个item间的垂直距离
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItemTop:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个item中间位置的上面
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItemCenterY:(id) item;

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
 设置与某个item的right一样
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItem:(id) item;

/**
 设置与某个item的right一样
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItem:(id) item margin:(CGFloat) margin;

/**
 设置与某个item的right一样
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个item左边，即两个item间的水平距离为0
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItemLeft:(id) item;

/**
 设置右边距离某个item左边的约束，即两个item间的水平距离
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItemLeft:(id) item margin:(CGFloat) margin;

/**
 设置右边距离某个item左边的约束，即两个item间的水平距离
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItemLeft:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation;

/**
 设置在某个item中间位置的左边
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItemCenterX:(id) item;

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
 设置宽度约束等于某个item
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToItem:(id) item;

/**
 设置高度约束等于某个item
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToItem:(id) item;

/**
 设置相对于某个item的宽度约束
 @param item 对应的item
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToItem:(id) item constant:(CGFloat) constant;

/**
 设置相对于某个item的高度约束
 @param item 对应的item
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToItem:(id) item constant:(CGFloat) constant;

/**
 设置相对于某个item的宽度约束
 @param item 对应的item
 @param multiplier 比值
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToItem:(id) item multiplier:(CGFloat) multiplier;

/**
 设置相对于某个item的高度约束
 @param item 对应的item
 @param multiplier 比值
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToItem:(id) item multiplier:(CGFloat) multiplier;

/**
 设置相对于某个item的宽度约束
 @param item 对应的item
 @param multiplier 比值
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToItem:(id) item multiplier:(CGFloat) multiplier constant:(CGFloat) constant;

/**
 设置相对于某个item的高度约束
 @param item 对应的item
 @param multiplier 比值
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToItem:(id) item multiplier:(CGFloat) multiplier constant:(CGFloat) constant;

/**
 设置宽高比例
 @param ratio 比例值  比如 宽是高的2倍 值就为2
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_aspectRatio:(CGFloat) ratio;

#pragma mark- AutoLayout Builder

/**
 自动布局 构造器
 */
@property(nonatomic, readonly) SeaAutoLayoutBuilder *sea_alb;

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

