//
//  SeaTableViewController.h
//  Sea

//

#import "SeaScrollViewController.h"
#import "UITableView+SeaRowHeight.h"

/**列表控制视图
 */
@interface SeaTableViewController : SeaScrollViewController<UITableViewDelegate,UITableViewDataSource>

/**信息列表
 */
@property(nonatomic,readonly) UITableView *tableView;

/**列表风格
 */
@property(nonatomic,assign) UITableViewStyle style;

/**分割线位置 default is '(0, 15.0, 0, 0)'
 */
@property(nonatomic,assign) UIEdgeInsets separatorEdgeInsets;

/**构造方法
 *@param style 列表风格
 *@return 一个初始化的 SeaTableViewController 对象
 */
- (id)initWithStyle:(UITableViewStyle) style;

///注册cell
- (void)registerNib:(Class) clazz;
- (void)registerNib:(UINib*) nib forCellReuseIdentifier:(NSString*) identifier;
- (void)registerClass:(Class) cellClas;
- (void)registerClass:(Class) cellClass forCellReuseIdentifier:(NSString*) identifier;

- (void)registerNibForHeaderFooterView:(Class) clazz;
- (void)registerNib:(UINib*) nib forHeaderFooterViewReuseIdentifier:(NSString*) identifier;
- (void)registerClassForHeaderFooterView:(Class) clazz;
- (void)registerClass:(Class) clazz forHeaderFooterViewReuseIdentifier:(NSString*) identifier;


@end
