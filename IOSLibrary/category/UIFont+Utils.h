//
//  UIFont+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (Utils)

/**
 把CTFont转成 uifont
 */
+ (UIFont*)sea_fontFromCTFont:(CTFontRef) ctFont;


/**
 字体是否相等
 */
- (BOOL)isEqualToFont:(UIFont*) font;


@end
