//
//  SeaObject.h
//  EasyToRun
//
//  Created by 罗海雄 on 17/9/18.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

///通过字典初始化
@interface SeaObject : NSObject

+ (instancetype)infoFromDictionary:(NSDictionary*) dic NS_REQUIRES_SUPER;

- (void)setDictionary:(NSDictionary*) dic;

@end
