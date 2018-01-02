//
//  SeaAlertController.m
//  AKYP
//
//  Created by 罗海雄 on 16/1/25.
//  Copyright (c) 2016年 罗海雄. All rights reserved.
//

#import "SeaAlertController.h"
#import "UIView+Utils.h"
#import "NSString+Utils.h"
#import "NSAttributedString+Utils.h"
#import "UIViewController+Utils.h"
#import "SeaBasic.h"
#import "UIColor+colorUtilities.h"
#import "UIFont+Utilities.h"

//系统默认的蓝色
#define UIKitTintColor [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0]

//边距
#define SeaAlertControllerMargin 15.0

//文本边距
#define SeaAlertControllerTextMargin 20.0

//圆角
#define SeaAlertControllerCornerRadius 8.0

///按钮间距
#define SeaAlertControllerButtonInterval 0.5

#pragma mark- button

///弹窗按钮
@interface SeaAlertButton : UIView

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**高亮显示视图
 */
@property(nonatomic,readonly) UIView *highlightView;

/**添加单击手势
 */
- (void)addTarget:(id) target action:(SEL) selector;

//方法
@property(nonatomic,weak) id target;
@property(nonatomic,assign) SEL selector;

@end

@implementation SeaAlertButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = SeaAlertControllerCornerRadius;
        self.layer.masksToBounds = YES;
        
        _highlightView = [[UIView alloc] initWithFrame:self.bounds];
        _highlightView.userInteractionEnabled = NO;
        _highlightView.hidden = YES;
        [self addSubview:_highlightView];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _titleLabel.frame = self.bounds;
    _highlightView.frame = self.bounds;
}

- (void)dealloc
{
    self.selector = nil;
}

#pragma mark- public method

/**开始点击 当手势为UITapGestureRecognizer时， 在处理手势的方法中调用该方法
 */
- (void)touchBegan
{
    _highlightView.hidden = NO;
}

/**结束点击 当手势为UITapGestureRecognizer时， 在处理手势的方法中调用该方法
 */
- (void)touchEnded
{
    _highlightView.hidden = YES;
}

/**添加单击手势
 */
- (void)addTarget:(id)target action:(SEL)selector
{
    self.target = target;
    self.selector = selector;
}


#pragma mark- touch

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchBegan];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTap];
    [self touchEnded];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self handleTap];
    [self touchEnded];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.superview];
    
    if(!CGRectContainsPoint(self.frame, point))
    {
        [self touchEnded];
    }
    else
    {
        [self touchBegan];
    }
}

///点击事件
- (void)handleTap
{
    if(!self.highlightView.hidden)
    {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.target performSelector:self.selector withObject:self];
#pragma clang diagnostic pop
    }
}

@end

#pragma mark- button cell

///弹窗按钮列表cell
@interface SeaAlertButtonCell : UICollectionViewCell

///按钮标题
@property(nonatomic,readonly) UILabel *titleLabel;

///高亮背景
@property(nonatomic,readonly) UIView  *highlightedBackgroundView;

@end

@implementation SeaAlertButtonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        _highlightedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
        _highlightedBackgroundView.hidden = YES;
        [self.contentView insertSubview:_highlightedBackgroundView belowSubview:_titleLabel];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = self.contentView.bounds;
    _highlightedBackgroundView.frame = self.contentView.bounds;
}

@end

/**弹窗头部
 */
@interface SeaAlertHeader : UIScrollView

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

///信息
@property(nonatomic,readonly) UILabel *messageLabel;

- (void)layout;

@end

@implementation SeaAlertHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = NO;
        
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SeaAlertControllerTextMargin, SeaAlertControllerTextMargin, self.width - SeaAlertControllerTextMargin * 2, 0)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_titleLabel];
        
        _messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(SeaAlertControllerTextMargin, _titleLabel.bottom + SeaAlertControllerTextMargin, SeaAlertControllerTextMargin, SeaAlertControllerTextMargin)];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_messageLabel];
    }
    
    return self;
}

