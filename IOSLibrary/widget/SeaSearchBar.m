//
//  SeaSearchBar.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/22.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaSearchBar.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaBasic.h"
#import "NSString+Utils.h"
#import "UIColor+Utils.h"
#import "UIFont+Utils.h"

/**
 图标 placeholder 容器
 */
@interface SeaSearchPlaceholderContainer : UIView

/**
 图标
 */
@property(nonatomic, readonly) UIImageView *imageView;

/**
 placeholder
 */
@property(nonatomic, readonly) UILabel *textLabel;

@end

@implementation SeaSearchPlaceholderContainer

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        
        self.userInteractionEnabled = NO;
        _imageView = [UIImageView new];
        [self addSubview:_imageView];
        
        _textLabel = [UILabel new];
        [self addSubview:_textLabel];
        
        [_imageView sea_leftToSuperview];
        [_imageView sea_centerYInSuperview];
        _imageView.sea_alb.topToSuperview.greaterThanOrEqual.build();
        _imageView.sea_alb.bottomToSuperview.greaterThanOrEqual.build();
        
        [_textLabel sea_leftToItemRight:_imageView margin:5];
        [_textLabel sea_topToSuperview];
        [_textLabel sea_bottomToSuperview];
        [_textLabel sea_rightToSuperview];
    }
    return self;
}

@end

@interface SeaSearchBar()<UITextFieldDelegate>

/**
 取消按钮
 */
@property(nonatomic, readonly) UIButton *cancelButton;

/**
 输入框
 */
@property(nonatomic, readonly) UITextField *textField;

/**
 图标 placeholder 容器
 */
@property(nonatomic, readonly) SeaSearchPlaceholderContainer *placeholderContainer;

/**
 placeholder 容器左边约束
 */
@property(nonatomic, strong) NSLayoutConstraint *placehonlderContainerLeftLayConstraint;

/**
 placeholder 容器居中约束
 */
@property(nonatomic, strong) NSLayoutConstraint *placeholderContainerCenterXConstraint;

/**
 取消按钮标题宽度
 */
@property(nonatomic, assign) CGFloat cancelTitleWidth;

/**
 placeholder 富文本
 */
@property(nonatomic, strong) NSMutableAttributedString *attributedPlaceholder;

/**
 点击手势
 */
@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@end

@implementation SeaSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialization];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.font = nil;
    self.textColor = nil;
    self.placeholderTextColor = nil;
    _contentInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self addGestureRecognizer:self.tapGestureRecognizer];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor whiteColor];
    _contentView.layer.cornerRadius = 5;
    [self addSubview:_contentView];
    
    _placeholderContainer = [SeaSearchPlaceholderContainer new];
    [_contentView addSubview:_placeholderContainer];
    
    _textField = [UITextField new];
    _textField.returnKeyType = UIReturnKeySearch;
    _textField.enablesReturnKeyAutomatically = YES;
    _textField.delegate = self;
    _textField.font = self.font;
    _textField.textColor = self.textColor;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [_textField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    [_textField setContentHuggingPriority:UILayoutPriorityDefaultLow - 1 forAxis:UILayoutConstraintAxisHorizontal];
    [_contentView addSubview:_textField];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelButton setTitleColor:SeaAppMainColor forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont fontWithName:SeaMainFontName size:16];
    [_cancelButton addTarget:self action:@selector(handleCacnel:) forControlEvents:UIControlEventTouchUpInside];
    _cancelButton.layoutMargins = UIEdgeInsetsMake(0, 10, 0, 10);
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [self addSubview:_cancelButton];
    
    self.cancelTitleWidth = [_cancelButton.currentTitle sea_stringSizeWithFont:_cancelButton.titleLabel.font].width;
    
    [_cancelButton sea_rightToSuperview];
    [_cancelButton sea_topToSuperview];
    [_cancelButton sea_bottomToSuperview];
    [_cancelButton sea_widthToSelf:0];
    
    [_contentView sea_leftToSuperview:_contentInsets.left];
    [_contentView sea_topToSuperview:_contentInsets.top];
    [_contentView sea_bottomToSuperview:_contentInsets.bottom];
    [_contentView sea_rightToItemLeft:_cancelButton margin:_contentInsets.right];
    
    self.placeholderContainerCenterXConstraint = [_placeholderContainer sea_centerXInSuperview];
    [_placeholderContainer sea_centerYInSuperview];
    
    [_textField sea_leftToItemRight:_placeholderContainer];
    [_textField sea_rightToSuperview];
    [_textField sea_topToSuperview];
    [_textField sea_bottomToSuperview];
}

