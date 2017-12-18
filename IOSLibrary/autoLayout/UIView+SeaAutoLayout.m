//
//  UIView+SeaAutoLayout.m
//  Sea
//
//  Created by 罗海雄 on 2017/11/1.
//

#import "UIView+SeaAutoLayout.h"

@implementation UIView (SeaAutoLayout)

#pragma mark- center

/**
 相对于父视图居中
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInSuperview
{
    return [self sea_centerInItem:self.superview];
}

/**
 相对于父视图居中
 @param offset x,y 轴增量
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInSuperviewWithOffset:(CGPoint) offset
{
    return [self sea_centerInItem:self.superview offset:offset];
}

/**
 相对于某个view居中
 @param item 对应的item
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInItem:(id) item
{
    return [self sea_centerInItem:item offset:CGPointZero];
}

/**
 相对于某个view居中
 @param item 对应的item
 @param offset x,y 轴增量
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInItem:(id) item offset:(CGPoint) offset
{
    return @[[self sea_centerXInItem:item offset:offset.x], [self sea_centerYInItem:item offset:offset.y]];
}

/**
 相对于父视水平图居中
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInSuperview
{
    return [self sea_centerXInItem:self.superview];
}

/**
 相对于父视水平图居中
 @param offset 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInSuperviewWithOffset:(CGFloat) offset
{
    return [self sea_centerXInItem:self.superview offset:offset];
}

/**
 相对于某个view水平居中
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInItem:(id) item
{
    return [self sea_centerXInItem:item offset:0];
}

/**
 相对于某个view水平居中
 @param item 对应的item
 @param offset 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInItem:(id) item offset:(CGFloat) offset
{
    return self.sea_autoLayoutBuilder.centerX(item).margin(offset).build;
}


/**
 相对于父视图垂直居中
 @param offset 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInSuperviewWithOffset:(CGFloat) offset
{
    return [self sea_centerYInItem:self.superview offset:offset];
}

/**
 相对于父视图垂直居中
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInSuperview
{
    return [self sea_centerYInSuperviewWithOffset:0];
}

/**
 相对于某个view垂直居中
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInItem:(id) item
{
    return [self sea_centerYInItem:item offset:0];
}

/**
 相对于某个view垂直居中
 @param item 对应的item
 @param offset 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInItem:(id) item offset:(CGFloat) offset
{
    return self.sea_autoLayoutBuilder.centerY(item).margin(offset).build;
}

#pragma mark- insets

/**
 设置在父视图中的 上左下右约束
 @param insets 上左下右约束值
 @return 生成的约束，约束index与 insets对应，即 top，left, bottom, right 约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_insetsInSuperview:(UIEdgeInsets) insets
{
    return [self sea_insets:insets inItem:self.superview];
}

/**
 设置在某个item中的 上左下右约束
 @param insets 上左下右约束值
 @param item 对应的item
 @return 生成的约束，约束index与 insets对应，即 top，left, bottom, right 约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_insets:(UIEdgeInsets) insets inItem:(id) item
{
    NSLayoutConstraint *topConstraint = [self sea_topToItem:item margin:insets.top];
    NSLayoutConstraint *leftConstraint = [self sea_leftToItem:item margin:insets.left];
    NSLayoutConstraint *bottomConstraint = [self sea_bottomToItem:item margin:insets.bottom];
    NSLayoutConstraint *rightConstraint = [self sea_rightToItem:item margin:insets.right];
    
    return @[topConstraint, leftConstraint, bottomConstraint, rightConstraint];
}

#pragma mark- top

/**
 设置与父视图的top一样
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToSuperview
{
    return [self sea_topToSuperview:0];
}

/**
 设置与父视图top的间距
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToSuperview:(CGFloat) margin
{
    return [self sea_topToItem:self.superview margin:margin];
}

/**
 设置与某个item的top一样
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItem:(id) item
{
    return [self sea_topToItem:item margin:0];
}

/**
 设置与某个item的top一样
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItem:(id) item margin:(CGFloat) margin
{
    return [self sea_topToItem:item margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置与某个item的top一样
 @param item 对应的item
 @param margin 间距
 @paran relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_autoLayoutBuilder.top(item).margin(margin).relation(relation).build;
}

/**
 设置在某个item下面，即两个视图间的垂直距离为0
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItemBottom:(id) item
{
    return [self sea_topToItemBottom:item margin:0];
}

/**
 设置上面距离某个item下面的约束，即两个视图间的垂直距离
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItemBottom:(id) item margin:(CGFloat) margin
{
    return [self sea_topToItemBottom:item margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置上面距离某个item下面的约束，即两个视图间的垂直距离
 @param item 对应的item
 @param margin 间距
 @paran relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToItemBottom:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_autoLayoutBuilder.topToBottom(item).margin(margin).relation(relation).build;
}

#pragma mark- left

/**
 设置与父视图的left一样
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToSuperview
{
    return [self sea_leftToSuperview:0];
}

/**
 设置与父视图left的间距
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToSuperview:(CGFloat) margin
{
    return [self sea_leftToItem:self.superview margin:margin];
}

/**
 设置与某个item的left一样
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItem:(id) item
{
    return [self sea_leftToItem:item margin:0];
}

/**
 设置与某个item的left一样
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItem:(id) item margin:(CGFloat) margin
{
    return [self sea_leftToItem:item margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置与某个item的left一样
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_autoLayoutBuilder.left(item).margin(margin).relation(relation).build;
}

/**
 设置在某个item右边，即两个视图间的水平距离为0
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItemRight:(id) item
{
    return [self sea_leftToItemRight:item margin:0];
}

/**
 设置左边距离某个item右边的约束，即两个视图间的水平距离
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItemRight:(id) item margin:(CGFloat) margin
{
    return [self sea_leftToItemRight:item margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置左边距离某个item右边的约束，即两个视图间的水平距离
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToItemRight:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_autoLayoutBuilder.leftToRight(item).margin(margin).relation(relation).build;
}

#pragma mark- bottom

/**
 设置与父视图的bottom一样
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToSuperview
{
    return [self sea_bottomToSuperview:0];
}

/**
 设置与父视图bottom的间距
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToSuperview:(CGFloat) margin
{
    return [self sea_bottomToItem:self.superview margin:margin];
}

/**
 设置与某个item的bottom一样
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItem:(id) item
{
    return [self sea_bottomToItem:item margin:0];
}

/**
 设置与某个item的bottom一样
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItem:(id) item margin:(CGFloat) margin
{
    return [self sea_bottomToItem:item margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置与某个item的bottom一样
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_autoLayoutBuilder.bottom(item).margin(margin).relation(relation).build;
}

/**
 设置在某个item上面，即两个视图间的垂直距离为0
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItemTop:(id) item
{
    return [self sea_bottomToItemTop:item margin:0];
}

/**
 设置下面距离某个item上面的约束，即两个视图间的垂直距离
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItemTop:(id) item margin:(CGFloat) margin
{
    return [self sea_bottomToItemTop:item margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置下面距离某个item上面的约束，即两个视图间的垂直距离
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToItemTop:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_autoLayoutBuilder.bottomToTop(item).margin(margin).relation(relation).build;
}

#pragma mark- right

/**
 设置与父视图的right一样
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToSuperview
{
    return [self sea_rightToSuperview:0];
}

/**
 设置与父视图right的间距
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToSuperview:(CGFloat) margin
{
    return [self sea_rightToItem:self.superview margin:margin];
}

/**
 设置与某个item的right一样
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItem:(id) item
{
    return [self sea_rightToItem:item margin:0];
}

/**
 设置与某个item的right一样
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItem:(id) item margin:(CGFloat) margin
{
    return [self sea_rightToItem:item margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置与某个item的right一样
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_autoLayoutBuilder.right(item).margin(margin).relation(relation).build;
}

/**
 设置在某个item左边，即两个视图间的水平距离为0
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItemLeft:(id) item
{
    return [self sea_rightToItemLeft:item margin:0];
}

/**
 设置右边距离某个item左边的约束，即两个视图间的水平距离
 @param item 对应的item
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItemLeft:(id) item margin:(CGFloat) margin
{
    return [self sea_rightToItemLeft:item margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置右边距离某个item左边的约束，即两个视图间的水平距离
 @param item 对应的item
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToItemLeft:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_autoLayoutBuilder.rightToLeft(item).margin(margin).relation(relation).build;
}

#pragma mark- size

/**
 设置约束大小
 @param size 大小
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_sizeToSelf:(CGSize) size
{
    return @[[self sea_widthToSelf:size.width], [self sea_heightToSelf:size.height]];
}

/**
 设置相宽度约束
 @param width 宽度
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToSelf:(CGFloat) width
{
    return [self sea_widthToItem:nil constant:width];
}

/**
 设置高度约束
 @param height 高度
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToSelf:(CGFloat) height
{
    return [self sea_heightToItem:nil constant:height];
}

/**
 设置宽度约束等于某个item
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToItem:(id) item
{
    return [self sea_widthToItem:item constant:0];
}

/**
 设置高度约束等于某个item
 @param item 对应的item
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToItem:(id) item
{
    return [self sea_heightToItem:item constant:0];
}

/**
 设置相对于某个item的宽度约束
 @param item 对应的item
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToItem:(id) item constant:(CGFloat) constant
{
    return [self sea_widthToItem:item multiplier:1.0 constant:constant];
}

/**
 设置相对于某个item的高度约束
 @param item 对应的item
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToItem:(id) item constant:(CGFloat) constant
{
    return [self sea_heightToItem:item multiplier:1.0 constant:constant];
}

/**
 设置相对于某个item的宽度约束
 @param item 对应的item
 @param multiplier 比值
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToItem:(id) item multiplier:(CGFloat) multiplier
{
    return [self sea_widthToItem:item multiplier:multiplier constant:0];
}

/**
 设置相对于某个item的高度约束
 @param item 对应的item
 @param multiplier 比值
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToItem:(id) item multiplier:(CGFloat) multiplier
{
    return [self sea_heightToItem:item multiplier:multiplier constant:0];
}

/**
 设置相对于某个item的宽度约束
 @param item 对应的item
 @param multiplier 比值
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToItem:(id) item multiplier:(CGFloat) multiplier constant:(CGFloat) constant
{
    return self.sea_autoLayoutBuilder.widthTo(item).margin(constant).multiplier(multiplier).build;
}

/**
 设置相对于某个item的高度约束
 @param item 对应的item
 @param multiplier 比值
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToItem:(id) item multiplier:(CGFloat) multiplier constant:(CGFloat) constant
{
    return self.sea_autoLayoutBuilder.heightTo(item).margin(constant).multiplier(multiplier).build;
}

/**
 设置宽高比例
 @param ratio 比例值  比如 宽是高的2倍 值就为2
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_aspectRatio:(CGFloat) ratio
{
    return self.sea_autoLayoutBuilder.aspectRatio(ratio).build;
}

/**
 自动布局 构造器
 
 @return 自动布局 构造器
 */
