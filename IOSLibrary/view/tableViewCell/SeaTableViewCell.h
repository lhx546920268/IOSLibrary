//
//  SeaTableViewCell.h

//

#import <UIKit/UIKit.h>

/**列表分割线类型
 */
typedef NS_ENUM(NSInteger, SeaTableViewCellStyle)
{
    SeaTableViewCellStyleNone = 0, //没有分割线
    SeaTableViewCellStyleSingleline = 1 //一条线，可设置 线条颜色
};

/**自定义cell, 可自定义分割线 ，去除 UITableViewStyleGrouped IOS 7.0以下的圆角和内容缩进
 */
@interface SeaTableViewCell : UITableViewCell

/**列表分割线类型仅 left和right有效 default is '(0, 10.0, 0, 0)'
 */
@property(nonatomic,assign) UIEdgeInsets separatorInsets;

/**分割线类型 default is 'SeaTableViewCellStyleNone'
 */
@property(nonatomic,assign) SeaTableViewCellStyle customSeparatorStyle;

/**分割线 当 SeaTableViewCellSeparatorStyleSingleline 时，有效
 */
@property(nonatomic,readonly) UIView *separator;


@end
