//
//  SeaSearchDisplayViewController.m
//  Sea

//

#import "SeaSearchDisplayViewController.h"
#import "SeaBasic.h"
#import "UISearchBar+Utils.h"
#import "UIView+SeaAutoLayout.h"
#import "UIViewController+Utils.h"

@interface SeaSearchDisplayViewController()

/**
 黑色半透明背景
 */
@property(nonatomic,strong) UIView *translucentView;

/**
 上一个视图 navigationBar的 translucent
 */
@property(nonatomic,assign) BOOL previousNavigationBarTranslucent;

/**
 tableView 初始高度
 */
@property(nonatomic,assign) CGFloat tableViewOriginHeight;

@end

@implementation SeaSearchDisplayViewController

///初始化
- (void)initParams
{
    _searchResults = [[NSMutableArray alloc] init];
    self.hideKeyboardWhileScroll = YES;
    self.showBackgroundWhileSearchingAndEmptyInput = YES;
    self.hideNavigationBarWhileSearching = YES;
}

#pragma mark- 视图消失出现

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.translucent = self.previousNavigationBarTranslucent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initParams];
}

#pragma mark- property

- (UITextField*)searchTextField
{
    return self.searchBar.sea_searchedTextField;
}

- (UIButton*)searchCancelButton
{
    return self.searchBar.sea_searchedCancelButton;
}

- (void)setHideNavigationBarWhileSearching:(BOOL)hideNavigationBarWhileSearching
{
    if(_hideNavigationBarWhileSearching != hideNavigationBarWhileSearching){
        if(_searchBarPosition == SeaSearchBarPositionShowWhenSearch)
            hideNavigationBarWhileSearching = YES;
        
        if(_searchBarPosition == SeaSearchBarPositionNavigationBar)
            hideNavigationBarWhileSearching = NO;
        
        _hideNavigationBarWhileSearching = hideNavigationBarWhileSearching;
    }
}

#pragma mark- public method

- (void)initialization
{
    [super initialization];
    
    [self initializeSearchBar];
}

//创建搜索栏
- (void)createSearchBar
{
    _searchBar = [UISearchBar new];
    
    self.searchBar.delegate = self;
    UITextField *searchField = self.searchTextField;
    searchField.font = [UIFont fontWithName:SeaMainFontName size:15.0];
    self.searchBar.placeholder = @"搜索";
}

- (void)initializeSearchBar
{
    if(_searchBar)
        return;
    
    switch (_searchBarPosition){
        case SeaSearchBarPositionTableViewHeader :
        case SeaSearchBarPositionTableViewTop : {
            if(!self.tableView){
                return;
            }
        }
            break;
            
        default:
            break;
    }
    
    if(_searchBarPosition != SeaSearchBarPositionShowWhenSearch){
        [self createSearchBar];
    }
    
    switch(_searchBarPosition){
        case SeaSearchBarPositionTableViewTop :
        case SeaSearchBarPositionTableViewHeader : {
            self.searchBar.frame = CGRectMake(0, 0, SeaScreenWidth, 45);
            self.tableView.tableHeaderView = self.searchBar;
            
//            self.tableView.top = self.searchBar.bottom;
//            self.tableView.height = self.contentHeight - self.searchBar.bottom;
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
//            [self setBarItemsWithStyle:UIBarButtonSystemItemSearch action:@selector(showSearchBar:) position:SeaNavigationItemPositionRight];
        }
        default:
            break;
    }
    
//    self.tableViewOriginHeight = self.tableView.height;
}

#pragma mark- 需要重写的方法

- (void)searchStringDidChangeWithString:(NSString*) string
{
    
}

- (void)searchButtonDidClickWithString:(NSString*) string{}

- (void)searchCancelDidClick{
    
}

