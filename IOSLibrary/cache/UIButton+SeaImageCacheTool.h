//
//  UIButton+SeaImageCacheTool.h
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/30.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaImageCacheToolOperation.h"

/**按钮图片缓存
 */
@interface UIButton (SeaImageCacheTool)

/**当前图片服务器路径
 */
@property(nonatomic,readonly) NSString *sea_imageURL;

/**当前背景图片服务器路径
 */
@property(nonatomic,readonly) NSString *sea_backgroundImageURL;

/**缩略图大小 default is 'CGSizeZero',如果值 为CGSizeZero表示不使用缩略图，可设置bounds.size
 */
@property(nonatomic,assign) CGSize sea_thumbnailSize;

/**显示加载指示器，当加载图片时 default is 'NO'
 */
@property(nonatomic,assign) BOOL sea_showLoadingActivity;

/**未加载图片显示的内容
 */
@property(nonatomic,strong) UIColor *sea_placeHolderColor;

/**未加载时显示的图片 default is 'nil'
 */
@property(nonatomic,strong) UIImage *sea_placeHolderImage;

/**加载指示器
 */
@property(nonatomic,strong) UIActivityIndicatorView *sea_actView;

/**加载指示器样式 default is 'UIActivityIndicatorViewStyleGray'
 */
@property(nonatomic,assign) UIActivityIndicatorViewStyle sea_actStyle;

/**获取下载的图片路径
 */
- (NSString*)sea_imageURLForState:(UIControlState) state;

/**设置图片路径
 *@param URL 图片路径
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state;

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheToolCompletionHandler) completion;

/**设置图片路径
 *@param URL 图片路径
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state progress:(SeaImageCacheToolProgressHandler) progress;

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheToolCompletionHandler) completion progress:(SeaImageCacheToolProgressHandler) progress;


/**获取下载的背景图片路径
 */
- (NSString*)sea_backgroundImageURLForState:(UIControlState) state;

/**设置图片路径
 *@param URL 图片路径
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state;

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheToolCompletionHandler) completion;

/**设置图片路径
 *@param URL 图片路径
 *@param progress 加载进度回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state progress:(SeaImageCacheToolProgressHandler) progress;

/**设置图片路径
 *@param URL 图片路径
 *@param completion 加载完成回调
 *@param progress 加载进度回调
 */
- (void)sea_setBackgroundImageWithURL:(NSString*) URL forState:(UIControlState) state completion:(SeaImageCacheToolCompletionHandler) completion progress:(SeaImageCacheToolProgressHandler) progress;

@end
