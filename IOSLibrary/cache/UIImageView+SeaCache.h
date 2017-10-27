//
//  UIImageView+SeaCache.h
//  SuYan
//
//  Created by 罗海雄 on 16/4/25.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

/**缓存
 */
@interface UIImageView (SeaCache)

/**缩略图大小 default is 'self.bounds.size',如果值 为CGSizeZero表示不使用缩略图，可设置bounds.size
 */
@property(nonatomic,assign) CGSize sea_thumbnailSize;

/**显示加载指示器，当加载图片时 default is 'NO'
 */
@property(nonatomic,assign) BOOL sea_showLoadingActivity;

/**未加载图片显示的内容
 */
@property(nonatomic,strong) UIColor *sea_placeHolderColor;

/**本来的背景颜色
 */
@property(nonatomic,strong) UIColor *sea_originBackgroundColor;

/**未加载时显示的图片 default is 'nil'
 */
@property(nonatomic,strong) UIImage *sea_placeHolderImage;

/**placeHolderImage 的渲染方式，default is 'UIViewContentModeScaleAspectFit'
 */
@property(nonatomic,assign) UIViewContentMode sea_placeHolderContentMode;

/**原始的contentMode ，default is 'UIViewContentModeScaleToFill' 图片加载完成后使用，加载之前如果使用sea_placeHolderImage，则使用 sea_placeHolderContentMode，防止图片变形
 */
@property(nonatomic,assign) UIViewContentMode sea_originContentMode;

/**加载指示器
 */
@property(nonatomic,strong) UIActivityIndicatorView *sea_actView;

/**加载指示器样式 default is 'UIActivityIndicatorViewStyleGray'
 */
@property(nonatomic,assign) UIActivityIndicatorViewStyle sea_actStyle;

//设置加载状态
- (void)setupLoading:(BOOL) loading;

@end
