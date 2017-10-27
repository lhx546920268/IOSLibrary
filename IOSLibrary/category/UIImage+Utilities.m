//
//  UIImage+Utilities.m

//

#import "UIImage+Utilities.h"
#import "SeaBasic.h"



@implementation UIImage (Utilities)

#pragma mark- init

/**图片初始化 png格式 使用initWithContentsOfFile
 *@param name 图片名称
 *@return 一个初始化的UIImage
 */
+ (UIImage*)bundleImageWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
    
    return image;
}

/**从图片资源中获取图片数据
 *@return [UIImage imageFromAsset:asset options:SeaAssetImageOptionsResolutionImage];
 */
+ (UIImage*)imageFromAsset:(ALAsset *)asset
{
    return [UIImage imageFromAsset:asset options:SeaAssetImageOptionsResolutionImage];
}

/**从图片资源中获取图片数据
 *@param asset 资源文件类
 *@param options 从资源文件中获取图片的选项
 */
+ (UIImage*)imageFromAsset:(ALAsset*) asset options:(SeaAssetImageOptions) options
{
    if(asset == nil)
        return nil;
    
    ALAssetRepresentation *representation = [asset defaultRepresentation];
    
    //获取正确的图片方向
    UIImageOrientation orientation = UIImageOrientationUp;
    NSNumber *number = [asset valueForProperty:ALAssetPropertyOrientation];
    
    if(number != nil)
    {
        orientation = [number intValue];
    }
    
    UIImage *image = nil;
    
    switch (options)
    {
        case SeaAssetImageOptionsFullScreenImage :
        {
            //满屏的图片朝向已调整为 UIImageOrientationUp
            image = [UIImage imageWithCGImage:[representation fullScreenImage]];
        }
            break;
        case SeaAssetImageOptionsResolutionImage :
        {
            //图片朝向可能不正确，需要调整
            image = [UIImage imageWithCGImage:[representation fullResolutionImage] scale:representation.scale orientation:orientation];
        }
            break;
    }
    
    
    return image;
}

#pragma mark- resize

/**等比例缩小图片
 *@param size 要缩小的图片最大尺寸
 *@param type 缩小方式
 *@return 返回要缩小的图片尺寸
 */
- (CGSize)shrinkWithSize:(CGSize) size type:(SeaImageShrinkType) type
{
    return [UIImage shrinkImageSize:self.size withSize:size type:type];
}

/**等比例缩小图片
 *@param imageSize 要缩小的图片大小
 *@param size 要缩小的图片最大尺寸
 *@param type 缩小方式
 *@return 返回要缩小的图片尺寸
 */