- (SeaAutoLayoutBuilder*)sea_autoLayoutBuilder
{
    return [SeaAutoLayoutBuilder builderWithView:self];
}

#pragma mark- 获取约束 constraint

/** 清空约束
 */
- (void)sea_removeAllContraints
{
    [self removeConstraints:self.constraints];
    NSArray *contraints = self.superview.constraints;
    
    if(contraints.count > 0)
    {
        NSMutableArray *toClearContraints = [NSMutableArray array];
        for(NSLayoutConstraint *constraint in contraints)
        {
            if(constraint.firstItem == self || constraint.secondItem == self)
            {
                [toClearContraints addObject:constraint];
            }
        }
        [self.superview removeConstraints:toClearContraints];
    }
}

- (NSLayoutConstraint*)sea_heightLayoutConstraint
{
    return [self sea_layoutConstraintForAttribute:NSLayoutAttributeHeight];
}

- (NSLayoutConstraint*)sea_widthLayoutConstraint
{
    return [self sea_layoutConstraintForAttribute:NSLayoutAttributeWidth];
}

- (NSLayoutConstraint*)sea_leftLayoutConstraint
{
    return [self sea_layoutConstraintForAttribute:NSLayoutAttributeLeading];
}

- (NSLayoutConstraint*)sea_rightLayoutConstraint
{
    return [self sea_layoutConstraintForAttribute:NSLayoutAttributeTrailing];
}

