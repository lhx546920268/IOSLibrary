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

///按钮标题
@property(nonatomic,readonly) UILabel *titleLabel;

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
        
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel sea_insetsInSuperview:UIEdgeInsetsZero];
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
    }
    
    return self;
}

+ (instancetype)alertActionWithTitle:(NSString*) title
{
    SeaAlertAction *action = [[[self class] alloc] init];
    action.title = title;
    
    return action;
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
 内容视图
 */
@property(nonatomic, strong) UIView *dialogContentView;

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
#if SeaDebug
    NSAssert(!title || [title isKindOfClass:[NSString class]] || [title isKindOfClass:[NSAttributedString class]], @"SeaAlertController title 必须为 nil 或者 NSString 或者 NSAttributedString");
    NSAssert(!message || [message isKindOfClass:[NSString class]] || [message isKindOfClass:[NSAttributedString class]], @"SeaAlertController message 必须为 nil 或者 NSString 或者 NSAttributedString");
#endif
    self = [super init];
    
    if(self){
        self.actions = [NSMutableArray array];
        self.titleString = title;
        self.message = message;
        self.icon = icon;
        
        self.cancelTitle = cancelButtonTitle;
        
        _style = style;
        
        for(NSString *title in otherButtonTitles){
            [self.actions addObject:[SeaAlertAction alertActionWithTitle:title]];
        }
        
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
    
    self.showAnimate = SeaDialogAnimateCustom;
    self.dismissAnimate = SeaDialogAnimateCustom;
    switch (_style){
        case SeaAlertControllerStyleActionSheet : {
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            tap.delegate = self;
            [self.backgroundView addGestureRecognizer:tap];
        }
            break;
        default:
            break;
    }
}

- (void)setDialog:(UIView *)dialog
{
    [super setDialog:dialog];
    [self.dialog sea_removeAllContraints];
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
    _cornerRadius = 8.0;
    _contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
    _horizontalSpacing = 15;
    _verticalSpacing = 8;
    
    switch (_style){
        case SeaAlertControllerStyleAlert : {
            _buttonHeight = 45.0;
        }
            break;
        case SeaAlertControllerStyleActionSheet : {
            _buttonHeight = 50.0;
        }
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark- layout

- (void)viewDidLayoutSubviews
{
    if(!self.dialogContentView){
        
        CGFloat width = [self alertViewWidth];
        CGFloat margin = (self.view.width - width) / 2.0;
        
        self.dialogContentView = [UIView new];
        self.dialogContentView.backgroundColor = [UIColor clearColor];
        self.dialogContentView.layer.cornerRadius = self.cornerRadius;
        self.dialogContentView.layer.masksToBounds = YES;
        
        
        if(self.titleString || self.message || self.icon){
            self.header = [[SeaAlertHeader alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
            CGFloat constraintWidth = self.header.width - self.horizontalSpacing * 2;
            
            CGFloat y = self.horizontalSpacing;
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
                    y += self.verticalSpacing;
                }
                self.header.titleLabel.font = self.titleFont;
                self.header.titleLabel.textColor = self.titleTextColor;
                self.header.titleLabel.textAlignment = self.titleTextAlignment;
                
                CGSize size = CGSizeZero;
                if([self.titleString isKindOfClass:[NSString class]]){
                    self.header.titleLabel.text = self.titleString;
                    size = [self.titleString sea_stringSizeWithFont:self.titleFont contraintWith:constraintWidth];
                }else if([self.titleString isKindOfClass:[NSAttributedString class]]){
                    self.header.titleLabel.attributedText = self.titleString;
                    size = [self.titleString sea_boundsWithConstraintWidth:constraintWidth];
                }
                
                self.header.titleLabel.frame = CGRectMake(self.horizontalSpacing, y, constraintWidth, size.height + 1.0);
                y += self.header.titleLabel.height;
            }
            
            if(self.message){
                if(self.icon || self.titleString){
                    y += self.verticalSpacing;
                }
                self.header.messageLabel.font = self.messageFont;
                self.header.messageLabel.textColor = self.messageTextColor;
                self.header.messageLabel.textAlignment = self.messageTextAlignment;
                
                CGSize size = CGSizeZero;
                if([self.message isKindOfClass:[NSString class]]){
                    self.header.messageLabel.text = self.message;
                    size = [self.message sea_stringSizeWithFont:self.messageFont contraintWith:constraintWidth];
                }else if ([self.message isKindOfClass:[NSAttributedString class]]){
                    self.header.messageLabel.attributedText = self.message;
                    size = [self.message sea_boundsWithConstraintWidth:constraintWidth];
                }
                self.header.messageLabel.frame = CGRectMake(self.horizontalSpacing, y, constraintWidth, size.height + 1.0);
                y += self.header.messageLabel.height;
            }
            
            self.header.height = y + self.horizontalSpacing;
            self.header.contentSize = CGSizeMake(self.header.width, self.header.height);
            
            self.header.backgroundColor = self.mainColor;
            [self.dialogContentView addSubview:self.header];
        }
        
        switch (_style){
            case SeaAlertControllerStyleAlert : {
                self.dialogContentView.frame = CGRectMake(margin, margin, width, 0);
            }
                break;
            case SeaAlertControllerStyleActionSheet : {
                
                self.dialogContentView.frame = CGRectMake(_contentInsets.left, margin, width, 0);
                self.cancelButton = [[SeaAlertButton alloc] initWithFrame:CGRectMake(margin, margin, width, self.buttonHeight)];
                self.cancelButton.layer.cornerRadius = self.cornerRadius;
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
        
        if(self.actions.count > 0){
            self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.header.bottom, width, 0)collectionViewLayout:[self layout]];
            self.collectionView.backgroundColor = [UIColor colorWithWhite:0.90 alpha:0.9];
            [self.collectionView registerClass:[SeaAlertButtonCell class] forCellWithReuseIdentifier:@"SeaAlertButtonCell"];
            self.collectionView.dataSource = self;
            self.collectionView.delegate = self;
            self.collectionView.bounces = YES;
            [self.dialogContentView addSubview:self.collectionView];
        }
        
        [self layoutSubViews];
        [self.view addSubview:self.dialogContentView];
        
        self.dialog = self.dialogContentView;
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
            return self.view.width - _contentInsets.left - _contentInsets.right;
        }
            break;
    }
}

///collectionView布局方式
- (UICollectionViewFlowLayout*)layout
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = SeaSeparatorWidth;
    layout.minimumLineSpacing = SeaSeparatorWidth;
    
    switch (_style){
        case SeaAlertControllerStyleActionSheet : {
            layout.itemSize = CGSizeMake([self alertViewWidth], self.buttonHeight);
        }
            break;
        case SeaAlertControllerStyleAlert : {
            layout.itemSize = CGSizeMake(self.actions.count == 2 ? ([self alertViewWidth] - SeaSeparatorWidth) / 2.0 : [self alertViewWidth], self.buttonHeight);
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
    if(self.header){
        headerHeight = self.header.height;
    }
    
    ///按钮高度
    CGFloat buttonHeight = 0;

    if(self.actions.count > 0){
        switch (_style){
            case SeaAlertControllerStyleAlert : {
                buttonHeight = self.actions.count < 3 ? self.buttonHeight : self.actions.count * (SeaSeparatorWidth + self.buttonHeight);
            }
                break;
            case SeaAlertControllerStyleActionSheet : {
                buttonHeight = self.actions.count * self.buttonHeight + (self.actions.count - 1) * SeaSeparatorWidth;
                
                if(headerHeight > 0){
                    buttonHeight += SeaSeparatorWidth;
                }
            }
                break;
        }
    }
    
    ///取消按钮高度
    CGFloat cancelHeight = self.cancelButton ? (self.cancelButton.height + _contentInsets.bottom) : 0;
    
    CGFloat maxContentHeight = self.view.height - _contentInsets.top - _contentInsets.bottom - cancelHeight;
    
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
        self.dialogContentView.height = maxContentHeight;
    }else{
        
        frame.origin.y = self.header.bottom;
        frame.size.height = buttonHeight;
        self.collectionView.frame = frame;
        self.dialogContentView.height = headerHeight + buttonHeight;
    }
    
    if(self.header.height > 0){
        self.collectionView.height += SeaSeparatorWidth;
        self.dialogContentView.height += SeaSeparatorWidth;
    }
    
    switch (_style){
        case SeaAlertControllerStyleActionSheet : {
            self.dialogContentView.top = self.view.height;
        }
            break;
        case SeaAlertControllerStyleAlert : {
            self.dialogContentView.top = (self.view.height - self.dialogContentView.height) / 2.0;
        }
            break;
    }
    
    self.cancelButton.top = self.dialogContentView.bottom + _contentInsets.bottom;
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

///点击黑色半透明
- (void)handleTap:(UITapGestureRecognizer*) tap
{
    [self dismiss];
}

- (void)didExecuteDismissCustomAnimate:(void (^)(BOOL))completion
{
    switch (_style){
        case SeaAlertControllerStyleActionSheet : {
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.backgroundView.alpha = 0;
                self.dialogContentView.top = self.view.height;
                self.cancelButton.top = self.dialogContentView.bottom + _contentInsets.bottom;
                
            }completion:completion];
        }
            break;
        case SeaAlertControllerStyleAlert : {
            !completion ?: completion(YES);
        }
            break;
    }
}

- (void)didExecuteShowCustomAnimate:(void (^)(BOOL))completion
{
    switch (_style){
        case SeaAlertControllerStyleAlert : {
            self.dialogContentView.alpha = 0;
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.backgroundView.alpha = 1.0;
                self.dialogContentView.alpha = 1.0;
                CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
                animation.fromValue = [NSNumber numberWithFloat:1.3];
                animation.toValue = [NSNumber numberWithFloat:1.0];
                animation.duration = 0.25;
                [self.dialogContentView.layer addAnimation:animation forKey:@"scale"];
            }completion:completion];
        }
            break;
        case SeaAlertControllerStyleActionSheet : {
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.backgroundView.alpha = 1.0;
                self.dialogContentView.top = self.view.height - _dialogContentView.height - _contentInsets.bottom - self.cancelButton.height - _contentInsets.bottom;
                self.cancelButton.top = self.dialogContentView.bottom + _contentInsets.bottom;
            }completion:completion];
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

