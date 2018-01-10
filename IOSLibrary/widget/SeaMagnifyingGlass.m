//
//  SeaMagnifyingGlass.m
//  WanShoes
//
//  Created by 罗海雄 on 16/4/8.
//  Copyright (c) 2016年 罗海雄. All rights reserved.
//

#import "SeaMagnifyingGlass.h"

@interface SeaMagnifyingGlass ()

@end

@implementation SeaMagnifyingGlass


- (instancetype)init
{
    self = [self initWithFrame:CGRectMake(0, 0, 100.0, 100.0)];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.layer.borderColor = [[UIColor colorWithWhite:1.0 alpha:0.4] CGColor];
        self.layer.borderWidth = 2.0;
        self.layer.cornerRadius = frame.size.width / 2;
        self.layer.masksToBounds = YES;
        self.touchPointOffset = CGPointMake(- 60, - 70.0);
        self.scale = 1.5;
        self.viewToMagnify = nil;
        self.scaleAtTouchPoint = YES;
    }
    return self;
}

- (void)setFrame:(CGRect)f
{
    super.frame = f;
    self.layer.cornerRadius = f.size.width / 2;
}

- (void)setTouchPoint:(CGPoint)point
{
    if(!CGPointEqualToPoint(_touchPoint, point))
    {
        _touchPoint = point;
        self.center = CGPointMake(_touchPoint.x + _touchPointOffset.x, _touchPoint.y + _touchPointOffset.y);
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.frame.size.width / 2, self.frame.size.height / 2);
    CGContextScaleCTM(context, _scale, _scale);
    CGContextTranslateCTM(context, - _touchPoint.x, - _touchPoint.y + (self.scaleAtTouchPoint ? 0 : self.bounds.size.height / 2));
    [self.viewToMagnify.layer renderInContext:context];
}

@end
