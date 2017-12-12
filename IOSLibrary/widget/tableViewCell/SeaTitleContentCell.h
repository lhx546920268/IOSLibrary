//
//  SeaTitleContentCell.h

//

#import <UIKit/UIKit.h>

//边距
#define _SeaTitleContentCellMargin_ 15.0

//视图间隔
#define _SeaTitleContentCellControlInterval_ 5.0

//高度
#define _SeaTitleContentCellHeight_ 45.0

//字体
#define _SeaTitleContentCellFont_ [UIFont systemFontOfSize:15.0]

//标题宽度
#define _SeaTitleContentCellTitleWidth_ 70.0

//箭头宽度
#define _SeaTitleContentCellArrowWidth_ 15.0

/**标题加内容的cell
 */
@interface SeaTitleContentCell : UITableViewCell

/**信息标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**信息内容
 */
@property(nonatomic,readonly) UILabel *contentLabel;

/**获取内容高度
 */
@property(nonatomic,assign) CGFloat contentHeight;

/**标题宽度
 */
@property(nonatomic,assign) CGFloat titleWidth;

/**箭头
 */
@property(nonatomic,readonly) UIImageView *arrowImageView;

@end
