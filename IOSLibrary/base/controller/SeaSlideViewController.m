//
//  SeaSlideViewController.m
//  Sea

//

#import "SeaSlideViewController.h"
#import "SeaBasic.h"
#import "UIViewController+Utils.h"
#import "UIView+Utils.h"

@interface SeaSlideViewController ()

/**滑动手势
 */
@property(nonatomic,strong) UIPanGestureRecognizer *panGestureRecognizer;

/**内容
 */
@property(nonatomic,strong) UIView *contentView;

/**middleViewController 起始位置
 */
@property(nonatomic,assign) CGFloat previousX;

@end

@implementation SeaSlideViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        [self initialization];
    }
    
    return self;
}

/**构造方法
 *@param middleViewController 中间视图 不能为空
 *@param leftViewController 左边视图
 *@param rightViewController 右边视图
 *@return 一个实例
 */
- (id)initWithMiddleViewController:(UIViewController*) middleViewController
                leftViewController:(UIViewController*) leftViewController
               rightViewController:(UIViewController*) rightViewController
{
    self = [super initWithNibName:nil bundle:nil];
    if(self)
    {
        [self initialization];
        self.middleViewController = middleViewController;
        self.leftViewController = leftViewController;
        self.rightViewController = rightViewController;
    }
    
    return self;
}

//初始化
- (void)initialization
{
    _controlByNavigationController = NO;
    self.delegates = [NSMutableArray array];
    _position = SeaSlideViewPositionMiddle;
    _leftViewWidth = _rightViewWidth = 260.0 / 320.0 * SeaScreenWidth;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SeaScreenWidth, SeaScreenHeight)];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor whiteColor];
    self.contentView = view;
}

#pragma mark- dealloc

- (void)dealloc
{
    self.panGestureRecognizerInView = nil;
}

#pragma mark- 视图消失出现

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(_controlByNavigationController)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if(_controlByNavigationController)
    {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

#pragma mark- 加载视图

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if SeaDebug
    NSAssert(_middleViewController != nil, @"middleViewController 不能为空");
#endif
    
    self.view = self.contentView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    pan.delegate = self;
    
    if(self.panGestureRecognizerInView != nil)
    {
        [self.panGestureRecognizerInView addGestureRecognizer:pan];
    }
    else
    {
        [self.view addGestureRecognizer:pan];
    }
    
    self.panGestureRecognizer = pan;
}

#pragma mark- content viewController

/**中间视图 不能为空
 */
- (void)setMiddleViewController:(UIViewController *)middleViewController
{
#if SeaDebug
    NSAssert(middleViewController != nil, @"middleViewController 不能为空");
#endif
    
    if(_middleViewController != middleViewController)
    {
        if(_middleViewController != nil)
        {
            [_middleViewController.view removeFromSuperview];
            [_middleViewController removeFromParentViewController];
        }
        
        _middleViewController = middleViewController;
        
        if(_middleViewController != nil)
        {
            [_middleViewController willMoveToParentViewController:self];
            [self addChildViewController:_middleViewController];
            [self.contentView addSubview:_middleViewController.view];
            [self.contentView bringSubviewToFront:_middleViewController.view];
            [_middleViewController didMoveToParentViewController:self];
            
            [self setupShadow];
        }
    }
}

/**左边视图
 */
- (void)setLeftViewController:(UIViewController *)leftViewController
{
    if(_leftViewController != leftViewController)
    {
        if(_leftViewController != nil)
        {
            [_leftViewController.view removeFromSuperview];
            [_leftViewController removeFromParentViewController];
        }
        
        _leftViewController = leftViewController;
        
        if(_leftViewController != nil)
        {
            [_leftViewController willMoveToParentViewController:self];
            [self addChildViewController:_leftViewController];
            [self.contentView insertSubview:_leftViewController.view belowSubview:_middleViewController.view];
            [_leftViewController didMoveToParentViewController:self];
            
            [self layoutLeftView];
        }
    }
}

/**右边视图
 */
