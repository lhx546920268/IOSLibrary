//
//  UIView+SeaAutoLayout.m
//  Sea
//
//  Created by 罗海雄 on 2017/11/1.
//

#import "UIView+SeaAutoLayout.h"

@implementation UIView (SeaAutoLayout)

/**
 适配自动布局
 */
- (void)sea_adjustAutoLayoutWithView:(UIView*) view
{
    //父视图不需要设置 translatesAutoresizingMaskIntoConstraints
    if(![view isEqual:self.superview]){
        view.translatesAutoresizingMaskIntoConstraints = NO;
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

#pragma mark- center

/**
 相对于父视图居中
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInSuperview
{
    return [self sea_centerInView:self.superview];
}

/**
 相对于父视图居中
 @param constants x,y 轴增量
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInSuperviewWithConstants:(CGPoint) constants
{
    return [self sea_centerInView:self.superview constants:constants];
}

/**
 相对于某个view居中
 @param view 对应的view
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInView:(UIView*) view
{
    return [self sea_centerInView:view constants:CGPointZero];
}

/**
 相对于某个view居中
 @param view 对应的view
 @param constants x,y 轴增量
 @return 生成的约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_centerInView:(UIView*) view constants:(CGPoint) constants
{
    return @[[self sea_centerXInView:view constant:constants.x], [self sea_centerYInView:view constant:constants.y]];
}

/**
 相对于父视水平图居中
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInSuperview
{
    return [self sea_centerXInView:self.superview];
}

/**
 相对于父视水平图居中
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInSuperviewWithConstant:(CGFloat) constant
{
    return [self sea_centerXInView:self.superview constant:constant];
}

/**
 相对于某个view水平居中
 @param view 对应的view
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInView:(UIView*) view
{
    return [self sea_centerXInView:view constant:0];
}

/**
 相对于某个view水平居中
 @param view 对应的view
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerXInView:(UIView*) view constant:(CGFloat) constant
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:constant];
    
    [self sea_adjustAutoLayoutWithView:view];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}


/**
 相对于父视图垂直居中
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInSuperviewWithConstant:(CGFloat) constant
{
    return [self sea_centerYInView:self.superview constant:constant];
}

/**
 相对于父视图垂直居中
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInSuperview
{
    return [self sea_centerYInSuperviewWithConstant:0];
}

/**
 相对于某个view垂直居中
 @param view 对应的view
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInView:(UIView *)view
{
    return [self sea_centerYInView:view constant:0];
}

/**
 相对于某个view垂直居中
 @param view 对应的view
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_centerYInView:(UIView*) view constant:(CGFloat) constant
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:constant];
    [self sea_adjustAutoLayoutWithView:view];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

#pragma mark- insets

/**
 设置在父视图中的 上左下右约束
 @param insets 上左下右约束值
 @return 生成的约束，约束index与 insets对应，即 top，left, bottom, right 约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_insetsInSuperview:(UIEdgeInsets) insets
{
    return [self sea_insets:insets inView:self.superview];
}

/**
 设置在某个视图中的 上左下右约束
 @param insets 上左下右约束值
 @param view 对应的视图
 @return 生成的约束，约束index与 insets对应，即 top，left, bottom, right 约束
 */
- (NSArray<NSLayoutConstraint*>*)sea_insets:(UIEdgeInsets) insets inView:(UIView*) view
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *topConstraint = [self sea_topToView:view margin:insets.top];
    
    NSLayoutConstraint *leftConstraint = [self sea_leftToView:view margin:insets.left];
    
    NSLayoutConstraint *bottomConstraint = [self sea_bottomToView:view margin:insets.bottom];
    
    NSLayoutConstraint *rightConstraint = [self sea_rightToView:view margin:insets.right];
    
    [self.superview addConstraint:topConstraint];
    [self.superview addConstraint:leftConstraint];
    [self.superview addConstraint:bottomConstraint];
    [self.superview addConstraint:rightConstraint];
    
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
    return [self sea_topToView:self.superview margin:margin];
}

/**
 设置与某个视图的top一样
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToView:(UIView*) view
{
    return [self sea_topToView:view margin:0];
}

/**
 设置与某个视图的top一样
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToView:(UIView*) view margin:(CGFloat) margin
{
    return [self sea_topToView:view margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置与某个视图的top一样
 @param view 对应的视图
 @param margin 间距
 @paran relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToView:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:relation toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:margin];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

/**
 设置在某个视图下面，即两个视图间的垂直距离为0
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToViewBottom:(UIView*) view
{
    return [self sea_topToViewBottom:view margin:0];
}

/**
 设置上面距离某个视图下面的约束，即两个视图间的垂直距离
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToViewBottom:(UIView*) view margin:(CGFloat) margin
{
    return [self sea_topToViewBottom:view margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置上面距离某个视图下面的约束，即两个视图间的垂直距离
 @param view 对应的视图
 @param margin 间距
 @paran relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_topToViewBottom:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTop relatedBy:relation toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:margin];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
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
    return [self sea_leftToView:self.superview margin:margin];
}

/**
 设置与某个视图的left一样
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToView:(UIView*) view
{
    return [self sea_leftToView:view margin:0];
}

/**
 设置与某个视图的left一样
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToView:(UIView*) view margin:(CGFloat) margin
{
    return [self sea_leftToView:view margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置与某个视图的left一样
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToView:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:relation toItem:view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:margin];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

/**
 设置在某个视图右边，即两个视图间的水平距离为0
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToViewRight:(UIView*) view
{
    return [self sea_leftToViewRight:view margin:0];
}

/**
 设置左边距离某个视图右边的约束，即两个视图间的水平距离
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToViewRight:(UIView*) view margin:(CGFloat) margin
{
    return [self sea_leftToViewRight:view margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置左边距离某个视图右边的约束，即两个视图间的水平距离
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_leftToViewRight:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:relation toItem:view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:margin];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
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
    return [self sea_bottomToView:self.superview margin:0];
}

/**
 设置与某个视图的bottom一样
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToView:(UIView*) view
{
    return [self sea_bottomToView:view margin:0];
}

/**
 设置与某个视图的bottom一样
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToView:(UIView*) view margin:(CGFloat) margin
{
    return [self sea_bottomToView:view margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置与某个视图的bottom一样
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToView:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:relation toItem:view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:-margin];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

/**
 设置在某个视图上面，即两个视图间的垂直距离为0
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToViewTop:(UIView*) view
{
    return [self sea_bottomToViewTop:view margin:0];
}

/**
 设置下面距离某个视图上面的约束，即两个视图间的垂直距离
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToViewTop:(UIView*) view margin:(CGFloat) margin
{
    return [self sea_bottomToViewTop:view margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置下面距离某个视图上面的约束，即两个视图间的垂直距离
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_bottomToViewTop:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:relation toItem:view attribute:NSLayoutAttributeTop multiplier:1.0 constant:-margin];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
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
    return [self sea_rightToView:self.superview margin:margin];
}

/**
 设置与某个视图的right一样
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToView:(UIView*) view
{
    return [self sea_rightToView:view margin:0];
}

/**
 设置与某个视图的right一样
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToView:(UIView*) view margin:(CGFloat) margin
{
    return [self sea_rightToView:view margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置与某个视图的right一样
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToView:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:relation toItem:view attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:-margin];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
}

/**
 设置在某个视图左边，即两个视图间的水平距离为0
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToViewLeft:(UIView*) view
{
    return [self sea_rightToViewLeft:view margin:0];
}

/**
 设置右边距离某个视图左边的约束，即两个视图间的水平距离
 @param view 对应的视图
 @param margin 间距
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToViewLeft:(UIView*) view margin:(CGFloat) margin
{
    return [self sea_rightToViewLeft:view margin:margin relation:NSLayoutRelationEqual];
}

/**
 设置右边距离某个视图左边的约束，即两个视图间的水平距离
 @param view 对应的视图
 @param margin 间距
 @param relation >=、=、<=
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_rightToViewLeft:(UIView*) view margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:relation toItem:view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-margin];
    
    [self.superview addConstraint:constraint];
    
    return constraint;
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
    return [self sea_widthToView:nil constant:width];
}

/**
 设置高度约束
 @param height 高度
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToSelf:(CGFloat) height
{
    return [self sea_heightToView:nil constant:height];
}

/**
 设置宽度约束等于某个视图
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToView:(UIView*) view
{
    return [self sea_widthToView:view constant:0];
}

/**
 设置高度约束等于某个视图
 @param view 对应的视图
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToView:(UIView*) view
{
    return [self sea_heightToView:view constant:0];
}

/**
 设置相对于某个视图的宽度约束
 @param view 对应的视图
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToView:(UIView*) view constant:(CGFloat) constant
{
    return [self sea_widthToView:view multiplier:1.0 constant:constant];
}

/**
 设置相对于某个视图的高度约束
 @param view 对应的视图
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToView:(UIView*) view constant:(CGFloat) constant
{
   return [self sea_heightToView:view multiplier:1.0 constant:constant];
}

/**
 设置相对于某个视图的宽度约束
 @param view 对应的视图
 @param multiplier 比值
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToView:(UIView*) view multiplier:(CGFloat) multiplier
{
    return [self sea_widthToView:view multiplier:multiplier constant:0];
}

/**
 设置相对于某个视图的高度约束
 @param view 对应的视图
 @param multiplier 比值
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToView:(UIView*) view multiplier:(CGFloat) multiplier
{
    return [self sea_heightToView:view multiplier:multiplier constant:0];
}

/**
 设置相对于某个视图的宽度约束
 @param view 对应的视图
 @param multiplier 比值
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_widthToView:(UIView*) view multiplier:(CGFloat) multiplier constant:(CGFloat) constant
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:view attribute:!view ? NSLayoutAttributeNotAnAttribute : NSLayoutAttributeWidth multiplier:multiplier constant:constant];
    
    if(view == nil){
        [self addConstraint:constraint];
    }else{
        [self.superview addConstraint:constraint];
    }
    
    return constraint;
}

/**
 设置相对于某个视图的高度约束
 @param view 对应的视图
 @param multiplier 比值
 @param constant 增量
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_heightToView:(UIView*) view multiplier:(CGFloat) multiplier constant:(CGFloat) constant
{
    [self sea_adjustAutoLayoutWithView:view];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:view attribute:!view ? NSLayoutAttributeNotAnAttribute : NSLayoutAttributeHeight multiplier:multiplier constant:constant];
    
    if(view == nil){
        [self addConstraint:constraint];
    }else{
        [self.superview addConstraint:constraint];
    }
    
    return constraint;
}

/**
 设置宽高比例
 @param ratio 比例值  比如 宽是高的2倍 值就为2
 @return 生成的约束
 */
- (NSLayoutConstraint*)sea_aspectRatio:(CGFloat) ratio
{
    [self sea_adjustAutoLayoutWithView:nil];
    
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:ratio constant:0];
    
   [self addConstraint:constraint];
    
    return constraint;
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
            
            //宽高约束主要有 固定值，纵横比，等于某个视图的宽高
            constraints = self.constraints;
            for(NSLayoutConstraint *constraint in constraints){
                //固定值，纵横比 放在本身
                if(constraint.firstAttribute == attribute && constraint.firstItem == self && constraint.secondAttribute == NSLayoutAttributeNotAnAttribute){
                    //忽略纵横比
                    [matchs addObject:constraint];
                }
            }
            
            if(matchs.count == 0){
                //等于某个视图的宽高 放在父视图
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


@end
