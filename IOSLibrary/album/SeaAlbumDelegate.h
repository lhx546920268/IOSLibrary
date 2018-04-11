//
//  SeaPhotoAlbumDelegate.h

//

#import <Foundation/Foundation.h>

@class ALAsset;

/**相册选择代理
 */
@protocol SeaAlbumDelegate <NSObject>

@optional

//下面两个方法建议只实现一个

/**图片选择完成
 *@param images 选择的图片
 */
- (void)albumDidFinishSelectImages:(NSArray<UIImage*>*) images;

/**图片资源选择完成 
 *@param assets 选择的图片
 */
- (void)albumDidFinishSelectAssets:(NSArray<ALAsset*>*) assets;

@end
