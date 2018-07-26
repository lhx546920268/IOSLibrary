//
//  SeaToast.m

//

#import "SeaToast.h"
#import "SeaBasic.h"
#import "NSString+Utils.h"
#import "UIView+Utils.h"

@implementation SeaToastStyle

- (instancetype)init
{
    self = [super init];
    if(self){
        
        _duration = 1.5;
        _verticalSpace = 5;
        _gravity = SeaToastGravityVertical;
        _superEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30);
        _contentEdgeInsets = UIEdgeInsetsMake(20, 20, 20, 20);
        _minimumSize = CGSizeMake(80, 20);
        _font = [UIFont fontWithName:SeaMainFontName size:15.0];
        _textColor = [UIColor whiteColor];
        _backgroundColor = [UIColor colorWithWhite:0 alpha:0.75];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static SeaToastStyle *style = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        style = [SeaToastStyle new];
    });
    
    return style;
}


@end

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
}

- (UIView*)translucentView
{
    if(!_translucentView){
        _translucentView = [[UIView alloc] init];
        _translucentView.backgroundColor = self.style.backgroundColor;
        _translucentView.layer.cornerRadius = 8;
        _translucentView.layer.masksToBounds = YES;
        [self addSubview:_translucentView];
    }
    
    return _translucentView;
}

- (UIImageView*)imageView
{
    if(!_imageView){
        _imageView = [[UIImageView alloc] init];
        [self.translucentView addSubview:_imageView];
    }
    
    return _imageView;
}

- (UILabel*)textLabel
{
    if(!_textLabel){
        _textLabel = [[UILabel alloc] init];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.font = self.style.font;
        _textLabel.numberOfLines = 0;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = self.style.textColor;
        [self.translucentView addSubview:_textLabel];
    }
    
    return _textLabel;
}

- (SeaToastStyle*)style
{
    if(!_style){
        return [SeaToastStyle sharedInstance];
    }
    return _style;
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
    
    SeaToastStyle *style = self.style;
    CGSize maxTranslucentSize = CGSizeMake(self.width - style.superEdgeInsets.left - style.superEdgeInsets.right, self.height - style.superEdgeInsets.bottom - style.superEdgeInsets.top);
    
    if(self.text){
        self.textLabel.hidden = NO;
        self.textLabel.text = self.text;
        textSize = [self.text sea_stringSizeWithFont:self.textLabel.font contraintWith:maxTranslucentSize.width - style.contentEdgeInsets.left - style.contentEdgeInsets.right];
        textSize.height += 1;
    }else{
        _textLabel.hidden = YES;
    }
    
    CGRect frame = self.translucentView.frame;
    CGFloat contentHeight = imageSize.height + style.verticalSpace + textSize.height;
    if(!self.text || !self.icon){
        contentHeight -= style.verticalSpace;
    }
    
    CGFloat width = MAX(textSize.width, imageSize.width);
    CGFloat height = contentHeight;
    if(width < style.minimumSize.width){
        width = style.minimumSize.width;
    }
    
    if(height < style.minimumSize.height){
        height = style.minimumSize.height;
    }
    
    frame.size.width = MIN(maxTranslucentSize.width, width + style.contentEdgeInsets.left + style.contentEdgeInsets.right);
    frame.size.height = MIN(maxTranslucentSize.height, style.contentEdgeInsets.top + style.contentEdgeInsets.bottom + height);
    
    frame.origin.x = (self.width - frame.size.width) / 2.0;
    switch (style.gravity) {
        case SeaToastGravityTop :
            frame.origin.y = style.superEdgeInsets.top;
            break;
        case SeaToastGravityBottom :
            frame.origin.y = self.height - frame.size.height - style.superEdgeInsets.bottom;
            break;
        case SeaToastGravityVertical :
            frame.origin.y = (self.height - frame.size.height) / 2.0;
            break;
    }
    frame.origin.y += style.offset;
    
    self.translucentView.frame = frame;
    
    contentHeight = imageSize.height;
    if(self.icon && self.text){
        contentHeight += style.verticalSpace;
    }
    contentHeight += textSize.height;
    
    if(self.icon){
        _imageView.frame = CGRectMake((self.translucentView.width - imageSize.width) / 2.0, (self.translucentView.height - contentHeight) / 2.0, imageSize.width, imageSize.height);
    }
    
    if(self.text){
        CGFloat height = self.translucentView.height - imageSize.height - style.contentEdgeInsets.top - style.contentEdgeInsets.bottom;
        if(self.icon){
            height -= style.verticalSpace;
        }
        _textLabel.bounds = CGRectMake(0, 0, textSize.width, height);
        _textLabel.center = CGPointMake(self.translucentView.width / 2.0, self.translucentView.height - style.contentEdgeInsets.bottom - height / 2.0);
    }
}

- (void)show
{
    [self showAndHideDelay:self.style.duration];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^(void){
       
        self.translucentView.alpha = 0;
        
    }completion:^(BOOL finish){
        self.hidden = YES;
        if(self.shouldRemoveOnDismiss){
            [self removeFromSuperview];
        }
        !self.dismissHanlder ?: self.dismissHanlder();
    }];
}

- (void)showAndHideDelay:(NSTimeInterval) delay
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
    self.hidden = NO;
    self.translucentView.alpha = 1.0;
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
}

- (void)dealloc
{
    [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:nil];
}

@end
