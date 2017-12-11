//
//  SeaFailPageView.h

//

#import <UIKit/UIKit.h>

/**当第一次获取数据失败时的提示框
 */
@interface SeaFailPageView : UIView

///图标
@property(nonatomic,strong) UIImageView *imageView;

/**提示信息
 */
@property(nonatomic,strong) UILabel *textLabel;

@end