- (void)layout
{
    if(_titleLabel)
    {
        CGFloat width = self.width - SeaAlertControllerTextMargin * 2;
        CGSize size;
        
        if(_titleLabel.attributedText != nil)
        {
            size = [_titleLabel.attributedText sea_boundsWithConstraintWidth:width];
        }
        else
        {
            size = [_titleLabel.text sea_stringSizeWithFont:_titleLabel.font contraintWith:width];
        }
        
        CGRect frame = _titleLabel.frame;
        frame.size.width = width;
        frame.size.height = size.height;
        _titleLabel.frame = frame;
        
        if(_messageLabel.text)
        {
            if(_messageLabel.attributedText != nil)
            {
                size = [_messageLabel.attributedText sea_boundsWithConstraintWidth:width];
            }
            else
            {
                size = [_messageLabel.text sea_stringSizeWithFont:_messageLabel.font contraintWith:width];
            }
        }
        else
        {
            size = CGSizeZero;
        }
        
        frame = _messageLabel.frame;
        frame.size.height = size.height;
        frame.size.width = width;
        frame.origin.y = _titleLabel.bottom + (_titleLabel.height > 0 ? SeaAlertControllerTextMargin : 0);
        _messageLabel.frame = frame;
        
        self.height = _messageLabel.height > 0 ? _messageLabel.bottom + SeaAlertControllerTextMargin : _titleLabel.bottom + SeaAlertControllerTextMargin;
        self.contentSize = CGSizeMake(self.width, self.height);
    }
    else
    {
        self.height = 0;
    }
}

@end

#pragma mark- action

@implementation SeaAlertAction

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        self.enable = YES;
    }
    
    return self;
}

/**
 *  构造方法
 *  @param title 按钮标题
 *  @return 一个实例
 */
+ (instancetype)alertActionWithTitle:(NSString*) title
{
    SeaAlertAction *action = [[[self class] alloc] init];
    action.title = title;
    
    return action;
}

@end

#pragma mark- controller

@interface SeaAlertController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

/**按钮列表
 */
@property(nonatomic, strong) UICollectionView *collectionView;

///头部
@property(nonatomic, strong) SeaAlertHeader *header;

/**取消按钮 用于 actionSheet
 */
@property(nonatomic, strong) SeaAlertButton *cancelButton;

///取消按钮标题
@property(nonatomic, copy) NSString *cancelTitle;

/**标题 NSString 或者 NSAttributedString
 */
@property(nonatomic, copy) id titleString;

///信息 NSString 或者 NSAttributedString
@property(nonatomic, copy) id message;

/**内容视图
 */
@property(nonatomic, strong) UIView *contentView;

///按钮样式，数组元素是 SeaAlertAction
@property(nonatomic, strong) NSMutableArray *actions;

///黑色半透明背景
@property(nonatomic,strong) UIView *backgroundView;

/**以前的ViewController
 */
@property(nonatomic,weak) UIViewController *previousPresentViewController;

/**以前的弹出样式
 */
@property(nonatomic,assign) UIModalPresentationStyle previousPresentationStyle;

@end

@implementation SeaAlertController

/**
 *  构造方法
 *  @param title             标题 NSString 或者 NSAttributedString
 *  @param message           信息 NSString 或者 NSAttributedString
 *  @param style             样式
 *  @param cancelButtonTitle 取消按钮 default is ‘取消’
 *  @param otherButtonTitles      按钮，必须是字符串NSString，必须以nil结束，否则会崩溃
 *  @return 一个实例
 */
