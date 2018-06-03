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
#import "UIColor+Utils.h"
#import "UIFont+Utils.h"
#import "UIView+SeaAutoLayout.h"
#import "UIImage+Utils.h"
#import "SeaContainer.h"
#import "UIButton+Utils.h"

#pragma mark- button

///弹窗按钮
@interface SeaAlertButton : UIView

/**
 标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**
 高亮显示视图
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
    if(self){
        self.clipsToBounds = YES;
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
    
    if(!CGRectContainsPoint(self.frame, point)){
        [self touchEnded];
    }else{
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

///按钮
@property(nonatomic,readonly) UIButton *button;

///高亮背景
@property(nonatomic,readonly) UIView  *highlightedBackgroundView;

@end

@implementation SeaAlertButtonCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        _highlightedBackgroundView = [UIView new];
        _highlightedBackgroundView.hidden = YES;
        [self.contentView addSubview:_highlightedBackgroundView];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.adjustsImageWhenHighlighted = NO;
        _button.adjustsImageWhenDisabled = NO;
        _button.enabled = NO;
        [self.contentView addSubview:_button];
        
        [_button sea_insetsInSuperview:UIEdgeInsetsZero];
        [_highlightedBackgroundView sea_insetsInSuperview:UIEdgeInsetsZero];
    }
    
    return self;
}

@end

/**
 弹窗头部
 */
@interface SeaAlertHeader : UIScrollView

/**图标
 */
@property(nonatomic,readonly) UIImageView *imageView;

/**
 标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

/**
 信息
 */
@property(nonatomic,readonly) UILabel *messageLabel;

@end

@implementation SeaAlertHeader

@synthesize titleLabel = _titleLabel;
@synthesize imageView = _imageView;
@synthesize messageLabel = _messageLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.alwaysBounceHorizontal = NO;
        self.alwaysBounceVertical = NO;
        
        self.backgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (UILabel*)titleLabel
{
    if(!_titleLabel){
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (UILabel*)messageLabel
{
    if(!_messageLabel){
        _messageLabel = [UILabel new];
        _messageLabel.textAlignment = NSTextAlignmentCenter;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.numberOfLines = 0;
        _messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_messageLabel];
    }
    
    return _messageLabel;
}
- (UIImageView*)imageView
{
    if(!_imageView){
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
    }
    
    return _imageView;
}

@end

#pragma mark- action

@implementation SeaAlertAction

- (instancetype)init
{
    self = [super init];
    if(self){
        self.enable = YES;
        self.spacing = 5;
    }
    
    return self;
}

+ (instancetype)alertActionWithTitle:(NSString*) title
{
    return [self alertActionWithTitle:title icon:nil];
}

+ (instancetype)alertActionWithTitle:(NSString*) title icon:(UIImage*) icon
{
    SeaAlertAction *action = [[[self class] alloc] init];
    action.title = title;
    action.icon = icon;
    
    return action;
}

@end

@implementation SeaAlertStyle

- (instancetype)init
{
    self = [super init];
    if(self){
        self.mainColor = [UIColor whiteColor];
        self.titleFont = [UIFont boldSystemFontOfSize:17.0];
        self.titleTextColor = [UIColor blackColor];
        self.titleTextAlignment = NSTextAlignmentCenter;
        self.messageFont = [UIFont fontWithName:SeaMainFontName size:13.0];
        self.messageTextColor = [UIColor blackColor];
        self.messageTextAlignment = NSTextAlignmentCenter;
        self.butttonFont = [UIFont fontWithName:SeaMainFontName size:17.0];;
        self.buttonTextColor = UIKitTintColor;
        self.destructiveButtonFont = [UIFont fontWithName:SeaMainFontName size:17.0];
        self.destructiveButtonTextColor = [UIColor redColor];
        self.cancelButtonFont = [UIFont boldSystemFontOfSize:17.0];
        self.cancelButtonTextColor = UIKitTintColor;
        self.disableButtonTextColor = [UIColor grayColor];
        self.highlightedBackgroundColor = [UIColor colorWithWhite:0.6 alpha:0.3];
        self.cornerRadius = 8.0;
        self.contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        self.cancelButtonVerticalSpacing = 15;
        self.horizontalSpacing = 15;
        self.verticalSpacing = 8;
    }
    
    return self;
}

+ (instancetype)actionSheetInstance
{
    static SeaAlertStyle *actionSheetStyle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actionSheetStyle = [SeaAlertStyle new];
        actionSheetStyle.buttonHeight = 50;
    });
    
    return actionSheetStyle;
}

