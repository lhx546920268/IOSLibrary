//
//  UIView+Utilities.m

//

#import "UIView+Utilities.h"
#import <objc/runtime.h>

/** 虚线边框图层
 */
static char dashBorderLayerKey;

@implementation UIView (Utilities)

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right
{
    CGRect frame = self.frame;
    frame.origin.x = right - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

#pragma mark- 约束 constraint

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
    return [self sea_layoutConstraintForAttribute:NSLayoutAttributeLeft];
}

- (NSLayoutConstraint*)sea_rightLayoutConstraint
{
    return [self sea_layoutConstraintForAttribute:NSLayoutAttributeRight];
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
    NSLayoutConstraint *layoutConstraint = nil;
    
    for(NSLayoutConstraint *constraint in self.constraints)
    {
        if(![constraint isMemberOfClass:[NSLayoutConstraint class]])
            continue;
        if(constraint.firstAttribute == attribute && constraint.firstItem == self && (constraint.secondItem == nil || constraint.secondItem == self))
        {
            if(layoutConstraint == nil || layoutConstraint.priority < constraint.priority)
            {
                layoutConstraint = constraint;
            }
        }
    }
    
    ///约束可能加在父视图那里
    if(layoutConstraint == nil)
    {
        for(NSLayoutConstraint *constraint in self.superview.constraints)
        {
            if(![constraint isMemberOfClass:[NSLayoutConstraint class]])
                continue;
            if(constraint.firstAttribute == attribute && (constraint.firstItem == self || constraint.firstItem == self.superview) && (constraint.secondItem == nil || constraint.secondItem == self.superview || constraint.secondItem == self))
            {
                if(layoutConstraint == nil || layoutConstraint.priority < constraint.priority)
                {
                    layoutConstraint = constraint;
                }
            }
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
        BOOL translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        //添加临时约束
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:type == SeaAutoLayoutCalculateTypeHeight ? NSLayoutAttributeWidth : NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:type == SeaAutoLayoutCalculateTypeHeight ? fitsSize.width : fitsSize.height];
        
        [self addConstraint:constraint];
        size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        [self removeConstraint:constraint];
        self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints;
    }
    else
    {
        BOOL translatesAutoresizingMaskIntoConstraints = self.translatesAutoresizingMaskIntoConstraints;
        self.translatesAutoresizingMaskIntoConstraints = NO;
        //添加临时约束
        NSLayoutConstraint *constraint = nil;
        if(!CGSizeEqualToSize(fitsSize, CGSizeZero))
        {
            constraint = [NSLayoutConstraint constraintWithItem:self attribute:fitsSize.width != 0 ? NSLayoutAttributeWidth : NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:fitsSize.width != 0 ? fitsSize.width : fitsSize.height];
            [self addConstraint:constraint];
        }
        
       
        size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
        
        if(constraint != nil)
        {
            [self removeConstraint:constraint];
        }
        
        self.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints;
    }
    
    return size;
}

#pragma mark- dash 虚线

- (void)makeBorderWidth:(CGFloat)width Color:(UIColor *)color CornerRadius:(CGFloat)cornerRadius
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
    self.layer.cornerRadius = cornerRadius;
    self.clipsToBounds = YES;
}

- (void)setDashBorderLayer:(CAShapeLayer *)dashBorderLayer
{
    if(dashBorderLayer != self.dashBorderLayer)
    {
        objc_setAssociatedObject(self, &dashBorderLayerKey, dashBorderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (CAShapeLayer*)dashBorderLayer
{
   return objc_getAssociatedObject(self, &dashBorderLayerKey);
}

/*添加虚线边框 圆角会根据 视图的圆角来确定
 *@param width 线条宽度
 *@param lineColor 线条颜色
 *@param dashesLength 虚线间隔宽度
 *@param dashesInterval 虚线每段宽度
 */
- (void)addDashBorderWidth:(CGFloat) width lineColor:(UIColor*) lineColor dashesLength:(CGFloat) dashesLength dashesInterval:(CGFloat) dashesInterval
{
    CAShapeLayer *borderLayer = self.dashBorderLayer;
    if(!borderLayer)
    {
        borderLayer = [CAShapeLayer layer];
        self.dashBorderLayer = borderLayer;
    }
    
    borderLayer.bounds = self.bounds;
    borderLayer.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    borderLayer.path = [UIBezierPath bezierPathWithRoundedRect:borderLayer.bounds cornerRadius:self.layer.cornerRadius].CGPath;
    borderLayer.lineWidth = width;
    //虚线边框
    borderLayer.lineDashPattern = @[@(dashesLength), @(dashesInterval)];

    borderLayer.fillColor = [UIColor clearColor].CGColor;
    borderLayer.strokeColor = lineColor.CGColor;
    [self.layer insertSublayer:borderLayer atIndex:0];
}

/**设置部分圆角
 *@param cornerRadius 圆角
 *@param corners 圆角位置
 */
- (void)sea_setCornerRadius:(CGFloat) cornerRadius corners:(UIRectCorner) corners
{
    [self sea_setCornerRadius:cornerRadius corners:corners rect:self.bounds];
}

/**设置部分圆角
 *@param cornerRadius 圆角
 *@param corners 圆角位置
 *@param rect 视图大小，如果使用autoLayout
 */
- (void)sea_setCornerRadius:(CGFloat) cornerRadius corners:(UIRectCorner) corners rect:(CGRect) rect
{
    CAShapeLayer *layer = (CAShapeLayer*)self.layer.mask;
    if(![layer isKindOfClass:[CAShapeLayer class]])
    {
        layer = [CAShapeLayer layer];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    [layer setPath:path.CGPath];
    self.layer.mask = layer;
}

@end
