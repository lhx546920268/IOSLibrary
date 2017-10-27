//
//  UIImage+Utilities.h

//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

///图片等比例缩小方式
typedef NS_ENUM(NSInteger, SeaImageShrinkType)
{
    ///宽和高
    SeaImageShrinkTypeWidthAndHeight = 0,
    
    ///宽
    SeaImageShrinkTypeWidth = 1,
    
    ///高
    SeaImageShrinkTypeHeight = 2,
};

/**从资源文件中获取图片的选项
 */
typedef NS_ENUM(NSInteger, SeaAssetImageOptions)
{
    ///适合当前屏幕大小的图片
    SeaAssetImageOptionsFullScreenImage = 0,
    
    ///完整的图片
    SeaAssetImageOptionsResolutionImage = 1,
};

///二维码容错率
typedef NS_ENUM(NSInteger, SeaQRCodeImageCorrectionLevel)
{
    /// 7% 容错率 L
    SeaQRCodeImageCorrectionLevelPercent7 = 0,
    
    /// 15% 容错率 M
    SeaQRCodeImageCorrectionLevelPercent15 = 1,
    
    /// 25% 容错率 Q
    SeaQRCodeImageCorrectionLevelPercent25 = 2,
    
    /// 30% 容错率 H
    SeaQRCodeImageCorrectionLevelPercent30 = 3,
};

///图片比例
#define SeaImageScale 2.0f

@interface UIImage (Utilities)

#pragma mark- init

/**图片初始化 png格式 使用initWithContentsOfFile
 *@param name 图片名称
 *@return 一个初始化的UIImage
 */
+ (UIImage*)bundleImageWithName:(NSString*) name;


/**从图片资源中获取图片数据
 *@return [UIImage imageFromAsset:asset options:SeaAssetImageOptionsResolutionImage];
 */
+ (UIImage*)imageFromAsset:(ALAsset *)asset;

/**从图片资源中获取图片数据
 *@param asset 资源文件类
 *@param options 从资源文件中获取图片的选项
 */
+ (UIImage*)imageFromAsset:(ALAsset*) asset options:(SeaAssetImageOptions) options;

#pragma mark- resize

/**等比例缩小图片
 *@param size 要缩小的图片最大尺寸
 *@param type 缩小方式
 *@return 返回要缩小的图片尺寸
 */
- (CGSize)shrinkWithSize:(CGSize) size type:(SeaImageShrinkType) type;

/**等比例缩小图片
 *@param imageSize 要缩小的图片大小
 *@param size 要缩小的图片最大尺寸
 *@param type 缩小方式
 *@return 返回要缩小的图片尺寸
 */
+ (CGSize)shrinkImageSize:(CGSize) imageSize withSize:(CGSize) size type:(SeaImageShrinkType) type;

/**通过给定大小获取图片的等比例缩小的缩率图
 *@param size 目标图片大小
 *@return 图片的缩略图
 */
- (UIImage*)aspectFitthumbnailWithSize:(CGSize) size;

/**居中截取的缩略图
 *@param size 目标图片大小
 *@return 图片的缩略图
 */
- (UIImage*)aspectFillThumbnailWithSize:(CGSize) size;

/**截取图片
 *@param rect 要截取的rect
 *@return 截取的图片
 */
- (UIImage*)subImageWithRect:(CGRect) rect;

/**把UIImage轉成bitmap 需要调用free(),避免内存泄露
 */
- (unsigned char *)createRGBABitmap;

/**拷贝图片
 */
- (UIImage*)deepCopy;

/**获取圆角图片，可设置边框
 *@param cornerRradius 圆角半径
 *@param borderWidth 边框线条宽度
 *@param borderColor 边框颜色
 *@return 圆角图片
 */
- (UIImage*)imageWithCornerRadius:(CGFloat) cornerRradius borderWidth:(CGFloat) borderWidth borderColor:(UIColor*) borderColor;

#pragma mark- 创建图片

/**通过view生成图片
 */
+ (UIImage*)imageFromView:(UIView*)view;

/**通过layer生成图片
 */
+ (UIImage*)imageFromLayer:(CALayer*) layer;

/**通过给定颜色创建图片
 */
+ (UIImage*)imageWithColor:(UIColor*) color size:(CGSize) size;


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
                             logo:(UIImage*) logo;

@end