+ (instancetype)alertInstance
{
    static SeaAlertStyle *alertStyle = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        alertStyle = [SeaAlertStyle new];
        alertStyle.buttonHeight = 45;
    });
    
    return alertStyle;
}

- (instancetype)copyWithZone:(NSZone *)zone
{
    SeaAlertStyle *style = [SeaAlertStyle allocWithZone:zone];
    style.contentInsets = self.contentInsets;
    style.cornerRadius = self.cornerRadius;
    style.horizontalSpacing = self.horizontalSpacing;
    style.verticalSpacing = self.verticalSpacing;
    
    style.cancelButtonFont = self.cancelButtonFont;
    style.cancelButtonTextColor = self.cancelButtonTextColor;
    style.cancelButtonVerticalSpacing = self.cancelButtonVerticalSpacing;
    style.spacingBackgroundColor = self.spacingBackgroundColor;
    style.mainColor = self.mainColor;
    
    style.titleFont = self.titleFont;
    style.titleTextColor = self.titleTextColor;
    style.titleTextAlignment = self.titleTextAlignment;
    
    style.messageFont = self.messageFont;
    style.messageTextColor = self.messageTextColor;
    style.messageTextAlignment = self.messageTextAlignment;
    
    style.buttonHeight = self.buttonHeight;
    style.butttonFont = self.butttonFont;
    style.buttonTextColor = self.buttonTextColor;
    
    style.destructiveButtonFont = self.destructiveButtonFont;
    style.destructiveButtonTextColor = self.destructiveButtonTextColor;
    style.destructiveButtonBackgroundColor = self.destructiveButtonBackgroundColor;
    
    style.highlightedBackgroundColor = self.highlightedBackgroundColor;
    
    style.disableButtonTextColor = self.disableButtonTextColor;
    
    return style;
}

@end

#pragma mark- controller

@interface SeaAlertController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>

/**
 按钮列表
 */
@property(nonatomic, strong) UICollectionView *collectionView;

/**
 头部
 */
@property(nonatomic, strong) SeaAlertHeader *header;

/**
 取消按钮 用于 actionSheet
 */
@property(nonatomic, strong) SeaAlertButton *cancelButton;

/**
 取消按钮标题
 */
@property(nonatomic, copy) NSString *cancelTitle;

/**
 标题 NSString 或者 NSAttributedString
 */
@property(nonatomic, copy) id titleString;

/**
 信息 NSString 或者 NSAttributedString
 */
@property(nonatomic, copy) id message;

/**
 图标
 */
@property(nonatomic, strong) UIImage *icon;

/**
 按钮
 */
@property(nonatomic, strong) NSMutableArray<SeaAlertAction*> *actions;

@end

@implementation SeaAlertController

+ (instancetype)alertWithTitle:(id)title message:(id)message cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
{
    return [[SeaAlertController alloc] initWithTitle:title message:message icon:nil style:SeaAlertControllerStyleAlert cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitles];
}

+ (instancetype)actionSheetWithTitle:(id)title message:(id)message otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
{
    return [[SeaAlertController alloc] initWithTitle:title message:message icon:nil style:SeaAlertControllerStyleActionSheet cancelButtonTitle:nil otherButtonTitles:otherButtonTitles];
}

- (instancetype)initWithTitle:(id) title
                      message:(id) message
                         icon:(UIImage*) icon
                        style:(SeaAlertControllerStyle) style
            cancelButtonTitle:(NSString *) cancelButtonTitle
            otherButtonTitles:(NSArray<NSString *> *)otherButtonTitles
{
    NSMutableArray *actions = [NSMutableArray array];
    for(NSString *title in otherButtonTitles){
        [actions addObject:[SeaAlertAction alertActionWithTitle:title]];
    }
    return [self initWithTitle:title message:message icon:icon style:style cancelButtonTitle:cancelButtonTitle otherButtonActions:actions];
}

