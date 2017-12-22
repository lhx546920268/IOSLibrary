//
//  SeaImageCacheOption.h
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

@property(nonatomic, strong) UIColor *placeholderColor;

@property(nonatomic, strong) UIImage *placeholderImage;

@property(nonatomic, assign) UIViewContentMode originalContentMode;

@property(nonatomic, assign) UIViewContentMode placeholderContentMode;

@property(nonatomic, assign) BOOL shouldAspectRatioFit;

@property(nonatomic, assign) UIActivityIndicatorViewStyle activityIndicatorViewStyle;

@property(nonatomic, assign) BOOL shouldShowLoadingActivity;

@end

