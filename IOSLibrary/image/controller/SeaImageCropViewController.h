//
//  SeaImageCropViewController.h

//

#import <UIKit/UIKit.h>
#import "SeaAlbumDelegate.h"
#import "SeaImageCropSettings.h"

/**图片裁剪
 */
@interface SeaImageCropViewController : UIViewController

@property (nonatomic, weak) id<SeaAlbumDelegate> delegate;

/**裁剪框的位置 大小
 */
@property (nonatomic, readonly) CGRect cropFrame;

/**构造方法
 *@param settings 裁剪设置
 *@return 一个实例
 */
- (id)initWithSettings:(SeaImageCropSettings*) settings;

///获取裁剪的图片
- (UIImage*)cropImage;

@end
