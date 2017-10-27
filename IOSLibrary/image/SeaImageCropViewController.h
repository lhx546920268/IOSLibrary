//
//  SeaImageCropViewController.h

//

#import "SeaViewController.h"

///裁剪设置
@interface SeaImageCropSettings : NSObject

///裁剪图片
@property(nonatomic,strong) UIImage *image;

///裁剪框大小
@property(nonatomic,assign) CGSize cropSize;

///裁剪框圆角
@property(nonatomic,assign) CGFloat cropCornerRadius;

///是否使用满屏裁剪框 default is 'YES'
@property(nonatomic,assign) BOOL useFullScreenCropFrame;

/**图片可以被放大的最大比例，default is '2.5'
 */
@property (nonatomic, assign) CGFloat limitRatio;

@end

/**图片裁剪
 */
@interface SeaImageCropViewController : SeaViewController

@property (nonatomic, weak) id delegate;

/**裁剪框的位置 大小
 */
@property (nonatomic, readonly) CGRect cropFrame;

/**是否是弹出视图 default is 'NO'
*/
@property(nonatomic,assign) BOOL present;

/**构造方法
 *@param settings 裁剪设置
 *@return 一个实例
 */
- (id)initWithSettings:(SeaImageCropSettings*) settings;

///获取裁剪的图片
- (UIImage*)cropImage;

@end
