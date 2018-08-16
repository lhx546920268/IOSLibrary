//
//  SeaLoadMoreControl.h

//

#import "SeaDataControl.h"

/**
 上拉加载视图，如果contentSize.height 小于frame.size.height 将无法上拉加载
 */
@interface SeaLoadMoreControl : SeaDataControl

/**
 到达底部时是否自动加载更多 default is 'YES'
 */
@property(nonatomic, assign) BOOL autoLoadMore;

/**
 当 contentSize 为0时是否可以加载更多 default is 'NO'
 */
@property(nonatomic, assign) BOOL loadMoreEnableWhileZeroContent;

/**
 当没有数据时 是否停留在原地 default is 'NO'
 */
@property(nonatomic, assign) BOOL shouldStayWhileNoData;

/**
 已经没有更多信息可以加载
 */
- (void)noMoreInfo;

/**
 加载失败
 */
- (void)loadFail;

@end
