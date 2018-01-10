//
//  UIScrollView+SeaRefreshControlUtilities.m

//

#import "UIScrollView+SeaDataControl.h"
#import <objc/runtime.h>
#import "UIView+SeaEmptyView.h"
#import "SeaRefreshControl.h"
#import "SeaLoadMoreControl.h"

//下拉刷新控制器的key
static char SeaRefreshControlKey;

//上拉加载控制器的 key
static char SeaLoadMoreControlKey;

@implementation UIScrollView (SeaDataControl)

- (void)sea_addRefreshWithHandler:(SeaDataControlHandler)handler
{
    SeaRefreshControl *refreshControl = [[SeaRefreshControl alloc] initWithScrollView:self];
    refreshControl.handler = handler;
    self.sea_refreshControl = refreshControl;
    self.sea_loadMoreControl.originalContentInset = self.contentInset;
    
}

- (void)sea_removeRefreshControl
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
- (void)setSea_refreshControl:(SeaRefreshControl *) refreshControl
{
    if(refreshControl != self.sea_refreshControl){
        [self.sea_refreshControl removeFromSuperview];
        [self willChangeValueForKey:@"sea_refreshControl"];
        objc_setAssociatedObject(self, &SeaRefreshControlKey, refreshControl, OBJC_ASSOCIATION_ASSIGN);
        [self didChangeValueForKey:@"sea_refreshControl"];
        
        [self addSubview:refreshControl];
    }
}

#pragma mark- loadmore control

- (void)sea_addLoadMoreWithHandler:(SeaDataControlHandler)handler
{
    SeaLoadMoreControl *loadMoreControl = [[SeaLoadMoreControl alloc] initWithScrollView:self];
    loadMoreControl.handler = handler;
    self.sea_loadMoreControl = loadMoreControl;
    self.sea_refreshControl.originalContentInset = self.contentInset;
}

- (void)sea_removeLoadMoreControl
{
    self.sea_loadMoreControl = nil;
}

/**设置上拉加载控制类
 */
- (void)setSea_loadMoreControl:(SeaLoadMoreControl *) loadMoreControl
{
    if(loadMoreControl != self.sea_loadMoreControl){
        [self.sea_loadMoreControl removeFromSuperview];
        [self willChangeValueForKey:@"sea_loadMoreControl"];
        objc_setAssociatedObject(self, &SeaLoadMoreControlKey, loadMoreControl, OBJC_ASSOCIATION_RETAIN);
        [self didChangeValueForKey:@"sea_loadMoreControl"];

        SeaEmptyView *emptyView = self.sea_emptyView;
        if(emptyView){
            [self insertSubview:loadMoreControl belowSubview:emptyView];
        }else{
            [self addSubview:loadMoreControl];
        }
    }
}

/**获取上拉加载控制类
 */
- (SeaLoadMoreControl*)sea_loadMoreControl
{
    return objc_getAssociatedObject(self, &SeaLoadMoreControlKey);
}


@end
