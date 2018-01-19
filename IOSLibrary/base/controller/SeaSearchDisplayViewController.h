//
//  SeaSearchDisplayViewController.h
//  Sea

//

#import "SeaTableViewController.h"


/**搜索栏位置
 */
typedef NS_ENUM(NSInteger, SeaSearchBarPosition)
{
    ///搜索栏在列表顶部
    SeaSearchBarPositionTableViewTop = 0,
    
    ///搜索栏在表头
    SeaSearchBarPositionTableViewHeader = 1,
    
    ///搜索栏在导航栏
    SeaSearchBarPositionNavigationBar = 2,
    
    ///搜索栏隐藏，当点击导航栏右边搜索按钮时，才显示搜索栏
    SeaSearchBarPositionShowWhenSearch = 3,
};

/**
 可以搜索的控制视图
 @warning 如果搜索栏位置是 SeaSearchBarPositionTableViewHeader 并且子类有重写 - (void)scrollViewDidScroll:(UIScrollView *)scrollView，必须调用super
 */
@interface SeaSearchDisplayViewController : SeaTableViewController<UISearchBarDelegate>

/**
 搜索栏，通过设置tintColor，可改变取消按钮的颜色，如果光标不显示，设置tintColor
 */
@property(nonatomic,readonly) UISearchBar *searchBar;

/**
 搜索栏输入框，要设置背景颜色，要先设置borderStyle 不为 RoundRect
 */
@property(nonatomic,readonly) UITextField *searchTextField;

/**
 搜索栏取消按钮
 */
@property(nonatomic,readonly) UIButton *searchCancelButton;

/**
 搜索结果
 */
@property(nonatomic,readonly) NSMutableArray *searchResults;

/**
 是否正在搜索
 */
@property(nonatomic,readonly) BOOL searching;

/**
 在搜索期间是否隐藏导航栏，default is 'YES'，如果搜索栏的位置是 SeaSearchBarPositionNavigationBar，将忽略该值，如果搜索栏的位置是 SeaSearchBarPositionShowWhenSearch，此值一定为YES
 */
@property(nonatomic,assign) BOOL hideNavigationBarWhileSearching;

/**
 是否显示黑色半透明视图，在搜索期间并且没有输入搜索内容 default is 'YES'
 */
@property(nonatomic,assign) BOOL showBackgroundWhileSearchingAndEmptyInput;

/**
 是否隐藏隐藏键盘当开始滑动时 default is 'YES'
 */
@property(nonatomic,assign) BOOL hideKeyboardWhileScroll;

/**
 搜索栏位置 default is 'SeaSearchBarPositionTableViewTop'
 */
@property(nonatomic,readonly) SeaSearchBarPosition searchBarPosition;

/**
 通过搜索栏位置 初始化
 */
- (id)initWithSearchBarPosition:(SeaSearchBarPosition) position;

/**
 初始化UISearchBar 默认在 initialization中调用该方法，如果searchBarPosition 不是 SeaSearchBarPositionNavigationBar或者SeaSearchBarPositionShowWhenSearch，并且当self.tableView == nil时，不做任何事
 */
- (void)initializeSearchBar;

/**
 搜索关键字改变 子类可重写该方法
 *@param string 当前搜索的关键字
 */
- (void)searchStringDidChangeWithString:(NSString*) string;

/**
 点击搜索按钮 默认不做任何事，子类可重写该方法
 *@param string 当前关键字
 */
- (void)searchButtonDidClickWithString:(NSString*) string;

/**
 点击取消搜索
 */
- (void)searchCancelDidClick;

/**
 取消搜索
 */
- (void)cancelSearch;

@end