- (void)setRightViewController:(UIViewController *)rightViewController
{
    if(_rightViewController != rightViewController)
    {
        if(_rightViewController != nil)
        {
            [_rightViewController.view removeFromSuperview];
            [_rightViewController removeFromParentViewController];
        }
        
        _rightViewController = rightViewController;
        
        if(_rightViewController != nil)
        {
            [_rightViewController willMoveToParentViewController:self];
            [self addChildViewController:_rightViewController];
            [self.contentView insertSubview:_rightViewController.view belowSubview:_middleViewController.view];
            [_rightViewController didMoveToParentViewController:self];
            
            [self layoutRightView];
        }
    }
}

#pragma mark- content wdith

/**左边视图宽度 default is '260.0 / 320.0 * SeaScreenWidth'
 */
- (void)setLeftViewWidth:(CGFloat)leftViewWidth
{
    if(_leftViewWidth != leftViewWidth)
    {
        _leftViewWidth = leftViewWidth;
        [self layoutLeftView];
    }
}

/**左边视图宽度 default is '260.0 / 320.0 * SeaScreenWidth'
 */
- (void)setRightViewWidth:(CGFloat)rightViewWidth
{
    if(_rightViewWidth != rightViewWidth)
    {
        _rightViewWidth = rightViewWidth;
        [self layoutRightView];
    }
}

/**调整左边视图
 */
- (void)layoutLeftView
{
    CGRect frame = _leftViewController.view.frame;
    frame.size.width = _leftViewWidth;
    _leftViewController.view.frame = frame;
}

/**调整右边视图
 */
- (void)layoutRightView
{
    CGRect frame = _rightViewController.view.frame;
    frame.size.width = _rightViewWidth;
    frame.origin.x = self.view.width - _rightViewWidth;
    _rightViewController.view.frame = frame;
}

#pragma mark- shadow

- (void)setupShadow
{
    if(_middleViewController.view)
    {
        CALayer *layer = _middleViewController.view.layer;
        layer.masksToBounds = NO;
        layer.shadowColor = [UIColor blackColor].CGColor;
        layer.shadowOpacity = 1.0f;
        layer.shadowOffset = CGSizeMake(0, 2.5);
        layer.shadowRadius = 2.5;
    }
}

#pragma mark- position

- (void)setPosition:(SeaSlideViewPosition)position
{
    if(_position != position)
    {
        [self setPosition:position animate:NO];
    }
}

/**动画设置当前显示的视图位置
 *@param position 新的位置
 *@param flag 是否动画
 */
- (void)setPosition:(SeaSlideViewPosition)position animate:(BOOL) flag
{
#if SeaDebug
    switch (position)
    {
        case SeaSlideViewPositionLeft :
        {
            NSAssert(_leftViewController != nil, @"leftViewController = nil, 无法设置 SeaSlideViewPositionLeft");
        }
            break;
        case SeaSlideViewPositionRight :
        {
            NSAssert(_rightViewController != nil, @"_rightViewController = nil, 无法设置 SeaSlideViewPositionRight");
        }
            break;
        default:
            break;
    }
#endif
    
    SeaSlideViewPosition fromPosition = _position;
    _position = position;
    
    if(fromPosition != position && self.delegates.count > 0)
    {
        for(id<SeaSlideViewControllerDelegate> delegate in _delegates)
        {
            if([delegate respondsToSelector:@selector(slideViewController:willTransitionPosition:toPosition:)])
            {
                [delegate slideViewController:self willTransitionPosition:fromPosition toPosition:position];
            }
        }
    }
    
    CGRect frame = _middleViewController.view.frame;
    
    switch (_position)
    {
        case SeaSlideViewPositionLeft :
        {
            if(_rightViewController)
            {
                [self.view sendSubviewToBack:_rightViewController.view];;
            }
            frame.origin.x = _leftViewWidth;
        }
            break;
        case SeaSlideViewPositionMiddle :
        {
            frame.origin.x = 0;
        }
            break;
        case SeaSlideViewPositionRight :
        {
            if(_leftViewController)
            {
                [self.view sendSubviewToBack:_leftViewController.view];
            }
            
            frame.origin.x = - _rightViewWidth;
        }
            break;
    }
    
    if(flag)
    {
        [UIView animateWithDuration:0.25 animations:^(void){
           
            self.middleViewController.view.frame = frame;
        }completion:^(BOOL finish){
            
            if(fromPosition != position && self.delegates.count > 0)
            {
                for(id<SeaSlideViewControllerDelegate> delegate in self.delegates)
                {
                    if([delegate respondsToSelector:@selector(slideViewController:didTransitionPosition:toPosition:)])
                    {
                        [delegate slideViewController:self didTransitionPosition:fromPosition toPosition:position];
                    }
                }
            }
        }];
    }
    else
    {
        _middleViewController.view.frame = frame;
        if(fromPosition != position && _delegates.count > 0)
        {
            for(id<SeaSlideViewControllerDelegate> delegate in _delegates)
            {
                if([delegate respondsToSelector:@selector(slideViewController:didTransitionPosition:toPosition:)])
                {
                    [delegate slideViewController:self didTransitionPosition:fromPosition toPosition:position];
                }
            }
        }
    }
}

