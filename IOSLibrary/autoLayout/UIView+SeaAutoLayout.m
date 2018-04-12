//
//  UIView+SeaAutoLayout.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/11/1.
//

#import "UIView+SeaAutoLayout.h"

@implementation UIView (SeaAutoLayout)

#pragma mark- center

- (NSArray<NSLayoutConstraint*>*)sea_centerInSuperview
{
    return [self sea_centerInItem:self.superview];
}

- (NSArray<NSLayoutConstraint*>*)sea_centerInSuperviewWithOffset:(CGPoint) offset
{
    return [self sea_centerInItem:self.superview offset:offset];
}

- (NSArray<NSLayoutConstraint*>*)sea_centerInItem:(id) item
{
    return [self sea_centerInItem:item offset:CGPointZero];
}

- (NSArray<NSLayoutConstraint*>*)sea_centerInItem:(id) item offset:(CGPoint) offset
{
    return @[[self sea_centerXInItem:item offset:offset.x], [self sea_centerYInItem:item offset:offset.y]];
}

- (NSLayoutConstraint*)sea_centerXInSuperview
{
    return [self sea_centerXInItem:self.superview];
}

- (NSLayoutConstraint*)sea_centerXInSuperviewWithOffset:(CGFloat) offset
{
    return [self sea_centerXInItem:self.superview offset:offset];
}

- (NSLayoutConstraint*)sea_centerXInItem:(id) item
{
    return [self sea_centerXInItem:item offset:0];
}

- (NSLayoutConstraint*)sea_centerXInItem:(id) item offset:(CGFloat) offset
{
    return self.sea_alb.centerX(item).margin(offset).build();
}

- (NSLayoutConstraint*)sea_centerYInSuperviewWithOffset:(CGFloat) offset
{
    return [self sea_centerYInItem:self.superview offset:offset];
}

- (NSLayoutConstraint*)sea_centerYInSuperview
{
    return [self sea_centerYInSuperviewWithOffset:0];
}

- (NSLayoutConstraint*)sea_centerYInItem:(id) item
{
    return [self sea_centerYInItem:item offset:0];
}

- (NSLayoutConstraint*)sea_centerYInItem:(id) item offset:(CGFloat) offset
{
    return self.sea_alb.centerY(item).margin(offset).build();
}

- (NSLayoutConstraint*)sea_centerXInItemLeft:(id) item
{
    return self.sea_alb.centerXToLeft(item).build();
}

- (NSLayoutConstraint*)sea_centerXInItemRight:(id) item
{
    return self.sea_alb.centerXToRight(item).build();
}

- (NSLayoutConstraint*)sea_centerYInItemTop:(id) item
{
    return self.sea_alb.centerYToTop(item).build();
}

- (NSLayoutConstraint*)sea_centerYInItemBottom:(id) item
{
    return self.sea_alb.centerYToBottom(item).build();
}

#pragma mark- insets

- (NSArray<NSLayoutConstraint*>*)sea_insetsInSuperview:(UIEdgeInsets) insets
{
    return [self sea_insets:insets inItem:self.superview];
}

- (NSArray<NSLayoutConstraint*>*)sea_insets:(UIEdgeInsets) insets inItem:(id) item
{
    NSLayoutConstraint *topConstraint = [self sea_topToItem:item margin:insets.top];
    NSLayoutConstraint *leftConstraint = [self sea_leftToItem:item margin:insets.left];
    NSLayoutConstraint *bottomConstraint = [self sea_bottomToItem:item margin:insets.bottom];
    NSLayoutConstraint *rightConstraint = [self sea_rightToItem:item margin:insets.right];
    
    return @[topConstraint, leftConstraint, bottomConstraint, rightConstraint];
}

#pragma mark- top

- (NSLayoutConstraint*)sea_topToSuperview
{
    return [self sea_topToSuperview:0];
}

- (NSLayoutConstraint*)sea_topToSuperview:(CGFloat) margin
{
    return [self sea_topToItem:self.superview margin:margin];
}

- (NSLayoutConstraint*)sea_topToItem:(id) item
{
    return [self sea_topToItem:item margin:0];
}

- (NSLayoutConstraint*)sea_topToItem:(id) item margin:(CGFloat) margin
{
    return [self sea_topToItem:item margin:margin relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint*)sea_topToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_alb.top(item).margin(margin).relation(relation).build();
}

- (NSLayoutConstraint*)sea_topToItemBottom:(id) item
{
    return [self sea_topToItemBottom:item margin:0];
}

- (NSLayoutConstraint*)sea_topToItemBottom:(id) item margin:(CGFloat) margin
{
    return [self sea_topToItemBottom:item margin:margin relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint*)sea_topToItemBottom:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_alb.topToBottom(item).margin(margin).relation(relation).build();
}

- (NSLayoutConstraint*)sea_topToItemCenterY:(id) item
{
    return self.sea_alb.topToCenterY(item).build();
}

