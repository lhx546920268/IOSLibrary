//
//  UIButton+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/2.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UIButton 图标位置
 */
typedef NS_ENUM(NSInteger, SeaButtonImagePosition){
    
    ///左边 系统默认
    SeaButtonImagePositionLeft = 0,
    
    ///图标在文字右边
    SeaButtonImagePositionRight,
    
    ///图标在文字顶部
    SeaButtonImagePositionTop,
    
    ///图标在文字底部
    SeaButtonImagePositionBottom,
};

@interface UIButton (Utils)

/**
 设置按钮图标位置 将改变 imageEdgeInsets titleEdgeInsets contentEdgeInsets，如果要设置对应的值，需要在调用该方法后设置 如果 title或者image为空 将全部设置0
 
 @param position 图标位置
 @param margin 图标和文字间隔
 @warning UIControlContentHorizontalAlignmentFill 和 UIControlContentVerticalAlignmentFill 将忽略
 */
- (void)sea_setImagePosition:(SeaButtonImagePosition) position margin:(CGFloat) margin;

@end
