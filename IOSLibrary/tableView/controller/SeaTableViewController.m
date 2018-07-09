//
//  SeaTableViewController.m

//

#import "SeaTableViewController.h"
#import "UIViewController+Utils.h"
#import "UIView+SeaAutoLayout.h"
#import "NSString+Utils.h"
#import "UIView+SeaEmptyView.h"
#import "UITableView+Utils.h"

@interface SeaTableViewController ()


@end

@implementation SeaTableViewController

@synthesize tableView = _tableView;

- (id)initWithStyle:(UITableViewStyle) style
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _style = style;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithStyle:UITableViewStylePlain];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _separatorEdgeInsets = UIEdgeInsetsMake(0, 15.0, 0, 0);
}

- (UITableView*)tableView
{
    [self initTableView];
    return _tableView;
}

#pragma mark- public method

/**初始化视图 子类必须调用该方法
 */
- (void)initialization
{
    [super initialization];
    [self initTableView];
    self.contentView = _tableView;
}

- (void)initTableView
{
    [super initialization];
    if(!_tableView){
        Class clazz = [self tableViewClass];
        NSAssert(![clazz isKindOfClass:[UITableView class]], @"tableViewClass 必须是UITableView 或者 其子类");
        _tableView = [[clazz alloc] initWithFrame:CGRectZero style:_style];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        _tableView.sea_emptyViewDelegate = self;
        
        [_tableView setSeparatorInset:self.separatorEdgeInsets];
        
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)]){
            [_tableView setLayoutMargins:self.separatorEdgeInsets];
        }
        
        self.scrollView = _tableView;
    }
}

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    if(![NSString isEmpty:self.title]){
        view.textLabel.text = [NSString stringWithFormat:@"暂无%@信息", self.title];
    }else{
        view.textLabel.text = @"暂无信息";
    }
}

///注册cell
- (void)registerNib:(Class)clazz
{
    [self.tableView registerNib:clazz];
}

- (void)registerClass:(Class) clazz
{
    [self.tableView registerClass:clazz];
}

- (void)registerNibForHeaderFooterView:(Class) clazz
{
    [self.tableView registerNibForHeaderFooterView:clazz];
}

- (void)registerClassForHeaderFooterView:(Class) clazz
{
    [self.tableView registerClassForHeaderFooterView:clazz];
}

- (Class)tableViewClass
{
    return [UITableView class];
}

#pragma mark- tableView 代理

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setSeparatorInset:self.separatorEdgeInsets];
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)])
    {
        [cell setLayoutMargins:self.separatorEdgeInsets];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(_tableView){
        [_tableView setSeparatorInset:self.separatorEdgeInsets];
        
        if([_tableView respondsToSelector:@selector(setLayoutMargins:)]){
            [_tableView setLayoutMargins:self.separatorEdgeInsets];
        }
    }
}

#pragma mark- 屏幕旋转

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [_tableView reloadData];
}

@end
