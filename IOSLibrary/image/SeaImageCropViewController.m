//
//  SeaImageCropViewController.m

//

#import "SeaImageCropViewController.h"
#import "SeaAlbumDelegate.h"
#import "SeaBasic.h"

#define BOUNDCE_DURATION 0.3f

@implementation SeaImageCropSettings

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.useFullScreenCropFrame = YES;
        self.limitRatio = 2.5;
    }
    
    return self;
}

@end

@interface SeaImageCropViewController ()

/**图片相框
 */
@property (nonatomic, strong) UIImageView *showImgView;

/**图片裁剪的部分控制图层，不被裁剪的部分会覆盖黑色半透明
 */
@property (nonatomic, strong) UIView *overlayView;

/**裁剪框
 */
@property (nonatomic, strong) UIView *ratioView;

/**图片的起始位置大小
 */
@property (nonatomic, assign) CGRect oldFrame;

/**图片的可以放大的最大尺寸
 */
@property (nonatomic, assign) CGRect largeFrame;

/**当前图片位置大小
 */
@property (nonatomic, assign) CGRect latestFrame;

/**取消按钮
 */
@property (nonatomic, strong) UIButton *cancelButton;

/**确认按钮
 */
@property (nonatomic, strong) UIButton *confirmButton;

///裁剪设置
@property (nonatomic, strong) SeaImageCropSettings *settings;

@end

@implementation SeaImageCropViewController

/**构造方法
 *@param settings 裁剪设置
 *@return 一个实例
 */
- (id)initWithSettings:(SeaImageCropSettings*) settings
{
    self = [super init];
    if (self)
    {
        self.settings = settings;
    }
    return self;
}

#pragma mark- dealloc

- (void)dealloc
{
    self.delegate = nil;
}
//
//#pragma mark- 视图消失出现
//
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    //隐藏导航栏和状态栏
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    
//    //显示导航栏和状态栏
//    [self.navigationController setNavigationBarHidden:NO];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//}

#pragma mark- 加载视图

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.clipsToBounds = YES;
    self.title = @"裁图";
    self.view.backgroundColor = [UIColor blackColor];
    [self initView];
    //[self initControlBtn];
    [self setBarItemsWithTitle:@"完成" icon:nil action:@selector(confirm) position:SeaNavigationItemPositionRight];
}

//初始化视图
- (void)initView
{
    self.backItem = YES;
    
    CGSize cropSize = self.settings.cropSize;
    if(self.settings.useFullScreenCropFrame)
    {
        cropSize = CGSizeMake(_width_, _width_ * cropSize.height / cropSize.width);
        self.settings.cropCornerRadius *= cropSize.width / self.settings.cropSize.width;
    }
    
    _cropFrame = CGRectMake((_width_ - cropSize.width) / 2.0, (self.contentHeight - cropSize.height) / 2.0, cropSize.width, cropSize.height);
    //显示图片
    self.showImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
    [self.showImgView setMultipleTouchEnabled:YES];
    [self.showImgView setUserInteractionEnabled:YES];
    [self.showImgView setImage:self.settings.image];

    
    //把图片适配屏幕
    CGFloat oriWidth = MIN(_width_, self.settings.image.size.width);
    CGFloat oriHeight = self.settings.image.size.height * (oriWidth / self.settings.image.size.width);
    
    if(self.settings.useFullScreenCropFrame)
    {
        if(oriWidth < _cropFrame.size.width || oriHeight < _cropFrame.size.height)
        {
            CGFloat scale = MAX(_cropFrame.size.width / oriWidth, _cropFrame.size.height / oriHeight);
            oriWidth *= scale;
            oriHeight *= scale;
        }
    }
    
    CGFloat oriX = self.cropFrame.origin.x + (self.cropFrame.size.width - oriWidth) / 2;
    CGFloat oriY = self.cropFrame.origin.y + (self.cropFrame.size.height - oriHeight) / 2;
    self.oldFrame = CGRectMake(oriX, oriY, oriWidth, oriHeight);
    self.latestFrame = self.oldFrame;
    self.showImgView.frame = self.oldFrame;
    
    self.largeFrame = CGRectMake(0, 0, self.settings.limitRatio * self.oldFrame.size.width, self.settings.limitRatio * self.oldFrame.size.height);
    
    //添加捏合缩放手势
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchView:)];
    [self.view addGestureRecognizer:pinchGestureRecognizer];
    
    //添加平移手势
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panView:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    [self.view addSubview:self.showImgView];
    
    //裁剪区分图层
    self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, self.contentHeight)];
    self.overlayView.alpha = .5f;
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.userInteractionEnabled = NO;
    [self.view addSubview:self.overlayView];
    
    //编辑框
    self.ratioView = [[UIView alloc] initWithFrame:self.cropFrame];
    self.ratioView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.ratioView.layer.borderWidth = 1.0f;
    self.ratioView.layer.cornerRadius = self.settings.cropCornerRadius;
    self.ratioView.layer.masksToBounds = YES;
    self.ratioView.autoresizingMask = UIViewAutoresizingNone;
    self.ratioView.userInteractionEnabled = NO;
    [self.view addSubview:self.ratioView];
    
    //
    [self overlayClipping];
}

