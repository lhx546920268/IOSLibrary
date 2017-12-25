//
//  SeaImageCacheOptions.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/22.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 图片缓存选项
 */
@interface SeaImageCacheOptions : NSObject<NSCopying>

/**
 加载中、加载失败显示的背景颜色
 */
@property(nonatomic, strong) UIColor *placeholderColor;

/**
 加载中、加载失败显示的图片
 */
@property(nonatomic, strong) UIImage *placeholderImage;

/**
 view 原始的 contentMode，在加载图片过程中，设置placeholderImage时，会改变contentMode，加载成功后会设置成 originalContentMode
 default is 'UIViewContentModeScaleToFill'
 */
@property(nonatomic, assign) UIViewContentMode originalContentMode;

/**
 view 原始背景颜色
 */
@property(nonatomic, assign) UIColor *originalBackgroundColor;

/**
 在加载图片过程中，设置placeholderImage时，会改变contentMode为 placeholderContentMode，加载成功后会设置成 originalContentMode
 default is ‘UIViewContentModeScaleAspectFit’
 */
@property(nonatomic, assign) UIViewContentMode placeholderContentMode;

/**
 是否根据view来缩小图片尺寸，default is 'YES'
 */
@property(nonatomic, assign) BOOL shouldAspectRatioFit;

/**
 default is 'UIActivityIndicatorViewStyleGray'
 */
@property(nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

/**
 加载过程中是否显示 UIActivityIndicatorView default is 'NO'
 */
@property(nonatomic, assign) BOOL shouldShowLoadingActivity;

///设置默认选项
+ (void)setDefaultOptions:(SeaImageCacheOptions*) options;

///默认选项
+ (instancetype)defaultOptions;

@end

