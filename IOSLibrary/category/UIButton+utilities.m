//
//  UIButton+utilities.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/30.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "UIButton+utilities.h"
#import "SeaBasic.h"

@implementation UIButton (utilities)

/**设置按钮的图片位于文本右边
 *@param interval 按钮与标题的间隔
 */
- (void)setButtonIconToRightWithInterval:(CGFloat) interval
{
    [self layoutIfNeeded];
    
    UIImage *image = self.currentImage;

    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, - image.size.width, 0, image.size.width)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, self.titleLabel.width + interval, 0, - (self.titleLabel.width + interval))];
}

/**设置按钮的图片位于标题上方
 *@param interval 按钮与标题的间隔
 */
- (void)setButtonIconToTopAndTitleBottomWithInterval:(CGFloat) interval
{
    [self layoutIfNeeded];
    
    UIImage *image = self.currentImage;
    CGFloat contentHeight = image.size.height + self.titleLabel.height + interval;
    CGFloat contentWidth = self.titleLabel.width + image.size.width;
    
    UIControlContentHorizontalAlignment aligment = self.contentHorizontalAlignment;
    
    if (@available(iOS 11.0, *)) {
        if(aligment == UIControlContentHorizontalAlignmentLeading){
            aligment = UIControlContentHorizontalAlignmentLeft;
        }else if (aligment == UIControlContentHorizontalAlignmentTrailing){
            aligment = UIControlContentHorizontalAlignmentRight;
        }
    }
    
    switch (aligment)
    {
        case UIControlContentHorizontalAlignmentLeft :
        {
            [self setTitleEdgeInsets:UIEdgeInsetsMake(contentHeight / 2.0, - ((self.width - self.titleLabel.width + image.size.width) / 2.0 - (self.width - contentWidth) / 2.0), 0, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, (self.width - image.size.width) / 2.0 - (self.width - contentWidth) / 2.0, contentHeight / 2.0, 0)];
        }
            break;
        case UIControlContentHorizontalAlignmentCenter :
        case UIControlContentHorizontalAlignmentFill :
        {
            [self setTitleEdgeInsets:UIEdgeInsetsMake(image.size.height + interval, - ((self.width - self.titleLabel.width + image.size.width) / 2.0 - (self.width - contentWidth) / 2.0), 0, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, (self.width - image.size.width) / 2.0 - (self.width - contentWidth) / 2.0, image.size.height / 2.0, -((self.width - image.size.width) / 2.0 - (self.width - contentWidth) / 2.0))];
        }
            break;
        case UIControlContentHorizontalAlignmentRight :
        {
            [self setTitleEdgeInsets:UIEdgeInsetsMake(contentHeight / 2.0, - ((self.width - self.titleLabel.width + image.size.width) / 2.0 - (self.width - contentWidth) / 2.0), 0, 0)];
            [self setImageEdgeInsets:UIEdgeInsetsMake(0, (self.width - image.size.width) / 2.0 - (self.width - contentWidth) / 2.0, contentHeight / 2.0, 0)];
        }
            break;
            default:
            break;
    }
    //    [self setTitleEdgeInsets:UIEdgeInsetsMake(- image.size.height / 2.0, - image.size.width, - image.size.height / 2.0, image.size.width)];
    //    [self setImageEdgeInsets:UIEdgeInsetsMake(- (self.titleLabel.height + interval) + image.size.width / 2.0, 0, self.titleLabel.width + interval, 0)];
}


@end
