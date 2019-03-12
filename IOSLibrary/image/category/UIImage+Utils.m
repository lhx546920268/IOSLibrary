//
//  UIImage+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UIImage+Utils.h"
#import "UIColor+Utils.h"


/**
 获取图片颜色空间
 */
static CGColorSpaceRef SeaImageColorSpaceCreateDeviceRGB(void)
{
    static CGColorSpaceRef colorSpaceRef;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    });
    
    return colorSpaceRef;
}

@implementation UIImage (Utils)

#pragma mark- init

+ (UIImage*)sea_bundleImageWithName:(NSString *)name
{
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:@"png"]];
}

+ (UIImage*)sea_imageFromAsset:(ALAsset *)asset
{
    return [UIImage sea_imageFromAsset:asset options:SeaAssetImageOptionsResolutionImage];
}

+ (UIImage*)sea_imageFromAsset:(ALAsset*) asset options:(SeaAssetImageOptions) options
{
    if(asset == nil)
        return nil;
    
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    
    UIImage *image = nil;
    
    switch (options){
        case SeaAssetImageOptionsFullScreenImage : {
            //满屏的图片朝向已调整为 UIImageOrientationUp
            image = [UIImage imageWithCGImage:[representation fullScreenImage]];
        }
            break;
        case SeaAssetImageOptionsResolutionImage : {
            //图片朝向可能不正确，需要调整
            //获取正确的图片方向
            UIImageOrientation orientation = UIImageOrientationUp;
            NSNumber *number = [asset valueForProperty:ALAssetPropertyOrientation];
            
            if(number != nil){
                orientation = [number intValue];
            }
            
            image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:representation.scale orientation:orientation];
        }
            break;
    }
    
    return image;
}

#pragma mark- resize

- (CGSize)sea_fitWithSize:(CGSize) size type:(SeaImageFitType) type
{
    return [UIImage sea_fitImageSize:self.size size:size type:type];
}

+ (CGSize)sea_fitImageSize:(CGSize) imageSize size:(CGSize) size type:(SeaImageFitType) type
{
    CGSize retSize = CGSizeZero;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if(width == height){
        width = MIN(width, size.width > size.height ? size.height : size.width);
        height = width;
    }else{
        CGFloat heightScale = height / size.height;
        CGFloat widthScale = width / size.width;
        
        switch (type) {
            case SeaImageFitTypeSize : {
                if(height >= size.height && width >= size.width){
                    if(heightScale > widthScale){
                        height = floorf(height / heightScale);
                        width = floorf(width / heightScale);
                    }else{
                        height = floorf(height / widthScale);
                        width = floorf(width / widthScale);
                    }
                } else {
                    if(height >= size.height && width <= size.width) {
                        height = floorf(height / heightScale);
                        width = floorf(width / heightScale);
                    } else if(height <= size.height && width >= size.width){
                        height = floorf(height / widthScale);
                        width = floorf(width / widthScale);
                    }
                }
            }
                break;
            case SeaImageFitTypeWidth : {
                if(width > size.width) {
                    height = floorf(height / widthScale);
                    width = floorf(width / widthScale);
                }
            }
                break;
            case SeaImageFitTypeHeight : {
                if(height > size.height) {
                    height = floorf(height / heightScale);
                    width = floorf(width / heightScale);
                }
            }
                break;
            default:
                break;
        }
    }
    
    retSize = CGSizeMake(width, height);
    return retSize;
}

- (UIImage*)sea_aspectFitWithSize:(CGSize)size
{
    CGImageRef cgImage = self.CGImage;
    size_t width = CGImageGetWidth(cgImage) / SeaImageScale;
    size_t height = CGImageGetHeight(cgImage) / SeaImageScale;
    
    size = [UIImage sea_fitImageSize:CGSizeMake(width, height) size:size type:SeaImageFitTypeSize];
    
    if(size.height >= height || size.width >= width)
        return self;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, SeaImageScale);
    CGRect imageRect = CGRectMake(0.0, 0.0, floorf(size.width), floorf(size.height));
    [self drawInRect:imageRect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    thumbnail = [UIImage imageWithCGImage:thumbnail.CGImage scale:thumbnail.scale orientation:thumbnail.imageOrientation];
    
    return thumbnail;
}

- (UIImage*)sea_aspectFillWithSize:(CGSize)size
{
    UIImage *ret = nil;
    
    if(self.size.width == self.size.height && size.width == size.height) {
        //正方形图片
        ret = self;
    } else {
        CGFloat multipleWidthNum = self.size.width / size.width;
        CGFloat multipleHeightNum = self.size.height / size.height;
        
        CGFloat scale = MIN(multipleWidthNum, multipleHeightNum);
        int width = size.width * scale;
        int height = size.height * scale;
        ret = [self sea_subImageWithRect:CGRectMake((self.size.width - width) / 2.0, (self.size.height - height) / 2.0, width, height)];
    }
    
    return [ret sea_aspectFitWithSize:size];
}

