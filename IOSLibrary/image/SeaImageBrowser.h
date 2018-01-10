//
//  SeaImageBrowser.h
//  IOSLibrary
//
//  Created by 罗海雄 on 16/6/2.
//  Copyright © 2016年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaImageBrowserCell;

///图片浏览器cell代理
@protocol SeaImageBrowserCellDelegate <NSObject>

///点击
- (void)imageBrowserCellDidTap:(SeaImageBrowserCell*) cell;

@end

///图片浏览器cell
@interface SeaImageBrowserCell : UICollectionViewCell<UIScrollViewDelegate>

/**滚动视图，用于图片放大缩小
 */
@property(nonatomic,readonly) UIScrollView *scrollView;

/**图片
 */
@property(nonatomic,readonly) UIImageView *imageView;

@property(nonatomic,weak) id<SeaImageBrowserCellDelegate> delegate;

/**重新布局图片当图片加载完成时
 */
- (void)layoutImageAfterLoad;

/**计算imageView的位置大小
 */
- (CGRect)rectFromImage:(UIImage*) image;

@end

@class SeaImageBrowser;

///图片浏览器代理
@protocol SeaImageBrowserDelegate <NSObject>

@optional
/**将进入满屏
 */
- (void)imageBrowserWillEnterFullScreen:(SeaImageBrowser*) browser;

/**已经进入满屏
 */
- (void)imageBrowserDidEnterFullScreen:(SeaImageBrowser *) browser;

/**将退出满屏
 */
- (void)imageBrowserWillExistFullScreen:(SeaImageBrowser*) browser;

/**已经退出满屏
 */
- (void)imageBrowserDidExistFullScreen:(SeaImageBrowser*) browser;

/**选择某个cell
 */
- (void)imageBrowser:(SeaImageBrowser*) browser didSelectCellAtIndex:(NSInteger) index;

@end

///图片浏览器
@interface SeaImageBrowser : UIViewController

/**图片路径集合 ，数组元素是 NSString
 */
@property(nonatomic,retain) NSArray *source;

/**当前显示的图片下标
 */
@property(nonatomic,readonly) NSInteger visibleIndex;

/**以前的大小 退出全屏后使用
 */
@property(nonatomic,assign) CGRect previousFrame;

/**显示全屏和退出全屏所需的图片
 */
@property(nonatomic,strong) UIImage *previousImage;

@property(nonatomic,weak) id<SeaImageBrowserDelegate> delegate;


/**构造方法
 *@param source 图片路径集合 ，数组元素是 NSString
 *@param index 当前显示的图片下标
 *@return 一个初始化的 SeaFullImagePreviewView 对象
 */
- (id)initWithSource:(NSArray*) source visibleIndex:(NSInteger) index;

/**显示全屏预览
 *@param show 是否显示
 *@param rect 起始位置大小，可以通过- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view 方法来获取
 *@param flag 是否动画
 */
- (void)setShowFullScreen:(BOOL) show fromRect:(CGRect) rect animate:(BOOL) flag;


/**重新加载数据
 */
- (void)reloadData;

@end
