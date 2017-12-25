//
//  SeaDataBase.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/25.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FMDatabaseQueue;

/**
 数据库
 */
@interface SeaDataBase : NSObject

///数据库队列
@property(nonatomic,readonly) FMDatabaseQueue *dbQueue;

///数据库地址
@property(nonatomic,readonly) NSString *sqlitePath;

///数据库单例
+ (instancetype)sharedInstance;

@end