+ (CGSize)shrinkImageSize:(CGSize) imageSize withSize:(CGSize) size type:(SeaImageShrinkType) type
{
    CGSize retSize = CGSizeZero;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    if(width == height)
    {
        width = MIN(width, size.width > size.height ? size.height : size.width);
        height = width;
    }
    else
    {
        CGFloat heightScale = height / size.height;
        CGFloat widthScale = width / size.width;
        
        switch (type)
        {
            case SeaImageShrinkTypeWidthAndHeight :
            {
                if(height >= size.height && width >= size.width)
                {
                    if(heightScale > widthScale)
                    {
                        height = floorf(height / heightScale);
                        width = floorf(width / heightScale);
                    }
                    else
                    {
                        height = floorf(height / widthScale);
                        width = floorf(width / widthScale);
                    }
                }
                else
                {
                    if(height >= size.height && width <= size.width)
                    {
                        height = floorf(height / heightScale);
                        width = floorf(width / heightScale);
                    }
                    else if(height <= size.height && width >= size.width)
                    {
                        height = floorf(height / widthScale);
                        width = floorf(width / widthScale);
                    }
                }
            }
                break;
            case SeaImageShrinkTypeWidth :
            {
                if(width > size.width)
                {
                    height = floorf(height / widthScale);
                    width = floorf(width / widthScale);
                }
            }
                break;
            case SeaImageShrinkTypeHeight :
            {
                if(height > size.height)
                {
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

/**通过给定大小获取图片的缩率图
 *@param size 目标图片大小
 *@return 图片的缩略图
 */
- (UIImage*)aspectFitthumbnailWithSize:(CGSize)size
{
    CGImageRef cgImage = self.CGImage;
    size_t width = CGImageGetWidth(cgImage) / SeaImageScale;
    size_t height = CGImageGetHeight(cgImage) / SeaImageScale;
    
    size = [UIImage shrinkImageSize:CGSizeMake(width, height) withSize:size type:SeaImageShrinkTypeWidthAndHeight];
    
    if(size.height >= height || size.width >= width)
        return self;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, SeaImageScale);
    CGRect imageRect = CGRectMake(0.0, 0.0, floorf(size.width), floorf(size.height));
    [self drawInRect:imageRect];
    UIImage *thumbnail = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    thumbnail = [UIImage imageWithCGImage:thumbnail.CGImage scale:thumbnail.scale orientation:thumbnail.imageOrientation];
    
//    NSLog(@"--%@", NSStringFromCGSize(size));
//    NSLog(@"--%@", NSStringFromCGSize(self.size));
    
    return thumbnail;
}

/**居中截取的缩略图
 *@param size 目标图片大小
 *@return 图片的缩略图
 */
- (UIImage*)aspectFillThumbnailWithSize:(CGSize)size
{
    UIImage *ret = nil;
    
    if(self.size.width == self.size.height && size.width == size.height)
    {
        //正方形图片
        ret = self;
    }
    //    else if (self.size.width < size.width && self.size.height < size.height)
    //    {
    //        ret = [self subImageWithRect:CGRectMake((self.size.width - size.width) / 2.0, (self.size.height - size.height) / 2.0, size.width, size.height)];
    //    }
    else
    {
        CGFloat multipleWidthNum = self.size.width / size.width;
        CGFloat multipleHeightNum = self.size.height / size.height;
        
        CGFloat scale = MIN(multipleWidthNum, multipleHeightNum);
        int width = size.width * scale;
        int height = size.height * scale;
        ret = [self subImageWithRect:CGRectMake((self.size.width - width) / 2.0, (self.size.height - height) / 2.0, width, height)];
    }
    
    return [ret aspectFitthumbnailWithSize:size];
}

/**截取图片
 *@param rect 要截取的rect
 *@return 截取的图片
 */
- (UIImage*)subImageWithRect:(CGRect)rect
{
    CGPoint origin = CGPointMake(-rect.origin.x, -rect.origin.y);
    
    UIImage *img = nil;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(rect.size.width), floorf(rect.size.height)), NO, SeaImageScale);
    
    [self drawAtPoint:origin];
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


/**把UIImage轉成bitmap 需要调用free(),避免内存泄露
 */
- (unsigned char *)createRGBABitmap
{
    CGContextRef context = NULL;
    CGColorSpaceRef colorSpace;
    unsigned char *bitmap;
    size_t bitmapSize;
    size_t bytesPerRow;
    
    CGImageRef image = self.CGImage;
    
    size_t width = CGImageGetWidth(image);
    size_t height = CGImageGetHeight(image);
    
    bytesPerRow   = (width * 4);
    bitmapSize     = (bytesPerRow * height);
    
    bitmap = malloc( bitmapSize );
    if (bitmap == NULL)
    {
        return NULL;
    }
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    if (colorSpace == NULL)
    {
        free(bitmap);
        return NULL;
    }
    
    CGBitmapInfo kBGRxBitmapInfo = kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipFirst;
    context = CGBitmapContextCreate (bitmap,
                                     width,
                                     height,
                                     8,
                                     bytesPerRow,
                                     colorSpace,
                                     kBGRxBitmapInfo);
    
    CGColorSpaceRelease( colorSpace );
    
    if (context == NULL)
    {
        free (bitmap);
        return NULL;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), image);
    CGContextRelease(context);
    
    return bitmap;
}

/**拷贝图片
 */
- (UIImage*)deepCopy
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floorf(self.size.width), floorf(self.size.height)), NO, SeaImageScale);
    
    [self drawAtPoint:CGPointMake(0, 0)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return image;
}

/**获取圆角图片，可设置边框
 *@param cornerRradius 圆角半径
 *@param borderWidth 边框线条宽度
 *@param borderColor 边框颜色
 *@return 圆角图片
 */
