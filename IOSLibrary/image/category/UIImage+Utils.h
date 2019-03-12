//
//  UIImage+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

///图片等比例缩小方式
typedef NS_ENUM(NSInteger, SeaImageFitType)
{
    ///宽和高
    SeaImageFitTypeSize = 0,
    
    ///宽
    SeaImageFitTypeWidth,
    
    ///高
    SeaImageFitTypeHeight,
};

/**从资源文件中获取图片的选项
 */
typedef NS_ENUM(NSInteger, SeaAssetImageOptions)
{
    ///适合当前屏幕大小的图片
    SeaAssetImageOptionsFullScreenImage = 0,
    
    ///完整的图片
    SeaAssetImageOptionsResolutionImage,
};

///二维码容错率
typedef NS_ENUM(NSInteger, SeaQRCodeImageCorrectionLevel)
{
    /// 7% 容错率 L
    SeaQRCodeImageCorrectionLevelPercent7 = 0,
    
    /// 15% 容错率 M
    SeaQRCodeImageCorrectionLevelPercent15,
    
    /// 25% 容错率 Q
    SeaQRCodeImageCorrectionLevelPercent25,
    
    /// 30% 容错率 H
    SeaQRCodeImageCorrectionLevelPercent30,
};

///图片比例
static const CGFloat SeaImageScale = 2.0f;

@interface UIImage (Utils)

#pragma mark- init

/**
 图片初始化 png格式 使用imageWithContentsOfFile 无法加载 imageAssets 里面的图片
 *@param name 图片名称
 *@return 一个初始化的UIImage
 */
+ (UIImage*)sea_bundleImageWithName:(NSString*) name;


/**
 从图片资源中获取图片数据
 *@return [UIImage imageFromAsset:asset options:SeaAssetImageOptionsResolutionImage];
 */
+ (UIImage*)sea_imageFromAsset:(ALAsset *)asset;

/**
 从图片资源中获取图片数据
 *@param asset 资源文件类
 *@param options 从资源文件中获取图片的选项
 */
+ (UIImage*)sea_imageFromAsset:(ALAsset*) asset options:(SeaAssetImageOptions) options;

#pragma mark- resize

/**
 通过给定的大小，获取等比例缩小后的图片尺寸
 *@param size 要缩小的图片最大尺寸
 *@param type 缩小方式
 *@return 返回要缩小的图片尺寸
 */
- (CGSize)sea_fitWithSize:(CGSize) size type:(SeaImageFitType) type;

/**
 通过给定的大小，获取等比例缩小后的图片尺寸
 *@param imageSize 要缩小的图片大小
 *@param size 要缩小的图片最大尺寸
 *@param type 缩小方式
 *@return 返回要缩小的图片尺寸
 */
+ (CGSize)sea_fitImageSize:(CGSize) imageSize size:(CGSize) size type:(SeaImageFitType) type;

/**
 通过给定大小获取图片的等比例缩小的缩率图
 *@param size 目标图片大小
 *@return 图片的缩略图
 */
- (UIImage*)sea_aspectFitWithSize:(CGSize) size;

/**
 居中截取的缩略图
 *@param size 目标图片大小
 *@return 图片的缩略图
 */
- (UIImage*)sea_aspectFillWithSize:(CGSize) size;

/**
 截取图片
 *@param rect 要截取的rect
 *@return 截取的图片
 */
- (UIImage*)sea_subImageWithRect:(CGRect) rect;

/**
 把UIImage转成bitmap 需要调用free(),避免内存泄露
 */
- (unsigned char*)sea_bitmap;

/*
 解压缩图片
 */
- (UIImage*)sea_decompressedImage;

/**
 拷贝图片
 */
- (UIImage*)sea_deepCopy;

/**
 获取圆角图片，可设置边框
 *@param cornerRradius 圆角半径
 *@param borderWidth 边框线条宽度
 *@param borderColor 边框颜色
 *@return 圆角图片
 */
- (UIImage*)sea_imageWithCornerRadius:(CGFloat) cornerRradius borderWidth:(CGFloat) borderWidth borderColor:(UIColor*) borderColor;

#pragma mark- 创建图片

/**
 通过view生成图片
 */
+ (UIImage*)sea_imageFromView:(UIView*)view;

/**
 通过layer生成图片
 */
+ (UIImage*)sea_imageFromLayer:(CALayer*) layer;

/**
 通过给定颜色创建图片
 */
+ (UIImage*)sea_imageWithColor:(UIColor*) color size:(CGSize) size;


#pragma mark- 二维码

/**
 通过给定信息生成二维码
 *@param string 二维码信息 不能为空
 *@param correctionLevel 二维码容错率
 *@param size 二维码大小 如果为CGSizeZero ，将使用 240的大小
 *@param contentColor 二维码内容颜色，如果空，将使用 blackColor
 *@param backgroundColor 二维码背景颜色，如果空，将使用 whiteColor
 *@param logo 二维码 logo ,放在中心位置 ，logo的大小 根据 UIImage.size 来确定
 *@return 成功返回二维码图片，否则nil
 */
+ (UIImage*)sea_qrCodeImageWithString:(NSString*) string
                  correctionLevel:(SeaQRCodeImageCorrectionLevel) correctionLevel
                             size:(CGSize) size
                     contentColor:(UIColor*) contentColor
                  backgroundColor:(UIColor*) backgroundColor
                             logo:(UIImage*) logo;

@end
