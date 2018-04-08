//
//  SeaTextInsetLabel.h

//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

/**
 可设置文字边距的lable
 */
@interface SeaInsetsLabel : UILabel

/**
 文本边距 default is 'UIEdgeInsetsZero'
 */
@property(nonatomic,assign) IBInspectable CGFloat paddingLeft;
@property(nonatomic,assign) IBInspectable CGFloat paddingTop;
@property(nonatomic,assign) IBInspectable CGFloat paddingRight;
@property(nonatomic,assign) IBInspectable CGFloat paddingBottom;

@property(nonatomic,assign) UIEdgeInsets contentInsets;

@end