- (NSLayoutConstraint*)placehonlderContainerLeftLayConstraint
{
    if(!_placehonlderContainerLeftLayConstraint){
        self.placehonlderContainerLeftLayConstraint = [_placeholderContainer sea_leftToSuperview:5];
    }
    return _placehonlderContainerLeftLayConstraint;
}

- (NSAttributedString*)attributedPlaceholder
{
    if(self.placeholder && !_attributedPlaceholder){
        NSDictionary *attrs = @{
                                NSForegroundColorAttributeName : _placeholderTextColor,
                                NSFontAttributeName : _font
                                };
        _attributedPlaceholder = [[NSMutableAttributedString alloc] initWithString:self.placeholder attributes:attrs];
    }
    
    return _attributedPlaceholder;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(UILayoutFittingCompressedSize.width, 45);
}

#pragma mark- property set

- (void)setFont:(UIFont *)font
{
    if(![_font isEqualToFont:font]){
        if(!font)
            font = [UIFont fontWithName:SeaMainFontName size:15];
        _font = font;
        _textField.font = _font;
        if(_attributedPlaceholder){
            [_attributedPlaceholder addAttribute:NSFontAttributeName value:_font range:NSMakeRange(0, _attributedPlaceholder.length)];
            [self adjustPlaceholder];
        }
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    if(![_textColor isEqualToColor:textColor]){
        if(!textColor)
            textColor = [UIColor blackColor];
        _textColor = textColor;
        _textField.textColor = _textColor;
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if(![_placeholder isEqualToString:placeholder]){
        _placeholder = [placeholder copy];
        _attributedPlaceholder = nil;
        [self adjustPlaceholder];
    }
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    if(![_placeholderTextColor isEqualToColor:placeholderTextColor]){
        if(!placeholderTextColor)
            placeholderTextColor = SeaPlaceholderTextColor;
        _placeholderTextColor = placeholderTextColor;
        
        if(_attributedPlaceholder){
            [_attributedPlaceholder addAttribute:NSForegroundColorAttributeName value:_placeholderTextColor range:NSMakeRange(0, _attributedPlaceholder.length)];
            [self adjustPlaceholder];
        }
    }
}

- (void)setIcon:(UIImage *)icon
{
    if(_icon != icon){
        _icon = icon;
        _placeholderContainer.imageView.image = _icon;
    }
}

- (void)setIconPosition:(SeaSearchBarIconPosition)iconPosition
{
    if(_iconPosition != iconPosition){
        _iconPosition = iconPosition;
        [self adjustPlaceholder];
        switch (_iconPosition) {
            case SeaSearchBarIconPositionLeft :
                [self setIconLeft:YES];
                break;
            case SeaSearchBarIconPositionCenter :
                [self setIconLeft:NO];
                break;
        }
    }
}

- (void)setContentInsets:(UIEdgeInsets)contentInsets
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_contentInsets, contentInsets)){
        _contentInsets = contentInsets;
        _contentView.sea_leftLayoutConstraint.constant = _contentInsets.left;
        _contentView.sea_topLayoutConstraint.constant = _contentInsets.top;
        _contentView.sea_bottomLayoutConstraint.constant = _contentInsets.bottom;
        
        //取消按钮显示中
        NSLayoutConstraint *constraint = self.cancelButton.sea_widthLayoutConstraint;
        if(constraint.constant > 0){
            constraint.constant = self.cancelTitleWidth + _contentInsets.right * 2;
        }else{
            self.cancelButton.sea_leftLayoutConstraint.constant = _contentInsets.right;
        }
    }
}

