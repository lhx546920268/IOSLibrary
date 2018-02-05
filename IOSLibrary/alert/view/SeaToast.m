//
//  SeaToast.m

//

#import "SeaToast.h"
#import "SeaBasic.h"
#import "NSString+Utils.h"
#import "UIView+Utils.h"

@interface SeaToast()

/**信息内容
 */
@property(nonatomic,strong) UILabel *textLabel;

/**图标
 */
@property(nonatomic,strong) UIImageView *imageView;

/**黑色半透明背景视图
 */
@property(nonatomic,strong) UIView *translucentView;

@end

@implementation SeaToast

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialization];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialization];
    }
    
    return self;
}

- (void)initialization
{
    self.shouldRemoveOnDismiss = YES;
    self.userInteractionEnabled = NO;
    _verticalSpace = 5;
    _gravity = SeaToastGravityCenterVertical;
    _superEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
    _contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    _translucentView = [[UIView alloc] init];
    _translucentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    _translucentView.layer.cornerRadius = 8;
    _translucentView.layer.masksToBounds = YES;
    [self addSubview:_translucentView];
}

- (UIImageView*)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        [_translucentView addSubview:_imageView];
    }
    
    return _imageView;
}

- (UILabel*)textLabel
{
    if(!_textLabel){
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = [UIFont fontWithName:SeaMainFontName size:15.0];
        _textLabel.numberOfLines = 0;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor whiteColor];
        [_translucentView addSubview:_textLabel];
    }
    
    return _textLabel;
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_contentEdgeInsets, contentEdgeInsets)){
        _contentEdgeInsets = contentEdgeInsets;
        [self setNeedsLayout];
    }
}

- (void)setSuperEdgeInsets:(UIEdgeInsets)superEdgeInsets
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_superEdgeInsets, superEdgeInsets)){
        _superEdgeInsets = superEdgeInsets;
        [self setNeedsLayout];
    }
}

- (void)setGravity:(SeaToastGravity)gravity
{
    if(_gravity != gravity){
        _gravity = gravity;
        [self setNeedsLayout];
    }
}

- (void)setText:(NSString *)text
{
    if(![_text isEqualToString:text]){
        _text = text;
        [self setNeedsLayout];
    }
}

- (void)setIcon:(UIImage *)icon
{
    if(_icon != icon){
        _icon = icon;
        [self setNeedsLayout];
    }
}

- (void)setVerticalSpace:(CGFloat)verticalSpace
{
    if(_verticalSpace != verticalSpace){
        _verticalSpace = verticalSpace;
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews
{
    //调整位置
    CGSize textSize = CGSizeZero;
    CGSize imageSize = CGSizeZero;
    
    if(self.icon){
        self.imageView.hidden = NO;
        imageSize = self.icon.size;
        self.imageView.image = self.icon;
    }else{
        _imageView.hidden = YES;
    }
    
    CGSize maxTranslucentSize = CGSizeMake(self.width - self.superEdgeInsets.left - self.superEdgeInsets.right, self.height - self.superEdgeInsets.bottom - self.superEdgeInsets.top);
    
    if(self.text){
        self.textLabel.hidden = NO;
        self.textLabel.text = self.text;
        textSize = [self.text sea_stringSizeWithFont:self.textLabel.font contraintWith:maxTranslucentSize.width - self.contentEdgeInsets.left - self.contentEdgeInsets.right];
        textSize.height += 1;
    }else{
        _textLabel.hidden = YES;
    }
    
    CGRect frame = self.translucentView.frame;
    CGFloat contentHeight = imageSize.height + self.verticalSpace + textSize.height;
    if(!self.text || !self.icon){
        contentHeight -= self.verticalSpace;
    }
    
    frame.size.width = MIN(maxTranslucentSize.width, MAX(textSize.width, imageSize.width) + self.contentEdgeInsets.left + self.contentEdgeInsets.right);
    frame.size.height = MIN(maxTranslucentSize.height, self.contentEdgeInsets.top + self.contentEdgeInsets.bottom + contentHeight);
    frame.origin.x = (self.width - frame.size.width) / 2.0;
    switch (self.gravity) {
        case SeaToastGravityTop :
            frame.origin.y = self.superEdgeInsets.top;
            break;
        case SeaToastGravityBottom :
            frame.origin.y = self.height - frame.size.height - self.superEdgeInsets.bottom;
            break;
        case SeaToastGravityCenterVertical :
            frame.origin.y = (self.height - frame.size.height) / 2.0;
            break;
    }
    
    self.translucentView.frame = frame;
    
    if(self.icon){
        _imageView.bounds = CGRectMake(0, 0, imageSize.width, imageSize.height);
        _imageView.center = CGPointMake(self.translucentView.width / 2.0, self.contentEdgeInsets.top + imageSize.height / 2.0);
    }
    
    if(self.text){
        CGFloat height = self.translucentView.height - imageSize.height - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom;
        if(self.icon){
            height -= self.verticalSpace;
        }
        _textLabel.bounds = CGRectMake(0, 0, textSize.width, height);
        _textLabel.center = CGPointMake(self.translucentView.width / 2.0, self.translucentView.height - self.contentEdgeInsets.bottom - height / 2.0);
    }
}

// 显示提示框 2秒后消失
- (void)show
{
    [self showAndHideDelay:2.0];
}

// 隐藏
- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^(void){
       
        self.translucentView.alpha = 0;
        
    }completion:^(BOOL finish){
        if(self.shouldRemoveOnDismiss){
            [self removeFromSuperview];
        }
    }];
    !self.dismissHanlder ?: self.dismissHanlder();
}

/**显示提示框并设置多少秒后消失
 *@param delay 消失延时时间
 */
- (void)showAndHideDelay:(NSTimeInterval) delay
{
    [self canPerformAction:@selector(dismiss) withSender:self];
    self.hidden = NO;
    self.translucentView.alpha = 1.0;
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
}

- (void)dealloc
{
    [self canPerformAction:@selector(dismiss) withSender:self];
}

@end
