//
//  UITableView+Utils.m

//

#import "UITableView+Utils.h"

@implementation UITableView (Utils)

/**隐藏多余的分割线
 */
- (void)setExtraCellLineHidden
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.tableFooterView = nil;
    self.tableFooterView = view;
}

@end
