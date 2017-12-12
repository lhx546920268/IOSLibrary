//
//  SeaSeparatorTableViewCell.h

//

#import <UIKit/UIKit.h>

/**列表分割线类型
 */
typedef NS_ENUM(NSInteger, SeaTableViewCellSeparatorStyle)
{
    SeaTableViewCellSeparatorStyleNone = 0, //没有分割线
    SeaTableViewCellSeparatorStyleSingleline = 1 //一条线，可设置 线条颜色
};

/**自带分割线的cell
 */
@interface SeaSeparatorTableViewCell : UITableViewCell

/**列表分割线类型仅 left和right有效 default is '(0, 10.0, 0, 0)'
 */
@property(nonatomic,assign) UIEdgeInsets separatorInsets;

/**分割线类型 default is 'SeaTableViewCellSeparatorStyleSingleline'
 */
@property(nonatomic,assign) SeaTableViewCellSeparatorStyle customSeparatorStyle;

/**分割线 当 SeaTableViewCellSeparatorStyleSingleline 时，有效
 */
@property(nonatomic,readonly) UIView *separator;

@end
