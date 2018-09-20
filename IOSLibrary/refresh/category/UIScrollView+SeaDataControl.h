//
//  UIScrollView+SeaRefreshControlUtilities.h

//

#import <UIKit/UIKit.h>
#import "SeaDataControl.h"

@class SeaRefreshControl, SeaLoadMoreControl;

///刷新 类目
@interface UIScrollView (SeaDataControl)

/**
 添加下拉刷新功能
 *@param handler 刷新回调方法
 */
- (SeaRefreshControl*)sea_addRefreshWithHandler:(SeaDataControlHandler) handler;

/**
 删除下拉刷新功能
 */
- (void)sea_removeRefreshControl;

/**
 下拉刷新控制类
 */
@property(nonatomic, strong) SeaRefreshControl *sea_refreshControl;


/**
 添加加载更多
 *@param handler 加载回调
 */
- (SeaLoadMoreControl*)sea_addLoadMoreWithHandler:(SeaDataControlHandler) handler;

/**
 删除加载更多功能
 */
- (void)sea_removeLoadMoreControl;

/**
 加载更多控制类
 */
@property(nonatomic, strong) SeaLoadMoreControl *sea_loadMoreControl;

@end