#pragma mark- left

- (NSLayoutConstraint*)sea_leftToSuperview
{
    return [self sea_leftToSuperview:0];
}

- (NSLayoutConstraint*)sea_leftToSuperview:(CGFloat) margin
{
    return [self sea_leftToItem:self.superview margin:margin];
}

- (NSLayoutConstraint*)sea_leftToItem:(id) item
{
    return [self sea_leftToItem:item margin:0];
}

- (NSLayoutConstraint*)sea_leftToItem:(id) item margin:(CGFloat) margin
{
    return [self sea_leftToItem:item margin:margin relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint*)sea_leftToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_alb.left(item).margin(margin).relation(relation).build();
}

- (NSLayoutConstraint*)sea_leftToItemRight:(id) item
{
    return [self sea_leftToItemRight:item margin:0];
}

- (NSLayoutConstraint*)sea_leftToItemRight:(id) item margin:(CGFloat) margin
{
    return [self sea_leftToItemRight:item margin:margin relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint*)sea_leftToItemRight:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_alb.leftToRight(item).margin(margin).relation(relation).build();
}

- (NSLayoutConstraint*)sea_leftToItemCenterX:(id) item
{
    return self.sea_alb.leftToCenterX(item).build();
}

#pragma mark- bottom

- (NSLayoutConstraint*)sea_bottomToSuperview
{
    return [self sea_bottomToSuperview:0];
}

- (NSLayoutConstraint*)sea_bottomToSuperview:(CGFloat) margin
{
    return [self sea_bottomToItem:self.superview margin:margin];
}

- (NSLayoutConstraint*)sea_bottomToItem:(id) item
{
    return [self sea_bottomToItem:item margin:0];
}

- (NSLayoutConstraint*)sea_bottomToItem:(id) item margin:(CGFloat) margin
{
    return [self sea_bottomToItem:item margin:margin relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint*)sea_bottomToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_alb.bottom(item).margin(margin).relation(relation).build();
}

- (NSLayoutConstraint*)sea_bottomToItemTop:(id) item
{
    return [self sea_bottomToItemTop:item margin:0];
}

- (NSLayoutConstraint*)sea_bottomToItemTop:(id) item margin:(CGFloat) margin
{
    return [self sea_bottomToItemTop:item margin:margin relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint*)sea_bottomToItemTop:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_alb.bottomToTop(item).margin(margin).relation(relation).build();
}

- (NSLayoutConstraint*)sea_bottomToItemCenterY:(id) item
{
    return self.sea_alb.bottomToCenterY(item).build();
}

#pragma mark- right

- (NSLayoutConstraint*)sea_rightToSuperview
{
    return [self sea_rightToSuperview:0];
}

- (NSLayoutConstraint*)sea_rightToSuperview:(CGFloat) margin
{
    return [self sea_rightToItem:self.superview margin:margin];
}

- (NSLayoutConstraint*)sea_rightToItem:(id) item
{
    return [self sea_rightToItem:item margin:0];
}

- (NSLayoutConstraint*)sea_rightToItem:(id) item margin:(CGFloat) margin
{
    return [self sea_rightToItem:item margin:margin relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint*)sea_rightToItem:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_alb.right(item).margin(margin).relation(relation).build();
}

- (NSLayoutConstraint*)sea_rightToItemLeft:(id) item
{
    return [self sea_rightToItemLeft:item margin:0];
}

- (NSLayoutConstraint*)sea_rightToItemLeft:(id) item margin:(CGFloat) margin
{
    return [self sea_rightToItemLeft:item margin:margin relation:NSLayoutRelationEqual];
}

- (NSLayoutConstraint*)sea_rightToItemLeft:(id) item margin:(CGFloat) margin relation:(NSLayoutRelation) relation
{
    return self.sea_alb.rightToLeft(item).margin(margin).relation(relation).build();
}

- (NSLayoutConstraint*)sea_rightToItemCenterX:(id) item
{
    return self.sea_alb.rightToCenterX(item).build();
}

#pragma mark- size

- (NSArray<NSLayoutConstraint*>*)sea_sizeToSelf:(CGSize) size
{
    return @[[self sea_widthToSelf:size.width], [self sea_heightToSelf:size.height]];
}

- (NSLayoutConstraint*)sea_widthToSelf:(CGFloat) width
{
    return [self sea_widthToItem:nil constant:width];
}

- (NSLayoutConstraint*)sea_heightToSelf:(CGFloat) height
{
    return [self sea_heightToItem:nil constant:height];
}

- (NSLayoutConstraint*)sea_widthToItem:(id) item
{
    return [self sea_widthToItem:item constant:0];
}

- (NSLayoutConstraint*)sea_heightToItem:(id) item
{
    return [self sea_heightToItem:item constant:0];
}

- (NSLayoutConstraint*)sea_widthToItem:(id) item constant:(CGFloat) constant
{
    return [self sea_widthToItem:item multiplier:1.0 constant:constant];
}

