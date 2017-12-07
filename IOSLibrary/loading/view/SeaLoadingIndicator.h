//
//  SeaLoadingIndicator.h

//
//

#import <UIKit/UIKit.h>

/**加载指示器,转轮和文字永远居中显示
 */
@interface SeaLoadingIndicator : UIView

/**加载标题
 */
@property(nonatomic,copy) NSString *title;

/**加载文字
 */
@property(nonatomic,readonly) UILabel *textLabel;

/**加载指示器
 */
@property(nonatomic,readonly) UIActivityIndicatorView *activityIndicatorView;

/**是否正在加载
 */
@property(nonatomic,assign) BOOL loading;


@end
