//
//  SeaLoadingIndicator.m

//
//

#import "SeaLoadingIndicator.h"
#import "SeaNetworkActivityView.h"
#import "SeaBasic.h"

@interface SeaLoadingIndicator ()

@end

@implementation SeaLoadingIndicator



/**构造方法
 *@param frame 位置大小
 *@param title 加载提示标题
 *@return 一个初始化的 SeaLoadingIndicator 对象
 */
- (id)initWithFrame:(CGRect)frame title:(NSString*) title
{
    self = [super initWithFrame:frame];
    if(self)
    {
//        _actView = [[SeaNetworkActivityView alloc] initWithFrame:CGRectZero];
//        [self addSubview:_actView];
        
        self.backgroundColor = SeaViewControllerBackgroundColor;
        _loadActivityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadActivityIndicator.bounds = CGRectMake(0, 0, 30, 30);
        [self addSubview:_loadActivityIndicator];
        
        UIFont *font = [UIFont fontWithName:SeaMainFontName size:15.0];
        CGSize size = [title stringSizeWithFont:font contraintWith:frame.size.width];
        
        _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
        _textLabel.text = title;
        _textLabel.textColor = [UIColor grayColor];
        _textLabel.font = font;
        _textLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_textLabel];
        
         self.loading = YES;
        [self setNeedsLayout];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsLayout];
}

#pragma mark- dealloc

- (void)dealloc
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    [self.actView setNeedsLayout];
    
    _loadActivityIndicator.center = CGPointMake((self.width - _textLabel.width - _loadActivityIndicator.width / 2.0) / 2.0, self.height / 2.0);
    
    CGRect frame = _textLabel.frame;
    frame.origin.x = _loadActivityIndicator.right;
    frame.origin.y = (self.height - frame.size.height) / 2;
    
    _textLabel.frame = frame;
}

#pragma mark- property

- (void)setLoading:(BOOL)loading
{
    if(_loading != loading)
    {
        _loading = loading;
        if(_loading)
        {
            [self.loadActivityIndicator startAnimating];
        }
        else
        {
            [self.loadActivityIndicator stopAnimating];
        }
    }
}

- (void)setTitle:(NSString *)title
{
    _textLabel.text = title;
    CGSize size = [title stringSizeWithFont:_textLabel.font contraintWith:self.frame.size.width];
    _textLabel.width = size.width;
    [self setNeedsLayout];
}

@end
