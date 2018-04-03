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
{
    UITableView *_tableView;
}

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
    self.scrollView = _tableView;
}

- (void)initTableView
{
    [super initialization];
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:_style];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = nil;
        _tableView.sea_emptyViewDelegate = self;
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

#pragma mark- tableView 代理

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
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
    [self.tableView setSeparatorInset:self.separatorEdgeInsets];
    
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.tableView setLayoutMargins:self.separatorEdgeInsets];
    }
}

#pragma mark- 屏幕旋转

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [self.tableView reloadData];
}

@end
