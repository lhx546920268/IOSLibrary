//
//  SeaCountDownButton.m
//  IOSLibrary
//
//  Created by 罗海雄 on 15/9/14.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import "SeaCountDownButton.h"
#import "SeaBasic.h"
#import "UIColor+Utils.h"
#import "SeaCountDownTimer.h"

@interface SeaCountDownButton ()

///计时器
@property(nonatomic, strong) SeaCountDownTimer *timer;

@end

@implementation SeaCountDownButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialization];
    }
    
    return self;
}

- (void)dealloc
{
    [self.timer stop];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        [self initialization];
    }
    return self;
}

/**初始化
 */
- (void)initialization
{
    self.countdownTimeInterval = 60;
    self.normalBackgroundColor = [UIColor clearColor];
    self.disableBackgroundColor = [UIColor clearColor];
    [self setTitleColor:SeaButtonTitleColor forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:SeaMainFontName size:15.0];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitle:@"60s" forState:UIControlStateDisabled];
    [self setTitleColor:SeaButtonDisableTitleColor forState:UIControlStateDisabled];
}

#pragma mark- property

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor
{
    if(![_normalBackgroundColor isEqualToColor:normalBackgroundColor]){
        if(normalBackgroundColor == nil)
            normalBackgroundColor = SeaButtonBackgroundColor;
        _normalBackgroundColor = normalBackgroundColor;
        if(!self.timing){
            self.backgroundColor = _normalBackgroundColor;
        }
    }
}

- (void)setDisableBackgroundColor:(UIColor *)disableBackgroundColor
{
    if(![_disableBackgroundColor isEqualToColor:disableBackgroundColor]){
        if(disableBackgroundColor == nil)
            disableBackgroundColor = SeaButtonDisableBackgroundColor;
        _disableBackgroundColor = disableBackgroundColor;
        if(self.timing){
            self.backgroundColor = _disableBackgroundColor;
        }
    }
}

#pragma mark- 计时器

- (BOOL)timing
{
    return self.timer.isExcuting;
}

- (void)startTimer
{
    if(!self.timer){
        WeakSelf(self);
        self.timer = [SeaCountDownTimer timerWithTime:self.countdownTimeInterval interval:1];
        self.timer.completionHandler = ^(void){
            [weakSelf onFinish];
        };
        self.timer.tickHandler = ^(NSTimeInterval timeLeft){
            [weakSelf countDown:timeLeft];
        };
    }
    [self.timer start];
    [self onStart];
}

/**停止计时
 */
- (void)stopTimer
{
    if(self.timing){
        [self.timer stop];
        [self onFinish];
    }
}

- (void)countDown:(NSTimeInterval) timeLeft
{
    [self setTitle:[NSString stringWithFormat:@"%ds", (int)timeLeft] forState:UIControlStateDisabled];
    !self.countDownHandler ?: self.countDownHandler(timeLeft);
}

///倒计时开始
- (void)onStart
{
    self.enabled = NO;
    self.backgroundColor = self.disableBackgroundColor;
}

///倒计时完成
- (void)onFinish
{
    self.enabled = YES;
    self.backgroundColor = self.normalBackgroundColor;
    !self.completionHandler ?: self.completionHandler();
}

@end
