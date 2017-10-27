//
//  UITableViewCell+addLineForCell.m
//  WuMei
//
//  Created by qsit on 15/7/23.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import "UITableViewCell+addLineForCell.h"
#import "SeaBasic.h"

@implementation UITableViewCell (addLineForCell)
- (void)addLineForBottomWithBottomFloat:(CGFloat)bottom{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(14.0, bottom - _separatorLineWidth_, _width_ - 5.0, _separatorLineWidth_)];
    [self addSubview:lineView];
    lineView.backgroundColor = _separatorLineColor_;
}
- (void)addLineForTop{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.top, _width_, _separatorLineWidth_)];
    [self addSubview:lineView];
    lineView.backgroundColor = _separatorLineColor_;
}
- (void)addLineForTopWithFloat:(CGFloat)contentFloat{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(contentFloat, self.top, _width_ - 2 * contentFloat, _separatorLineWidth_)];
    [self addSubview:lineView];
    lineView.backgroundColor = _separatorLineColor_;
}
@end
