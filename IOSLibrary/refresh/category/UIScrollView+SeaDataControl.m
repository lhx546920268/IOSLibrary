//
//  UIScrollView+SeaRefreshControlUtilities.m

//

#import "UIScrollView+SeaDataControl.h"
#import <objc/runtime.h>
#import "SeaEmptyView.h"
#import "SeaRefreshControl.h"
#import "SeaLoadMoreControl.h"

//下拉刷新控制器的key
static char SeaRefreshControlKey;

//上拉加载控制器的 key
static char SeaLoadMoreControlKey;

@implementation UIScrollView (SeaDataControl)

#pragma mark- refresh control

/**添加下拉刷新功能
 *@param block 刷新回调方法
 */
- (void)addRefreshControlUsingBlock:(void (^)(void)) block
{
    SeaRefreshControl *refreshControl = [[SeaRefreshControl alloc] initWithScrollView:self];
    refreshControl.refreshBlock = block;
    self.sea_refreshControl = refreshControl;
    self.loadMoreControl.originalContentInset = self.contentInset;
    
}

/**删除下拉刷新功能
 */
- (void)removeRefreshControl
{
    self.sea_refreshControl = nil;
}

/**获取下拉刷新控制器
 */
- (SeaRefreshControl*)sea_refreshControl
{
    return objc_getAssociatedObject(self, &SeaRefreshControlKey);
}

/**设置下拉属性控制器
 */
- (void)setSea_refreshControl:(SeaRefreshControl *)refreshControl
{
    if(refreshControl != self.sea_refreshControl)
    {
        [self.sea_refreshControl removeFromSuperview];
        [self willChangeValueForKey:@"sea_refreshControl"];
        objc_setAssociatedObject(self, &SeaRefreshControlKey, refreshControl, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"sea_refreshControl"];
        
        [self addSubview:refreshControl];
    }
}

#pragma mark- loadmore control

/**添加上拉加载功能
 *@param block 加载回调
 */
- (void)addLoadMoreControlUsingBlock:(SeaDataControlBlock) block
{
    SeaLoadMoreControl *loadMoreControl = [[SeaLoadMoreControl alloc] initWithScrollView:self];
    loadMoreControl.refreshBlock = block;
    self.loadMoreControl = loadMoreControl;
    self.sea_refreshControl.originalContentInset = self.contentInset;
}

/**删除上拉加载功能
 */
- (void)removeLoadMoreControl
{
    self.loadMoreControl = nil;
}

/**设置上拉加载控制类
 */
- (void)setLoadMoreControl:(SeaLoadMoreControl *)loadMoreControl
{
    if(loadMoreControl != self.loadMoreControl)
    {
        [self.loadMoreControl removeFromSuperview];
        [self willChangeValueForKey:@"loadMoreControl"];
        objc_setAssociatedObject(self, &SeaLoadMoreControlKey, loadMoreControl, OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"loadMoreControl"];

        SeaEmptyView *emptyView = self.sea_emptyView;
        if(emptyView)
        {
            [self insertSubview:loadMoreControl belowSubview:emptyView];
        }
        else
        {
            [self addSubview:loadMoreControl];
        }
    }
}

/**获取上拉加载控制类
 */
- (SeaLoadMoreControl*)loadMoreControl
{
    return objc_getAssociatedObject(self, &SeaLoadMoreControlKey);
}


@end
