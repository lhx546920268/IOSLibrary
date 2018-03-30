//
//  UITableView+Utils.h

//

#import <UIKit/UIKit.h>

@interface UITableView (Utils)

/**
 隐藏多余的分割线
 */
- (void)setExtraCellLineHidden;

///注册cell
- (void)registerNib:(Class) clazz;
- (void)registerClass:(Class) clazz;

///注册header footer
- (void)registerNibForHeaderFooterView:(Class) clazz;
- (void)registerClassForHeaderFooterView:(Class) clazz;

@end
