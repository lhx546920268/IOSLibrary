//
//  SeaTabBarItem.m

//

#import "SeaTabBarItem.h"
#import "SeaNumberBadge.h"
#import "SeaBasic.h"

@interface SeaTabBarItem ()

/**边缘视图
 */
@property(nonatomic,retain) SeaNumberBadge *badge;

/**图片
 */
@property(nonatomic,readonly) UIImageView *imageView;

@end

@implementation SeaTabBarItem

/**构造方法
 *@param frame 位置大小
 *@param normalImage 未选中的图片
 *@param selectedImage 选中的图片
 *@param title 标题 如果为nil，图片占满 否则标题高 18.0
 *@return 返回一个 实例
 */
- (id)initWithFrame:(CGRect) frame normalImage:(UIImage*) normalImage selectedImage:(UIImage*) selectedImage title:(NSString*) title
{
    self = [super initWithFrame:frame];
    if(self)
    {
        CGFloat imageHeight = frame.size.height;
        if(title != nil)
            imageHeight = frame.size.height - _SeaTabBarItemTextHeight_;
        
        //图标
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, imageHeight)];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.image = normalImage;
        _imageView.highlightedImage = selectedImage;
        [self addSubview:_imageView];
        
        //标题
        if(title != nil)
        {
            _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageHeight, frame.size.width, _SeaTabBarItemTextHeight_)];
            _textLabel.textAlignment = NSTextAlignmentCenter;
            _textLabel.backgroundColor = [UIColor clearColor];
            _textLabel.font = [UIFont fontWithName:SeaMainFontName size:13.0];
            _textLabel.textColor = [UIColor blackColor];
            _textLabel.text = title;
            [self addSubview:_textLabel];
        }
    }
    return self;
}

#pragma mark- dealloc

- (void)dealloc
{
   
}

#pragma mark- property

//设置边缘数值
- (void)setBadgeValue:(NSString *)badgeValue
{
    if(_badgeValue != badgeValue)
    {
        _badgeValue = badgeValue;
        
        if(!self.badge)
        {
            CGFloat x = _imageView.image.size.width + (_imageView.width - _imageView.image.size.width) / 2.0 - 20.0;
            SeaNumberBadge *badge = [[SeaNumberBadge alloc] initWithFrame:CGRectMake(x, - 5.0, _badgeViewWidth_, _badgeViewHeight_)];
            [self addSubview:badge];
            self.badge = badge;
        }
        
        if([_badgeValue isEqualToString:@""])
        {
            self.badge.point = YES;
        }
        else
        {
            self.badge.point = NO;
            self.badge.value = _badgeValue;
        }
    }
}

//设置是否选中
- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    
    self.imageView.highlighted = selected;
//    if(selected)
//    {
//        _textLabel.textColor = SeaAppMainColor;
//    }
//    else
//    {
//        _textLabel.textColor = [UIColor blackColor];
//    }
}

- (BOOL)selected
{
    return self.imageView.highlighted;
}

@end
