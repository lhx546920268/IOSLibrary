//
//  SeaCheckBox.m

//

#import "SeaCheckBox.h"
#import "SeaImageGenerator.h"
#import "SeaBasic.h"

@implementation SeaCheckBox

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
    }
    
    return self;
}

/**构造方法
 *@param frame 位置大小
 *@param normalImage 未选中图片 如果nil,则使用默认的图片
 *@param selectedImage 选中状态的图片 如果nil,则使用默认的图片
 *@return 已初始化的 SeaCheckBox
 */
- (id)initWithFrame:(CGRect)frame normalImage:(UIImage*) normalImage selectedImage:(UIImage*) selectedImage
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.normalImage = normalImage;
        self.selectedImage = selectedImage;
        [self initialization];
    }
    return self;
}

//初始化
- (void)initialization
{
    self.animateWhenSelected = YES;
    self.adjustsImageWhenDisabled = NO;
    self.adjustsImageWhenHighlighted = NO;
    
    if(self.normalImage == nil || self.selectedImage == nil)
    {
        self.normalImage = [SeaImageGenerator untickIconWithColor:[UIColor grayColor]];
        self.selectedImage = [SeaImageGenerator tickingIconWithBackgroundColor:_appMainColor_ tickColor:WMTintColor];
    }
}


#pragma mark- dealloc

- (void)dealloc
{
    
}

#pragma mark- property

- (void)setNormalImage:(UIImage *)normalImage
{
    if(_normalImage != normalImage)
    {
        _normalImage = normalImage;
        [self setImage:_normalImage forState:UIControlStateNormal];
    }
}

- (void)setSelectedImage:(UIImage *)selectedImage
{
    if(_selectedImage != selectedImage)
    {
        _selectedImage = selectedImage;
        [self setImage:_selectedImage forState:UIControlStateSelected];
    }
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
//    if(self.selected && self.superview)
//    {
//        CGSize size = self.bounds.size;
//        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"size"];
//        animation.fromValue = [NSValue valueWithCGSize:size];
//        
//        size.width += 3.0;
//        size.height += 3.0;
//        
//        animation.toValue = [NSValue valueWithCGSize:size];
//        animation.repeatCount = 2;
//        animation.duration = 0.25;
//        animation.autoreverses = YES;
//        [self.layer addAnimation:animation forKey:@"size"];
//    }
}

@end
