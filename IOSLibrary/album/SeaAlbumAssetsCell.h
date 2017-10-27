//
//  SeaAlbumAssetsCell.h

//

#import <UIKit/UIKit.h>

@class SeaCheckBox;

/**相册缩略图选中覆盖物
 */
@interface SeaAlbumAssetsOverlay : UIView

/**选中勾
 */
@property(nonatomic,readonly) SeaCheckBox *checkBox;

@end

/**相册缩略图
 */
@interface SeaAlbumAssetsThumbnail : UICollectionViewCell

/**图片
 */
@property(nonatomic,readonly) UIImageView *imageView;

/**选中覆盖
 */
@property(nonatomic,readonly) SeaAlbumAssetsOverlay *overlay;


- (void)setSelected:(BOOL)selected animated:(BOOL) animated;


@end

//缩略图间隔
#define _SeaAlbumAssetThumbnailInterval_ 3.0

//每行缩略图数量
#define _SeaAlbumAssetNumberThumbnailPerRow_ 4

//缩略图片大小，正方形
#define _SeaAlbumAssetThumbnailSize_ ((_width_ - _SeaAlbumAssetThumbnailInterval_ * (_SeaAlbumAssetNumberThumbnailPerRow_ + 1)) / _SeaAlbumAssetNumberThumbnailPerRow_)

