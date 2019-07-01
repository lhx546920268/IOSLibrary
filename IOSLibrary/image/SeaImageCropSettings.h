//
//  SeaImageCropSettings.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/1.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

///裁剪设置
@interface SeaImageCropSettings : NSObject

///裁剪图片
@property(nonatomic,strong) UIImage *image;

///裁剪框大小
@property(nonatomic,assign) CGSize cropSize;

///裁剪框圆角
@property(nonatomic,assign) CGFloat cropCornerRadius;

///是否使用满屏裁剪框 default is 'YES'
@property(nonatomic,assign) BOOL useFullScreenCropFrame;

/**图片可以被放大的最大比例，default is '2.5'
 */
@property (nonatomic, assign) CGFloat limitRatio;

@end