//初始化控制按钮
- (void)initControlBtn
{
//    CGFloat buttonHeight = 50.0f;
//    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - buttonHeight, _width_, buttonHeight)];
//    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
//    [self.view addSubview:bgView];
//    
//    
//    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, buttonHeight)];
//    cancelBtn.backgroundColor = [UIColor clearColor];
//    cancelBtn.titleLabel.textColor = [UIColor whiteColor];
//    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//    [cancelBtn.titleLabel setFont:[UIFont font:18.0f]];
//    [cancelBtn.titleLabel setNumberOfLines:0];
//    [cancelBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
//    [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:cancelBtn];
//    self.cancelButton = cancelBtn;
//    
//    UIButton *confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - 100.0f, 0, 100, buttonHeight)];
//    confirmBtn.backgroundColor = [UIColor clearColor];
//    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
//    [confirmBtn setTitle:@"使用" forState:UIControlStateNormal];
//    [confirmBtn.titleLabel setFont:[UIFont font:18.0f]];
//    confirmBtn.titleLabel.textColor = [UIColor whiteColor];
//    [confirmBtn.titleLabel setNumberOfLines:0];
//    [confirmBtn setTitleEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
//    [confirmBtn addTarget:self action:@selector(confirm:) forControlEvents:UIControlEventTouchUpInside];
//    [bgView addSubview:confirmBtn];
//    self.confirmButton = confirmBtn;
}

#pragma mark- private method

//取消编辑
- (void)back
{
    if(self.present)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)longPressBack:(UILongPressGestureRecognizer *)longPress
{
    
}

//确认编辑
- (void)confirm
{
    if ([self.delegate respondsToSelector:@selector(albumDidFinishSelectImages:)])
    {
        [self.delegate albumDidFinishSelectImages:[NSArray arrayWithObject:[self cropImage]]];
    }
    
    if(self.presentingViewController != nil)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//绘制裁剪区分图层
- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    CGMutablePathRef path = CGPathCreateMutable();
    
    if(self.settings.cropCornerRadius == 0)
    {
        //编辑框左边
        CGPathAddRect(path, NULL, CGRectMake(0, 0,
                                            self.ratioView.left,
                                            self.overlayView.height));
        //编辑框右边
        CGPathAddRect(path, NULL, CGRectMake(
                                            self.ratioView.right,
                                            0,
                                            self.overlayView.width - self.ratioView.right,
                                            self.overlayView.height));
        //编辑框上面
        CGPathAddRect(path, NULL, CGRectMake(0, 0,
                                            self.overlayView.width,
                                            self.ratioView.top));
        //编辑框下面
        CGPathAddRect(path, NULL, CGRectMake(0,
                                            self.ratioView.bottom,
                                            self.overlayView.width,
                                            self.overlayView.height - self.ratioView.bottom));
    }
    else
    {
        CGPoint point1 = CGPointMake(0, self.ratioView.top + self.ratioView.height / 2.0);
        CGPoint point2 = CGPointMake(self.ratioView.width, self.ratioView.top + self.ratioView.height / 2.0);
        
        CGMutablePathRef path1 = CGPathCreateMutable();
        CGPathMoveToPoint(path1, NULL, point1.x, point1.y);
        CGPathAddLineToPoint(path1, NULL, 0, 0);
        CGPathAddLineToPoint(path1, NULL, self.ratioView.width, 0);
        CGPathAddLineToPoint(path1, NULL, point2.x, point2.y);
        CGPathAddArc(path1, NULL, self.ratioView.width / 2.0, point1.y, self.ratioView.width / 2.0, 0, M_PI, YES);
        
        CGPathAddPath(path, NULL, path1);
        
        CGMutablePathRef path2 = CGPathCreateMutable();
        CGPathMoveToPoint(path2, NULL, point1.x, point1.y);
        CGPathAddLineToPoint(path2, NULL, 0, self.overlayView.height);
        CGPathAddLineToPoint(path2, NULL, self.ratioView.width, self.overlayView.height);
        CGPathAddLineToPoint(path2, NULL, point2.x, point2.y);
        CGPathAddArc(path2, NULL, self.ratioView.width / 2.0, point1.y, self.ratioView.width / 2.0, 0, M_PI, NO);
        
        CGPathAddPath(path, NULL, path2);
        
        CGPathRelease(path1);
        CGPathRelease(path2);
    }
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    CGPathRelease(path);
}

#pragma mark- Gesture

