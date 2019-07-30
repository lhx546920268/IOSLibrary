//
//  SeaPhotosPreviewCell.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/22.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PHAsset, SeaPhotosPreviewCell;

///代理
@protocol SeaPhotosPreviewCellDelegate <NSObject>

///单击
- (void)photosPreviewCellDidClick:(SeaPhotosPreviewCell*) cell;

@end

///相册预览
@interface SeaPhotosPreviewCell : UICollectionViewCell

///加载中
@property(nonatomic, assign) BOOL loading;

///asset标识符
@property(nonatomic, strong) PHAsset *asset;

///代理
@property(nonatomic, weak) id<SeaPhotosPreviewCellDelegate> delegate;

///图片加载完成时
- (void)onLoadImage:(UIImage*) image;

@end

