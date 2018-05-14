//
//  SeaColorMacro.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/10.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#ifndef SeaColorMacro_h
#define SeaColorMacro_h

/**
 全局颜色宏定义
 */

///视图主要灰色背景颜色
#define SeaGrayBackgroundColor [SeaConstant grayBackgroundColor]

///按钮背景颜色
#define SeaButtonBackgroundColor [SeaConstant buttonBackgroundColor]

///按钮标题颜色
#define SeaButtonTitleColor [SeaConstant buttonTitleColor]

///不能点击按钮标题颜色
#define SeaButtonDisableTitleColor [SeaConstant buttonDisableTitleColor]

///不能点击的按钮背景颜色
#define SeaButtonDisableBackgroundColor [SeaConstant buttonDisableBackgroundColor]

///app主色调
#define SeaAppMainColor [SeaConstant appMainColor]

///app主着色
#define SeaAppMainTintColor [SeaConstant appMainTintColor]

///系统默认的蓝色
#define UIKitTintColor [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0]

///图片没加载前默认背景颜色
#define SeaImageBackgroundColorBeforeDownload [UIColor sea_colorFromHex:@"e6e6e6"]

///分割线颜色
#define SeaSeparatorColor [SeaConstant separatorColor]

///输入框 placeholder 颜色
#define SeaPlaceholderTextColor [UIColor colorWithWhite:0.702f alpha:0.7]

///web进度条颜色
#define SeaWebProgressColor [SeaConstant webProgressColor]

#endif /* SeaColorMacro_h */
