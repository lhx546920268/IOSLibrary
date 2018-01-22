//
//  UITableView+Utils.m

//

#import "UITableView+Utils.h"

@implementation UITableView (Utils)

- (void)setExtraCellLineHidden
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    self.tableFooterView = nil;
    self.tableFooterView = view;
}

@end
