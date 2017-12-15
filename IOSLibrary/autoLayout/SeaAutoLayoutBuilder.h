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

@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^leftToRight)(id item);

@property(nonatomic, readonly) SeaAutoLayoutBuilder* (^priority)(UILayoutPriority priority);


/**
 构建约束
 */
- (NSLayoutConstraint*)build;


/**
 创建一个构造器

 @param item 要设置约束的item
 @return 构造器
 */
+ (instancetype)builderWithItem:(id) item;

@end
