//
//  SeaImageFilterColorMatrix.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/27.
//  Copyright (c) 2015年 luohaixiong. All rights reserved.
//

#import "SeaImageFilterColorMatrix.h"


@implementation SeaImageFilterColorMatrix

#pragma mark- 颜色矩阵

//LOMO
const float colormatrix_lomo[] = {
    1.7f,  0.1f, 0.1f, 0, -73.1f,
    0,  1.7f, 0.1f, 0, -73.1f,
    0,  0.1f, 1.6f, 0, -73.1f,
    0,  0, 0, 1.0f, 0 };

//黑白
const float colormatrix_heibai[] = {
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0.8f,  1.6f, 0.2f, 0, -163.9f,
    0,  0, 0, 1.0f, 0 };
//复古
const float colormatrix_huajiu[] = {
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0.2f, 0.5f, 0.1f, 0, 40.8f,
    0.2f,0.5f, 0.1f, 0, 40.8f,
    0, 0, 0, 1, 0 };

//哥特
const float colormatrix_gete[] = {
    1.9f,-0.3f, -0.2f, 0,-87.0f,
    -0.2f, 1.7f, -0.1f, 0, -87.0f,
    -0.1f,-0.6f, 2.0f, 0, -87.0f,
    0, 0, 0, 1.0f, 0 };

//锐化
const float colormatrix_ruise[] = {
    4.8f,-1.0f, -0.1f, 0,-388.4f,
    -0.5f,4.4f, -0.1f, 0,-388.4f,
    -0.5f,-1.0f, 5.2f, 0,-388.4f,
    0, 0, 0, 1.0f, 0 };


//淡雅
const float colormatrix_danya[] = {
    0.6f,0.3f, 0.1f, 0,73.3f,
    0.2f,0.7f, 0.1f, 0,73.3f,
    0.2f,0.3f, 0.4f, 0,73.3f,
    0, 0, 0, 1.0f, 0 };

//酒红
const float colormatrix_jiuhong[] = {
    1.2f,0.0f, 0.0f, 0.0f,0.0f,
    0.0f,0.9f, 0.0f, 0.0f,0.0f,
    0.0f,0.0f, 0.8f, 0.0f,0.0f,
    0, 0, 0, 1.0f, 0 };

//清宁
const float colormatrix_qingning[] = {
    0.9f, 0, 0, 0, 0,
    0, 1.1f,0, 0, 0,
    0, 0, 0.9f, 0, 0,
    0, 0, 0, 1.0f, 0 };

//浪漫
const float colormatrix_langman[] = {
    0.9f, 0, 0, 0, 63.0f,
    0, 0.9f,0, 0, 63.0f,
    0, 0, 0.9f, 0, 63.0f,
    0, 0, 0, 1.0f, 0 };

//光晕
const float colormatrix_guangyun[] = {
    0.9f, 0, 0,  0, 64.9f,
    0, 0.9f,0,  0, 64.9f,
    0, 0, 0.9f,  0, 64.9f,
    0, 0, 0, 1.0f, 0 };