- (instancetype)initWithTitle:(id)title message:(id)message icon:(UIImage *)icon style:(SeaAlertControllerStyle)style cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonActions:(NSArray<SeaAlertAction *> *)actions
{
#if SeaDebug
    NSAssert(!title || [title isKindOfClass:[NSString class]] || [title isKindOfClass:[NSAttributedString class]], @"SeaAlertController title 必须为 nil 或者 NSString 或者 NSAttributedString");
    NSAssert(!message || [message isKindOfClass:[NSString class]] || [message isKindOfClass:[NSAttributedString class]], @"SeaAlertController message 必须为 nil 或者 NSString 或者 NSAttributedString");
#endif
    self = [super init];
    
    if(self){
        self.titleString = title;
        self.message = message;
        self.icon = icon;
        
        self.cancelTitle = cancelButtonTitle;
        
        _style = style;
        
        self.actions = [NSMutableArray arrayWithArray:actions];
        
        switch (_style){
            case SeaAlertControllerStyleAlert : {
                if(self.actions.count == 0 && !self.cancelTitle){
                    self.cancelTitle = @"取消";
                }
                
                if(self.cancelTitle){
                    if(self.actions.count < 2){
                        [self.actions insertObject:[SeaAlertAction alertActionWithTitle:self.cancelTitle] atIndex:0];
                    }else{
                        [self.actions addObject:[SeaAlertAction alertActionWithTitle:self.cancelTitle]];
                    }
                }
            }
                break;
            case SeaAlertControllerStyleActionSheet :{
                if(!self.cancelTitle){
                    self.cancelTitle = @"取消";
                }
            }
                break;
        }
        
        
        [self initilization];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dialogShowAnimate = SeaDialogAnimateCustom;
    self.dialogDismissAnimate = SeaDialogAnimateCustom;
    self.shouldDismissDialogOnTapTranslucent = self.style == SeaAlertControllerStyleActionSheet;
    self.tapDialogBackgroundGestureRecognizer.delegate = self;
}

///属性初始化
- (void)initilization
{
    _destructiveButtonIndex = NSNotFound;
    _dismissWhenSelectButton = YES;
}

#pragma mark- layout

- (void)viewDidLayoutSubviews
{
    if(!self.isViewDidLayoutSubviews){
        
        SeaAlertStyle *style = self.alertStyle;
        CGFloat width = [self alertViewWidth];
        CGFloat margin = (self.view.width - width) / 2.0;
        
        self.container.backgroundColor = [UIColor clearColor];
        self.container.layer.cornerRadius = style.cornerRadius;
        self.container.layer.masksToBounds = YES;
        
        
        if(self.titleString || self.message || self.icon){
            self.header = [[SeaAlertHeader alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
            CGFloat constraintWidth = self.header.width - style.horizontalSpacing * 2;
            
            CGFloat y = style.horizontalSpacing;
            if(self.icon){
                self.header.imageView.image = self.icon;
                if(self.icon.size.width > constraintWidth){
                    CGSize size = [self.icon sea_fitWithSize:CGSizeMake(constraintWidth, 0) type:SeaImageFitTypeWidth];
                    self.header.imageView.frame = CGRectMake((self.header.width - size.width) / 2, y, size.width, size.height);
                }else{
                    self.header.imageView.frame = CGRectMake((self.header.width - self.icon.size.width) / 2, y, self.icon.size.width, self.icon.size.height);
                }
                y += self.header.imageView.height;
            }
            
            if(self.titleString){
                if(self.icon){
                    y += style.verticalSpacing;
                }
                self.header.titleLabel.font = style.titleFont;
                self.header.titleLabel.textColor = style.titleTextColor;
                self.header.titleLabel.textAlignment = style.titleTextAlignment;
                
                CGSize size = CGSizeZero;
                if([self.titleString isKindOfClass:[NSString class]]){
                    self.header.titleLabel.text = self.titleString;
                    size = [self.titleString sea_stringSizeWithFont:style.titleFont contraintWith:constraintWidth];
                }else if([self.titleString isKindOfClass:[NSAttributedString class]]){
                    self.header.titleLabel.attributedText = self.titleString;
                    size = [self.titleString sea_boundsWithConstraintWidth:constraintWidth];
                }
                
                self.header.titleLabel.frame = CGRectMake(style.horizontalSpacing, y, constraintWidth, size.height + 1.0);
                y += self.header.titleLabel.height;
            }
            
            if(self.message){
                if(self.icon || self.titleString){
                    y += style.verticalSpacing;
                }
                self.header.messageLabel.font = style.messageFont;
                self.header.messageLabel.textColor = style.messageTextColor;
                self.header.messageLabel.textAlignment = style.messageTextAlignment;
                
                CGSize size = CGSizeZero;
                if([self.message isKindOfClass:[NSString class]]){
                    self.header.messageLabel.text = self.message;
                    size = [self.message sea_stringSizeWithFont:style.messageFont contraintWith:constraintWidth];
                }else if ([self.message isKindOfClass:[NSAttributedString class]]){
                    self.header.messageLabel.attributedText = self.message;
                    size = [self.message sea_boundsWithConstraintWidth:constraintWidth];
                }
                self.header.messageLabel.frame = CGRectMake(style.horizontalSpacing, y, constraintWidth, size.height + 1.0);
                y += self.header.messageLabel.height;
            }
            
            self.header.height = y + style.horizontalSpacing;
            self.header.contentSize = CGSizeMake(self.header.width, self.header.height);
            
            self.header.backgroundColor = style.mainColor;
            [self.container addSubview:self.header];
        }
        
        switch (_style){
            case SeaAlertControllerStyleAlert : {
                self.container.frame = CGRectMake(margin, margin, width, 0);
            }
                break;
            case SeaAlertControllerStyleActionSheet : {
                
                self.container.frame = CGRectMake(style.contentInsets.left, margin, width, 0);
                self.cancelButton = [[SeaAlertButton alloc] initWithFrame:CGRectMake(margin, margin, width, style.buttonHeight)];
                self.cancelButton.layer.cornerRadius = style.cornerRadius;
                self.cancelButton.backgroundColor = style.mainColor;
                self.cancelButton.titleLabel.text = self.cancelTitle;
                self.cancelButton.titleLabel.textColor = style.cancelButtonTextColor;
                self.cancelButton.titleLabel.font = style.cancelButtonFont;
                self.cancelButton.highlightView.backgroundColor = style.highlightedBackgroundColor;
                [self.cancelButton addTarget:self action:@selector(cancel:)];
                
                //取消按钮和 内容视图的间隔
                if(style.spacingBackgroundColor && style.cancelButtonVerticalSpacing > 0){
                    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, -style.cancelButtonVerticalSpacing, self.cancelButton.width, style.cancelButtonVerticalSpacing)];
                    view.backgroundColor = style.spacingBackgroundColor;
                    [self.cancelButton addSubview:view];
                    self.cancelButton.clipsToBounds = NO;
                }
                
                [self.view addSubview:self.cancelButton];
            }
                break;
        }
        
        if(self.actions.count > 0){
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.header.bottom, width, 0)collectionViewLayout:[self layout]];
            self.collectionView.backgroundColor = [UIColor colorWithWhite:0.90 alpha:0.9];
            [self.collectionView registerClass:[SeaAlertButtonCell class] forCellWithReuseIdentifier:@"SeaAlertButtonCell"];
            self.collectionView.dataSource = self;
            self.collectionView.delegate = self;
            self.collectionView.bounces = YES;
            [self.container addSubview:self.collectionView];
        }
        
        [self layoutSubViews];
    }
    [super viewDidLayoutSubviews];
}

