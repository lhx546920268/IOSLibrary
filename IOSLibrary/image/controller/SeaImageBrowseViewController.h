//
//  SeaImageBrowseViewController.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/17.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaCollectionViewController.h"

@class ALAsset;

/**
 图片浏览信息
 */
@interface SeaImageBrowseInfo : NSObject

/**
 图片
 */
@property(nonatomic, strong) UIImage *image;

/**
 图片资源
 */
@property(nonatomic, strong) ALAsset *asset;

/**
 图片路径
 */
@property(nonatomic, strong) NSString *URL;

/**
 通过图片初始化
 */
+ (instancetype)infoWithImage:(UIImage*) image;

/**
 通过图片路径初始化
 */
+ (instancetype)infoWithURL:(NSString*) URL;

/**
 通过图片资源初始化
 */
+ (instancetype)infoWithAsset:(ALAsset*) asset;

@end

@class SeaimageBrowseViewControllerCell;
@class SeaImageBrowseCell;

/**
 图片浏览器cell代理
 */
@protocol SeaImageBrowseCellDelegate<NSObject>

//单击图片
- (void)imageBrowseCellDidTap:(SeaImageBrowseCell*) cell;

@end

/**
 图片浏览器cell
 */
@interface SeaImageBrowseCell : UICollectionViewCell<UIScrollViewDelegate>

/**
 滚动视图，用于图片放大缩小
 */
@property(nonatomic,readonly) UIScrollView *scrollView;

/**
 图片
 */
@property(nonatomic,readonly) UIImageView *imageView;

/**
 代理
 */
@property(nonatomic,weak) id<SeaImageBrowseCellDelegate> delegate;

/**
 重新布局图片当图片加载完成时
 */
- (void)layoutImageAfterLoad;

/**
 计算imageView的位置大小
 */
- (CGRect)rectFromImage:(UIImage*) image;

@end

@class SeaImageBrowseViewController;

/**
 图片浏览器代理
 */
@protocol SeaImageBrowseViewControllerDelegate <NSObject>

@optional

/**
 将进入满屏
 */
- (void)imageBrowseViewControllerWillEnterFullScreen:(SeaImageBrowseViewController*) viewController;

/**
 已经进入满屏
 */
- (void)imageBrowseViewControllerDidEnterFullScreen:(SeaImageBrowseViewController*) viewController;

/**
 将退出满屏
 */
- (void)imageBrowseViewControllerWillExistFullScreen:(SeaImageBrowseViewController*) viewController;

/**
 已经退出满屏
 */
- (void)imageBrowseViewControllerDidExistFullScreen:(SeaImageBrowseViewController*) viewController;

@end

/**
 图片浏览 支持 UIImage NSString图片路径
 */
@interface SeaImageBrowseViewController : SeaCollectionViewController

/**
 动画时间长度 default is '0.3'
 */
@property(nonatomic, assign) CGFloat animateDuration;

/**
 图片信息
 */
@property(nonatomic,readonly) NSArray<SeaImageBrowseInfo*> *infos;

/**
 当前显示的图片下标
 */
@property(nonatomic,readonly) NSUInteger visibleIndex;

/**
 获取动画的视图，如果需要显示和隐藏动画， index 图片下标
 */
@property(nonatomic,copy) UIView *(^animatedViewHandler)(NSUInteger index);

/**
 代理
 */
@property(nonatomic,weak) id<SeaImageBrowseViewControllerDelegate> delegate;


/**
 通过图片初始化

 @param images 图片数组
 @param visibleIndex 当前可见位置
 @return 一个实例
 */
- (instancetype)initWithImages:(NSArray<UIImage*>*) images visibleIndex:(NSInteger) visibleIndex;

/**
 通过图片路径初始化
 
 @param URLs 图片路径数组
 @param visibleIndex 当前可见位置
 @return 一个实例
 */
- (instancetype)initWithURLs:(NSArray<NSString*>*) URLs visibleIndex:(NSInteger) visibleIndex;

/**
 通过图片资源初始化
 
 @param assets 图片资源数组
 @param visibleIndex 当前可见位置
 @return 一个实例
 */
- (instancetype)initWithAssets:(NSArray<ALAsset*>*) assets visibleIndex:(NSInteger) visibleIndex;

/**
 显示
 */
- (void)showAnimate:(BOOL) animate;

/**
 消失
 */
- (void)dismissAimate:(BOOL) animate;

/**
 重新加载数据
 */
- (void)reloadData;

@end
