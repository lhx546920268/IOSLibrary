//
//  SeaPhotoAlbumDelegate.h

//

#import <Foundation/Foundation.h>

/**相册选择代理
 */
@protocol SeaAlbumDelegate <NSObject>

@optional

//下面两个方法建议只实现一个

/**图片选择完成
 *@param images 数组元素是 UIImage
 */
- (void)albumDidFinishSelectImages:(NSArray*) images;

/**图片资源选择完成 
 *@param assets 数组元素是 ALAsset
 */
- (void)albumDidFinishSelectAssets:(NSArray*) assets;

@end
