//
//  SeaAutoLayoutBuilder.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/15.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaAutoLayoutBuilder.h"
#import "SeaBasic.h"

@interface SeaAutoLayoutBuilder()

@property(nonatomic, weak) UIView *sea_item1;

@property(nonatomic, weak) id sea_item2;

@property(nonatomic, assign) NSLayoutAttribute sea_attr1;

@property(nonatomic, assign) NSLayoutAttribute sea_attr2;

@property(nonatomic, assign) CGFloat sea_multiplier;

@property(nonatomic, assign) NSLayoutRelation sea_relation;

@property(nonatomic, assign) CGFloat sea_constant;

@property(nonatomic, assign) UILayoutPriority sea_priority;

@end

@implementation SeaAutoLayoutBuilder

- (instancetype)init
{
    self = [super init];
    if(self){
        [self reset];
    }
    return self;
}

/**
 重置
 */
- (void)reset
{
    self.sea_priority = SeaAutoLayoutPriorityDefault;
    self.sea_constant = 0;
    self.sea_multiplier = 1.0;
    self.sea_relation = NSLayoutRelationEqual;
    self.sea_attr2 = NSLayoutAttributeNotAnAttribute;
    self.sea_attr1 = NSLayoutAttributeNotAnAttribute;
    self.sea_item2 = nil;
}

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    static SeaAutoLayoutBuilder *builder;
    dispatch_once(&onceToken, ^{
        builder = [SeaAutoLayoutBuilder new];
    });
    
    [builder reset];
    return builder;
}

+ (instancetype)builderWithView:(UIView*) view
{
    SeaAutoLayoutBuilder *builder = [SeaAutoLayoutBuilder shareInstance];
    builder.sea_item1 = view;
    
    return builder;
}

#pragma mark- left

- (SeaAutoLayoutBuilder*)leftToSuperview
{
    return self.left([self superview]);
}

- (SeaAutoLayoutBuilder* (^)(id))left
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeLeading;
        self.sea_attr2 = NSLayoutAttributeLeading;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(id))leftToRight
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeLeading;
        self.sea_attr2 = NSLayoutAttributeTrailing;
        return self;
    };
}

- (SeaAutoLayoutBuilder*)leftToSuperviewCenterX
{
    return self.leftToCenterX([self superview]);
}

- (SeaAutoLayoutBuilder* (^)(id))leftToCenterX
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeLeading;
        self.sea_attr2 = NSLayoutAttributeCenterX;
        return self;
    };
}

#pragma mark- top

- (SeaAutoLayoutBuilder*)topToSuperview
{
    return self.top([self superview]);
}

- (SeaAutoLayoutBuilder* (^)(id))top
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeTop;
        self.sea_attr2 = NSLayoutAttributeTop;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(id))topToBottom
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeTop;
        self.sea_attr2 = NSLayoutAttributeBottom;
        return self;
    };
}

- (SeaAutoLayoutBuilder*)topToSuperviewCenterY
{
    return self.topToCenterY([self superview]);
}

- (SeaAutoLayoutBuilder* (^)(id))topToCenterY
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeTop;
        self.sea_attr2 = NSLayoutAttributeCenterY;
        return self;
    };
}

#pragma mark- right

- (SeaAutoLayoutBuilder*)rightToSuperview
{
    return self.right([self superview]);
}

- (SeaAutoLayoutBuilder* (^)(id))right
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeTrailing;
        self.sea_attr2 = NSLayoutAttributeTrailing;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(id))rightToLeft
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeTrailing;
        self.sea_attr2 = NSLayoutAttributeLeading;
        return self;
    };
}

- (SeaAutoLayoutBuilder*)rightToSuperviewCenterX
{
    return self.rightToCenterX([self superview]);
}

- (SeaAutoLayoutBuilder* (^)(id))rightToCenterX
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeTrailing;
        self.sea_attr2 = NSLayoutAttributeCenterX;
        return self;
    };
}

#pragma mark- bottom

- (SeaAutoLayoutBuilder*)bottomToSuperview
{
    return self.left([self superview]);
}