//蓝调
const float colormatrix_landiao[] = {
    2.1f, -1.4f, 0.6f, 0.0f, -31.0f,
    -0.3f, 2.0f, -0.3f, 0.0f, -31.0f,
    -1.1f, -0.2f, 2.6f, 0.0f, -31.0f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//梦幻
const float colormatrix_menghuan[] = {
    0.8f, 0.3f, 0.1f, 0.0f, 46.5f,
    0.1f, 0.9f, 0.0f, 0.0f, 46.5f,
    0.1f, 0.3f, 0.7f, 0.0f, 46.5f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

//夜色
const float colormatrix_yese[] = {
    1.0f, 0.0f, 0.0f, 0.0f, -66.6f,
    0.0f, 1.1f, 0.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 1.0f, 0.0f, -66.6f,
    0.0f, 0.0f, 0.0f, 1.0f, 0.0f
};

/**滤镜名称
 *@retrun 数组元素是 NSString
 */
+ (NSArray*)filterNames
{
    return [NSArray arrayWithObjects:@"原图",@"LOMO",@"黑白",@"复古",@"哥特",@"锐色",@"淡雅",@"酒红",@"青柠",@"浪漫",@"光晕",@"蓝调",@"梦幻",@"夜色", nil];
}

/**通过滤镜名称下标获取颜色矩阵
 *@param index 滤镜名称下标
 *@return 颜色矩阵
 */
+ (const float*) colorMartrixForIndex:(NSInteger) index
{
    switch (index)
    {
        case 1 :
            return colormatrix_lomo;
            break;
        case 2 :
            return colormatrix_heibai;
            break;
        case 3 :
            return colormatrix_huajiu;
            break;
        case 4 :
            return colormatrix_gete;
            break;
        case 5 :
            return colormatrix_ruise;
            break;
        case 6 :
            return colormatrix_danya;
            break;
        case 7 :
            return colormatrix_jiuhong;
            break;
        case 8 :
            return colormatrix_qingning;
            break;
        case 9 :
            return colormatrix_langman;
            break;
        case 10 :
            return colormatrix_guangyun;
            break;
        case 11 :
            return colormatrix_landiao;
            break;
        case 12 :
            return colormatrix_menghuan;
            break;
        case 13 :
            return colormatrix_yese;
            break;
        default:
            return NULL;
            break;
    }
}

//修改RGB的值
static void changeRGBA(int *red,int *green,int *blue,int *alpha, const float* f)
{
    int redV = *red;
    int greenV = *green;
    int blueV = *blue;
    int alphaV = *alpha;
    
    *red = f[0] * redV + f[1] * greenV + f[2] * blueV + f[3] * alphaV + f[4];
    *green = f[0 + 5] * redV + f[1 + 5] * greenV + f[2 + 5] * blueV + f[3 + 5] * alphaV + f[4 + 5];
    *blue = f[0 + 5 * 2] * redV + f[1 + 5 * 2] * greenV + f[2 + 5 * 2] * blueV + f[3 + 5 * 2] * alphaV + f[4 + 5 * 2];
    *alpha = f[0 + 5 * 3] * redV + f[1 + 5 * 3] * greenV + f[2 + 5 * 3] * blueV + f[3 + 5 * 3] * alphaV + f[4 + 5 * 3];
    
    if (*red > 255)
    {
        *red = 255;
    }
    if(*red < 0)
    {
        *red = 0;
    }
    if(*green > 255)
    {
        *green = 255;
    }
    if(*green < 0)
    {
        *green = 0;
    }
    if(*blue > 255)
    {
        *blue = 255;
    }
    if(*blue < 0)
    {
        *blue = 0;
    }
    if(*alpha > 255)
    {
        *alpha = 255;
    }
    if(*alpha < 0)
    {
        *alpha = 0;
    }
}

/**通过颜色矩阵获取滤镜图片
 *@param inImage 原图
 *@param colorMatrix 颜色矩阵
 *@return 结果图片
 */
+ (UIImage*)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*) colorMatrix
{
    if(colorMatrix == NULL)
        return inImage;
    
    //获取图片RGB数据
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    
    unsigned char *imgPixel;
    size_t bitmapSize;
    size_t bytesPerRow;
    
    CGImageRef image = inImage.CGImage;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    bytesPerRow   = (width * 4);
    bitmapSize     = (bytesPerRow * height);
    
    imgPixel = malloc( bitmapSize );
    if (imgPixel == NULL)
    {
        return inImage;
    }
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        free(imgPixel);
        return inImage;
    }
    
    CGBitmapInfo kBGRxBitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;
    context = CGBitmapContextCreate (imgPixel,
                                     width,
                                     height,
                                     8,
                                     bytesPerRow,
                                     colorSpace,
                                     kBGRxBitmapInfo);
    
    CGColorSpaceRelease( colorSpace );
    
    if (context == NULL)
    {
        free (imgPixel);
        return inImage;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    if(imgPixel == NULL)
        return inImage;
    
    int wOff = 0;
    int pixOff = 0;
    
    for(size_t y = 0;y < height;y ++)//双层循环按照长宽的像素个数迭代每个像素点
    {
        pixOff = wOff;
        
        for (size_t x = 0; x < width; x ++)
        {
            int red = (unsigned char)imgPixel[pixOff];
            int green = (unsigned char)imgPixel[pixOff+1];
            int blue = (unsigned char)imgPixel[pixOff+2];
            int alpha = (unsigned char)imgPixel[pixOff+3];
            changeRGBA(&red, &green, &blue, &alpha, colorMatrix);
            
            //回写数据
            imgPixel[pixOff] = red;
            imgPixel[pixOff + 1] = green;
            imgPixel[pixOff + 2] = blue;
            imgPixel[pixOff + 3] = alpha;
            
            
            pixOff += 4; //将数组的索引指向下四个元素
        }
        
        wOff += width * 4;
    }
    
    NSInteger dataLength = width * height * 4;
    
    //下面的代码创建要输出的图像的相关参数
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, imgPixel, dataLength, dataProviderReleaseData);
    
    size_t bitsPerComponent = 8;
    size_t bitsPerPixel = 32;
    bytesPerRow = 4 * width;
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    
    
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow,colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);//创建要输出的图像
    
    UIImage *myImage = [UIImage imageWithCGImage:imageRef];
    
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);
    
    
    return myImage;
}

/**CGDataProviderRef 内存释放回调 data必须在此地释放，否则会出现图片像素出错
 */
void dataProviderReleaseData(void *info, const void *data,
                             size_t size)
{
    free((void*)data);
}

/**系统滤镜名称
 */
+ (NSArray*)systemFilterNames
{
    return [NSArray arrayWithObjects:@"original", @"sunny" ,@"sweat",@"cool",@"impress", @"clear", @"memory" ,@"film",@"maple",@"veliva" , @"fantacy", nil];
}

struct CubeMap {
    int length;
    float dimension;
    float *data;
};