#pragma mark- UITapGestureRecognizer delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint point = [gestureRecognizer locationInView:self.backgroundView];
    point.y += self.backgroundView.top;
    if(CGRectContainsPoint(self.dialogContentView.frame, point)){
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
    
    if(isCancel){
        cell.titleLabel.textColor = action.textColor ? action.textColor : self.cancelButtonTextColor;
        cell.titleLabel.font = action.font ? action.font : self.cancelButtonFont;
    }else if(indexPath.item == _destructiveButtonIndex){
        cell.titleLabel.textColor = action.textColor ? action.textColor : self.destructiveButtonTextColor;
        cell.titleLabel.font = action.font ? action.font : self.destructiveButtonFont;
    }else{
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
    if(action.enable){
        !self.selectionHandler ?: self.selectionHandler(indexPath.item);
        !self.dismissWhenSelectButton ?: [self dismiss];
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

- (void)setMainColor:(UIColor *)mainColor
{
    if(![_mainColor isEqualToColor:mainColor]){
        if(mainColor == nil)
            mainColor = [UIColor whiteColor];
        _mainColor = mainColor;
        self.cancelButton.backgroundColor = _mainColor;
    }
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if(![_titleFont isEqualToFont:titleFont]){
        if(titleFont == nil)
            titleFont = [UIFont boldSystemFontOfSize:17.0];
        _titleFont = titleFont;
        self.header.titleLabel.font = _titleFont;
    }
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    if(![_titleTextColor isEqualToColor:titleTextColor]){
        if(titleTextColor == nil)
            titleTextColor = [UIColor blackColor];
        _titleTextColor = titleTextColor;
        
        self.header.titleLabel.textColor = _titleTextColor;
    }
}

- (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment
{
    if(_titleTextAlignment != titleTextAlignment){
        _titleTextAlignment = titleTextAlignment;
        self.header.titleLabel.textAlignment = _titleTextAlignment;
    }
}

- (void)setMessageFont:(UIFont *)messageFont
{
    if(![_messageFont isEqualToFont:messageFont]){
        if(messageFont == nil)
            messageFont = [UIFont fontWithName:SeaMainFontName size:13.0];
        _messageFont = messageFont;
        self.header.messageLabel.font = _messageFont;
    }
}

- (void)setMessageTextColor:(UIColor *)messageTextColor
{
    if(![_messageTextColor isEqualToColor:messageTextColor]){
        if(messageTextColor == nil)
            _messageTextColor = messageTextColor;
        self.header.messageLabel.textColor = messageTextColor;
    }
}

- (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment
{
    if(_messageTextAlignment != messageTextAlignment){
        _messageTextAlignment = messageTextAlignment;
        self.header.messageLabel.textAlignment = _messageTextAlignment;
    }
}

- (void)setButttonFont:(UIFont *)butttonFont
{
    if(![_butttonFont isEqualToFont:butttonFont]){
        if(butttonFont == nil)
            butttonFont = [UIFont fontWithName:SeaMainFontName size:17.0];
        _butttonFont = butttonFont;
        
        [self.collectionView reloadData];
    }
}

- (void)setButtonTextColor:(UIColor *)buttonTextColor
{
    if(![_buttonTextColor isEqualToColor:buttonTextColor]){
        if(buttonTextColor == nil)
            buttonTextColor = UIKitTintColor;
        
        _buttonTextColor = buttonTextColor;
        
        [self.collectionView reloadData];
    }
}

- (void)setDestructiveButtonFont:(UIFont *)destructiveButtonFont
{
    if(![_destructiveButtonFont isEqualToFont:destructiveButtonFont]){
        if(destructiveButtonFont == nil)
            destructiveButtonFont = [UIFont fontWithName:SeaMainFontName size:17.0];
        _destructiveButtonFont = destructiveButtonFont;
        
        if(self.destructiveButtonIndex < self.actions.count){
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:self.destructiveButtonIndex inSection:0]]];
        }
    }
}

- (void)setDestructiveButtonTextColor:(UIColor *)destructiveButtonTextColor
{
    if(![_destructiveButtonTextColor isEqualToColor:destructiveButtonTextColor]){
        if(destructiveButtonTextColor == nil)
            destructiveButtonTextColor = [UIColor redColor];
        _destructiveButtonTextColor = destructiveButtonTextColor;
        
        if(self.destructiveButtonIndex < self.actions.count){
            [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:self.destructiveButtonIndex inSection:0]]];
        }
    }
}

