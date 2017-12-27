//
//  SeaNumberKeyboard.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/23.
//  Copyright (c) 2015年 罗海雄. All rights reserved.
//

#import "SeaNumberKeyboard.h"
#import "SeaHighlightButton.h"
#import "UIImage+Utilities.h"
#import "UIView+Utils.h"
#import "SeaBasic.h"

@interface SeaNumberKeyboard ()

///其他按钮
@property(nonatomic,strong) UIButton *other_btn;

///删除按钮
@property(nonatomic,strong) UIButton *delete_btn;

/**
 *  长按删除计时器
 */
@property(nonatomic,strong) NSTimer *timer;

@end

@implementation SeaNumberKeyboard

/**初始化方法，必须通过该方法初始化
 *@param otherButtonTittle 左下角按钮标题
 *@return 已设置好frame 的实例
 */
- (instancetype)initWithotherButtonTittle:(NSString*) otherButtonTittle
{
    CGFloat buttonHeight = 54.0;
    NSInteger row = 4;
    CGFloat margin = 0.5;
    self = [super initWithFrame:CGRectMake(0, 0, SeaScreenWidth, buttonHeight * row + margin * (row - 1))];
    if(self)
    {
        if(otherButtonTittle == nil)
            otherButtonTittle = @"";
        self.backgroundColor = [UIColor grayColor];

        NSInteger countPerRow = 3;

        CGFloat buttonWidth = (self.width - (countPerRow - 1) * margin) / countPerRow;

        NSArray *titles = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", otherButtonTittle, @"0", [UIImage imageNamed:@"keyboard_delete"], nil];
        
        ///按钮背景图片
        UIImage *nor_bg_image = [UIImage imageWithColor:[UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1] size:CGSizeMake(1, 1)];
        UIImage *high_light_bg_image = [UIImage imageWithColor:[UIColor colorWithWhite:0.85 alpha:1.0] size:CGSizeMake(1, 1)];
        
        NSInteger currentRow = 0;
        NSInteger currentColumn = 0;
        
        for(int i = 0;i < titles.count;i ++)
        {
            if(i % countPerRow == 0)
            {
                currentColumn = 0;
                currentRow ++;
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            if(i != titles.count - 1)
            {
                NSString *title = [titles objectAtIndex:i];
                [btn setTitle:title forState:UIControlStateNormal];
                
                if(i == 9)
                {
                    self.other_btn = btn;
                    [btn setBackgroundImage:high_light_bg_image forState:UIControlStateNormal];
                    if(title.length > 0)
                    {
                        [btn setBackgroundImage:nor_bg_image forState:UIControlStateHighlighted];
                    }
                }
                else
                {
                    [btn setBackgroundImage:high_light_bg_image forState:UIControlStateHighlighted];
                    [btn setBackgroundImage:nor_bg_image forState:UIControlStateNormal];
                }
            }
            else
            {
                [btn setImage:[titles objectAtIndex:i] forState:UIControlStateNormal];
                self.delete_btn = btn;
                [btn setBackgroundImage:high_light_bg_image forState:UIControlStateNormal];
                [btn setBackgroundImage:nor_bg_image forState:UIControlStateHighlighted];
                [self.delete_btn addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
                [self.delete_btn addTarget:self action:@selector(touchCancel:) forControlEvents:UIControlEventTouchCancel];
            }
            
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:27.0];
            [btn addTarget:self action:@selector(buttonDidClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i;
            btn.frame = CGRectMake(currentColumn * (buttonWidth + margin), (buttonHeight + margin) * (currentRow - 1), buttonWidth, buttonHeight);
            
            [self addSubview:btn];
            currentColumn ++;
            
            self.inpuLimitMax = NSNotFound;
        }
    }
    
    return self;
}

- (void)buttonDidClick:(UIButton*) btn
{
    
    if([btn isEqual:self.delete_btn])
    {
        [self stopTimer];
    }
    else
    {
        NSRange range = self.textField.selectedRange;
        NSString *text = self.textField.text;
        NSString *title = [btn titleForState:UIControlStateNormal];
        if(text.length - range.length + title.length > self.inpuLimitMax)
        {
            return;
        }
        
        self.textField.text = [text stringByReplacingCharactersInRange:range withString:title];
        self.textField.selectedRange = NSMakeRange(range.location + title.length, 0);
    }
}

/**
 *  删除文本
 */
- (void)deleteText
{
    NSRange range = self.textField.selectedRange;
    NSString *text = self.textField.text;
    if(range.location != 0)
    {
        if(range.length == 0)
        {
            range = NSMakeRange(range.location - 1, 1);
        }
        self.textField.text = [text stringByReplacingCharactersInRange:range withString:@""];
        self.textField.selectedRange = NSMakeRange(range.location, 0);
    }
    else
    {
        [self stopTimer];
    }
}

/**
 *  按下
 */
- (void)touchDown:(id) sender
{
    [self deleteText];
    [self startTimer];
}

/**
 *  松开
 */
- (void)touchCancel:(id) sender
{
    [self stopTimer];
}

/**
 *  开启计时器
 */
- (void)startTimer
{
    if(!self.timer)
    {
        self.timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0.5] interval:0.15 target:self selector:@selector(deleteText) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

/**
 *  停止计时器
 */
- (void)stopTimer
{
    if(self.timer && [self.timer isValid])
    {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
