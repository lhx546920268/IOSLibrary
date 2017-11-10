//
//  SeaToast.m

//

#import "SeaToast.h"
#import "SeaBasic.h"

@interface SeaToast()

/**信息内容
 */
@property(nonatomic,readonly) UILabel *messageLabel;

@end

@implementation SeaToast

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

/**构造方法
 *@param frame 提示框大小位置
 *@return 一个初始化的 SeaAlertView
 */
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.removeFromSuperViewAfterHidden = NO;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        self.layer.cornerRadius = 8;
        self.layer.masksToBounds = YES;
    
        _superEdgeInsets = UIEdgeInsetsMake(30, 30, 120, 30);
        
        _messageLabel = [[UILabel alloc] init];
        [_messageLabel setTextAlignment:NSTextAlignmentCenter];
        _messageLabel.font = [UIFont fontWithName:SeaMainFontName size:15.0];
        _messageLabel.numberOfLines = 0;
        _messageLabel.backgroundColor = [UIColor clearColor];
        _messageLabel.textColor = [UIColor whiteColor];
        [self addSubview:_messageLabel];
        
        _messageLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        self.contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);

        _isAnimating = NO;
    }
    
    return self;
}

- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets
{
    if(!UIEdgeInsetsEqualToEdgeInsets(_contentEdgeInsets, contentEdgeInsets))
    {
        _contentEdgeInsets = contentEdgeInsets;
        [self.messageLabel sea_removeAllContraints];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_messageLabel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_messageLabel]-%f-|", _contentEdgeInsets.left, _contentEdgeInsets.right] options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_messageLabel]-%f-|", _contentEdgeInsets.top, _contentEdgeInsets.bottom] options:0 metrics:nil views:views]];
    }
}

- (void)setText:(NSString *)text
{
    if(![text isEqualToString:self.messageLabel.text])
    {
        self.messageLabel.text = text;
        [self layout];
    }
}

- (void)layout
{
    CGFloat superWidth = self.superview == nil ? SeaScreenWidth : self.superview.width;
    CGFloat superHeight = self.superview == nil ? SeaScreenHeight : self.superview.height;
    
    CGFloat width = self.superEdgeInsets.left - self.superEdgeInsets.right;
    
    CGSize size = [self.messageLabel.text stringSizeWithFont:self.messageLabel.font contraintWith:width];
    size.width += self.contentEdgeInsets.left + self.contentEdgeInsets.right + 1.0;
    size.height += self.contentEdgeInsets.top + self.contentEdgeInsets.bottom + 1.0;
    
    self.frame = CGRectMake((superWidth - size.width) / 2.0, superHeight - self.superEdgeInsets.bottom - size.height, size.width, size.height);
}

/**显示提示框并设置多少秒后消失
 *@param delay 消失延时时间
 */
- (void)showAndHideDelay:(NSTimeInterval) delay
{
    [self canPerformAction:@selector(alertViewHidden) withSender:self];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        self.hidden = NO;
        
        [self performSelector:@selector(alertViewHidden) withObject:nil afterDelay:delay];
    });
}

//提示框隐藏
- (void)alertViewHidden
{
    dispatch_async(dispatch_get_main_queue(), ^(void){
        
        _isAnimating = NO;
        self.hidden = YES;
        if(self.removeFromSuperViewAfterHidden)
        {
            [self removeFromSuperview];
        }
    });
}

@end
