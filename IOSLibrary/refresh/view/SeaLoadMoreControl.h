//
//  SeaLoadMoreControl.h

//

#import "SeaDataControl.h"

/**上拉加载视图，如果contentSize.height 小于frame.size.height 将无法上拉加载
 */
@interface SeaLoadMoreControl : SeaDataControl

/**加载菊花
 */
@property(nonatomic,readonly) UIActivityIndicatorView *activityIndicatorView;

/**加载显示的提示信息
 */
@property(nonatomic,readonly) UILabel *remindLabel;

/**到达底部时是否自动加载更多 default is 'YES'
 */
@property(nonatomic, assign) BOOL autoLoadMore;

/**当 contentSize 为0时是否可以加载更多 default is 'NO'
 */
@property(nonatomic, assign) BOOL loadMoreEnableWhileZeroContent;

/**已经没有更多信息可以加载
 */
- (void)noMoreInfo;

@end
