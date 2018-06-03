//
//  SeaLoadingStyle.h
//  IOSLibrary
//
//  Created by luohaixiong on 2018/6/3.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

///加载 样式
@interface SeaLoadingStyle : NSObject

///页面第一次加载显示
@property(nonatomic, strong, nonnull) Class pageLoadingClass;

///加载失败页面
@property(nonatomic, strong, nonnull) Class failPageClass;

///网络指示器类
@property(nonatomic, strong, nonnull) Class networkActivityClass;

///单例
+ (nonnull instancetype)sharedInstance;

@end