//图片捏合缩放
- (void)pinchView:(UIPinchGestureRecognizer *)pinchGestureRecognizer
{
    UIView *view = self.showImgView;
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        view.transform = CGAffineTransformScale(view.transform, pinchGestureRecognizer.scale, pinchGestureRecognizer.scale);
        pinchGestureRecognizer.scale = 1;
    }
    else if (pinchGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleScaleOverflow:newFrame];
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

//图片平移
- (void)panView:(UIPanGestureRecognizer *)panGestureRecognizer
{
    UIView *view = self.showImgView;
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        CGFloat absCenterX = self.cropFrame.origin.x + self.cropFrame.size.width / 2;
        CGFloat absCenterY = self.cropFrame.origin.y + self.cropFrame.size.height / 2;
        CGFloat scaleRatio = self.showImgView.frame.size.width / self.cropFrame.size.width;
        
        CGFloat acceleratorX = 1 - ABS(absCenterX - view.center.x) / (scaleRatio * absCenterX);
        CGFloat acceleratorY = 1 - ABS(absCenterY - view.center.y) / (scaleRatio * absCenterY);
        CGPoint translation = [panGestureRecognizer translationInView:view.superview];
        
        [view setCenter:(CGPoint){view.center.x + translation.x * acceleratorX, view.center.y + translation.y * acceleratorY}];
        [panGestureRecognizer setTranslation:CGPointZero inView:view.superview];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        CGRect newFrame = self.showImgView.frame;
        newFrame = [self handleBorderOverflow:newFrame];
        [UIView animateWithDuration:BOUNDCE_DURATION animations:^{
            self.showImgView.frame = newFrame;
            self.latestFrame = newFrame;
        }];
    }
}

//控制图片的缩放大小
- (CGRect)handleScaleOverflow:(CGRect)newFrame
{
    CGPoint oriCenter = CGPointMake(newFrame.origin.x + newFrame.size.width / 2, newFrame.origin.y + newFrame.size.height / 2);
    if (newFrame.size.width < self.oldFrame.size.width)
    {
        newFrame = self.oldFrame;
    }
    if (newFrame.size.width > self.largeFrame.size.width)
    {
        newFrame = self.largeFrame;
    }
    newFrame.origin.x = oriCenter.x - newFrame.size.width / 2;
    newFrame.origin.y = oriCenter.y - newFrame.size.height / 2;
    return newFrame;
}

//控制平移的范围，不让图片超出编辑框
- (CGRect)handleBorderOverflow:(CGRect)newFrame
{
    //水平方向
    if (newFrame.origin.x > self.cropFrame.origin.x)
        newFrame.origin.x = self.cropFrame.origin.x;
    
    if (CGRectGetMaxX(newFrame) < self.cropFrame.origin.x + self.cropFrame.size.width)
        newFrame.origin.x = self.cropFrame.origin.x + self.cropFrame.size.width - newFrame.size.width;
    
    //垂直方向
    if (newFrame.origin.y > self.cropFrame.origin.y)
        newFrame.origin.y = self.cropFrame.origin.y;

    if (CGRectGetMaxY(newFrame) < self.cropFrame.origin.y + self.cropFrame.size.height)
        newFrame.origin.y = self.cropFrame.origin.y + self.cropFrame.size.height - newFrame.size.height;
    
    //图片小于裁剪框 让图片居中
    if (newFrame.size.height <= self.cropFrame.size.height)
    {
        newFrame.origin.y = self.cropFrame.origin.y + (self.cropFrame.size.height - newFrame.size.height) / 2;
    }
    
    if (newFrame.size.width <= self.cropFrame.size.width)
    {
        newFrame.origin.x = self.cropFrame.origin.x + (self.cropFrame.size.width - newFrame.size.width) / 2.0;
    }
    
    return newFrame;
}

//裁剪图片
- (UIImage*)cropImage
{
    //隐藏编辑框和控制按钮
    self.overlayView.hidden = YES;
    self.ratioView.hidden = YES;
    self.cancelButton.superview.hidden = YES;
    
    //如果图片小于编辑框，使用白色背景替代
    if(self.showImgView.width < self.cropFrame.size.width || self.showImgView.height < self.cropFrame.size.height)
    {
        self.view.backgroundColor = [UIColor whiteColor];
    }
    
    //裁剪图片
    CGFloat height = self.contentHeight;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(_width_, height), NO, SeaImageScale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    
    CGFloat scale = viewImage.scale;
    CGRect rect = CGRectMake(floor(_cropFrame.origin.x * scale), floor(_cropFrame.origin.y * scale), floor(_cropFrame.size.width * scale), floor(_cropFrame.size.height * scale));//这里可以设置想要截图的区域
    
    CGImageRef imageRefRect = CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    CFRelease(imageRefRect);
    
    if(sendImage.size.width > self.settings.cropSize.width)
    {
        sendImage = [sendImage aspectFitthumbnailWithSize:self.settings.cropSize];
    }
    
    return sendImage;
}

@end
