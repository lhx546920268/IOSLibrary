//
//  SeaAutoLayoutBuilder.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/15.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaAutoLayoutBuilder.h"


@interface SeaAutoLayoutBuilder()

@property(nonatomic, strong) id sea_item1;

@property(nonatomic, strong) id sea_item2;

@property(nonatomic, assign) CGFloat sea_multiplier;

@property(nonatomic, assign) NSLayoutRelation sea_relation;

@property(nonatomic, assign) CGFloat sea_constant;

@property(nonatomic, assign) NSLayoutAttribute sea_attr1;

@property(nonatomic, assign) NSLayoutAttribute sea_attr2;

@property(nonatomic, assign) UILayoutPriority sea_priority;

@end

@implementation SeaAutoLayoutBuilder

- (instancetype)init
{
    self = [super init];
    if(self){
        self.sea_priority = SeaAutoLayoutPriorityDefault;
        self.sea_constant = 0;
        self.sea_multiplier = 0;
        self.sea_relation = NSLayoutRelationEqual;
    }
    return self;
}

/**
 创建一个构造器
 
 @param item 要设置约束的item
 @return 构造器
 */
+ (instancetype)builderWithItem:(id) item
{
    SeaAutoLayoutBuilder *builder = [SeaAutoLayoutBuilder new];
    builder.sea_item1 = item;
    
    
    return builder;
}

/**
 获取合适的item
 */
- (id)sea_fitItem:(id) item attribute:(NSLayoutAttribute) attribute
{
    if([item isKindOfClass:[UIViewController class]]){
        UIViewController *viewController = (UIViewController*)item;
        if(@available(iOS 11.0, *)){
            switch (attribute) {
                case NSLayoutAttributeTop :
                case NSLayoutAttributeLeft :
                case NSLayoutAttributeLeading :
                case NSLayoutAttributeRight :
                case NSLayoutAttributeTrailing :
                case NSLayoutAttributeBottom :
                    item = viewController.view.safeAreaLayoutGuide;
                    break;
                default:
                    item = viewController.view;
                    break;
            }
        }else{
            switch (attribute) {
                case NSLayoutAttributeTop :
                    item = viewController.topLayoutGuide;
                    break;
                case NSLayoutAttributeBottom :
                    item = viewController.bottomLayoutGuide;
                    break;
                default:
                    item = viewController.view;
                    break;
            }
        }
    }
    
    return item;
}

/**
 构建约束
 */
- (NSLayoutConstraint*)build
{
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.sea_item1 attribute:self.sea_attr1 relatedBy:NSLayoutRelationEqual toItem:self.sea_item2 attribute:self.sea_attr2 multiplier:self.sea_multiplier constant:self.sea_constant];
    constraint.priority = self.sea_priority;
}

@end
