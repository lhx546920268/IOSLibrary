//
//  SeaDataBase.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/25.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaDataBase.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "SeaBasic.h"
#import "SeaFileManager.h"

@implementation SeaDataBase
{
    ///数据库队列
    FMDatabaseQueue *_dbQueue;
}

///浏览记录数据库单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t once = 0;
    static SeaDataBase *dataBase = nil;
    
    dispatch_once(&once, ^(void){
        
        dataBase = [SeaDataBase new];
    });
    
    return dataBase;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        //创建数据库连接
        NSString *sqlitePath = [self sqlitePath];
        _dbQueue = [[FMDatabaseQueue alloc] initWithPath:sqlitePath];

        [_dbQueue inDatabase:^(FMDatabase *db){
            
#if SeaDebug
            db.logsErrors = YES;
#endif
            if(![db open]){
                NSLog(@"不能打开数据库");
            }
        }];
    }
    
    return self;
}

- (void)dealloc
{
    [_dbQueue close];
}

- (FMDatabaseQueue*)dbQueue
{
    return _dbQueue;
}

///获取数据库地址
- (NSString*)sqlitePath
{
    NSString *docDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString *sqliteDirectory = [docDirectory stringByAppendingPathComponent:@"sqlite"];
    BOOL isDir = NO;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exist = [fileManager fileExistsAtPath:sqliteDirectory isDirectory:&isDir];
    
    if(!(exist && isDir)){
        if(![fileManager createDirectoryAtPath:sqliteDirectory withIntermediateDirectories:YES attributes:nil error:nil]){
            return nil;
        }else{
            ///防止iCloud备份
            [SeaFileManager addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:sqliteDirectory isDirectory:YES]];
        }
    }
    
    return [sqliteDirectory stringByAppendingPathComponent:@"lhx_sqlite"];
}

@end