- (NSLayoutConstraint*)sea_topLayoutConstraint
{
    return [self sea_layoutConstraintForAttribute:NSLayoutAttributeTop];
}

- (NSLayoutConstraint*)sea_bottomLayoutConstraint
{
    return [self sea_layoutConstraintForAttribute:NSLayoutAttributeBottom];
}

- (NSLayoutConstraint*)sea_centerXLayoutConstraint
{
    return [self sea_layoutConstraintForAttribute:NSLayoutAttributeCenterX];
}

- (NSLayoutConstraint*)sea_centerYLayoutConstraint
{
    return [self sea_layoutConstraintForAttribute:NSLayoutAttributeCenterY];
}

/**通过约束类型获取对应的约束
 *@param attribute 约束类型
 *@return 如果存在，则返回优先级最高的约束，否则返回nil
 */
- (NSLayoutConstraint*)sea_layoutConstraintForAttribute:(NSLayoutAttribute) attribute
{
    NSArray *constraints = nil;
    
    //符合条件的，可能有多个，取最高优先级的
    NSMutableArray *matchs = [NSMutableArray array];
    switch (attribute)
    {
        case NSLayoutAttributeWidth :
        case NSLayoutAttributeHeight :
            
            //宽高约束主要有 固定值，纵横比，等于某个item的宽高
            constraints = self.constraints;
            for(NSLayoutConstraint *constraint in constraints){
                //固定值，纵横比 放在本身
                if(constraint.firstAttribute == attribute && constraint.firstItem == self && constraint.secondAttribute == NSLayoutAttributeNotAnAttribute){
                    //忽略纵横比
                    [matchs addObject:constraint];
                }
            }
            
            if(matchs.count == 0){
                //等于某个item的宽高 放在父视图
                constraints = self.superview.constraints;
                for(NSLayoutConstraint *constraint in constraints){
                    if((constraint.firstAttribute == attribute && constraint.firstItem == self) || (constraint.secondAttribute == attribute && constraint.secondItem == self)){
                        //忽略纵横比
                        [matchs addObject:constraint];
                    }
                }
            }
            
            break;
        case NSLayoutAttributeLeft :
        case NSLayoutAttributeLeading :
        case NSLayoutAttributeTop :
            //左上 约束 必定在父视图
            //item1.attribute1 = item2.attribute2 + constant
            //item2.attribute2 = item1.attribute1 - constant
            constraints = self.superview.constraints;
            for(NSLayoutConstraint *constraint in constraints){
                if(constraint.firstItem == self && constraint.firstAttribute == attribute && constraint.constant >= 0){
                    [matchs addObject:constraint];
                }else if (constraint.secondItem == self && constraint.secondAttribute == attribute && constraint.constant <= 0){
                    [matchs addObject:constraint];
                }
            }
            break;
        case NSLayoutAttributeRight :
        case NSLayoutAttributeTrailing :
        case NSLayoutAttributeBottom :
            //右下约束 必定在父视图
            //item1.attribute1 = item2.attribute2 - constant
            //item2.attribute2 = item1.attribute1 + constant
            constraints = self.superview.constraints;
            for(NSLayoutConstraint *constraint in constraints){
                if(constraint.firstItem == self && constraint.firstAttribute == attribute && constraint.constant <= 0){
                    [matchs addObject:constraint];
                }else if (constraint.secondItem == self && constraint.secondAttribute == attribute && constraint.constant >= 0){
                    [matchs addObject:constraint];
                }
            }
            break;
        case NSLayoutAttributeCenterX :
        case NSLayoutAttributeCenterY :
            //居中约束 必定在父视图
            constraints = self.superview.constraints;
            for(NSLayoutConstraint *constraint in constraints){
                if(constraint.firstItem == self && constraint.firstAttribute == attribute){
                    [matchs addObject:constraint];
                }
            }
            break;
        default:
            break;
    }
    
    NSLayoutConstraint *layoutConstraint = [matchs firstObject];
    //符合的约束太多，拿优先级最高的
    for(int i = 1;i < matchs.count;i ++){
        NSLayoutConstraint *constraint = [matchs objectAtIndex:i];
        if(layoutConstraint.priority < constraint.priority)
        {
            layoutConstraint = constraint;
        }
    }
    
    return layoutConstraint;
}