#pragma mark- UIPanGestureRecognizer

/**添加滑动手势的 view , default is 'nil', 在 SeaSlideViewController.view 中添加
 */
- (void)setPanGestureRecognizerInView:(UIView *)panGestureRecognizerInView
{
    if(_panGestureRecognizerInView != panGestureRecognizerInView)
    {
        if(_panGestureRecognizerInView && self.panGestureRecognizer)
        {
            [_panGestureRecognizerInView removeGestureRecognizer:self.panGestureRecognizer];
        }
        else if(self.panGestureRecognizer)
        {
            [self.view removeGestureRecognizer:self.panGestureRecognizer];
        }
        
        _panGestureRecognizerInView = panGestureRecognizerInView;
        if(self.panGestureRecognizer)
        {
            [_panGestureRecognizerInView addGestureRecognizer:self.panGestureRecognizer];
        }
    }
}

- (void)handlePanGestureRecognizer:(UIPanGestureRecognizer*) pan
{
    CGPoint point = [pan translationInView:pan.view];
    if(pan.state == UIGestureRecognizerStateBegan)
    {
        self.view.userInteractionEnabled = NO;
        self.previousX = _middleViewController.view.left;
    }
    else if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGFloat x = point.x + self.previousX;
        
        if(x > _leftViewWidth)
        {
            x = _leftViewWidth;
        }
        else if(x < - _rightViewWidth)
        {
            x = - _rightViewWidth;
        }
       
        if(_leftViewController == nil && x > 0)
        {
            x = 0;
        }
        
        if(_rightViewController == nil && x < 0)
        {
            x = 0;
        }
        
        _middleViewController.view.left = x;
        
        if(x < 0)
        {
            [self.contentView sendSubviewToBack:_leftViewController.view];
        }
        else
        {
            [self.contentView sendSubviewToBack:_rightViewController.view];
        }
    }
    else
    {
        self.view.userInteractionEnabled = YES;
        
        SeaSlideViewPosition targetPosition = SeaSlideViewPositionMiddle;
        
        if(_middleViewController.view.left < 0)
        {
            if(_position == SeaSlideViewPositionMiddle)
            {
                if(point.x <= - _rightViewWidth / 3.0)
                {
                    targetPosition = SeaSlideViewPositionRight;
                }
            }
            else
            {
                if(!(point.x > 0 && fabs(point.x) >= _leftViewWidth / 3.0))
                {
                    targetPosition = SeaSlideViewPositionRight;
                }
            }
        }
        else
        {
            if(_position == SeaSlideViewPositionMiddle)
            {
                if(point.x >= _leftViewWidth / 3.0)
                {
                    targetPosition = SeaSlideViewPositionLeft;
                }
            }
            else
            {
                if(!(point.x < 0 && fabs(point.x) >= _leftViewWidth / 3.0))
                {
                    targetPosition = SeaSlideViewPositionLeft;
                }
            }
        }
        
        [self setPosition:targetPosition animate:YES];
    }
}

@end


@implementation UIViewController (SeaSlideViewControllerExtentions)

/**获取侧滑菜单控制视图
 */
- (SeaSlideViewController*)slideViewController
{
    if([self.navigationController.parentViewController isKindOfClass:[SeaSlideViewController class]])
    {
        return (SeaSlideViewController*)self.navigationController.parentViewController;
    }
    
    if([self.parentViewController isKindOfClass:[SeaSlideViewController class]])
    {
        return (SeaSlideViewController*)self.parentViewController;
    }
    
    return nil;
}

@end