- (instancetype)initWithTitle:(id) title
                      message:(id) message
                        style:(SeaAlertControllerStyle) style
            cancelButtonTitle:(NSString *) cancelButtonTitle
            otherButtonTitles:(NSString*) otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION
{
    self = [super init];
    if(self)
    {
        self.actions = [NSMutableArray array];
        self.titleString = title;
        self.message = message;
        
        self.cancelTitle = cancelButtonTitle;
        
        _style = style;
        
        if(otherButtonTitles)
        {
            [self.actions addObject:[SeaAlertAction alertActionWithTitle:otherButtonTitles]];
            
            va_list list;
            va_start(list, otherButtonTitles);
            NSString *args;
            do
            {
                args = va_arg(list, NSString*);
                if(args)
                {
                    [self.actions addObject:[SeaAlertAction alertActionWithTitle:args]];
                }
                
            }while(args != nil);
                
            va_end(list);
        }
        
        switch (_style)
        {
            case SeaAlertControllerStyleAlert :
            {
                if(self.actions.count == 0 && !self.cancelTitle)
                {
                    self.cancelTitle = @"取消";
                }
                
                if(self.cancelTitle)
                {
                    [self.actions insertObject:[SeaAlertAction alertActionWithTitle:self.cancelTitle] atIndex:0];
                }
            }
                break;
            case SeaAlertControllerStyleActionSheet :
            {
                if(!self.cancelTitle)
                {
                    self.cancelTitle = @"取消";
                }
            }
                break;
        }
        
        
        [self initilization];
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    CGFloat width = [self alertViewWidth];
    CGFloat margin = (SeaScreenWidth - width) / 2.0;
    
    self.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.backgroundView.alpha = 0;
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    
    switch (_style)
    {
        case SeaAlertControllerStyleActionSheet :
        {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            tap.delegate = self;
            [self.backgroundView addGestureRecognizer:tap];
        }
            break;
            
        default:
            break;
    }
    
    [self.view addSubview:self.backgroundView];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(margin, margin, width, 0)];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.layer.cornerRadius = SeaAlertControllerCornerRadius;
    self.contentView.layer.masksToBounds = YES;
    
    
    if(self.titleString || self.message)
    {
        self.header = [[SeaAlertHeader alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
        self.header.titleLabel.font = self.titleFont;
        self.header.titleLabel.textColor = self.titleTextColor;
        self.header.titleLabel.textAlignment = self.titleTextAlignment;
        
        if([self.titleString isKindOfClass:[NSString class]])
        {
            self.header.titleLabel.text = self.titleString;
        }
        else if([self.titleString isKindOfClass:[NSAttributedString class]])
        {
            self.header.titleLabel.attributedText = self.titleString;
        }
        
        self.header.messageLabel.font = self.messageFont;
        self.header.messageLabel.textColor = self.messageTextColor;
        self.header.messageLabel.textAlignment = self.messageTextAlignment;
        
        if([self.message isKindOfClass:[NSString class]])
        {
            self.header.messageLabel.text = self.message;
        }
        else if ([self.message isKindOfClass:[NSAttributedString class]])
        {
            self.header.messageLabel.attributedText = self.message;
        }
        
        self.header.backgroundColor = self.mainColor;
        [self.contentView addSubview:self.header];
    }
    
    switch (_style)
    {
        case SeaAlertControllerStyleAlert :
        {
            
        }
            break;
        case SeaAlertControllerStyleActionSheet :
        {
            self.cancelButton = [[SeaAlertButton alloc] initWithFrame:CGRectMake(margin, margin, width, self.alertButtonHeight)];
            self.cancelButton.backgroundColor = self.mainColor;
            self.cancelButton.titleLabel.text = self.cancelTitle;
            self.cancelButton.titleLabel.textColor = self.cancelButtonTextColor;
            self.cancelButton.titleLabel.font = self.cancelButtonFont;
            self.cancelButton.highlightView.backgroundColor = self.highlightedBackgroundColor;
            [self.cancelButton addTarget:self action:@selector(cancel:)];
            [self.view addSubview:self.cancelButton];
        }
            break;
    }
    
    if(self.actions.count > 0)
    {
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.header.bottom, width, 0)collectionViewLayout:[self layout]];
        self.collectionView.backgroundColor = [UIColor colorWithWhite:0.90 alpha:0.9];
        [self.collectionView registerClass:[SeaAlertButtonCell class] forCellWithReuseIdentifier:@"SeaAlertButtonCell"];
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.bounces = YES;
        [self.contentView addSubview:self.collectionView];
    }
    
    [self layoutSubViews];
    [self.view addSubview:self.contentView];
    
    
    switch (_style)
    {
        case SeaAlertControllerStyleAlert :
        {
            self.contentView.alpha = 0;
            [UIView animateWithDuration:0.25 animations:^(void){
               
                self.backgroundView.alpha = 1.0;
                self.contentView.alpha = 1.0;
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation.fromValue = [NSNumber numberWithFloat:1.3];
                animation.toValue = [NSNumber numberWithFloat:1.0];
                animation.duration = 0.25;
                [self.contentView.layer addAnimation:animation forKey:@"scale"];
            }];
        }
            break;
        case SeaAlertControllerStyleActionSheet :
        {
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.backgroundView.alpha = 1.0;
                self.contentView.top = SeaScreenHeight - _contentView.height - SeaAlertControllerMargin - self.cancelButton.height - SeaAlertControllerMargin;
                self.cancelButton.top = self.contentView.bottom + SeaAlertControllerMargin;
            }];
        }
            break;
    }
}

