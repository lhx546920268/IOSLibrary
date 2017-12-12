//
//  SeaTextInsetLabel.h

//

#import <UIKit/UIKit.h>

/**可设置文字边距的lable
 */
@interface SeaTextInsetLabel : UILabel

/**文本边距 default is 'UIEdgeInsetsZero'
 */
@property(nonatomic,assign) UIEdgeInsets insets;

@end
