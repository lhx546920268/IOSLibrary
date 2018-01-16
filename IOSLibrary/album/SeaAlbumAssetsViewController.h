//
//  SeaPhotoAlbumAssetsViewController.h

//

#import "SeaCollectionViewController.h"
#import "SeaAlbumDelegate.h"

@class ALAssetsGroup, ALAssetsLibrary,SeaImageCropSettings;

/**
 相册分组内容列表
 需要在 info.plist 添加
 <key>NSPhotoLibraryUsageDescription</key>
 <string>使用相册干嘛</string>
 */
@interface SeaAlbumAssetsViewController : SeaCollectionViewController

/**
 相册代理
 */
@property(nonatomic,weak) id<SeaAlbumDelegate> delegate;

/**
 图片最大选择数量 default is '1'
 */
@property(nonatomic,assign) int maxSelectedCount;

/**
 网格图片间距 default is '3.0'
 */
@property(nonatomic,assign) CGFloat gridInterval;

/**
 每行图片数量 default is '3'
 */
@property(nonatomic,assign) int numberOfItemsPerRow;

/**
 相册分组信息
 */
@property(nonatomic,strong) ALAssetsGroup *group;

/**
 裁剪图片裁剪框设置 当不为空时会去裁剪图片，将忽略 maxSelectedCount，只选择一张图片
 */
@property(nonatomic,strong) SeaImageCropSettings *settings;

/**
 相册资源单例，必须使用单例，否则在 ios8.0 重复创建ALAssetsLibrary时 会出现崩溃
 */
+ (ALAssetsLibrary*)sharedAssetsLibrary;

@end
