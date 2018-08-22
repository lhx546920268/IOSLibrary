//
//  SeaNumberBadge.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/15.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaNumberBadge.h"
#import "NSString+Utils.h"
#import "UIFont+Utils.h"
#import "UIColor+Utils.h"
#import "SeaBasic.h"

@interface SeaNumberBadge()

///内容大小
@property(nonatomic, assign) CGSize contentSize;

///文字大小
@property(nonatomic, assign) CGSize textSize;

@end

@implementation SeaNumberBadge

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self){
        [self initialization];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialization];
    }
    
    return self;
}

- (void)initialization
{
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = NO;
    self.shouldAutoAdjustSize = YES;
    _contentInsets = UIEdgeInsetsMake(3, 5, 3, 5);
    
    _fillColor = [UIColor redColor];
    _strokeColor = [UIColor clearColor];
    _textColor = [UIColor whiteColor];
    _font = [UIFont fontWithName:SeaMainFontName size:16];
    _pointRadius = 5.0;
    _hideWhenZero = YES;
    _max = 99;
    _shouldDisplayPlusSign = YES;
    self.hidden = YES;
}

- (CGSize)intrinsicContentSize
{
    return self.contentSize;
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_contentInsets, contentInsets)){
        _contentInsets = contentInsets;
        [self refresh];
    }
}

- (void)setContentSize:(CGSize)contentSize
{
    if(!CGSizeEqualToSize(_contentSize, contentSize)){
        _contentSize = contentSize;
        if(self.shouldAutoAdjustSize){
            self.bounds = CGRectMake(0, 0, _contentSize.width, _contentSize.height);
        }
        [self invalidateIntrinsicContentSize];
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef cx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(cx);
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    CGContextSetFillColorWithColor(cx, self.fillColor.CGColor );
    CGContextSetStrokeColorWithColor(cx, self.strokeColor.CGColor);
    CGContextSetLineWidth(cx, 1);
    
    if(self.point){
        CGContextAddArc(cx, width / 2, height / 2, self.pointRadius, 0, 2.0 * M_PI, YES);
        CGContextFillPath(cx);
    }else{
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:height / 2];
        CGContextAddPath(cx, path.CGPath);
        CGContextDrawPath(cx, kCGPathFillStroke);
        
        //绘制文字
        CGPoint point = CGPointMake((width - _textSize.width) / 2, (height - _textSize.height) / 2);
        NSDictionary *attrs = @{NSFontAttributeName : _font,
                                NSForegroundColorAttributeName : _textColor
                                };
        [self.value drawAtPoint:point withAttributes:attrs];
    }
    CGContextRestoreGState(cx);
}

#pragma mark- private method

- (void)setShouldDisplayPlusSign:(BOOL)shouldDisplayPlusSign
{
    if(_shouldDisplayPlusSign != shouldDisplayPlusSign){
        _shouldDisplayPlusSign = shouldDisplayPlusSign;
        [self refresh];
    }
}

- (void)setPoint:(BOOL)point
{
    if(_point != point){
        _point = point;
        [self refresh];
    }
}

- (void)setPointRadius:(CGFloat)pointRadius
{
    if(_pointRadius != pointRadius){
        _pointRadius = pointRadius;
        [self refresh];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if(![_textColor isEqualToColor:textColor]){
        if(!textColor){
            textColor = [UIColor whiteColor];
        }
        _textColor = textColor;
        [self setNeedsDisplay];
    }
}

- (void)setFont:(UIFont *)font
{
    if(![_font isEqualToFont:font]){
        if(!font){
            font = [UIFont fontWithName:SeaMainFontName size:16.0];
        }
        _font = font;
        [self refresh];
    }
}

- (void)setFillColor:(UIColor *)fillColor
{
    if(![_fillColor isEqualToColor:fillColor]){
        if(!fillColor){
            fillColor = [UIColor redColor];
        }
        _fillColor = fillColor;
        [self setNeedsDisplay];
    }
}

- (void)setStrokeColor:(UIColor *)strokeColor
{
    if(![_strokeColor isEqualToColor:strokeColor]){
        if(!strokeColor){
            strokeColor = [UIColor clearColor];
        }
        _strokeColor = strokeColor;
        [self setNeedsDisplay];
    }
}

- (void)setValue:(NSString *)value
{
    if(_value != value){
        if([NSString isEmpty:value])
            value = @"0";
        
        if([value isInteger]){
            int number = [value intValue];
            if(number < 0)
                number = 0;
            if(number <= self.max){
                _value = [NSString stringWithFormat:@"%d", number];
            }else{
                _value = _shouldDisplayPlusSign ? [NSString stringWithFormat:@"%d+", self.max] : [NSString stringWithFormat:@"%d", self.max];
            }
        }else{
            _value = [value copy];
        }
        
        [self refresh];
    }
}

///刷新
- (void)refresh
{
    if(self.hidden){
        return;
    }
    
    if(!self.value){
        self.hidden = YES;
        return;
    }
    
    BOOL zero = NO;
    if([self.value isInteger]){
        zero = [self.value intValue] == 0;
    }
    
    if([NSString isEmpty:self.value]){
        zero = YES;
    }
    
    self.hidden = zero && !self.point;
    
    CGSize contentSize = CGSizeZero;
    if(self.point){
        contentSize = CGSizeMake(self.pointRadius * 2, self.pointRadius * 2);
    }else{
        _textSize = [self.value sizeWithAttributes:@{NSFontAttributeName : _font}];
        
        CGFloat width = _textSize.width + self.contentInsets.left + self.contentInsets.right;
        CGFloat height = _textSize.height + self.contentInsets.top + self.contentInsets.bottom;
        
        contentSize.width = MAX(width, height);
        contentSize.height = height;
    }
    
    self.contentSize = contentSize;
    
    [self setNeedsDisplay];
}

@end