///弹窗宽度
- (CGFloat)alertViewWidth
{
    switch (_style){
        case SeaAlertControllerStyleAlert : {
            return 260 + SeaSeparatorWidth;
        }
            break;
        case SeaAlertControllerStyleActionSheet : {
            SeaAlertStyle *style = self.alertStyle;
            return self.view.width - style.contentInsets.left - style.contentInsets.right;
        }
            break;
    }
}

///collectionView布局方式
- (UICollectionViewFlowLayout*)layout
{
    SeaAlertStyle *style = self.alertStyle;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = SeaSeparatorWidth;
    layout.minimumLineSpacing = SeaSeparatorWidth;
    
    switch (_style){
        case SeaAlertControllerStyleActionSheet : {
            layout.itemSize = CGSizeMake([self alertViewWidth], style.buttonHeight);
        }
            break;
        case SeaAlertControllerStyleAlert : {
            layout.itemSize = CGSizeMake(self.actions.count == 2 ? ([self alertViewWidth] - SeaSeparatorWidth) / 2.0 : [self alertViewWidth], style.buttonHeight);
            layout.scrollDirection = self.actions.count >= 3 ? UICollectionViewScrollDirectionVertical : UICollectionViewScrollDirectionHorizontal;
        }
            break;
    }
    
    return layout;
}