- (void)cancelSearch
{
    if([self.searchBar isFirstResponder]){
        [self.searchBar resignFirstResponder];
    }
    
    _searching = NO;
    _translucentView.hidden = YES;
    _translucentView.alpha = 0;
    
    if(self.hideNavigationBarWhileSearching){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
    
    if(_searchBarPosition != SeaSearchBarPositionShowWhenSearch){
        [self.searchBar setShowsCancelButton:NO animated:YES];
    }else{
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
    
    _searching = YES;
    
    if(self.showBackgroundWhileSearchingAndEmptyInput){
//        if(!_translucentView){
//            _translucentView = [UIView new];
//            _translucentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//            
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
//            [_translucentView addGestureRecognizer:tap];
//            [self.view addSubview:_translucentView];
//            
//            switch(_searchBarPosition){
//                case SeaSearchBarPositionTableViewTop :
//                case SeaSearchBarPositionTableViewHeader :
//                    case SeaSearchBarPositionShowWhenSearch : {
//                    [_translucentView sea_leftToSuperview];
//                    [_translucentView sea_rightToSuperview];
//                    [_translucentView sea_bottomToSuperview];
//                    [_translucentView sea_topToItemBottom:self.searchBar];
//                }
//                    break;
//                case SeaSearchBarPositionNavigationBar : {
//                    [_translucentView sea_insetsInSuperview:UIEdgeInsetsZero];
//                }
//                    break;
//                default:
//                    break;
//            }
//        }
        
        _translucentView.hidden = NO;
        _translucentView.alpha = 0;
        
        [UIView animateWithDuration:0.25 animations:^(void){
            _translucentView.alpha = 1.0;
        }];
        
        
    }
    
    if(self.hideNavigationBarWhileSearching){
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    
    if(_searchBarPosition != SeaSearchBarPositionShowWhenSearch){
        [self.searchBar setShowsCancelButton:YES animated:YES];
    }
    
    if(self.searchBarPosition == SeaSearchBarPositionNavigationBar){
        [self.searchCancelButton setTitleColor:self.sea_iconTintColor forState:UIControlStateNormal];
    }
    
    if(searchBar.text.length > 0){
        [self searchBar:self.searchBar textDidChange:searchBar.text];
    }
    
    if(_translucentView){
        [self.view bringSubviewToFront:_translucentView];
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
    if(self.showBackgroundWhileSearchingAndEmptyInput){
        _translucentView.hidden = searchText.length > 0 || !_searching;
    }
    if(_translucentView){
        [self.view bringSubviewToFront:_translucentView];
    }
    
    [self searchStringDidChangeWithString:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchButtonDidClickWithString:searchBar.text];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

#pragma mark- private method

//显示搜索栏
- (void)showSearchBar:(id) sender
{
    if(!_searchBar){
        [self createSearchBar];
        [_searchBar setShowsCancelButton:YES animated:NO];
//        _searchBar.top = - _searchBar.height - self.statusBarHeight;
        [self.view addSubview:_searchBar];
    }
    
    [_searchBar becomeFirstResponder];
    [self setSearchBarHidden:NO];
}

//设置搜索栏隐藏状态
- (void)setSearchBarHidden:(BOOL) hidden
{
    if(hidden){
        [UIView animateWithDuration:0.25 animations:^(void){
            
//            _searchBar.top = - self.statusBarHeight - _searchBar.height;
            
            CGRect frame = self.tableView.frame;
            frame.origin.y = 0;
//            frame.size.height = self.contentHeight;
            self.tableView.frame = frame;
            
        }completion:^(BOOL finish){
            
            _searchBar.hidden = YES;
        }];
    }else{
        _searchBar.hidden = hidden;
        [UIView animateWithDuration:0.25 animations:^(void){
            
//            _searchBar.top = 0;
            
            CGRect frame = self.tableView.frame;
//            frame.origin.y = _searchBar.height;
//            frame.size.height = self.contentHeight;
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
    if(_hideKeyboardWhileScroll && [self.searchBar isFirstResponder]){
        [self.searchBar resignFirstResponder];
        self.searchCancelButton.enabled = YES;
    }
}

@end

