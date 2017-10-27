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
    
    ///选择头像，只能选一张，并且会裁剪图片，默认大小为 屏幕宽度 1 : 1
    SeaAlbumAssetsViewControllerHeadImage,
    
    ///店招 只能选一张，并且会裁剪图片，默认大小为 WMRecommendImageSize
    SeaAlbumAssetsViewControllerRecommend,
    
    ///自定义图片裁剪，可设置corpSize
    SeaAlbumAssetsViewControllerImageCrop,
};

@class ALAssetsGroup, ALAssetsLibrary,SeaImageCropSettings,WMRecommendGoodInfo;

/**相册分组内容列表
 */
@interface SeaAlbumAssetsViewController : SeaCollectionViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**相册代理
 */
@property(nonatomic,weak) id delegate;

/**图片最大选择数量 default is '1'
 */
@property(nonatomic,assign) int maxSelectedCount;

/**相册分组信息
 */
@property(nonatomic,strong) ALAssetsGroup *group;

/**是否是弹出视图 default is 'YES'
 */
@property(nonatomic,assign) BOOL present;

///裁剪图片裁剪框设置，图片不需要设置
@property(nonatomic,strong) SeaImageCropSettings *settings;

/**相册使用目的 default is 'SeaAlbumAssetsViewControllerTarget'
 */
@property(nonatomic,assign) SeaAlbumAssetsViewControllerTarget target;

/**推荐商品信息
 */
@property(nonatomic,strong) WMRecommendGoodInfo *recommendGoodInfo;

/**相册资源单例，必须使用单例，否则在 ios8.0 重复创建ALAssetsLibrary时 会出现崩溃
 */
+ (ALAssetsLibrary*)sharedAssetsLibrary;

@end