- (SeaAutoLayoutBuilder* (^)(id))bottom
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeBottom;
        self.sea_attr2 = NSLayoutAttributeBottom;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(id))bottomToTop
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeBottom;
        self.sea_attr2 = NSLayoutAttributeTop;
        return self;
    };
}

- (SeaAutoLayoutBuilder*)bottomToSuperviewCenterY
{
    return self.bottomToCenterY([self superview]);
}

- (SeaAutoLayoutBuilder* (^)(id))bottomToCenterY
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeBottom;
        self.sea_attr2 = NSLayoutAttributeCenterY;
        return self;
    };
}

#pragma mark- center

- (SeaAutoLayoutBuilder*)centerXInSuperview
{
    return self.centerX([self superview]);
}


- (SeaAutoLayoutBuilder* (^)(id))centerX
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeCenterX;
        self.sea_attr2 = NSLayoutAttributeCenterX;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(id))centerXToLeft
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeCenterX;
        self.sea_attr2 = NSLayoutAttributeLeading;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(id))centerXToRight
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeCenterX;
        self.sea_attr2 = NSLayoutAttributeTrailing;
        return self;
    };
}

- (SeaAutoLayoutBuilder*)centerYInSuperview
{
    return self.centerY([self superview]);
}

- (SeaAutoLayoutBuilder* (^)(id))centerY
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeCenterY;
        self.sea_attr2 = NSLayoutAttributeCenterY;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(id))centerYToTop
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeCenterY;
        self.sea_attr2 = NSLayoutAttributeTop;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(id))centerYToBottom
{
    return ^ SeaAutoLayoutBuilder* (id item){
        
        self.sea_item2 = item;
        self.sea_attr1 = NSLayoutAttributeCenterY;
        self.sea_attr2 = NSLayoutAttributeBottom;
        return self;
    };
}

#pragma mark- width

