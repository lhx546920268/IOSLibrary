//
//  SeaURLSessionMultiTask.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/21.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaMultiTasks.h"
#import "SeaHttpTask.h"
#import "SeaHttpTaskDelegate.h"
#import "SeaURLSessionManager.h"
#import "NSObject+Utils.h"

@interface SeaMultiTasks()<SeaHttpTaskDelegate>

///任务列表
@property(nonatomic, strong) NSMutableArray<NSURLSessionTask*> *tasks;

///是否有请求失败
@property(nonatomic, assign) BOOL hasFail;

///是否并发执行
@property(nonatomic, assign) BOOL concurrent;

///对应任务
@property(nonatomic, strong) NSMutableDictionary<NSString*, __kindof SeaHttpTask*> *taskDictionary;

@end

@implementation SeaMultiTasks

///保存请求队列的单例
+ (NSMutableSet*)sharedContainers
{
    static NSMutableSet *sharedContainers = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedContainers = [NSMutableSet set];
    });
    
    return sharedContainers;
}

- (void)dealloc
{
    
}

- (instancetype)init
{
    self = [super init];
    if(self){
        
        self.tasks = [NSMutableArray array];
        self.taskDictionary = [NSMutableDictionary dictionary];
        self.shouldCancelAllTaskWhileOneFail = YES;
    }
    
    return self;
}

- (void)addTask:(SeaHttpTask *)task
{
    [self addTask:task forKey:[task sea_nameOfClass]];
}

- (void)addTask:(SeaHttpTask*) task forKey:(NSString *)key
{
    [self.taskDictionary setObject:task forKey:key];
    [self addURLSessionTask:[task getURLSessionTask] URLSessionManager:task.URLSessionManager];
}

- (void)addURLSessionTask:(NSURLSessionTask*) task
{
    [self addURLSessionTask:task URLSessionManager:nil];
}

- (void)addURLSessionTask:(NSURLSessionTask*) task URLSessionManager:(SeaURLSessionManager*) manager
{
    if(!task)
        return;
    
    if(!manager)
        manager = [SeaURLSessionManager shareInstance];
    
    [self.tasks addObject:task];
    [manager addDelegate:self forTask:task];
}

- (void)start
{
    self.concurrent = YES;
    [self startTask];
}

- (void)startSerially
{
    self.concurrent = NO;
    [self startTask];
}

- (void)cancelAllTasks
{
    for(NSURLSessionTask *task in self.tasks){
        [task cancel];
    }
    [self.tasks removeAllObjects];
    [self.taskDictionary removeAllObjects];
    
    [[SeaMultiTasks sharedContainers] removeObject:self];
}

- (__kindof SeaHttpTask*)taskForKey:(NSString*) key
{
    return [self.taskDictionary objectForKey:key];
}

///开始任务
- (void)startTask
{
    [[SeaMultiTasks sharedContainers] addObject:self];
    self.hasFail = NO;
    
    if(self.concurrent){
        for(NSURLSessionTask *task in self.tasks){
            [task resume];
        }
    }else{
        [self startNextTask];
    }
}

///开始执行下一个任务 串行时用到
- (void)startNextTask
{
    NSURLSessionTask *task = [self.tasks firstObject];
    [task resume];
}

///删除任务
- (void)task:(NSURLSessionTask*) task didComplete:(BOOL) success
{
    [self.tasks removeObject:task];
    
    if(!success){
        self.hasFail = YES;
        if(self.shouldCancelAllTaskWhileOneFail){
            for(NSURLSessionTask *task in self.tasks){
                [task cancel];
            }
            [self.tasks removeAllObjects];
        }
    }
    
    if(self.tasks.count == 0){
        !self.completionHandler ?: self.completionHandler(self, self.hasFail);
        [self.taskDictionary removeAllObjects];
        [[SeaMultiTasks sharedContainers] removeObject:self];
        
    }else if (!self.concurrent){
        [self startNextTask];
    }
}

#pragma mark- SeaHttpTaskDelegate

- (void)URLSessionDataTask:(NSURLSessionDataTask *)dataTask didCompleteWithData:(NSData *)data error:(NSInteger)error
{
    [self task:dataTask didComplete:error == SeaHttpErrorCodeNoError];
}

- (void)URLSessionDownloadTask:(NSURLSessionDownloadTask *)downloadTask didCompleteWithURL:(NSURL *)URL error:(NSInteger)error
{
    [self task:downloadTask didComplete:error == SeaHttpErrorCodeNoError];
}

@end
