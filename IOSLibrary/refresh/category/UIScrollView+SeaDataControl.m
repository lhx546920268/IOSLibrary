//
//  UIScrollView+SeaRefreshControlUtilities.m

//

#import "UIScrollView+SeaDataControl.h"
#import <objc/runtime.h>
#import "UIView+SeaEmptyView.h"
#import "SeaRefreshControl.h"
#import "SeaLoadMoreControl.h"
#import "SeaRefreshStyle.h"

//下拉刷新控制器的key
static char SeaRefreshControlKey;

//上拉加载控制器的 key
static char SeaLoadMoreControlKey;

@implementation UIScrollView (SeaDataControl)

- (SeaRefreshControl*)sea_addRefreshWithHandler:(SeaDataControlHandler)handler
{
    SeaRefreshControl *refreshControl = self.sea_refreshControl;
    if(!refreshControl){
        refreshControl = [[[SeaRefreshStyle sharedInstance].refreshClass alloc] initWithScrollView:self];
    }
    refreshControl.handler = handler;
    self.sea_refreshControl = refreshControl;
    self.sea_loadMoreControl.originalContentInset = self.contentInset;
    
    return refreshControl;
}

- (void)sea_removeRefreshControl
{
    SeaRefreshControl *refreshControl = self.sea_refreshControl;
    if(refreshControl){
        self.contentInset = refreshControl.originalContentInset;
        self.sea_refreshControl = nil;
    }
}

- (SeaRefreshControl*)sea_refreshControl
{
    return objc_getAssociatedObject(self, &SeaRefreshControlKey);
}

- (void)setSea_refreshControl:(SeaRefreshControl *) refreshControl
{
    if(refreshControl != self.sea_refreshControl){
        [self.sea_refreshControl removeFromSuperview];
        objc_setAssociatedObject(self, &SeaRefreshControlKey, refreshControl, OBJC_ASSOCIATION_ASSIGN);
        
        [self addSubview:refreshControl];
    }
}

#pragma mark loadmore control

- (SeaLoadMoreControl*)sea_addLoadMoreWithHandler:(SeaDataControlHandler)handler
{
    SeaLoadMoreControl *loadMoreControl = self.sea_loadMoreControl;
    if(!loadMoreControl){
        loadMoreControl = [[[SeaRefreshStyle sharedInstance].loadMoreClass alloc] initWithScrollView:self];
    }
    loadMoreControl.handler = handler;
    self.sea_loadMoreControl = loadMoreControl;
    self.sea_refreshControl.originalContentInset = self.contentInset;
    
    return loadMoreControl;
}

- (void)sea_removeLoadMoreControl
{
    SeaLoadMoreControl *loadMoreControl = self.sea_loadMoreControl;
    if(loadMoreControl){
        self.contentInset = loadMoreControl.originalContentInset;
        self.sea_loadMoreControl = nil;
    }
}

- (void)setSea_loadMoreControl:(SeaLoadMoreControl *) loadMoreControl
{
    if(loadMoreControl != self.sea_loadMoreControl){
        [self.sea_loadMoreControl removeFromSuperview];
        objc_setAssociatedObject(self, &SeaLoadMoreControlKey, loadMoreControl, OBJC_ASSOCIATION_RETAIN);

        SeaEmptyView *emptyView = self.sea_emptyView;
        if(emptyView){
            [self insertSubview:loadMoreControl belowSubview:emptyView];
        }else{
            [self addSubview:loadMoreControl];
        }
    }
}

- (SeaLoadMoreControl*)sea_loadMoreControl
{
    return objc_getAssociatedObject(self, &SeaLoadMoreControlKey);
}

@end
