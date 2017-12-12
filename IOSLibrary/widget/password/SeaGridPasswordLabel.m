//
//  SeaGridPasswordLabel.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/31.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "SeaGridPasswordLabel.h"
#import "SeaBasic.h"

#define SeaGridPasswordItemStartTag 1800

@interface SeaGridPasswordLabel ()

/**数量
 */
@property(nonatomic,assign) int count;

@end

@implementation SeaGridPasswordLabel

/**初始化
 *@param count 字符数量
 */
- (id)initWithFrame:(CGRect)frame count:(int) count
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat lineWidth = 1.0;
        UIColor *lineColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        self.layer.borderColor = lineColor.CGColor;
        self.layer.borderWidth = lineWidth;
        
        self.count = count;
        CGFloat width = (self.width - lineWidth * (count - 1)) / count;
        for(int i = 0;i < count;i ++)
        {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((width + lineWidth) * i, 0, width, self.height)];
            label.textColor = [UIColor blackColor];
            label.font = [UIFont systemFontOfSize:20.0];
            label.tag = SeaGridPasswordItemStartTag + i;
            [self addSubview:label];
            label.textAlignment = NSTextAlignmentCenter;
            
            if(i != count - 1)
            {
                UIView *line = [[UIView alloc] initWithFrame:CGRectMake(label.right, 0, lineWidth, self.height)];
                line.backgroundColor = lineColor;
                [self addSubview:line];
            }
        }
    }
    
    return self;
}

- (void)setString:(NSString *)string
{
    _string = string;
    for(int i = 0; i < _string.length; i ++)
    {
        UILabel *label = (UILabel*)[self viewWithTag:SeaGridPasswordItemStartTag + i];
        label.text = @"●";
    }
    
    for(int i = (int)_string.length;i < self.count;i ++)
    {
        UILabel *label = (UILabel*)[self viewWithTag:SeaGridPasswordItemStartTag + i];
        label.text = nil;
    }
}

@end
