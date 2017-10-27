//
//  SeaLoadingIndicator.h

//
//

#import <UIKit/UIKit.h>

#define _SeaLoadingIndicatorHeight_ 40.0

@class SeaNetworkActivityView;

/**加载指示器,转轮和文字永远居中显示
 */
@interface SeaLoadingIndicator : UIView

/**加载标题
 */
@property(nonatomic,assign) NSString *title;

/**加载文字
 */
@property(nonatomic,readonly) UILabel *textLabel;

/**加载指示器
 */
@property(nonatomic,readonly) UIActivityIndicatorView *loadActivityIndicator;

/**加载指示器
 */
@property(nonatomic,strong) SeaNetworkActivityView *actView;

/**是否正在加载
 */
@property(nonatomic,assign) BOOL loading;

/**构造方法
 *@param frame 位置大小
 *@param title 加载提示标题
 *@return 一个初始化的 SeaLoadingIndicator 对象
 */
- (id)initWithFrame:(CGRect)frame title:(NSString*) title;



@end