///属性初始化
- (void)initilization
{

    self.mainColor = nil;
    self.titleFont = nil;
    self.titleTextColor = nil;
    self.titleTextAlignment = NSTextAlignmentCenter;
    self.messageFont = nil;
    self.messageTextColor = nil;
    self.messageTextAlignment = NSTextAlignmentCenter;
    self.butttonFont = nil;
    self.buttonTextColor = nil;
    self.destructiveButtonFont = nil;
    self.destructiveButtonTextColor = nil;
    self.cancelButtonFont = nil;
    self.cancelButtonTextColor = nil;
    self.disableButtonTextColor = nil;
    _destructiveButtonIndex = NSNotFound;
    _dismissWhenSelectButton = YES;
    self.highlightedBackgroundColor = nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark- layout

///弹窗宽度
- (CGFloat)alertViewWidth
{
    switch (_style)
    {
        case SeaAlertControllerStyleAlert :
        {
            return 260 + SeaAlertControllerButtonInterval;
        }
            break;
        case SeaAlertControllerStyleActionSheet :
        {
            return SeaScreenWidth - SeaAlertControllerMargin * 2;
        }
            break;
    }
}

///按钮高度
- (CGFloat)alertButtonHeight
{
    switch (_style)
    {
        case SeaAlertControllerStyleAlert :
        {
            return 45.0;
        }
            break;
        case SeaAlertControllerStyleActionSheet :
        {
            return 50.0;
        }
            break;
    }
}

///collectionView布局方式
- (UICollectionViewFlowLayout*)layout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = SeaAlertControllerButtonInterval;
    layout.minimumLineSpacing = SeaAlertControllerButtonInterval;
    
    switch (_style)
    {
        case SeaAlertControllerStyleActionSheet :
        {
            layout.itemSize = CGSizeMake(SeaScreenWidth - SeaAlertControllerMargin * 2, self.alertButtonHeight);
        }
            break;
        case SeaAlertControllerStyleAlert :
        {
            layout.itemSize = CGSizeMake(self.actions.count == 2 ? ([self alertViewWidth] - SeaAlertControllerButtonInterval) / 2.0 : [self alertViewWidth], self.alertButtonHeight);
            layout.scrollDirection = self.actions.count >= 3 ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
        }
            break;
    }
    
    return layout;
}

