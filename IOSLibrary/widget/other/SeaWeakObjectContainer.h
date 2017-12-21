//
//  SeaWeakObjectContainer.h
//  StandardShop
//
//  Created by 罗海雄 on 16/7/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

///主要用于类目中设置 weak的属性， 因为 objc_setAssociatedObject 是没有weak的
@interface SeaWeakObjectContainer : NSObject

@property(nonatomic,weak) id weakObject;

+ (instancetype)containerWithObject:(id) object;

@end
