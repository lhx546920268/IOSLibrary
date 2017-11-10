//
//  SeaSearchDisplayViewController.m
//  Sea

//

#import "SeaSearchDisplayViewController.h"
#import "SeaBasic.h"

@interface SeaSearchDisplayViewController()

/**黑色半透明背景
 */
@property(nonatomic,strong) UIView *transparentView;

/**上一个视图 navigationBar的 translucent
 */
@property(nonatomic,assign) BOOL previousNavigationBarTranslucent;

/**容器滚动视图
 */
@property(nonatomic,strong) UIScrollView *containerScrollView;

/**tableView 初始高度
 */
@property(nonatomic,assign) CGFloat tableViewOriginHeight;

@end

@implementation SeaSearchDisplayViewController

/**构造方法
 *@param position 搜索栏位置
 *@return 一个初始化的 SeaSearchDisplayViewController
 */
- (id)initWithSearchBarPosition:(SeaSearchBarPosition) position
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _searchBarPosition = position;
        [self initParams];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        _searchBarPosition = SeaSearchBarPositionTableViewHeader;
        [self initParams];
    }
    return self;
}

///初始化
- (void)initParams
{
    _searchResults = [[NSMutableArray alloc] init];
    self.hideKeyboardWhileScroll = YES;
    self.showBackgroundWhileSearchingAndEmptyInput = YES;
    self.hideNavigationBarWhileSearching = YES;
}

#pragma mark- dealloc

- (void)dealloc
{
    
}

#pragma mark- 视图消失出现

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = self.previousNavigationBarTranslucent;
}

#pragma mark- property

/**搜索栏输入框
 */
- (UITextField*)searchTextField
{
    return self.searchBar.sea_searchedTextField;
}

/**搜索栏取消按钮
 */
- (UIButton*)searchCancelButton
{
    return self.searchBar.sea_searchedCancelButton;
}

/**在搜索期间是否隐藏导航栏，default is 'YES'，如果搜索栏的位置是 SeaSearchBarPositionNavigationBar，将忽略该值，如果搜索栏的位置是 SeaSearchBarPositionShowWhenSearch，此值一定为YES
 */
- (void)setHideNavigationBarWhileSearching:(BOOL)hideNavigationBarWhileSearching
{
    if(_hideNavigationBarWhileSearching != hideNavigationBarWhileSearching)
    {
        if(_searchBarPosition == SeaSearchBarPositionShowWhenSearch)
            hideNavigationBarWhileSearching = YES;
        
        if(_searchBarPosition == SeaSearchBarPositionNavigationBar)
            hideNavigationBarWhileSearching = NO;
        
        _hideNavigationBarWhileSearching = hideNavigationBarWhileSearching;
    }
}

#pragma mark- public method


//把控制视图中view改成UiScrollView，因为只有当UISearchBar的父视图为 UIScrollView时，UIBarPositionTopAttached才会生效
- (void)loadView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SeaScreenWidth, self.contentHeight)];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    self.view = scrollView;
    self.containerScrollView = scrollView;
}

/**初始化 子类必须调用该方法
 */
- (void)initialization
{
    [super initialization];
    
    [self initializeSearchBar];
}

