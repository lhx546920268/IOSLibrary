//
//  SeaTextCell.h

//

#import <UIKit/UIKit.h>

//边距
#define _SeaTextCellMargin_ 15.0

//字体
#define _SeaTextCellFont_ [UIFont systemFontOfSize:15.0]

/**单文本
 */
@interface SeaTextCell : UITableViewCell

/**文本
 */
@property(nonatomic,readonly) UILabel *contentLabel;

/**文本高度
 */
@property(nonatomic,assign) CGFloat contentHeight;

@end
