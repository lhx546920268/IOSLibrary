//
//  UIScrollView+SeaRefreshControlUtilities.h

//

#import <UIKit/UIKit.h>
#import "SeaRefreshControl.h"
#import "SeaLoadMoreControl.h"

/**下拉刷新方便创建的 方法
 */
@interface UIScrollView (SeaDataControl)

/**添加下拉刷新功能
 *@param block 刷新回调方法
 */
- (void)addRefreshControlUsingBlock:(SeaDataControlBlock) block;

/**删除下拉刷新功能
 */
- (void)removeRefreshControl;

/**下拉刷新控制类
 */
@property(nonatomic,assign) SeaRefreshControl *sea_refreshControl;


/**添加上拉加载功能
 *@param block 加载回调
 */
- (void)addLoadMoreControlUsingBlock:(SeaDataControlBlock) block;

/**删除上拉加载功能
 */
- (void)removeLoadMoreControl;

/**上拉加载控制类
 */
@property(nonatomic,assign) SeaLoadMoreControl *loadMoreControl;

@end
