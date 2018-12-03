//
//  SeaURLSessionMultiTask.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/21.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SeaHttpTask;
@class SeaURLSessionManager;

/**
 多个任务
 */
@interface SeaMultiTasks : NSObject

/**
 当有一个任务失败时，是否取消所有任务 default is 'YES'
 */
@property(nonatomic, assign) BOOL shouldCancelAllTaskWhileOneFail;

/**
 所有任务完成回调 hasFail 是否有任务失败了
 */
@property(nonatomic, copy) void(^completionHandler)(SeaMultiTasks *tasks, BOOL hasFail);

/**
 添加任务 key 为className
 */
- (void)addTask:(SeaHttpTask*) task;

/**
 添加任务
 
 @param task 对应任务，会通过 getURLSessionTask 添加
 不要需要调用 SeaHttpTask 的start方法
 SeaHttpTask中 onStart 方法将不会触发
 
 @param key 唯一标识符
 */
- (void)addTask:(SeaHttpTask*) task forKey:(NSString*) key;

/**
 添加任务

 @param task 对应任务 不需要调用 resume方法
 */
- (void)addURLSessionTask:(NSURLSessionTask*) task;

/**
 添加任务

 @param task 对应任务 不需要调用 resume方法
 @param manager 如果为nil，将使用 shareInstance
 */
- (void)addURLSessionTask:(NSURLSessionTask*) task URLSessionManager:(SeaURLSessionManager*) manager;

/**
 开始所有任务
 */
- (void)start;

/**
 串行执行所有任务，按照添加顺序来执行
 */
- (void)startSerially;

/**
 取消所有请求
 */
- (void)cancelAllTasks;

/**
 获取某个请求
 */
- (__kindof SeaHttpTask*)taskForKey:(NSString*) key;

@end