- (UIImage*)sea_subImageWithRect:(CGRect)rect
{
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(rect.size.width), floorf(rect.size.height)), NO, SeaImageScale);
    
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (unsigned char *)sea_bitmap
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    unsigned char *bitmap;
    size_t bitmapSize;
    size_t bytesPerRow;
    
    CGImageRef image = self.CGImage;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    bytesPerRow = (width * 4);
    bitmapSize = (bytesPerRow * height);
    
    bitmap = malloc( bitmapSize );
    if (bitmap == NULL) {
        return NULL;
    }
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL) {
        free(bitmap);
        return NULL;
    }
    
    CGBitmapInfo kBGRxBitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    context = CGBitmapContextCreate (bitmap,
                                     width,
                                     height,
                                     CGImageGetBitsPerComponent(image),
                                     bytesPerRow,
                                     colorSpace,
                                     kBGRxBitmapInfo);
    
    CGColorSpaceRelease(colorSpace);
    
    if (context == NULL) {
        free (bitmap);
        return NULL;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    return bitmap;
}

- (UIImage*)sea_decompressedImage
{
    CGImageRef imageRef = self.CGImage;
    
    //判断是否包含透明通道
    CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
    if(alphaInfo == kCGImageAlphaPremultipliedLast
       || alphaInfo == kCGImageAlphaPremultipliedFirst
       || alphaInfo == kCGImageAlphaLast
       || alphaInfo == kCGImageAlphaFirst){
        return self;
    }
    
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 0, SeaImageColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst);
    if(context == NULL){
        return self;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    UIImage *image = [[UIImage alloc] initWithCGImage:decompressedImageRef scale:self.scale orientation:self.imageOrientation];
    
    CGImageRelease(decompressedImageRef);
    CGContextRelease(context);
    
    return image;
}


- (UIImage*)sea_deepCopy
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(self.size.width), floorf(self.size.height)), NO, SeaImageScale);
    
    [self drawAtPoint:CGPointMake(0, 0)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage*)sea_imageWithCornerRadius:(CGFloat) cornerRradius borderWidth:(CGFloat) borderWidth borderColor:(UIColor*) borderColor
{
    CGImageRef imageR = self.CGImage;
    size_t width = CGImageGetWidth(imageR);
    size_t height = CGImageGetHeight(imageR);
    
    
    borderWidth *= self.scale;
    cornerRradius *= self.scale;
    
    ///创建位图
    CGSize size = CGSizeMake(floorf(width), floorf(height));
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, size.width, size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    
    if(context == NULL)
        return nil;
    
    //切割画板
    CGContextSetLineWidth(context, 0);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    
    //绘制圆角矩形边框
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:cornerRradius];
    CGContextAddPath(context, path.CGPath);
    CGContextClip(context);
    
    //绘图
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    
    if(borderColor != nil){
        ///绘制边框
        CGContextSetLineWidth(context, borderWidth * 2);
        CGContextSetStrokeColorWithColor(context, borderColor.CGColor);
        path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width, height) cornerRadius:cornerRradius];
        CGContextAddPath(context, path.CGPath);
        CGContextStrokePath(context);
    }
    
    CGImageRef imageRef = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    
    if(imageRef == NULL)
        return nil;
    
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    
    return image;
}

#pragma mark- 创建图片

+ (UIImage*)sea_imageFromView:(UIView *)view
{
    return [UIImage sea_imageFromLayer:view.layer];
}

+ (UIImage*)sea_imageFromLayer:(CALayer*) layer
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floor(layer.bounds.size.width), floor(layer.bounds.size.height)), layer.opaque, SeaImageScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [layer renderInContext:context];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

+ (UIImage*)sea_imageWithColor:(UIColor*) color size:(CGSize) size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, SeaImageScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [color setFill];
    CGContextAddRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextDrawPath(context, kCGPathFill);

    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

#pragma mark- QRCode 二维码