- (void)setCancelButtonFont:(UIFont *)cancelButtonFont
{
    if(![_cancelButtonFont isEqualToFont:cancelButtonFont]){
        if(cancelButtonFont == nil)
            cancelButtonFont = [UIFont boldSystemFontOfSize:17.0];
        
        _cancelButtonFont = cancelButtonFont;
        
        switch (_style){
            case SeaAlertControllerStyleActionSheet : {
                self.cancelButton.titleLabel.font = _cancelButtonFont;
            }
                break;
            case SeaAlertControllerStyleAlert : {
                if(self.cancelTitle){
                    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
                }
            }
                break;
        }
    }
}

- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor
{
    if(![_cancelButtonTextColor isEqualToColor:cancelButtonTextColor]){
        if(cancelButtonTextColor == nil)
            cancelButtonTextColor = UIKitTintColor;
        _cancelButtonTextColor = cancelButtonTextColor;
        
        switch (_style){
            case SeaAlertControllerStyleActionSheet : {
                self.cancelButton.titleLabel.textColor = _cancelButtonTextColor;
            }
                break;
            case SeaAlertControllerStyleAlert : {
                if(self.cancelTitle){
                    [self.collectionView reloadItemsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForItem:0 inSection:0]]];
                }
            }
                break;
        }
    }
}

- (void)setDisableButtonTextColor:(UIColor *)disableButtonTextColor
{
    if(![_disableButtonTextColor isEqualToColor:disableButtonTextColor]){
        if(disableButtonTextColor == nil)
            disableButtonTextColor = [UIColor grayColor];
        _disableButtonTextColor = disableButtonTextColor;
        
        [self.collectionView reloadData];
    }
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor
{
    if(![_highlightedBackgroundColor isEqualToColor:highlightedBackgroundColor]){
        if(highlightedBackgroundColor == nil)
            highlightedBackgroundColor = [UIColor colorWithWhite:0.6 alpha:0.3];
        
        _highlightedBackgroundColor = highlightedBackgroundColor;
        
        self.cancelButton.highlightView.backgroundColor = _highlightedBackgroundColor;
        [self.collectionView reloadData];
    }
}

- (NSArray<SeaAlertAction*>*)alertActions
{
    return [self.actions copy];
}

@end
