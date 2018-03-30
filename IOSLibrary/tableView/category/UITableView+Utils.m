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

- (void)registerNib:(Class)clazz
{
    NSString *name = NSStringFromClass(clazz);
    [self registerNib:[UINib nibWithNibName:name bundle:nil] forCellReuseIdentifier:name];
}

- (void)registerClass:(Class) clazz
{
    [self registerClass:clazz forCellReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerNibForHeaderFooterView:(Class)clazz
{
    NSString *name = NSStringFromClass(clazz);
    [self registerNib:[UINib nibWithNibName:name bundle:nil] forHeaderFooterViewReuseIdentifier:name];
}

- (void)registerClassForHeaderFooterView:(Class)clazz
{
    [self registerClass:clazz forHeaderFooterViewReuseIdentifier:NSStringFromClass(clazz)];
}

@end