#pragma mark- AutoLayout 计算大小

/**根据给定的 size 计算当前view的大小，要使用auto layout
 *@param fitsSize 大小范围 0 则不限制范围
 *@param type 计算方式
 *@return view 大小
 */
- (CGSize)sea_sizeThatFits:(CGSize) fitsSize type:(SeaAutoLayoutCalculateType) type
{
    CGSize size = CGSizeZero;
    if (type != SeaAutoLayoutCalculateTypeSize)
    {
//        BOOL translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
//        self.translatesAutoresizingMaskIntoConstraints = NO;
        //添加临时约束
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:type == SeaAutoLayoutCalculateTypeHeight ? NSLayoutAttributeWidth : NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:type == SeaAutoLayoutCalculateTypeHeight ? fitsSize.width : fitsSize.height];
        constraint.priority = SeaAutoLayoutPriorityDefault;
        [self addConstraint:constraint];
        size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [self removeConstraint:constraint];
//        self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints;
    }
    else
    {
//        BOOL translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
//        self.translatesAutoresizingMaskIntoConstraints = NO;
        //添加临时约束
        NSLayoutConstraint *constraint = nil;
        if(!CGSizeEqualToSize(fitsSize, CGSizeZero))
        {
            constraint = [NSLayoutConstraint constraintWithItem:self attribute:fitsSize.width != 0 ? NSLayoutAttributeWidth : NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:fitsSize.width != 0 ? fitsSize.width : fitsSize.height];
            constraint.priority = SeaAutoLayoutPriorityDefault;
            [self addConstraint:constraint];
        }
        
        
        size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        if(constraint != nil)
        {
            [self removeConstraint:constraint];
        }
        
//        self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints;
    }
    
    return size;
}

@end