+ (UIImage*)sea_qrCodeImageWithString:(NSString*) string
                  correctionLevel:(SeaQRCodeImageCorrectionLevel) correctionLevel
                             size:(CGSize) size
                     contentColor:(UIColor*) contentColor
                  backgroundColor:(UIColor*) backgroundColor
                             logo:(UIImage*) logo
{
    
    if(string == nil)
        return nil;
    
    ///设置默认属性
    if(contentColor == nil)
        contentColor = [UIColor blackColor];
    if(backgroundColor == nil)
        backgroundColor = [UIColor whiteColor];
    
    if(CGSizeEqualToSize(size, CGSizeZero)){
        size = CGSizeMake(240.0, 240.0);
    }
    
    NSString *level = nil;
    switch (correctionLevel){
        case SeaQRCodeImageCorrectionLevelPercent7 :
            level = @"L";
            break;
        case SeaQRCodeImageCorrectionLevelPercent15 :
            level = @"M";
            break;
        case SeaQRCodeImageCorrectionLevelPercent25 :
            level = @"Q";
            break;
        case SeaQRCodeImageCorrectionLevelPercent30 :
            level = @"H";
            break;
    }
    
    ///通过coreImage生成默认的二维码图片
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:[string dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    [filter setValue:level forKey:@"inputCorrectionLevel"];
    
    CIImage *ciImage = filter.outputImage;
    
    ///把它生成给定大小的图片
    CGRect rect = CGRectIntegral(ciImage.extent);
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef imageRef = [context createCGImage:ciImage fromRect:rect];
    
    if(imageRef == NULL)
        return nil;
    
    ///创建位图
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    ///获取实际生成的图片宽高
    size_t width = CGImageGetWidth(imageRef);
    size_t height = CGImageGetHeight(imageRef);
    
    ///计算需要的二维码图片宽高比例
    CGFloat w_scale = size.width / (CGFloat)width;
    CGFloat h_scale = size.height / (CGFloat)height;
    
    width *= w_scale;
    height *= h_scale;
    
    size_t bytesPerRow = width * 4; ///每行字节数
    uint32_t *data = malloc(bytesPerRow * height); ///创建像素存储空间
    CGContextRef cx = CGBitmapContextCreate(data, width, height, 8, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Little);
    CGColorSpaceRelease(colorSpace);
    
    if(cx == NULL){
        CGImageRelease(imageRef);
        free(data);
        return nil;
    }
    
    CGContextSetInterpolationQuality(cx, kCGInterpolationNone); ///设置二维码质量，否则二维码图片会变模糊，可无损放大
    CGContextScaleCTM(cx, w_scale, h_scale); ///调整坐标系比例
    CGContextDrawImage(cx, rect, imageRef);
    
    CGImageRelease(imageRef);
    
    ///也可以使用 CIFalseColor 类型的滤镜来改变二维码背景颜色和二维码颜色
    
    ///如果二维码颜色不是黑色 并且背景不是白色 ，改变它的颜色
    if(![contentColor isEqualToColor:[UIColor blackColor]]
       || ![backgroundColor isEqualToColor:[UIColor whiteColor]]){
        ///获取颜色的rgba值
        NSDictionary *dic = [contentColor sea_colorARGB];
        int c_red = [[dic objectForKey:SeaColorRed] floatValue] * 255;
        int c_green = [[dic objectForKey:SeaColorGreen] floatValue] * 255;
        int c_blue = [[dic objectForKey:SeaColorBlue] floatValue] * 255;
        int c_alpha = [[dic objectForKey:SeaColorAlpha] floatValue] * 255;
        
        dic = [backgroundColor sea_colorARGB];
        int b_red = [[dic objectForKey:SeaColorRed] floatValue] * 255;
        int b_green = [[dic objectForKey:SeaColorGreen] floatValue] * 255;
        int b_blue = [[dic objectForKey:SeaColorBlue] floatValue] * 255;
        int b_alpha = [[dic objectForKey:SeaColorAlpha] floatValue] * 255;
        
        
        ///遍历图片的像素并改变值，像素是一个二维数组， 每个像素由RGBA的数组组成，在数组中的排列顺序是从右到左即 array[0] 是 A阿尔法通道
        uint32_t *tmpData = data; ///创建临时的数组指针，保持data的指针指向为起始位置
        for(size_t i = 0;i < height; i ++){
            for(size_t j = 0;j < width; j ++){
                if((*tmpData & 0xFFFFFF) < 0x999999){ ///判断是否是背景像素，白色是背景
                    ///改变二维码颜色
                    uint8_t *ptr = (uint8_t*)tmpData;
                    ptr[3] = c_red;
                    ptr[2] = c_green;
                    ptr[1] = c_blue;
                    ptr[0] = c_alpha;
                }else{
                    ///改变背景颜色
                    uint8_t *ptr = (uint8_t*)tmpData;
                    ptr[3] = b_red;
                    ptr[2] = b_green;
                    ptr[1] = b_blue;
                    ptr[0] = b_alpha;
                }
                
                tmpData ++; ///指针指向下一个像素
            }
        }
    }
    
    ///绘制logo 圆角有锯齿，暂无解决方案
    //    if(logo)
    //    {
    //        ///因为前面 画板已缩放过了，这里的坐标系要调整比例
    //        CGImageRef logoRef = logo.CGImage;
    //        width = logo.size.width / w_scale;
    //        height = logo.size.height / h_scale;
    //        rect = CGRectMake((size.width / w_scale - width) / 2.0, (size.height / h_scale - height) / 2.0, width, height);
    //        CGContextDrawImage(cx, rect, logoRef);
    //    }
    
    ///从画板中获取二维码图片
    CGImageRef qrImageRef = CGBitmapContextCreateImage(cx);
    CGContextRelease(cx);
    free(data);
    
    if(qrImageRef == NULL)
        return nil;
    
    UIImage *image = [UIImage imageWithCGImage:qrImageRef];
    CGImageRelease(qrImageRef);
    
    ///绘制logo 没有锯齿
    if(logo){
        CGSize size = CGSizeMake(floorf(image.size.width), floorf(image.size.height));
        UIGraphicsBeginImageContextWithOptions(size, NO, SeaImageScale);
        
        [image drawAtPoint:CGPointZero];
        [logo drawAtPoint:CGPointMake((size.width - logo.size.width) / 2.0, (size.height - logo.size.height) / 2.0)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    return image;
}

@end
