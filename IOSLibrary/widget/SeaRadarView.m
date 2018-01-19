//
//  SeaRadarView.m
//  BeautifulLife
//
//  Created by 罗海雄 on 17/9/9.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaRadarView.h"
#import "UIColor+Utils.h"
#import "NSString+Utils.h"
#import "SeaBasic.h"

@implementation SeaRadarInfo


@end

@interface SeaRadarView()


@end

@implementation SeaRadarView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
    }
    return self;
}

///初始化
- (void)initialization
{
    self.redarStrokeColor = [UIColor sea_colorFromHex:@"bcbcbc"];
    self.dataStrokeColor = [UIColor sea_colorFromHex:@"28cec1"];
    self.innerFillColor = [UIColor sea_colorFromHex:@"a0d3da"];
    self.outerFillColor = [UIColor sea_colorFromHex:@"afe2e9"];
    self.offsetY = 10;
    self.maxValue = 100;
}

- (void)setRadarInfos:(NSArray<SeaRadarInfo *> *)radarInfos
{
    if(_radarInfos != radarInfos)
    {
        _radarInfos = radarInfos;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    if(_radarInfos.count == 0)
        return;
    
    CGContextRef cx = UIGraphicsGetCurrentContext();
    CGContextSetAllowsAntialiasing(cx, true);
    CGContextSetLineWidth(cx, 1);
    
    int count = (int)_radarInfos.count;
    int centerX = rect.size.width / 2.0;;
    int centerY = rect.size.height / 2.0 + self.offsetY;
    
    int outRadius = MIN(centerX, centerY);
    int radius = outRadius - 15 - self.offsetY;
    
    double radian = M_PI * 2 / 5;
    double startRadin = count % 2 == 0 ? 0 : M_PI / 2;
    
    
    //绘制蛛网
    float x;
    float y;
    for(int i = count;i > 0;i --)
    {
        int tmpRaidus = radius / count * i;

        
        x = (float)(centerX + cos(startRadin) * tmpRaidus);
        y = (float)(centerY - sin(startRadin) * tmpRaidus);
        
        CGContextMoveToPoint(cx, x, y);
        
        for(int j = 1;j <= count;j ++)
        {
            x = (float)(centerX + cos(startRadin + radian * j) * tmpRaidus);
            y = (float)(centerY - sin(startRadin + radian * j) * tmpRaidus);
            CGContextAddLineToPoint(cx, x, y);
        }
        
        CGContextSetStrokeColorWithColor(cx, _redarStrokeColor.CGColor);
        if(i % 2 == 0)
        {
            CGContextSetFillColorWithColor(cx, self.innerFillColor.CGColor);
        }
        else
        {
            CGContextSetFillColorWithColor(cx, self.outerFillColor.CGColor);
        }
        CGContextDrawPath(cx, kCGPathFillStroke);
    }
    
    
    //绘制多边形角上的点和中心连线
    for(int i = 0;i < count;i ++)
    {
        CGContextMoveToPoint(cx, centerX, centerY);
        x = (float)(centerX + cos(startRadin + radian * i) * radius);
        y = (float)(centerY - sin(startRadin + radian * i) * radius);
        CGContextAddLineToPoint(cx, x, y);
       
        CGContextSetStrokeColorWithColor(cx, self.redarStrokeColor.CGColor);
        CGContextStrokePath(cx);
    }
    
    
    //绘制数据线
    float startX = 0;
    float startY = 0;
    
    for(int i = 0;i < count;i ++)
    {
        SeaRadarInfo *info = [_radarInfos objectAtIndex:i];
        int tmpRadius = info.value / self.maxValue * radius;
        x = (float)(centerX + cos(startRadin + radian * i) * tmpRadius);
        y = (float)(centerY - sin(startRadin + radian * i) * tmpRadius);
        
        if(i == 0)
        {
            startX = x;
            startY = y;
            CGContextMoveToPoint(cx, startX, startY);
        }else
        {
            CGContextAddLineToPoint(cx, x, y);
            if(i == count - 1)
            {
                CGContextAddLineToPoint(cx, startX, startY);
            }
        }
    }
    
    CGContextSetStrokeColorWithColor(cx, self.dataStrokeColor.CGColor);
    CGContextStrokePath(cx);
    
    UIFont *font = [UIFont fontWithName:SeaMainFontName size:9.0];
    UIColor *textColor = self.dataStrokeColor;

    float fontHeight = font.descender - font.ascender;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName, textColor, NSForegroundColorAttributeName, nil];
    
    //绘制文字
    for(int i = 0;i < count;i ++)
    {
        SeaRadarInfo *info = [_radarInfos objectAtIndex:i];
        
        double tmpRadian = startRadin + radian * i;
        
        x = (float)(centerX + cos(tmpRadian) * (radius + fontHeight / 2));
        y = (float)(centerY - sin(tmpRadian) * (radius + fontHeight / 2));
        
        if(tmpRadian > M_PI * 2)
        {
            tmpRadian -= M_PI * 2;
        }
        
        if(tmpRadian >= 0 && tmpRadian <= M_PI_2)
        {
            //第1象限
            if(tmpRadian == M_PI_2)
            {
                float dis = [info.title sea_stringSizeWithFont:font contraintWith:rect.size.width].width;
                x -= dis / 2;
                y -= font.lineHeight + 10.0;
            }
            else
            {
                y -= font.lineHeight;
                x += 10.0;
            }
            
            [info.title drawAtPoint:CGPointMake(x, y) withAttributes:attributes];
        }
        else if(tmpRadian >= 3 * M_PI_2 && tmpRadian <= M_PI * 2)
        {
            //第4象限
            [info.title drawAtPoint:CGPointMake(x + 10, y) withAttributes:attributes];
        }
        else if(tmpRadian > M_PI_2 && tmpRadian <= M_PI)
        {
            //第2象限
            float dis = [info.title sea_stringSizeWithFont:font contraintWith:rect.size.width].width;//文本长度
            [info.title drawAtPoint:CGPointMake(x - dis - 10.0, y - font.lineHeight) withAttributes:attributes];
        }
        else if(tmpRadian >= M_PI && tmpRadian < 3 * M_PI_2)
        {
            //第3象限
            float dis = [info.title sea_stringSizeWithFont:font contraintWith:rect.size.width].width;//文本长度
            [info.title drawAtPoint:CGPointMake(x - dis - 10, y) withAttributes:attributes];
        }
    }
    

    //绘制点
    for(int i = 0;i < count;i ++)
    {
        SeaRadarInfo *info = [_radarInfos objectAtIndex:i];
        int tmpRadius = info.value / self.maxValue * radius;
        x = (float)(centerX + cos(startRadin + radian * i) * tmpRadius);
        y = (float)(centerY - sin(startRadin + radian * i) * tmpRadius);
        CGContextAddArc(cx, x, y, 1.5, 0, 2 * M_PI, 1);
       
        CGContextSetFillColorWithColor(cx, self.dataStrokeColor.CGColor);
        CGContextFillPath(cx);
    }
}

@end
