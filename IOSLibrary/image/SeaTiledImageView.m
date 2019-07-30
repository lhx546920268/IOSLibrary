//
//  SeaTiledImageView.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/3/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaTiledImageView.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaBasic.h"

@interface SeaTiledImageViewLayer : CATiledLayer

@end

@implementation SeaTiledImageViewLayer

+ (NSTimeInterval)fadeDuration
{
    return 0;
}

@end

@interface SeaTiledImageView()

/**
 背景 需要这个，否则在快速滑动时会出现闪烁
 */
@property(nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation SeaTiledImageView

+ (Class)layerClass
{
    return [SeaTiledImageViewLayer class];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.opaque = NO;
        self.userInteractionEnabled = NO;
        SeaTiledImageViewLayer *tiledLayer = (SeaTiledImageViewLayer*)[self layer];

        //设置砖块大小
        tiledLayer.levelsOfDetail = 4;
        tiledLayer.levelsOfDetailBias = 0;
        CGSize size = [UIScreen mainScreen].bounds.size;
        size.width *= [UIScreen mainScreen].scale;
        size.height *= [UIScreen mainScreen].scale;
        
        tiledLayer.tileSize = size;
    }
    
    return self;
}

- (void)setImage:(UIImage *)image
{
    if(_image != image){
        _image = image;
        if(!self.backgroundImageView){
            self.backgroundImageView = [UIImageView new];
            
            [self addSubview:self.backgroundImageView];
        }

        self.backgroundImageView.frame = self.bounds;
        [self adjust];
        
        [self setNeedsDisplay];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if(!CGRectEqualToRect(self.bounds, self.backgroundImageView.frame)){
        self.backgroundImageView.frame = self.bounds;
        [self adjust];
    }
}

- (void)adjust
{
    if([self shouldUseTile]){
        //压缩图片
        UIGraphicsBeginImageContext(self.bounds.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSaveGState(context);
        [self.image drawInRect:self.bounds];
        CGContextRestoreGState(context);
        UIImage *backgroundImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        self.backgroundImageView.image = backgroundImage;
        self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFit;
        
    }else{
        self.backgroundImageView.contentMode = self.contentMode;
        self.backgroundImageView.image = _image;
    }
}

-(void)drawRect:(CGRect)rect
{
    UIImage *image = self.image;
    
    if(image && [self shouldUseTile]){
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);

        //转换坐标系，防止颠倒
        CGAffineTransform transform = CGAffineTransformMake(1, 0, 0, -1, 0, rect.size.height);
        CGContextConcatCTM(ctx, transform);
        
        //截取要绘制的图片
        size_t width = CGImageGetWidth(image.CGImage) ;
        CGFloat scale = width / rect.size.width;
        
        CGRect imageRect =  CGRectMake(rect.origin.x, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
        CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, imageRect);
        
        //转换成 CG的 坐标系
        rect = CGRectApplyAffineTransform(rect, transform);
        CGContextDrawImage(ctx, rect, imageRef);
        CGImageRelease(imageRef);
        
        CGContextRestoreGState(ctx);
    }
}

///是否需要使用铺砖
- (BOOL)shouldUseTile
{
    return self.image.size.height > [UIScreen mainScreen].bounds.size.height * 3;
}

@end
