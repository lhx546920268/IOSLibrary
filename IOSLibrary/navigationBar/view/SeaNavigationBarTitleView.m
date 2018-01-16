//
//  SeaNavigationBarTitleView.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/16.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaNavigationBarTitleView.h"

@implementation SeaNavigationBarTitleView

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    _contentSize = UILayoutFittingExpandedSize;
}

- (CGSize)intrinsicContentSize
{
    return _contentSize;
}

- (void)setContentSize:(CGSize)contentSize
{
    if(!CGSizeEqualToSize(_contentSize, contentSize)){
        _contentSize = contentSize;
        [self invalidateIntrinsicContentSize];
    }
}

@end