///布局子视图
- (void)layoutSubViews
{
    SeaAlertStyle *style = self.alertStyle;
    
    ///头部高度
    CGFloat headerHeight = 0;
    if(self.header){
        headerHeight = self.header.height;
    }
    
    ///按钮高度
    CGFloat buttonHeight = 0;

    if(self.actions.count > 0){
        switch (_style){
            case SeaAlertControllerStyleAlert : {
                buttonHeight = self.actions.count < 3 ? style.buttonHeight : self.actions.count * (SeaSeparatorWidth + style.buttonHeight);
            }
                break;
            case SeaAlertControllerStyleActionSheet : {
                buttonHeight = self.actions.count * style.buttonHeight + (self.actions.count - 1) * SeaSeparatorWidth;
                
                if(headerHeight > 0){
                    buttonHeight += SeaSeparatorWidth;
                }
            }
                break;
        }
    }
    
    
    ///取消按钮高度
    CGFloat cancelHeight = self.cancelButton ? (self.cancelButton.height + style.contentInsets.bottom) : 0;
    
    CGFloat maxContentHeight = self.view.height - style.contentInsets.top - style.contentInsets.bottom - cancelHeight;
    
    CGRect frame = self.collectionView.frame;
    if(headerHeight + buttonHeight > maxContentHeight){
        CGFloat contentHeight = maxContentHeight;
        if(headerHeight >= contentHeight / 2.0 && buttonHeight >= contentHeight / 2.0){
            self.header.height = contentHeight / 2.0;
            frame.size.height = buttonHeight;
        }else if (headerHeight >= contentHeight / 2.0 && buttonHeight < contentHeight / 2.0){
            self.header.height = contentHeight - buttonHeight;
            frame.size.height = buttonHeight;
        }else{
            self.header.height = headerHeight;
            frame.size.height = contentHeight - headerHeight;
        }
        
        frame.origin.y = self.header.bottom;
        self.collectionView.frame = frame;
        self.container.height = maxContentHeight;
    }else{
        
        frame.origin.y = self.header.bottom;
        frame.size.height = buttonHeight;
        self.collectionView.frame = frame;
        self.container.height = headerHeight + buttonHeight;
    }
    
    if(self.header.height > 0){
        self.collectionView.height += SeaSeparatorWidth;
        self.container.height += SeaSeparatorWidth;
    }
    
    switch (_style){
        case SeaAlertControllerStyleActionSheet : {
            self.container.top = self.view.height;
        }
            break;
        case SeaAlertControllerStyleAlert : {
            self.container.top = (self.view.height - self.container.height) / 2.0;
        }
            break;
    }
    
    self.cancelButton.top = self.container.bottom + style.cancelButtonVerticalSpacing;
}

#pragma mark- private method

///取消
- (void)cancel:(id) sender
{
    switch (_style){
        case SeaAlertControllerStyleAlert : {
            !self.selectionHandler ?: self.selectionHandler(0);
        }
            break;
        case SeaAlertControllerStyleActionSheet : {
            !self.selectionHandler ?: self.selectionHandler(self.actions.count);
        }
            break;
    }
    [self dismiss];
}

- (void)didExecuteDialogShowCustomAnimate:(void (^)(BOOL))completion
{
    switch (_style){
        case SeaAlertControllerStyleAlert : {
            self.container.alpha = 0;
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.dialogBackgroundView.alpha = 1.0;
                self.container.alpha = 1.0;
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation.fromValue = [NSNumber numberWithFloat:1.3];
                animation.toValue = [NSNumber numberWithFloat:1.0];
                animation.duration = 0.25;
                [self.container.layer addAnimation:animation forKey:@"scale"];
            }completion:completion];
        }
            break;
        case SeaAlertControllerStyleActionSheet : {
            SeaAlertStyle *style = self.alertStyle;
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.dialogBackgroundView.alpha = 1.0;
                self.container.top = self.view.height - self.container.height - style.contentInsets.bottom - self.cancelButton.height - style.cancelButtonVerticalSpacing;
                self.cancelButton.top = self.container.bottom + style.cancelButtonVerticalSpacing;
            }completion:completion];
        }
            break;
    }
}

