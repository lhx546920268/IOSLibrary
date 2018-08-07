//
//  SeaTextInsetLabel.h

//

#import <UIKit/UIKit.h>

/**
 可设置文字边距的lable
 */
@interface SeaInsetsLabel : UILabel

/**
 文本边距 default is 'UIEdgeInsetsZero'
 */
@property(nonatomic,assign) CGFloat paddingLeft;
@property(nonatomic,assign) CGFloat paddingTop;
@property(nonatomic,assign) CGFloat paddingRight;
@property(nonatomic,assign) CGFloat paddingBottom;

@property(nonatomic,assign) UIEdgeInsets contentInsets;

@end
