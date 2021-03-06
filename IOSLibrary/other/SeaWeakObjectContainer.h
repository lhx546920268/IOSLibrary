//
//  SeaWeakObjectContainer.h
//  IOSLibrary
//
//  Created by 罗海雄 on 16/7/14.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

///主要用于类目中设置 weak的属性， 因为 objc_setAssociatedObject 是没有weak的
@interface SeaWeakObjectContainer : NSObject

///需要weak引用的对象
@property(nonatomic,weak) id weakObject;

+ (instancetype)containerWithObject:(id) object;

@end