//创建搜索栏
- (void)createSearchBar
{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SeaScreenWidth, 45.0)];
    [_searchBar setImage:[UIImage imageNamed:@"search_icon"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    self.searchBar.delegate = self;
    UITextField *searchField = self.searchTextField;
    searchField.font = [UIFont fontWithName:SeaMainFontName size:15.0];
    self.searchBar.placeholder = @"搜索";
}

///初始化UISearchBar
- (void)initializeSearchBar
{
    if(_searchBar)
        return;
    
    switch (_searchBarPosition)
    {
        case SeaSearchBarPositionTableViewHeader :
        case SeaSearchBarPositionTableViewTop :
        {
            if(!self.tableView)
            {
                return;
            }
        }
            break;
            
        default:
            break;
    }
    
    if(_searchBarPosition != SeaSearchBarPositionShowWhenSearch)
    {
        [self createSearchBar];
    }
    
    switch (_searchBarPosition)
    {
        case SeaSearchBarPositionTableViewTop :
        case SeaSearchBarPositionTableViewHeader :
        {
            [self.view addSubview:self.searchBar];
            
            self.tableView.top = self.searchBar.bottom;
            self.tableView.height = self.contentHeight - self.searchBar.bottom;
        }
            break;
        case SeaSearchBarPositionNavigationBar :
        {
            _searchBar.searchBarStyle = UISearchBarStyleMinimal;
            self.navigationItem.titleView = _searchBar;
        }
            break;
        case SeaSearchBarPositionShowWhenSearch :
        {
            [self setBarItemsWithStyle:UIBarButtonSystemItemSearch action:@selector(showSearchBar:) position:SeaNavigationItemPositionRight];
        }
        default:
            break;
    }
    
    self.tableViewOriginHeight = self.tableView.height;
}

#pragma mark- 需要重写的方法

/**搜索关键字改变 ,子类可重写该方法
 *@param string 当前搜索的关键字
 */
- (void)searchStringDidChangeWithString:(NSString*) string
{
    
}

/**点击搜索按钮 默认不做任何事，子类可重写该方法
 *@param string 当前关键字
 */
- (void)searchButtonDidClickWithString:(NSString*) string{}

/**点击取消搜索
 */
- (void)searchCancelDidClick{
    
}

/**取消搜索
 */
- (void)cancelSearch
{
    if([self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
    }
    
    _searching = NO;
    _transparentView.hidden = YES;
    _transparentView.alpha = 0;
    
    if(self.hideNavigationBarWhileSearching)
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if(_searchBarPosition != SeaSearchBarPositionShowWhenSearch)
    {
        [self.searchBar setShowsCancelButton:NO animated:YES];
    }
    else
    {
        [self setSearchBarHidden:YES];
    }
    
    [self searchCancelDidClick];
}

#pragma mark- UISearchBar delegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return self.tableView != nil;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if(_searching)
        return;
    
    self.containerScrollView.contentInset = UIEdgeInsetsZero;
    _searching = YES;
    
    if(self.showBackgroundWhileSearchingAndEmptyInput)
    {
        if(!_transparentView)
        {
            switch (_searchBarPosition)
            {
                case SeaSearchBarPositionTableViewTop :
                case SeaSearchBarPositionTableViewHeader :
                {
                    _transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchBar.bottom, SeaScreenWidth, self.contentHeight)];
                }
                    break;
                case SeaSearchBarPositionNavigationBar :
                {
                    _transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SeaScreenWidth, self.contentHeight)];
                }
                    break;
                case SeaSearchBarPositionShowWhenSearch :
                {
                    _transparentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.searchBar.height + self.statusBarHidden, SeaScreenWidth, self.contentHeight)];
                }
                    break;
                default:
                    break;
            }
            
            _transparentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
            [_transparentView addGestureRecognizer:tap];
            [self.view addSubview:_transparentView];
        }
        
        _transparentView.hidden = NO;
        _transparentView.alpha = 0;
        
        [UIView animateWithDuration:0.25 animations:^(void){
            _transparentView.alpha = 1.0;
        }];
        
        
    }
    
    if(self.hideNavigationBarWhileSearching)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    if(_searchBarPosition != SeaSearchBarPositionShowWhenSearch)
    {
        [self.searchBar setShowsCancelButton:YES animated:YES];
    }
    
    if(self.searchBarPosition == SeaSearchBarPositionNavigationBar)
    {
        [self.searchCancelButton setTitleColor:self.iconTintColor forState:UIControlStateNormal];
    }
    
    if(searchBar.text.length > 0)
    {
        [self searchBar:self.searchBar textDidChange:searchBar.text];
    }
    
    if(_transparentView)
    {
        [self.view bringSubviewToFront:_transparentView];
    }
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self cancelSearch];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(self.showBackgroundWhileSearchingAndEmptyInput)
    {
        _transparentView.hidden = searchText.length > 0 || !_searching;
    }
    if(_transparentView)
    {
        [self.view bringSubviewToFront:_transparentView];
    }
    
    [self searchStringDidChangeWithString:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchButtonDidClickWithString:searchBar.text];
}

#ifdef __IPHONE_7_0

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#endif


#pragma mark- private method

//显示搜索栏
- (void)showSearchBar:(id) sender
{
    if(!_searchBar)
    {
        [self createSearchBar];
        [_searchBar setShowsCancelButton:YES animated:NO];
        _searchBar.top = - _searchBar.height - self.statusBarHeight;
        [self.view addSubview:_searchBar];
    }
    
    [_searchBar becomeFirstResponder];
    [self setSearchBarHidden:NO];
}

//设置搜索栏隐藏状态
- (void)setSearchBarHidden:(BOOL) hidden
{
    if(hidden)
    {
        [UIView animateWithDuration:0.25 animations:^(void){
            
            _searchBar.top = - self.statusBarHeight - _searchBar.height;
            
            CGRect frame = self.tableView.frame;
            frame.origin.y = 0;
            frame.size.height = self.contentHeight;
            self.tableView.frame = frame;
            
        }completion:^(BOOL finish){
            
            _searchBar.hidden = YES;
        }];
    }
    else
    {
        _searchBar.hidden = hidden;
        [UIView animateWithDuration:0.25 animations:^(void){
            
            _searchBar.top = 0;
            
            CGRect frame = self.tableView.frame;
            frame.origin.y = _searchBar.height;
            frame.size.height = self.contentHeight;
            self.tableView.frame = frame;
        }];
    }
}

//取消搜索
- (void)cancel:(UITapGestureRecognizer*) tap
{
    [self cancelSearch];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(_hideKeyboardWhileScroll && [self.searchBar isFirstResponder])
    {
        [self.searchBar resignFirstResponder];
        self.searchCancelButton.enabled = YES;
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(!_searching)
    {
        switch (_searchBarPosition)
        {
            case SeaSearchBarPositionTableViewHeader :
            {
                UIScrollView *s = (UIScrollView*)self.view;
                
                CGFloat top = - scrollView.contentOffset.y;
                if(top < - self.searchBar.height)
                {
                    top = - self.searchBar.height;
                }
                else if(top > 0)
                {
                    top = 0;
                }
                s.contentInset = UIEdgeInsetsMake(top, 0, 0, 0);
                
                self.tableView.height = self.tableViewOriginHeight - top;
            }
                break;
                
            default:
                break;
        }
    }
}

@end