- (NSLayoutConstraint*)sea_heightToItem:(id) item constant:(CGFloat) constant
{
    return [self sea_heightToItem:item multiplier:1.0 constant:constant];
}

- (NSLayoutConstraint*)sea_widthToItem:(id) item multiplier:(CGFloat) multiplier
{
    return [self sea_widthToItem:item multiplier:multiplier constant:0];
}

- (NSLayoutConstraint*)sea_heightToItem:(id) item multiplier:(CGFloat) multiplier
{
    return [self sea_heightToItem:item multiplier:multiplier constant:0];
}

- (NSLayoutConstraint*)sea_widthToItem:(id) item multiplier:(CGFloat) multiplier constant:(CGFloat) constant
{
    return self.sea_alb.widthTo(item).margin(constant).multiplier(multiplier).build();
}

- (NSLayoutConstraint*)sea_heightToItem:(id) item multiplier:(CGFloat) multiplier constant:(CGFloat) constant
{
    return self.sea_alb.heightTo(item).margin(constant).multiplier(multiplier).build();
}

- (NSLayoutConstraint*)sea_aspectRatio:(CGFloat) ratio
{
    return self.sea_alb.aspectRatio(ratio).build();
}

#pragma mark- AutoLayout Builder

- (SeaAutoLayoutBuilder*)sea_alb
{
    return [SeaAutoLayoutBuilder builderWithView:self];
}

#pragma mark- 约束判断

- (BOOL)sea_existConstraints
{
    if(self.constraints.count > 0){
        return YES;
    }
    
    NSArray *contraints = self.superview.constraints;
    
    if(contraints.count > 0){
        for(NSLayoutConstraint *constraint in contraints){
            if(constraint.firstItem == self || constraint.secondItem == self){
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark- 获取约束 constraint

- (void)sea_removeAllContraints
{
    [self removeConstraints:self.constraints];
    NSArray *contraints = self.superview.constraints;
    
    if(contraints.count > 0){
        NSMutableArray *toClearContraints = [NSMutableArray array];
        for(NSLayoutConstraint *constraint in contraints){
            if(constraint.firstItem == self || constraint.secondItem == self){
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

- (NSLayoutConstraint*)sea_layoutConstraintForAttribute:(NSLayoutAttribute) attribute
{
    NSArray *constraints = nil;
    
    //符合条件的，可能有多个，取最高优先级的 忽略其子类
    NSMutableArray *matchs = [NSMutableArray array];
    Class clazz = [NSLayoutConstraint class];
    
    switch (attribute)
    {
        case NSLayoutAttributeWidth :
        case NSLayoutAttributeHeight :
            
            //宽高约束主要有 固定值，纵横比，等于某个item的宽高
            constraints = self.constraints;
            for(NSLayoutConstraint *constraint in constraints){
                //固定值，纵横比 放在本身
                if([constraint isMemberOfClass:clazz]){
                    if(constraint.firstAttribute == attribute && constraint.firstItem == self && constraint.secondAttribute == NSLayoutAttributeNotAnAttribute){
                        //忽略纵横比
                        [matchs addObject:constraint];
                    }
                }
            }
            
            if(matchs.count == 0){
                //等于某个item的宽高 放在父视图
                constraints = self.superview.constraints;
                for(NSLayoutConstraint *constraint in constraints){
                    if([constraint isMemberOfClass:clazz]){
                        if((constraint.firstAttribute == attribute && constraint.firstItem == self) || (constraint.secondAttribute == attribute && constraint.secondItem == self)){
                            //忽略纵横比
                            [matchs addObject:constraint];
                        }
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
                if([constraint isMemberOfClass:clazz]){
                    if(constraint.firstItem == self && constraint.firstAttribute == attribute){
                        [matchs addObject:constraint];
                    }else if (constraint.secondItem == self && constraint.secondAttribute == attribute){
                        [matchs addObject:constraint];
                    }
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
                if([constraint isMemberOfClass:clazz]){
                    if(constraint.firstItem == self && constraint.firstAttribute == attribute){
                        [matchs addObject:constraint];
                    }else if (constraint.secondItem == self && constraint.secondAttribute == attribute){
                        [matchs addObject:constraint];
                    }
                }
            }
            break;
        case NSLayoutAttributeCenterX :
        case NSLayoutAttributeCenterY :
            //居中约束 必定在父视图
            constraints = self.superview.constraints;
            for(NSLayoutConstraint *constraint in constraints){
                if([constraint isMemberOfClass:clazz]){
                    if(constraint.firstItem == self && constraint.firstAttribute == attribute){
                        [matchs addObject:constraint];
                    }
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
        if(layoutConstraint.priority < constraint.priority){
            layoutConstraint = constraint;
        }
    }
    
    return layoutConstraint;
}

#pragma mark- AutoLayout 计算大小

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