///布局子视图
- (void)layoutSubViews
{
    ///头部高度
    CGFloat headerHeight = 0;
    if(self.header)
    {
        [self.header layout];
        headerHeight = self.header.height;
    }
    
    ///按钮高度
    CGFloat buttonHeight = 0;

    if(self.actions.count > 0)
    {
        switch (_style)
        {
            case SeaAlertControllerStyleAlert :
            {
                buttonHeight = self.actions.count < 3 ? self.alertButtonHeight : self.actions.count * (SeaAlertControllerButtonInterval + self.alertButtonHeight);
            }
                break;
            case SeaAlertControllerStyleActionSheet :
            {
                buttonHeight = self.actions.count * self.alertButtonHeight + (self.actions.count - 1) * SeaAlertControllerButtonInterval;
                
                if(headerHeight > 0)
                {
                    buttonHeight += SeaAlertControllerButtonInterval;
                }
            }
                break;
            default:
                break;
        }
    }
    
    ///取消按钮高度
    CGFloat cancelHeight = self.cancelButton ? (self.cancelButton.height + SeaAlertControllerMargin) : 0;
    
    CGFloat maxContentHeight = SeaScreenHeight - SeaAlertControllerMargin * 2 - cancelHeight;
    
    CGRect frame = self.collectionView.frame;
    if(headerHeight + buttonHeight > maxContentHeight)
    {
        CGFloat contentHeight = maxContentHeight;
        if(headerHeight >= contentHeight / 2.0 && buttonHeight >= contentHeight / 2.0)
        {
            self.header.height = contentHeight / 2.0;
            frame.size.height = buttonHeight;
        }
        else if (headerHeight >= contentHeight / 2.0 && buttonHeight < contentHeight / 2.0)
        {
            self.header.height = contentHeight - buttonHeight;
            frame.size.height = buttonHeight;
        }
        else
        {
            self.header.height = headerHeight;
            frame.size.height = contentHeight - headerHeight;
        }
        
        frame.origin.y = self.header.bottom;
        self.collectionView.frame = frame;
        self.contentView.height = maxContentHeight;
    }
    else
    {
        
        frame.origin.y = self.header.bottom;
        frame.size.height = buttonHeight;
        self.collectionView.frame = frame;
        self.contentView.height = headerHeight + buttonHeight;
    }
    
    if(self.header.height > 0)
    {
        self.collectionView.height += SeaAlertControllerButtonInterval;
        self.contentView.height += SeaAlertControllerButtonInterval;
    }
    
    switch (_style)
    {
        case SeaAlertControllerStyleActionSheet :
        {
            self.contentView.top = SeaScreenHeight;
        }
            break;
        case SeaAlertControllerStyleAlert :
        {
            self.contentView.top = (SeaScreenHeight - self.contentView.height) / 2.0;
        }
            break;
    }
    
    self.cancelButton.top = self.contentView.bottom + SeaAlertControllerMargin;
}

#pragma mark- private method

///取消
- (void)cancel:(id) sender
{
    switch (_style)
    {
        case SeaAlertControllerStyleAlert :
        {
            !self.selectionHandler ?: self.selectionHandler(0);
        }
            break;
        case SeaAlertControllerStyleActionSheet :
        {
            !self.selectionHandler ?: self.selectionHandler(self.actions.count);
        }
            break;
    }
    [self close];
}

///点击黑色半透明
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    [self close];
}

/**隐藏
 */
- (void)dismiss
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    self.previousPresentViewController.modalPresentationStyle = self.previousPresentationStyle;
    [self dismissViewControllerAnimated:NO completion:nil];
}


#pragma mark- public method

/**
 *  显示在window.rootViewController
 */
- (void)show
{
    [self showInViewController:[[UIApplication sharedApplication].keyWindow.rootViewController sea_topestPresentedViewController]];
}

/**
 *  可显示在其他视图
 *  @param viewController 要显示的位置
 */
- (void)showInViewController:(UIViewController *)viewController
{
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:self];
    
    ///设置使背景透明
    if(_ios8_0_)
    {
        nav.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    else
    {
        self.previousPresentViewController = viewController;
        self.previousPresentationStyle = self.previousPresentViewController.modalPresentationStyle;
        self.previousPresentViewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    
    [viewController presentViewController:nav animated:NO completion:nil];
}

///关闭视图控制器
- (void)close
{
    switch (_style)
    {
        case SeaAlertControllerStyleActionSheet :
        {
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.backgroundView.alpha = 0;
                self.contentView.top = SeaScreenHeight;
                self.cancelButton.top = self.contentView.bottom + SeaAlertControllerMargin;
                
            }completion:^(BOOL finish){
                
                [self dismiss];
            }];
        }
            break;
        case SeaAlertControllerStyleAlert :
        {
            [self dismiss];
        }
            break;
    }
}

///更新某个按钮 不包含actionSheet 的取消按钮
- (void)reloadWithButtonIndex:(NSInteger) buttonIndex
{
    if(buttonIndex < self.actions.count)
    {
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:buttonIndex inSection:0]]];
    }
}

