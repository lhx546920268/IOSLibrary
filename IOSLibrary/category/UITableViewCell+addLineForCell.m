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
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(14.0, bottom - SeaSeparatorHeight, SeaScreenWidth - 5.0, SeaSeparatorHeight)];
    [self addSubview:lineView];
    lineView.backgroundColor = SeaSeparatorColor;
}
- (void)addLineForTop{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.top, SeaScreenWidth, SeaSeparatorHeight)];
    [self addSubview:lineView];
    lineView.backgroundColor = SeaSeparatorColor;
}
- (void)addLineForTopWithFloat:(CGFloat)contentFloat{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(contentFloat, self.top, SeaScreenWidth - 2 * contentFloat, SeaSeparatorHeight)];
    [self addSubview:lineView];
    lineView.backgroundColor = SeaSeparatorColor;
}
@end
