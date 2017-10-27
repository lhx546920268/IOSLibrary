//
//  SeaBadNetworkRemindView.h

//

#import <UIKit/UIKit.h>

@class SeaBadNetworkRemindView;

@protocol SeaBadNetworkRemindViewDelegate <NSObject>

@optional

/**重新加载数据
 */
- (void)badNetworkRemindViewDidReloadData:(SeaBadNetworkRemindView*) view;

@end

/**当第一次获取数据失败时的提示框
 */
@interface SeaBadNetworkRemindView : UIView

@property(nonatomic,weak) id delegate;

/**构造方法
 *@param frame 大小位置
 *@param message 提示信息 如果为空则使用默认的提示信息
 *@return 一个初始化的 SeaBadNetworkRemindView 
 */
- (id)initWithFrame:(CGRect)frame message:(NSString*) message;

@end
