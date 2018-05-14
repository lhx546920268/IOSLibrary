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
#import "UIViewController+Dialog.h"
#import "UIViewController+Keyboard.h"
#import "UIView+Utils.h"

@interface SeaViewController ()

///用来在delloc之前 要取消的请求
@property(nonatomic, strong) NSMutableSet<SeaWeakObjectContainer*> *currentTasks;

@end

@implementation SeaViewController


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
       
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
        if(!self.isShowAsDialog){
            self.view = self.container;
        }else{
            self.view = [UIView new];
        }
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.isShowAsDialog){
        [self addKeyboardNotification];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if(self.isShowAsDialog){
        [self removeKeyboardNotification];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(self.isShowAsDialog){
        if(self.container){
            [self.view addSubview:self.container];
        }
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.navigationController.navigationBar.translucent = NO;
        self.view.backgroundColor = [UIColor whiteColor];
        
        if(self.navigationController.viewControllers.count > 1 && !self.sea_showBackItem){
            self.sea_showBackItem = YES;
        }
    }
}

#pragma mark- UIStatusBar

/**
 用于 present ViewController 的 statusBar 隐藏状态控制
 */
- (BOOL)prefersStatusBarHidden
{
    return self.sea_statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if(self.isShowAsDialog){
        return UIStatusBarStyleLightContent;
    }else{
        return [super preferredStatusBarStyle];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    _isViewDidLayoutSubviews = YES;
}

- (void)addCanceledTask:(SeaHttpTask*) task
{
    [self removeInvalidTasks];
    if(task){
        if(!self.currentTasks){
            self.currentTasks = [NSMutableSet set];
        }
        [self.currentTasks addObject:[SeaWeakObjectContainer containerWithObject:task]];
    }
}

- (void)addCanceledTasks:(SeaMultiTasks*) tasks
{
    [self removeInvalidTasks];
    if(tasks){
        if(!self.currentTasks){
            self.currentTasks = [NSMutableSet set];
        }
        [self.currentTasks addObject:[SeaWeakObjectContainer containerWithObject:tasks]];
    }
}

///移除无效的请求
- (void)removeInvalidTasks
{
    if(self.currentTasks.count > 0){
        NSMutableSet *toRemoveTasks = [NSMutableSet set];
        for(SeaWeakObjectContainer *obj in self.currentTasks){
            if(obj.weakObject == nil){
                [toRemoveTasks addObject:obj];
            }
        }
        
        for(SeaWeakObjectContainer *obj in toRemoveTasks){
            [self.currentTasks removeObject:obj];
        }
    }
}

- (void)dealloc
{
    //取消正在执行的请求
    for(SeaWeakObjectContainer *obj in self.currentTasks){
        if([obj.weakObject isKindOfClass:[SeaHttpTask class]]){
            SeaHttpTask *task = (SeaHttpTask*)obj.weakObject;
            [task cancel];
        }else if ([obj.weakObject isKindOfClass:[SeaMultiTasks class]]){
            SeaMultiTasks *tasks = (SeaMultiTasks*)obj.weakObject;
            [tasks cancelAllTasks];
        }
    }
}

#pragma mark dialog 键盘

/**
 键盘高度改变
 */
- (void)keyboardWillChangeFrame:(NSNotification*) notification
{
    [super keyboardWillChangeFrame:notification];
    
    ///弹出键盘，改变弹窗位置
    if(self.isShowAsDialog){
        [self adjustDialogPosition];
    }
}

@end
