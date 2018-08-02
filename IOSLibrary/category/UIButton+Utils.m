//
//  UIButton+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UIButton+Utils.h"
#import "NSString+Utils.h"

@implementation UIButton (Utils)

- (void)sea_setImagePosition:(SeaButtonImagePosition) position margin:(CGFloat) margin
{
    if(self.contentHorizontalAlignment == UIControlContentHorizontalAlignmentFill || self.contentVerticalAlignment == UIControlContentVerticalAlignmentFill){
        return;
    }
    
    [self layoutIfNeeded];
    
    UIImage *image = self.currentImage;
    NSString *title = self.currentTitle;
    CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:self.titleLabel.font}];
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat titleWidth = size.width;
    CGFloat titleHeight = size.height;
    
    UIEdgeInsets titleInsets = UIEdgeInsetsZero;
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    if([NSString isEmpty:title] || !image){
        self.titleEdgeInsets = titleInsets;
        self.imageEdgeInsets = imageInsets;
        self.contentEdgeInsets = contentInsets;
        return;
    }
    
    switch (position) {
        case SeaButtonImagePositionLeft : {
            
            UIControlContentHorizontalAlignment contentHorizontalAlignment = self.contentHorizontalAlignment;
            
            if(@available(iOS 11.0, *)){
                if(contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeading){
                    contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                }else if (contentHorizontalAlignment == UIControlContentHorizontalAlignmentTrailing){
                    contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                }
            }
            
            switch (contentHorizontalAlignment) {
                case UIControlContentHorizontalAlignmentCenter : {
                    titleInsets.left = margin / 2;
                    titleInsets.right = - margin / 2;
                    
                    imageInsets.left = - margin / 2;
                    imageInsets.right = margin / 2;
                }
                    break;
                case UIControlContentHorizontalAlignmentLeft : {
                    titleInsets.left = margin;
                    titleInsets.right = - margin;
                }
                    break;
                case UIControlContentHorizontalAlignmentRight : {
                    imageInsets.left = - margin;
                    imageInsets.right = margin;
                }
                    break;
                default:
                    break;
            }
            
            //图标和文字 + 间隔已经超过 父视图范围了，点击事件将不触发，设置contentInset 可扩大UIButton的大小
            if(imageWidth + titleWidth + margin > self.bounds.size.width){
                switch (contentHorizontalAlignment) {
                    case UIControlContentHorizontalAlignmentCenter : {
                        contentInsets.left = margin / 2;
                        contentInsets.right = margin / 2;
                    }
                        break;
                    case UIControlContentHorizontalAlignmentLeft : {
                        contentInsets.right = margin;
                    }
                        break;
                    case UIControlContentHorizontalAlignmentRight : {
                        contentInsets.left = margin;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case SeaButtonImagePositionTop : {
            
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentCenter : {
                    titleInsets.top = (imageHeight + margin) / 2;
                    titleInsets.left = - imageWidth / 2;
                    titleInsets.bottom = - (imageHeight + margin) / 2;
                    titleInsets.right = imageWidth / 2;
                    
                    imageInsets.top = - (titleHeight + margin) / 2;
                    imageInsets.left = titleWidth / 2;
                    imageInsets.bottom = (titleHeight + margin) / 2;
                    imageInsets.right = - titleWidth / 2;
                }
                    break;
                case UIControlContentVerticalAlignmentTop : {
                    titleInsets.top = imageHeight + margin;
                    titleInsets.left = - imageWidth / 2;
                    titleInsets.bottom = - imageHeight - margin;
                    titleInsets.right = imageWidth / 2;
                    
                    imageInsets.left = titleWidth / 2;
                    imageInsets.right = - titleWidth / 2;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom : {
                    titleInsets.left = - imageWidth / 2;
                    titleInsets.right = imageWidth / 2;
                    
                    imageInsets.top = - titleHeight - margin;
                    imageInsets.left = titleWidth / 2;
                    imageInsets.bottom = titleHeight + margin;
                    imageInsets.right = - titleWidth / 2;
                }
                    break;
                default:
                    break;
            }
            
            //图标和文字 + 间隔已经超过 父视图范围了，点击事件将不触发，设置contentInset 可扩大UIButton的大小
            if(imageHeight + titleHeight + margin > self.bounds.size.height){
                switch (self.contentVerticalAlignment) {
                    case UIControlContentVerticalAlignmentCenter : {
                        int value = (imageHeight + titleHeight + margin - self.bounds.size.height) / 2.0;
                        contentInsets.top = value;
                        contentInsets.bottom = value;
                    }
                        break;
                    case UIControlContentVerticalAlignmentTop : {
                        contentInsets.bottom = imageHeight + titleHeight + margin - self.bounds.size.height;
                    }
                        break;
                    case UIControlContentVerticalAlignmentBottom : {
                        contentInsets.top = imageHeight + titleHeight + margin - self.bounds.size.height;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case SeaButtonImagePositionRight : {
            
            UIControlContentHorizontalAlignment contentHorizontalAlignment = self.contentHorizontalAlignment;
            
            if(@available(iOS 11.0, *)){
                if(contentHorizontalAlignment == UIControlContentHorizontalAlignmentLeading){
                    contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                }else if (contentHorizontalAlignment == UIControlContentHorizontalAlignmentTrailing){
                    contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
                }
            }
            
            switch (contentHorizontalAlignment) {
                case UIControlContentHorizontalAlignmentCenter : {
                    titleInsets.left = - imageWidth - margin / 2;
                    titleInsets.right = imageWidth + margin / 2;
                    
                    imageInsets.left = titleWidth + margin / 2;
                    imageInsets.right = - titleWidth - margin / 2;
                }
                    break;
                case UIControlContentHorizontalAlignmentLeft : {
                    titleInsets.left = - imageWidth;
                    titleInsets.right = imageWidth;
                    
                    imageInsets.left = titleWidth + margin;
                    imageInsets.right = - titleWidth - margin;
                }
                    break;
                case UIControlContentHorizontalAlignmentRight : {
                    titleInsets.left = - imageWidth - margin;
                    titleInsets.right = imageWidth + margin;
                    
                    imageInsets.left = titleWidth;
                    imageInsets.right = - titleWidth;
                }
                    break;
                default:
                    break;
            }
            
            //图标和文字 + 间隔已经超过 父视图范围了，点击事件将不触发，设置contentInset 可扩大UIButton的大小
            if(imageWidth + titleWidth + margin > self.bounds.size.width){
                switch (contentHorizontalAlignment) {
                    case UIControlContentHorizontalAlignmentCenter : {
                        contentInsets.left = margin / 2;
                        contentInsets.right = margin / 2;
                    }
                        break;
                    case UIControlContentHorizontalAlignmentLeft : {
                        contentInsets.right = margin;
                    }
                        break;
                    case UIControlContentHorizontalAlignmentRight : {
                        contentInsets.left = margin;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        case SeaButtonImagePositionBottom : {
            switch (self.contentVerticalAlignment) {
                case UIControlContentVerticalAlignmentCenter : {
                    titleInsets.top = - (imageHeight + margin) / 2;
                    titleInsets.left = - imageWidth / 2;
                    titleInsets.bottom = (imageHeight + margin) / 2;
                    titleInsets.right = imageWidth / 2;
                    
                    imageInsets.top = (titleHeight + margin) / 2;
                    imageInsets.left = titleWidth / 2;
                    imageInsets.bottom = - (titleHeight + margin) / 2;
                    imageInsets.right = - titleWidth / 2;
                }
                    break;
                case UIControlContentVerticalAlignmentTop : {
                    titleInsets.left = - imageWidth / 2;
                    titleInsets.right = imageWidth / 2;
                    
                    imageInsets.top = titleHeight + margin;
                    imageInsets.left = titleWidth / 2;
                    imageInsets.bottom = - titleHeight - margin;
                    imageInsets.right = - titleWidth / 2;
                }
                    break;
                case UIControlContentVerticalAlignmentBottom : {
                    titleInsets.top =  - imageHeight - margin;
                    titleInsets.left = - imageWidth / 2;
                    titleInsets.bottom = imageHeight + margin;
                    titleInsets.right = imageWidth / 2;
                    
                    imageInsets.left = titleWidth / 2;
                    imageInsets.right = - titleWidth / 2;
                }
                    break;
                default:
                    break;
            }
            
            //图标和文字 + 间隔已经超过 父视图范围了，点击事件将不触发，设置contentInset 可扩大UIButton的大小
            if(imageHeight + titleHeight + margin > self.bounds.size.height){
                switch (self.contentVerticalAlignment) {
                    case UIControlContentVerticalAlignmentCenter : {
                        int value = (imageHeight + titleHeight + margin - self.bounds.size.height) / 2.0;
                        contentInsets.top = value;
                        contentInsets.bottom = value;
                    }
                        break;
                    case UIControlContentVerticalAlignmentTop : {
                        contentInsets.bottom = imageHeight + titleHeight + margin - self.bounds.size.height;
                    }
                        break;
                    case UIControlContentVerticalAlignmentBottom : {
                        contentInsets.top = imageHeight + titleHeight + margin - self.bounds.size.height;
                    }
                        break;
                    default:
                        break;
                }
            }
        }
            break;
        default:
            break;
    }
    
    self.titleEdgeInsets = titleInsets;
    self.imageEdgeInsets = imageInsets;
    self.contentEdgeInsets = contentInsets;
}

@end
