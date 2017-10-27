//
//  SeaWebToolBar.h

//

#import <UIKit/UIKit.h>

@class SeaWebViewController,SeaButton;

/**网页工具条，具有前进，后退，刷新，分享功能
 */
@interface SeaWebToolBar : NSObject

/**工具条
 */
@property(nonatomic,readonly) UIToolbar *toolBar;

/**工具条隐藏状态
 */
@property(nonatomic,assign) BOOL toolBarHidden;

//前进按钮
@property(nonatomic,strong) SeaButton *forwrodButton;

//后退按钮
@property(nonatomic,strong) SeaButton *backwordButton;

//刷新按钮
@property(nonatomic,strong) SeaButton *refreshButton;

/**构造方法
 *@param webViewController 浏览器
 *@return 一个实例
 */
- (id)initWithWebViewController:(SeaWebViewController*)  webViewController;

/**刷新工具条功能
 */
- (void)refreshToolBar;

/**设置toolBar的隐藏状态
 */
- (void)setToolBarHidden:(BOOL) hidden animate:(BOOL) flag;

@end
