//
//  SeaImageTitleMenuItem.m

//

#import "SeaImageTitleMenuItem.h"
#import "SeaBasic.h"

#define _titleHeight_ 25.0

@implementation SeaImageTitleMenuItem

/**构造方法
 *@param image 正常显示的图片
 *@param title 标题
 *@param insets 边距
 *@return 一个初始化的 SeaImageTitleMenuItem 对象
 */
- (id)initWithFrame:(CGRect)frame image:(UIImage*) image title:(NSString*) title insets:(UIEdgeInsets) insets
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat y = insets.top;
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = YES;
        self.normalImage = image;
        self.selected = NO;
        
        _imageView = [[UIImageView alloc] initWithImage:image];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.frame = CGRectMake(insets.left, y, frame.size.width - insets.left - insets.right, image.size.height);
        [self addSubview:_imageView];
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(insets.left, _imageView.bottom, frame.size.width - insets.left - insets.right, _titleHeight_)];
        _titleLabel.text = title;
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        _titleLabel.userInteractionEnabled = YES;
        [self addSubview:_titleLabel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected
{
    if(_selected != selected)
    {
        _selected = selected;
        if(self.selectedImage)
        {
            _imageView.image = _selected ? self.selectedImage : self.normalImage;
        }
    }
}

@end
