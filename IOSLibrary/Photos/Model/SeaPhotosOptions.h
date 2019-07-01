//
//  SeaPhotosOptions.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/1.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SeaImageCropSettings.h"

///打开相册的意图
typedef NS_ENUM(NSInteger, SeaPhotosIntention){
    
    ///单选
    SeaPhotosIntentionSingleSelection,
    
    ///多选
    SeaPhotosIntentionMultiSelection,
    
    ///裁剪 必须设置裁剪选项 cropSettings
    SeaPhotosIntentionCrop,
};


///相册选项
@interface SeaPhotosOptions : NSObject

///意图
@property(nonatomic, assign) SeaPhotosIntention intention;

///裁剪选项
@property(nonatomic, strong) SeaImageCropSettings *cropSettings;

///多选数量 default 1
@property(nonatomic, assign) NSInteger maxCount;

///网格图片间距 default is '3.0'
@property(nonatomic,assign) CGFloat gridInterval;

///每行图片数量 default is '4'
@property(nonatomic,assign) int numberOfItemsPerRow;

@end