#pragma mark- UITapGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.backgroundView];
    point.y += self.backgroundView.top;
    if(CGRectContainsPoint(self.contentView.frame, point))
    {
        return NO;
    }
    
    return YES;
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.actions.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if(self.header.height > 0)
    {
        return UIEdgeInsetsMake(SeaAlertControllerButtonInterval, 0, 0, 0);
    }
    else
    {
        return UIEdgeInsetsZero;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaAlertButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SeaAlertButtonCell" forIndexPath:indexPath];
    
    SeaAlertAction *action = [self.actions objectAtIndex:indexPath.item];
    
    if(indexPath.item == 0 && self.cancelTitle && self.style == SeaAlertControllerStyleAlert)
    {
        cell.titleLabel.textColor = action.textColor ? action.textColor : self.cancelButtonTextColor;
        cell.titleLabel.font = action.font ? action.font : self.cancelButtonFont;
    }
    else if(indexPath.item == _destructiveButtonIndex)
    {
        cell.titleLabel.textColor = action.textColor ? action.textColor : self.destructiveButtonTextColor;
        cell.titleLabel.font = action.font ? action.font : self.destructiveButtonFont;
    }
    else
    {
        cell.titleLabel.textColor = action.textColor ? action.textColor : self.buttonTextColor;
        cell.titleLabel.font = action.font ? action.font : self.butttonFont;
    }
    
    cell.highlightedBackgroundView.backgroundColor = self.highlightedBackgroundColor;
    cell.titleLabel.text = action.title;
    cell.contentView.backgroundColor = self.mainColor;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    SeaAlertAction *action = [self.actions objectAtIndex:indexPath.item];
    if(action.enable)
    {
        !self.selectionHandler ?: self.selectionHandler(indexPath.item);
        !self.dismissWhenSelectButton ?: [self close];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaAlertAction *action = [self.actions objectAtIndex:indexPath.item];
    
    return action.enable;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaAlertButtonCell *cell = (SeaAlertButtonCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.highlightedBackgroundView.hidden = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaAlertButtonCell *cell = (SeaAlertButtonCell*)[collectionView cellForItemAtIndexPath:indexPath];
    cell.highlightedBackgroundView.hidden = NO;
}

#pragma mark- property

/**主题颜色
 */
- (void)setMainColor:(UIColor *)mainColor
{
    if(![_mainColor isEqualToColor:mainColor])
    {
        if(mainColor == nil)
            mainColor = [UIColor whiteColor];
        _mainColor = mainColor;
        self.cancelButton.backgroundColor = _mainColor;
    }
}

/**标题字体
 */
- (void)setTitleFont:(UIFont *)titleFont
{
    if(![_titleFont isEqualToFont:titleFont])
    {
        if(titleFont == nil)
            titleFont = [UIFont boldSystemFontOfSize:17.0];
        _titleFont = titleFont;
        self.header.titleLabel.font = _titleFont;
    }
}

/**标题字体颜色
 */
- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    if(![_titleTextColor isEqualToColor:titleTextColor])
    {
        if(titleTextColor == nil)
            titleTextColor = [UIColor blackColor];
        _titleTextColor = titleTextColor;
        
        self.header.titleLabel.textColor = _titleTextColor;
    }
}

///标题对其方式
- (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment
{
    if(_titleTextAlignment != titleTextAlignment)
    {
        _titleTextAlignment = titleTextAlignment;
        self.header.titleLabel.textAlignment = _titleTextAlignment;
    }
}

///信息字体
- (void)setMessageFont:(UIFont *)messageFont
{
    if(![_messageFont isEqualToFont:messageFont])
    {
        if(messageFont == nil)
            messageFont = [UIFont systemFontOfSize:13.0];
        _messageFont = messageFont;
        self.header.messageLabel.font = _messageFont;
    }
}

///信息字体颜色
- (void)setMessageTextColor:(UIColor *)messageTextColor
{
    if(![_messageTextColor isEqualToColor:messageTextColor])
    {
        if(messageTextColor == nil)
            _messageTextColor = messageTextColor;
        self.header.messageLabel.textColor = messageTextColor;
    }
}

///信息对其方式
- (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment
{
    if(_messageTextAlignment != messageTextAlignment)
    {
        _messageTextAlignment = messageTextAlignment;
        self.header.messageLabel.textAlignment = _messageTextAlignment;
    }
}

/**按钮字体
 */
- (void)setButttonFont:(UIFont *)butttonFont
{
    if(![_butttonFont isEqualToFont:butttonFont])
    {
        if(butttonFont == nil)
            butttonFont = [UIFont systemFontOfSize:18.0];
        _butttonFont = butttonFont;
        
        [self.collectionView reloadData];
    }
}

/**按钮字体颜色
 */
- (void)setButtonTextColor:(UIColor *)buttonTextColor
{
    if(![_buttonTextColor isEqualToColor:buttonTextColor])
    {
        if(buttonTextColor == nil)
            buttonTextColor = UIKitTintColor;
        
        _buttonTextColor = buttonTextColor;
        
        [self.collectionView reloadData];
    }
}

/**警示按钮字体
 */
- (void)setDestructiveButtonFont:(UIFont *)destructiveButtonFont
{
    if(![_destructiveButtonFont isEqualToFont:destructiveButtonFont])
    {
        if(destructiveButtonFont == nil)
            destructiveButtonFont = [UIFont systemFontOfSize:18.0];
        _destructiveButtonFont = destructiveButtonFont;
        
        if(self.destructiveButtonIndex < self.actions.count)
        {
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:self.destructiveButtonIndex inSection:0]]];
        }
    }
}

