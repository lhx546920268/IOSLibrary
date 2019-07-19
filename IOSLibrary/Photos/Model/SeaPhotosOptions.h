//
//  SeaPhotosOptions.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/1.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaImageCropSettings.h"

@class SeaPhotosOptions;

///打开相册的意图
typedef NS_ENUM(NSInteger, SeaPhotosIntention){
    
    ///单选
    SeaPhotosIntentionSingleSelection,
    
    ///多选
    SeaPhotosIntentionMultiSelection,
    
    ///裁剪 必须设置裁剪选项 cropSettings
    SeaPhotosIntentionCrop,
};

///相册选择结果
@interface SeaPhotosPickResult : NSObject

///图片缩略图
@property(nonatomic, strong) UIImage *thumbnail;

///压缩后的图片
@property(nonatomic, strong) UIImage *compressedImage;

///原图
@property(nonatomic, strong) UIImage *originalImage;

///通过相册选项 图片数据创建 创建失败返回nil
+ (instancetype)resultWithData:(NSData*) data options:(SeaPhotosOptions*) options;

@end


///相册选项
@interface SeaPhotosOptions : NSObject

///选择图片完成回调
@property(nonatomic, copy) void(^completion)(NSArray<SeaPhotosPickResult*> *results);

///意图
@property(nonatomic, assign) SeaPhotosIntention intention;

///裁剪选项
@property(nonatomic, strong) SeaImageCropSettings *cropSettings;

///缩略图大小 default zero
@property(nonatomic, assign) CGSize thumbnailSize;

///压缩图片的大小 default 512
@property(nonatomic, assign) CGSize compressedImageSize;

///是否需要原图 default NO
@property(nonatomic, assign) BOOL needOriginalImage;

///多选数量 default 1
@property(nonatomic, assign) NSInteger maxCount;

///网格图片间距 default is '3.0'
@property(nonatomic, assign) CGFloat gridInterval;

///每行图片数量 default is '4'
@property(nonatomic, assign) NSInteger numberOfItemsPerRow;

///是否显示所有图片 default YES
@property(nonatomic, assign) BOOL shouldDisplayAllPhotos;

///是否显示空的相册 default NO
@property(nonatomic, assign) BOOL shouldDisplayEmptyCollection;

///是否直接显示第一个相册的内容 default YES
@property(nonatomic, assign) BOOL displayFistCollection;

///图片scale default SeaImageScale
@property(nonatomic, assign) CGFloat scale;

@end

