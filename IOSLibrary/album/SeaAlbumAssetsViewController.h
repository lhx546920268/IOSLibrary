//
//  SeaPhotoAlbumAssetsViewController.h

//

#import "SeaCollectionViewController.h"
#import "SeaAlbumDelegate.h"

/**相册使用目的
 */
typedef NS_ENUM(NSInteger, SeaAlbumAssetsViewControllerTarget)
{
    ///选择图片 可设置选择数量
    SeaAlbumAssetsViewControllerTargetSelected = 0,
    
    ///自定义图片裁剪，可设置corpSize 只能选择一张
    SeaAlbumAssetsViewControllerImageCrop,
};

@class ALAssetsGroup, ALAssetsLibrary,SeaImageCropSettings;

/**相册分组内容列表
 */
@interface SeaAlbumAssetsViewController : SeaCollectionViewController

/**相册代理
 */
@property(nonatomic,weak) id<SeaAlbumDelegate> delegate;

/**图片最大选择数量 default is '1'
 */
@property(nonatomic,assign) int maxSelectedCount;

///网格图片间距 default is '3.0'
@property(nonatomic,assign) CGFloat gridInterval;

///每行图片数量 default is '3'
@property(nonatomic,assign) int numberOfItemsPerRow;

/**相册分组信息
 */
@property(nonatomic,strong) ALAssetsGroup *group;

///裁剪图片裁剪框设置，图片不需要设置
@property(nonatomic,strong) SeaImageCropSettings *settings;

/**相册使用目的 default is 'SeaAlbumAssetsViewControllerTarget'
 */
@property(nonatomic,assign) SeaAlbumAssetsViewControllerTarget target;

/**相册资源单例，必须使用单例，否则在 ios8.0 重复创建ALAssetsLibrary时 会出现崩溃
 */
+ (ALAssetsLibrary*)sharedAssetsLibrary;

@end
