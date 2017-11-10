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