struct CubeMap createCubeMap(float minHueAngle, float maxHueAngle) {
    const unsigned int size = 64;
    struct CubeMap map;
    map.length = size * size * size * sizeof (float) * 4;
    map.dimension = size;
    float *cubeData = (float *)malloc (map.length);
    float rgb[3], hsv[3], *c = cubeData;
    
    for (int z = 0; z < size; z++){
        rgb[2] = ((double)z)/(size-1); // Blue value
        for (int y = 0; y < size; y++){
            rgb[1] = ((double)y)/(size-1); // Green value
            for (int x = 0; x < size; x ++){
                rgb[0] = ((double)x)/(size-1); // Red value
                rgbToHSV(rgb,hsv);
                // Use the hue value to determine which to make transparent
                // The minimum and maximum hue angle depends on
                // the color you want to remove
                float alpha = (hsv[0] > minHueAngle && hsv[0] < maxHueAngle) ? 0.0f: 1.0f;
                // Calculate premultiplied alpha values for the cube
                c[0] = rgb[0] * alpha;
                c[1] = rgb[1] * alpha;
                c[2] = rgb[2] * alpha;
                c[3] = alpha;
                c += 4; // advance our pointer into memory for the next color value
            }
        }
    }
    map.data = cubeData;
    return map;
}

void rgbToHSV(float *rgb, float *hsv) {
    float min, max, delta;
    float r = rgb[0], g = rgb[1], b = rgb[2];
    float *h = hsv, *s = hsv + 1, *v = hsv + 2;
    
    min = fmin(fmin(r, g), b );
    max = fmax(fmax(r, g), b );
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h = 2 + ( b - r ) / delta;
    else
        *h = 4 + ( r - g ) / delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}

/**通过下标获取滤镜图片
 *@param inImage 要生成滤镜的图片
 *@param context 上下文
 *@param index 对应 systemFilterNames 的下标
 */
+ (UIImage*)imageWithImage:(UIImage*) inImage inContent:(CIContext*) context forIndex:(NSInteger) index
{
    if(index == 0)
        return inImage;
    
    CIFilter *filter = nil;
    switch (index)
    {
        case 5 :
        {
            CIImage *inputImage = [CIImage imageWithCGImage:inImage.CGImage];
            NSArray *filters = [inputImage autoAdjustmentFiltersWithOptions:nil];
            for(CIFilter *filter in filters)
            {
                [filter setValue:inputImage forKey:kCIInputImageKey];
                inputImage = filter.outputImage;
            }
            CGRect cropRect = [inputImage extent];
            if(cropRect.size.width >= NSNotFound || cropRect.size.height >= NSNotFound)
            {
                cropRect = CGRectMake(0, 0, inImage.size.width, inImage.size.height);
            }
            
            CGImageRef imageRef = [context createCGImage:inputImage fromRect:cropRect];
            
            UIImage *retImage = [UIImage imageWithCGImage:imageRef];
            
            CGImageRelease(imageRef);
            
            return retImage;
        }
        case 3 :
        {
            filter = [CIFilter filterWithName:@"CIPhotoEffectTonal"];
        }
            break;
        case 9 :
        {
            filter = [CIFilter filterWithName:@"CIColorCubeWithColorSpace"];
        }
            break;
        case 10 :
        {
            filter = [CIFilter filterWithName:@"CIPhotoEffectProcess"];
        }
            break;
        case 1 :
        {
            filter = [CIFilter filterWithName:@"CIPhotoEffectTransfer"];
        }
            break;
        case 4 :
        {
            filter = [CIFilter filterWithName:@"CIPhotoEffectChrome"];
        }
            break;
        case 6 :
        {
            filter = [CIFilter filterWithName:@"CITemperatureAndTint"];
        }
            break;
        case 8 :
        {
            filter = [CIFilter filterWithName:@"CIPhotoEffectNoir"];
        }
            break;
        case 2 :
        {
            filter = [CIFilter filterWithName:@"CIPhotoEffectInstant"];
        }
            break;
        case 7 :
        {
            filter = [CIFilter filterWithName:@"CIPhotoEffectFade"];
        }
            break;
    }
    
    if(filter != nil)
    {
        CIImage *inputImage = [CIImage imageWithCGImage:inImage.CGImage];
        [filter setValue:inputImage forKey:kCIInputImageKey];
        [filter setDefaults];
        
       
        CIImage *outputImage = [filter outputImage];
        
        
        
        CGRect cropRect = [outputImage extent];
        if(cropRect.size.width >= NSNotFound || cropRect.size.height >= NSNotFound)
        {
            cropRect = CGRectMake(0, 0, inImage.size.width, inImage.size.height);
        }
        
        CGImageRef imageRef = [context createCGImage:outputImage fromRect:cropRect];
        
        UIImage *retImage = [UIImage imageWithCGImage:imageRef];
        
        CGImageRelease(imageRef);
        
        return retImage;
    }
    
    return nil;
}


@end
