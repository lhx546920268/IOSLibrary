//
//  SeaMagnifyingGlass.h
//  WanShoes
//
//  Created by 罗海雄 on 16/4/8.
//  Copyright (c) 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///放大镜
@interface SeaMagnifyingGlass : UIView

///需要放大的view
@property (nonatomic, strong) UIView *viewToMagnify;

///点击的位置
@property (nonatomic, assign) CGPoint touchPoint;

///偏移量，用来设置放大镜距离点击的位置
@property (nonatomic, assign) CGPoint touchPointOffset;

///放大倍数
@property (nonatomic, assign) CGFloat scale;


@property (nonatomic, assign) BOOL scaleAtTouchPoint;

@end