- (void)didExecuteDialogDismissCustomAnimate:(void (^)(BOOL))completion
{
    switch (_style){
        case SeaAlertControllerStyleActionSheet : {
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.dialogBackgroundView.alpha = 0;
                self.container.top = self.view.height;
                SeaAlertStyle *style = self.alertStyle;
                self.cancelButton.top = self.container.bottom + style.cancelButtonVerticalSpacing;
                
            }completion:completion];
        }
            break;
        case SeaAlertControllerStyleAlert : {
            !completion ?: completion(YES);
        }
            break;
    }
}

#pragma mark- public method

- (void)reloadButtonForIndex:(NSUInteger) index
{
    if(index < self.actions.count){
        [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:index inSection:0]]];
    }
}

- (NSString*)buttonTitleForIndex:(NSUInteger) index
{
    if(index < self.actions.count){
        SeaAlertAction *action = self.actions[index];
        return action.title;
    }
    
    return nil;
}

/**
 显示弹窗
 */
- (void)show
{
    [self showAsDialog];
}

/**
 隐藏弹窗
 */
- (void)dismiss
{
    [self dismissDialog];
}

#pragma mark- UITapGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.dialogBackgroundView];
    point.y += self.dialogBackgroundView.top;
    if(CGRectContainsPoint(self.container.frame, point)){
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
    if(self.header.height > 0){
        return UIEdgeInsetsMake(SeaSeparatorWidth, 0, 0, 0);
    }else{
        return UIEdgeInsetsZero;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaAlertButtonCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SeaAlertButtonCell" forIndexPath:indexPath];
    
    SeaAlertAction *action = [self.actions objectAtIndex:indexPath.item];
    
    BOOL isCancel = NO;
    if(self.style == SeaAlertControllerStyleAlert && self.cancelTitle){
        isCancel = (indexPath.item == 0 && self.actions.count < 3) || (indexPath.item == self.actions.count - 1 && self.actions.count >= 3);
    }
    
    SeaAlertStyle *style = self.alertStyle;
    UIFont *font;
    UIColor *textColor;
    if(isCancel){
        textColor = action.textColor ? action.textColor : style.cancelButtonTextColor;
        font = action.font ? action.font : style.cancelButtonFont;
    }else if(indexPath.item == _destructiveButtonIndex){
        textColor = action.textColor ? action.textColor : style.destructiveButtonTextColor;
        font = action.font ? action.font : style.destructiveButtonFont;
    }else{
        textColor = action.textColor ? action.textColor : style.buttonTextColor;
        font = action.font ? action.font : style.butttonFont;
    }
    [cell.button setTitleColor:textColor forState:UIControlStateNormal];
    cell.button.titleLabel.font = font;
    
    cell.highlightedBackgroundView.backgroundColor = style.highlightedBackgroundColor;
    [cell.button setTitle:action.title forState:UIControlStateNormal];
    [cell.button setImage:action.icon forState:UIControlStateNormal];
    [cell.button sea_setImagePosition:SeaButtonImagePositionLeft margin:action.spacing];
    
    if(indexPath.item == _destructiveButtonIndex && style.destructiveButtonBackgroundColor){
        cell.contentView.backgroundColor = style.destructiveButtonBackgroundColor;
    }else{
        cell.contentView.backgroundColor = style.mainColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    SeaAlertAction *action = [self.actions objectAtIndex:indexPath.item];
    if(action.enable){
        !self.dismissWhenSelectButton ?: [self dismiss];
        !self.selectionHandler ?: self.selectionHandler(indexPath.item);
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

- (SeaAlertStyle*)alertStyle
{
    if(!_alertStyle){
        _alertStyle = _style == SeaAlertControllerStyleActionSheet ? [SeaAlertStyle actionSheetInstance] : [SeaAlertStyle alertInstance];
    }
    return _alertStyle;
}

- (NSArray<SeaAlertAction*>*)alertActions
{
    return [self.actions copy];
}

@end
