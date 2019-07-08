//
//  SeaPhotosCheckBox.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/2.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosCheckBox.h"
#import "SeaBasic.h"
#import "UIColor+Utils.h"
#import "NSString+Utils.h"

@interface SeaPhotosCheckBox()

///文字大小
@property(nonatomic, assign) CGSize checkedTextSize;

@end

@implementation SeaPhotosCheckBox

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
    self.opaque = NO;
    self.font = [UIFont systemFontOfSize:12];
    self.padding = 5;
}

- (void)setCheckedText:(NSString *)checkedText
{
    if(![_checkedText isEqualToString:checkedText]){
        _checkedText = checkedText;
        self.checkedTextSize = [_checkedText sea_stringSizeWithFont:self.font contraintWith:UIScreen.screenWidth];
        [self setNeedsDisplay];
    }
}

- (void)setChecked:(BOOL)checked
{
    if(_checked != checked){
        _checked = checked;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    CGContextSetShadowWithColor(context, CGSizeZero, 1, [UIColor colorWithWhite:0.8 alpha:0.5].CGColor);
    CGFloat lineWidth = 1.0;
    CGContextSetLineWidth(context, lineWidth);
    
    if(self.checked){
        CGContextSetFillColorWithColor(context, SeaAppMainColor.CGColor);
        CGContextAddArc(context, rect.size.width / 2.0, rect.size.height / 2.0, rect.size.width / 2.0 - self.padding, 0, M_PI * 2, NO);
        CGContextFillPath(context);
        
        [self.checkedText drawAtPoint:CGPointMake((rect.size.width - self.checkedTextSize.width) / 2.0, (rect.size.height - self.checkedTextSize.height) / 2.0) withAttributes:@{NSFontAttributeName : self.font, NSForegroundColorAttributeName : SeaAppMainTintColor}];
    }else{
        CGContextAddArc(context, rect.size.width / 2.0, rect.size.height / 2.0, rect.size.width / 2.0 - lineWidth / 2.0 - self.padding, 0, M_PI * 2, NO);
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor.CGColor);
        CGContextStrokePath(context);
    }
    
    CGContextRestoreGState(context);
}

- (void)setChecked:(BOOL)checked animated:(BOOL)animated
{
    self.checked = checked;
    if(checked && animated){
        CASpringAnimation *animation = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
        animation.fromValue = @0.7;
        animation.toValue = @1.0;
        animation.duration = 0.5;
        [self.layer addAnimation:animation forKey:@"scale"];
    }
}

@end
