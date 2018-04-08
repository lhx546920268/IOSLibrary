//
//  SeaViewController.m

//
//

#import "SeaViewController.h"
#import "UIViewController+Utils.h"
#import "SeaBasic.h"
#import "SeaContainer.h"
#import "SeaTabBarController.h"
#import "UIView+SeaAutoLayout.h"
#import "NSObject+Utils.h"
#import "SeaWeakObjectContainer.h"
#import "SeaHttpTask.h"
#import "SeaMultiTasks.h"

@interface SeaViewController ()

///用来在delloc之前 要取消的请求
@property(nonatomic, strong) NSMutableSet<SeaWeakObjectContainer*> *currentTasks;

@end

@implementation SeaViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

#pragma mark- 视图消失出现

- (void)loadView
{
    //如果有 xib 则加载对应的xib
    if([[NSBundle mainBundle] pathForResource:self.sea_nameOfClass ofType:@"nib"]){
        self.view = [[[NSBundle mainBundle] loadNibNamed:self.sea_nameOfClass owner:self options:nil] lastObject];
    }else{
        _container = [[SeaContainer alloc] initWithViewController:self];
        self.view = self.container;
    }
}

- (void)setTopView:(UIView *)topView
{
    [_container setTopView:topView];
}

- (void)setTopView:(UIView *)topView height:(CGFloat)height
{
    [_container setTopView:topView height:height];
}

- (UIView*)topView
{
    return _container.topView;
}

- (void)setBottomView:(UIView *)bottomView
{
    [_container setBottomView:bottomView];
}

- (void)setBottomView:(UIView *)bottomView height:(CGFloat)height
{
    [_container setBottomView:bottomView height:height];
}

- (UIView*)bottomView
{
    return _container.bottomView;
}

- (void)setContentView:(UIView *)contentView
{
    [_container setContentView:contentView];
}

- (UIView*)contentView
{
    return _container.contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    if(self.navigationController.viewControllers.count > 1){
        self.sea_showBackItem = YES;
    }
}

#pragma mark- UIStatusBar

/**用于 present ViewController 的 statusBar 隐藏状态控制
 */
- (BOOL)prefersStatusBarHidden
{
    return self.sea_statusBarHidden;
}

- (void)viewDidLayoutSubviews
{
    
}

- (void)addCanceledTask:(SeaHttpTask*) task
{
    if(task){
        if(!self.currentTasks){
            self.currentTasks = [NSMutableSet set];
        }
        [self.currentTasks addObject:[SeaWeakObjectContainer containerWithObject:task]];
    }
}

- (void)addCanceledTasks:(SeaMultiTasks*) tasks
{
    if(tasks){
        if(!self.currentTasks){
            self.currentTasks = [NSMutableSet set];
        }
        [self.currentTasks addObject:[SeaWeakObjectContainer containerWithObject:tasks]];
    }
}

- (void)dealloc
{
    //取消正在执行的请求
    for(SeaWeakObjectContainer *obj in self.currentTasks){
        if([obj isKindOfClass:[SeaHttpTask class]]){
            SeaHttpTask *task = (SeaHttpTask*)obj.weakObject;
            [task cancel];
        }else if ([obj isKindOfClass:[SeaMultiTasks class]]){
            SeaMultiTasks *tasks = (SeaMultiTasks*)obj.weakObject;
            [tasks cancelAllTasks];
        }
    }
}

@end
