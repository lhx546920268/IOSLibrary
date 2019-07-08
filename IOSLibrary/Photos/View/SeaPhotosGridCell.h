//
//  SeaPhotosGridCell.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/2.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaPhotosCheckBox, SeaPhotosGridCell;

///代理
@protocol SeaPhotosGridCellDelegate <NSObject>

///选中某个图片
- (void)photosGridCellCheckedDidChange:(SeaPhotosGridCell*) cell;

@end

///相册网格
@interface SeaPhotosGridCell : UICollectionViewCell

///图片
@property(nonatomic, readonly) UIImageView *imageView;

///选中覆盖
@property(nonatomic, readonly) UIView *overlay;

///选中勾
@property(nonatomic, readonly) SeaPhotosCheckBox *checkBox;

///选中
@property(nonatomic, assign) BOOL checked;

///asset标识符
@property(nonatomic, strong) NSString *assetLocalIdentifier;

///代理
@property(nonatomic, weak) id<SeaPhotosGridCellDelegate> delegate;

///设置选中
- (void)setChecked:(BOOL)checked animated:(BOOL) animated;

@end