- (SeaAutoLayoutBuilder* (^)(CGFloat))width
{
    return ^ SeaAutoLayoutBuilder* (CGFloat width){
        self.sea_attr1 = NSLayoutAttributeWidth;
        self.sea_constant = width;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(id))widthTo
{
    return ^ SeaAutoLayoutBuilder* (id item){
        self.sea_attr1 = NSLayoutAttributeWidth;
        self.sea_item2 = item;
        self.sea_attr2 = NSLayoutAttributeWidth;
        return self;
    };
}

#pragma mark- height

- (SeaAutoLayoutBuilder* (^)(CGFloat))height
{
    return ^ SeaAutoLayoutBuilder* (CGFloat height){
        self.sea_attr1 = NSLayoutAttributeHeight;
        self.sea_constant = height;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(id))heightTo
{
    return ^ SeaAutoLayoutBuilder* (id item){
        self.sea_attr1 = NSLayoutAttributeHeight;
        self.sea_item2 = item;
        self.sea_attr2 = NSLayoutAttributeHeight;
        return self;
    };
}

#pragma mark- ratio

- (SeaAutoLayoutBuilder* (^)(CGFloat))aspectRatio
{
    return ^ SeaAutoLayoutBuilder* (CGFloat ratio){
        self.sea_attr1 = NSLayoutAttributeWidth;
        self.sea_item2 = self.sea_item1;
        self.sea_attr2 = NSLayoutAttributeHeight;
        self.sea_multiplier = ratio;
        return self;
    };
}

#pragma mark- relation

- (SeaAutoLayoutBuilder* (^)(NSLayoutRelation))relation
{
    return ^ SeaAutoLayoutBuilder* (NSLayoutRelation relation){
        self.sea_relation = relation;
        return self;
    };
}

- (SeaAutoLayoutBuilder*)equal
{
    self.sea_relation = NSLayoutRelationEqual;
    return self;
}

- (SeaAutoLayoutBuilder*)lessThanOrEqual
{
    self.sea_relation = NSLayoutRelationLessThanOrEqual;
    return self;
}

- (SeaAutoLayoutBuilder*)greaterThanOrEqual
{
    self.sea_relation = NSLayoutRelationGreaterThanOrEqual;
    return self;
}

#pragma mark- constant

- (SeaAutoLayoutBuilder* (^)(CGFloat))multiplier
{
    return ^ SeaAutoLayoutBuilder* (CGFloat multiplier){
        self.sea_multiplier = multiplier;
        return self;
    };
}

- (SeaAutoLayoutBuilder* (^)(CGFloat))margin
{
    return ^ SeaAutoLayoutBuilder* (CGFloat margin){
        self.sea_constant = margin;
        return self;
    };
}

#pragma mark- priority

- (SeaAutoLayoutBuilder* (^)(UILayoutPriority))priority
{
    return ^ SeaAutoLayoutBuilder* (UILayoutPriority priority){
        self.sea_priority = priority;
        return self;
    };
}

- (SeaAutoLayoutBuilder*)priorityRequired
{
    self.sea_priority = UILayoutPriorityRequired;
    return self;
}
- (SeaAutoLayoutBuilder*)priorityHigh
{
    self.sea_priority = UILayoutPriorityDefaultHigh;
    return self;
}

- (SeaAutoLayoutBuilder*)priorityLow
{
    self.sea_priority = UILayoutPriorityDefaultLow;
    return self;
}

/**
 适配自动布局
 */
- (void)adjustAutoLayout
{
    id item = self.sea_item2;
    //父视图不需要设置 translatesAutoresizingMaskIntoConstraints
    if([item isKindOfClass:[UIViewController class]]){
        item = [(UIViewController*)item view];
    }
    
    if([item isKindOfClass:[UIView class]] && ![item isEqual:self.superview]){
        [(UIView*)item setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    self.sea_item1.translatesAutoresizingMaskIntoConstraints = NO;
}

- (UIView*)superview
{
    UIView *superview = self.sea_item1.superview;
    
#if  SeaDebug
    NSAssert(superview != nil, @"添加约束前，必须把view添加到父视图");
#endif
    
    return superview;
}

/**
 构建约束
 */
- (NSLayoutConstraint *(^)(void))build
{
    return ^(void){
        
        [self adjustAutoLayout];
        id item1 = self.sea_item1;
        id item2 = self.sea_item2;
        NSLayoutAttribute attr1 = self.sea_attr1;
        NSLayoutAttribute attr2 = self.sea_attr2;
        
        if([item2 isKindOfClass:[UIViewController class]]){
            UIViewController *viewController = (UIViewController*)item2;
            if(@available(iOS 11.0, *)){
                switch (attr1) {
                    case NSLayoutAttributeTop :
                    case NSLayoutAttributeLeft :
                    case NSLayoutAttributeLeading :
                    case NSLayoutAttributeRight :
                    case NSLayoutAttributeTrailing :
                    case NSLayoutAttributeBottom :
                        item2 = viewController.view.safeAreaLayoutGuide;
                        break;
                    default:
                        item2 = viewController.view;
                        break;
                }
            }else{
                switch (attr1) {
                    case NSLayoutAttributeTop :
                        item2 = viewController.topLayoutGuide;
                        attr2 = NSLayoutAttributeBottom;
                        break;
                    case NSLayoutAttributeBottom :
                        item2 = viewController.bottomLayoutGuide;
                        attr2 = NSLayoutAttributeTop;
                        break;
                    default:
                        item2 = viewController.view;
                        break;
                }
            }
        }
        
        if((attr1 == NSLayoutAttributeTrailing&& attr2 == NSLayoutAttributeTrailing)
           ||
           (attr1 == NSLayoutAttributeBottom && attr2 == NSLayoutAttributeBottom)
           ||
           (attr1 == NSLayoutAttributeTrailing && attr2 == NSLayoutAttributeLeading)
           ||
           (attr1 == NSLayoutAttributeBottom && attr2 == NSLayoutAttributeTop)){
            id item = item2;
            item2 = item1;
            item1 = item;
            
            NSLayoutAttribute attr = attr2;
            attr2 = attr1;
            attr1 = attr;
        }
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:item1 attribute:attr1 relatedBy:self.sea_relation toItem:item2 attribute:attr2 multiplier:self.sea_multiplier constant:self.sea_constant];
        constraint.priority = self.sea_priority;
        
        if(attr2){
            [[self superview] addConstraint:constraint];
        }else{
            [self.sea_item1 addConstraint:constraint];
        }
        
        [self reset];
        return constraint;
    };
}

@end