- (UIImage*)imageWithCornerRadius:(CGFloat) cornerRradius borderWidth:(CGFloat) borderWidth borderColor:(UIColor*) borderColor
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
    
    if(borderColor != nil)
    {
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

+ (UIImage*)imageFromView:(UIView *)view
{
    return [UIImage imageFromLayer:view.layer];
}

/**通过layer生成图片
 */
+ (UIImage*)imageFromLayer:(CALayer*) layer
{
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(floor(layer.bounds.size.width), floor(layer.bounds.size.height)), layer.opaque, SeaImageScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [layer renderInContext:context];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

/**通过给定颜色创建图片
 */
+ (UIImage*)imageWithColor:(UIColor*) color size:(CGSize) size
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    view.backgroundColor = color;
    
    UIGraphicsBeginImageContextWithOptions(size, view.opaque, SeaImageScale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return retImage;
}

#pragma mark- QRCode 二维码

/**通过给定信息生成二维码
 *@param string 二维码信息 不能为空
 *@param correctionLevel 二维码容错率
 *@param size 二维码大小 如果为CGSizeZero ，将使用 240的大小
 *@param contentColor 二维码内容颜色，如果空，将使用 blackColor
 *@param backgroundColor 二维码背景颜色，如果空，将使用 whiteColor
 *@param logo 二维码 logo ,放在中心位置 ，logo的大小 根据 UIImage.size 来确定
 *@return 成功返回二维码图片，否则nil
 */
+ (UIImage*)qrCodeImageWithString:(NSString*) string
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
    
    if(CGSizeEqualToSize(size, CGSizeZero))
    {
        size = CGSizeMake(240.0, 240.0);
    }
    
    NSString *level = nil;
    switch (correctionLevel)
    {
        case SeaQRCodeImageCorrectionLevelPercent7 :
        {
            level = @"L";
        }
            break;
        case SeaQRCodeImageCorrectionLevelPercent15 :
        {
            level = @"M";
        }
            break;
        case SeaQRCodeImageCorrectionLevelPercent25 :
        {
            level = @"Q";
        }
            break;
        case SeaQRCodeImageCorrectionLevelPercent30 :
        {
            level = @"H";
        }
        default:
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
    
    if(cx == NULL)
    {
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
    if(![contentColor isEqualToColor:[UIColor blackColor]] || ![backgroundColor isEqualToColor:[UIColor whiteColor]])
    {
        ///获取颜色的rgba值
        NSDictionary *dic = [contentColor getColorRGB];
        int c_red = [[dic objectForKey:_colorRedKey_] floatValue] * 255;
        int c_green = [[dic objectForKey:_colorGreenKey_] floatValue] * 255;
        int c_blue = [[dic objectForKey:_colorBlueKey_] floatValue] * 255;
        int c_alpha = [[dic objectForKey:_colorAlphaKey_] floatValue] * 255;
        
        dic = [backgroundColor getColorRGB];
        int b_red = [[dic objectForKey:_colorRedKey_] floatValue] * 255;
        int b_green = [[dic objectForKey:_colorGreenKey_] floatValue] * 255;
        int b_blue = [[dic objectForKey:_colorBlueKey_] floatValue] * 255;
        int b_alpha = [[dic objectForKey:_colorAlphaKey_] floatValue] * 255;
        
        
        ///遍历图片的像素并改变值，像素是一个二维数组， 每个像素由RGBA的数组组成，在数组中的排列顺序是从右到左即 array[0] 是 A阿尔法通道
        uint32_t *tmpData = data; ///创建临时的数组指针，保持data的指针指向为起始位置
        for(size_t i = 0;i < height; i ++)
        {
            for(size_t j = 0;j < width; j ++)
            {
                if((*tmpData & 0xFFFFFF) < 0x999999) ///判断是否是背景像素，白色是背景
                {
                    ///改变二维码颜色
                    uint8_t *ptr = (uint8_t*)tmpData;
                    ptr[3] = c_red;
                    ptr[2] = c_green;
                    ptr[1] = c_blue;
                    ptr[0] = c_alpha;
                }
                else
                {
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
    if(logo)
    {
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
