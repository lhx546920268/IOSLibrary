//
//  SeaBadNetworkRemindView.m

//

#import "SeaBadNetworkRemindView.h"
#import "SeaBasic.h"

@interface SeaBadNetworkRemindView ()

///图标
@property(nonatomic,strong) UIImageView *imageView;

/**提示信息
 */
@property(nonatomic,strong) UILabel *messageLabel;

@end

@implementation SeaBadNetworkRemindView

/**构造方法
 *@param frame 大小位置
 *@param message 提示信息
 *@return 一个初始化的 SeaBadNetworkRemindView
 */
- (id)initWithFrame:(CGRect)frame message:(NSString*) message
{
    self = [super initWithFrame:frame];
    if(self)
    {
        if(message == nil)
            message = @"加载失败\n轻触屏幕重新加载";

        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
        UIFont *font = [UIFont fontWithName:SeaMainFontName size:15.0];

//        UIImage *image = [UIImage imageNamed:@"load_fail"];
//        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
//        [self addSubview:imageView];
//        self.imageView = imageView;

        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.font = font;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor grayColor];
        label.text = message;
        label.numberOfLines = 0;
        [self addSubview:label];
        self.messageLabel = label;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(reload:)];
        [self addGestureRecognizer:tap];

        [self sea_layoutSubviews];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];

    
    [self sea_layoutSubviews];
}

- (void)sea_layoutSubviews
{
    self.messageLabel.frame = self.bounds;
//    CGFloat margin = 10.0;
//    CGSize size = [self.messageLabel.text stringSizeWithFont:self.messageLabel.font contraintWith:self.width - margin * 2];
//    size.height += 1.0;
//
//    UIImage *image = self.imageView.image;
//    self.imageView.frame = CGRectMake((self.width - image.size.width) / 2.0, (self.height - image.size.height - margin - size.height) / 2.0, image.size.width, image.size.height);
//
//    CGFloat y = self.imageView.bottom + margin;
//    self.messageLabel.frame = CGRectMake(margin, y, self.width - margin * 2, size.height);
}

//重新加载数据
- (void)reload:(id) sender
{
    if([self.delegate respondsToSelector:@selector(badNetworkRemindViewDidReloadData:)])
    {
        [self.delegate badNetworkRemindViewDidReloadData:self];
    }
}

@end