/**警示按钮字体颜色
 */
- (void)setDestructiveButtonTextColor:(UIColor *)destructiveButtonTextColor
{
    if(![_destructiveButtonTextColor isEqualToColor:destructiveButtonTextColor])
    {
        if(destructiveButtonTextColor == nil)
            destructiveButtonTextColor = [UIColor redColor];
        _destructiveButtonTextColor = destructiveButtonTextColor;
        
        if(self.destructiveButtonIndex < self.actions.count)
        {
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:self.destructiveButtonIndex inSection:0]]];
        }
    }
}

/**取消按钮字体
 */
- (void)setCancelButtonFont:(UIFont *)cancelButtonFont
{
    if(![_cancelButtonFont isEqualToFont:cancelButtonFont])
    {
        if(cancelButtonFont == nil)
            cancelButtonFont = [UIFont boldSystemFontOfSize:18.0];
        
        _cancelButtonFont = cancelButtonFont;
        
        switch (_style)
        {
            case SeaAlertControllerStyleActionSheet :
            {
                self.cancelButton.titleLabel.font = _cancelButtonFont;
            }
                break;
            case SeaAlertControllerStyleAlert :
            {
                if(self.cancelTitle)
                {
                    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
                }
            }
                break;
        }
    }
}

/**取消按钮字体颜色
 */
- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor
{
    if(![_cancelButtonTextColor isEqualToColor:cancelButtonTextColor])
    {
        if(cancelButtonTextColor == nil)
            cancelButtonTextColor = UIKitTintColor;
        _cancelButtonTextColor = cancelButtonTextColor;
        
        switch (_style)
        {
            case SeaAlertControllerStyleActionSheet :
            {
                self.cancelButton.titleLabel.textColor = _cancelButtonTextColor;
            }
                break;
            case SeaAlertControllerStyleAlert :
            {
                if(self.cancelTitle)
                {
                    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
                }
            }
                break;
        }
    }
}

///按钮无法点击时的字体颜色
- (void)setDisableButtonTextColor:(UIColor *)disableButtonTextColor
{
    if(![_disableButtonTextColor isEqualToColor:disableButtonTextColor])
    {
        if(disableButtonTextColor == nil)
            disableButtonTextColor = [UIColor grayColor];
        _disableButtonTextColor = disableButtonTextColor;
        
        [self.collectionView reloadData];
    }
}

///高亮背景
- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    if(![_highlightedBackgroundColor isEqualToColor:highlightedBackgroundColor])
    {
        if(highlightedBackgroundColor == nil)
            highlightedBackgroundColor = [UIColor colorWithWhite:0.6 alpha:0.3];
        
        _highlightedBackgroundColor = highlightedBackgroundColor;
        
        self.cancelButton.highlightView.backgroundColor = _highlightedBackgroundColor;
        [self.collectionView reloadData];
    }
}

- (NSArray*)alertActions
{
    return [self.actions copy];
}

@end
