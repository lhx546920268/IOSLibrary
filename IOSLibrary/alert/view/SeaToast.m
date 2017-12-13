//
//  SeaToast.m

//

#import "SeaToast.h"
#import "SeaBasic.h"
#import "UIView+SeaAutoLayout.h"

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
    _gravity = SeaToastGravityCenterVertical;
    _superEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
    _contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
    
    _translucentView = [[UIView alloc] init];
    _translucentView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    _translucentView.layer.cornerRadius = 8;
    _translucentView.layer.masksToBounds = YES;
    [self addSubview:_translucentView];
    
    _imageView = [[UIImageView alloc] init];
    [self addSubview:_imageView];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = [UIFont fontWithName:SeaMainFontName size:15.0];
    _textLabel.numberOfLines = 0;
    _textLabel.backgroundColor = [UIColor clearColor];
    _textLabel.textColor = [UIColor whiteColor];
    [self addSubview:_textLabel];
    
    [_translucentView sea_leftToItem:_translucentView.superview margin:_superEdgeInsets.left relation:NSLayoutRelationGreaterThanOrEqual];
    [_translucentView sea_rightToItem:_translucentView.superview margin:_superEdgeInsets.right relation:NSLayoutRelationGreaterThanOrEqual];
    [_translucentView sea_bottomToItem:_translucentView.superview margin:_superEdgeInsets.bottom relation:NSLayoutRelationGreaterThanOrEqual];
    [_translucentView sea_topToItem:_translucentView.superview margin:_superEdgeInsets.top relation:NSLayoutRelationGreaterThanOrEqual];
    [_translucentView sea_centerInSuperview];
    
    [_imageView sea_centerXInSuperview];
    [_imageView sea_topToSuperview:_contentEdgeInsets.top];
    [_imageView sea_leftToItem:_imageView.superview margin:_contentEdgeInsets.left relation:NSLayoutRelationGreaterThanOrEqual];
    [_imageView sea_rightToItemLeft:_imageView.superview margin:_contentEdgeInsets.right relation:NSLayoutRelationGreaterThanOrEqual];
    
    [_textLabel sea_leftToItem:_textLabel.superview margin:_contentEdgeInsets.left relation:NSLayoutRelationGreaterThanOrEqual];
    [_textLabel sea_rightToSuperview:_contentEdgeInsets.right];
    [_textLabel sea_topToItemBottom:_imageView margin:0];
    [_textLabel sea_bottomToSuperview:_contentEdgeInsets.bottom];
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_contentEdgeInsets, contentEdgeInsets)){
        _contentEdgeInsets = contentEdgeInsets;
        
        _imageView.sea_topLayoutConstraint.constant = _contentEdgeInsets.top;
        _imageView.sea_leftLayoutConstraint.constant = _contentEdgeInsets.left;
        _imageView.sea_rightLayoutConstraint.constant = _contentEdgeInsets.right;
        
        _textLabel.sea_leftLayoutConstraint.constant = _contentEdgeInsets.left;
        _textLabel.sea_rightLayoutConstraint.constant = _contentEdgeInsets.right;
        _textLabel.sea_bottomLayoutConstraint.constant = _contentEdgeInsets.bottom;
    }
}

- (void)setSuperEdgeInsets:(UIEdgeInsets)superEdgeInsets
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_superEdgeInsets, superEdgeInsets)){
        _superEdgeInsets = superEdgeInsets;
        _translucentView.sea_leftLayoutConstraint.constant = _superEdgeInsets.left;
        _translucentView.sea_rightLayoutConstraint.constant = _superEdgeInsets.right;
        _translucentView.sea_topLayoutConstraint.constant = _superEdgeInsets.top;
        _translucentView.sea_bottomLayoutConstraint.constant = _superEdgeInsets.bottom;
    }
}

- (void)setGravity:(SeaToastGravity)gravity
{
    if(_gravity != gravity){
        _gravity = gravity;
        
        switch (_gravity) {
            case SeaToastGravityTop :

                [self removeConstraint:_translucentView.sea_topLayoutConstraint];
                [self removeConstraint:_translucentView.sea_bottomLayoutConstraint];
                [self removeConstraint:_translucentView.sea_centerYLayoutConstraint];
                [_translucentView sea_topToSuperview:_superEdgeInsets.top];
                break;
            case SeaToastGravityBottom :
                [self removeConstraint:_translucentView.sea_topLayoutConstraint];
                [self removeConstraint:_translucentView.sea_bottomLayoutConstraint];
                [self removeConstraint:_translucentView.sea_centerYLayoutConstraint];
                [_translucentView sea_bottomToSuperview:_superEdgeInsets.bottom];
                break;
            case SeaToastGravityCenterVertical :
                [self removeConstraint:_translucentView.sea_topLayoutConstraint];
                [self removeConstraint:_translucentView.sea_bottomLayoutConstraint];
                [_translucentView sea_centerYInSuperview];
                [_translucentView sea_topToItem:_translucentView.superview margin:_superEdgeInsets.top relation:NSLayoutRelationGreaterThanOrEqual];
                [_translucentView sea_bottomToItem:_translucentView.superview margin:_superEdgeInsets.bottom relation:NSLayoutRelationGreaterThanOrEqual];
                break;
            default:
                break;
        }
    }
}

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
}

// 显示提示框 2秒后消失
- (void)show
{
    [self showAndHideDelay:2.0];
}

// 隐藏
- (void)dismiss
{
    self.hidden = YES;
    if(self.shouldRemoveOnDismiss){
        [self removeFromSuperview];
    }
    !self.dismissHanlder ?: self.dismissHanlder();
}

/**显示提示框并设置多少秒后消失
 *@param delay 消失延时时间
 */
- (void)showAndHideDelay:(NSTimeInterval) delay
{
    [self canPerformAction:@selector(dismiss) withSender:self];
    self.hidden = NO;
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
}

- (void)dealloc
{
    [self canPerformAction:@selector(dismiss) withSender:self];
}

@end