#pragma mark- public method

- (void)becomeFirstResponder
{
    [_textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder
{
    return [_textField resignFirstResponder];
}

- (void)setShowsCancelButton:(BOOL) show
{
    [self setShowsCancelButton:show animated:NO];
}

- (void)setShowsCancelButton:(BOOL) show animated:(BOOL) animated
{
    if(_showsCancelButton != show){
        _showsCancelButton = show;
        if(animated){
            [UIView animateWithDuration:0.25 animations:^(void){
                [self setCancelButtonHidden:!show];
                [self layoutIfNeeded];
            }];
        }else{
            [self setCancelButtonHidden:!show];
        }
    }
}

#pragma mark- event

///取消
- (void)handleCacnel:(UIButton*) btn
{
    [_textField resignFirstResponder];
}

///成为第一响应者
- (void)handleTap:(id) sender
{
    if(![_textField isFirstResponder]){
        [self becomeFirstResponder];
        self.tapGestureRecognizer.enabled = NO;
    }
}

#pragma mark- UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    switch (self.iconPosition) {
        case SeaSearchBarIconPositionCenter : {
            //把光标隐藏
            self.textField.tintColor = [UIColor clearColor];
       
            //
            [UIView animateWithDuration:0.25 animations:^(void){
                
                //把搜索图标移到左边
                [self setIconLeft:YES];
                [self layoutIfNeeded];
            }completion:^(BOOL finsih){
                
                //设置 placeholder 显示光标
                self.placeholderContainer.textLabel.text = nil;
                self.textField.placeholder = self.placeholder;
                self.textField.tintColor = UIKitTintColor;
            }];
        }
            break;
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(searchBarDidBeginEditing:)]){
        [self.delegate searchBarDidBeginEditing:self];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    ///把搜索图标放回原位
    if(textField.text.length == 0){
        switch (self.iconPosition) {
            case SeaSearchBarIconPositionCenter : {
                [self adjustPlaceholder];
                [UIView animateWithDuration:0.25 animations:^(void){
                    
                    //把搜索图标放回原位
                    [self setIconLeft:NO];
                    [self layoutIfNeeded];
                }];
            }
                break;
            default:
                break;
        }
    }
    
    self.tapGestureRecognizer.enabled = YES;
    if([self.delegate respondsToSelector:@selector(searchBarDidEndEditing:)]){
        [self.delegate searchBarDidEndEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return NO;
}

///输入框内容改变
- (void)textFieldTextDidChange:(UITextField*)textField
{
    
}

#pragma mark- private method

///调整内容
- (void)adjustPlaceholder
{
    switch (self.iconPosition) {
        case SeaSearchBarIconPositionCenter : {
            if(_textField.text.length > 0 || ([_textField isFirstResponder])){
                _placeholderContainer.textLabel.text = nil;
            }else{
                _textField.placeholder = nil;
                _placeholderContainer.textLabel.attributedText = self.attributedPlaceholder;
            }
        }
            break;
        case SeaSearchBarIconPositionLeft : {
            _placeholderContainer.textLabel.text = nil;
            _textField.attributedPlaceholder = self.attributedPlaceholder;
        }
            break;
        default:
            break;
    }
}

///设置取消按钮隐藏
- (void)setCancelButtonHidden:(BOOL) hidden
{
    if(hidden){
        self.cancelButton.sea_widthLayoutConstraint.constant = 0;
        self.cancelButton.sea_leftLayoutConstraint.constant = _contentInsets.right;
    }else{
        self.cancelButton.sea_widthLayoutConstraint.constant = self.cancelTitleWidth + _contentInsets.right * 2;
        self.cancelButton.sea_leftLayoutConstraint.constant = 0;
    }
}

///跳转icon位置
- (void)setIconLeft:(BOOL) flag
{
    if(flag){
        self.placeholderContainerCenterXConstraint.active = NO;
        self.placehonlderContainerLeftLayConstraint.active = YES;
        
    }else{
        self.placeholderContainerCenterXConstraint.active = YES;
        self.placehonlderContainerLeftLayConstraint.active = NO;
    }
}

@end