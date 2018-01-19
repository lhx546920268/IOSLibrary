//
//  SeaTabBarItem.h

//

#import <UIKit/UIKit.h>

@class SeaNumberBadge;

/**
 选项卡按钮
 */
@interface SeaTabBarItem : UIControl

/**
 标题
 */
@property(nonatomic,readonly) UILabel *textLabel;

/**
 边缘数值
 */
@property(nonatomic,copy) NSString *badgeValue;

/**
 边缘视图
 */
@property(nonatomic,retain) SeaNumberBadge *badge;

/**
 图片
 */
@property(nonatomic,readonly) UIImageView *imageView;

@end
