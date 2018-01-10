//
//  SeaColorMacro.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/10.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#ifndef SeaColorMacro_h
#define SeaColorMacro_h

#import "SeaBasicInitialization.h"

/**
 全局颜色宏定义
 */

///视图主要背景颜色
#define SeaViewControllerBackgroundColor [SeaBasicInitialization sea_backgroundColor]

///按钮背景颜色
#define SeaButtonBackgroundColor [SeaBasicInitialization sea_buttonBackgroundColor]

///按钮标题颜色
#define SeaButtonTitleColor [SeaBasicInitialization sea_buttonTitleColor]

///不能点击按钮标题颜色
#define SeaButtonDisableTitleColor [SeaBasicInitialization sea_buttonDisableTitleColor]

///不能点击的按钮背景颜色
#define SeaButtonDisableBackgroundColor [SeaBasicInitialization sea_buttonDisableBackgroundColor]

///app主色调
#define SeaAppMainColor [SeaBasicInitialization sea_appMainColor]

///导航栏背景颜色
#define SeaNavigationBarBackgroundColor [SeaBasicInitialization sea_navigationBarColor]

///导航栏标题颜色
#define SeaNavigationBarTitleColor [SeaBasicInitialization sea_navigationBarTitleColor]

//系统默认的蓝色
#define UIKitTintColor [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0]

//图片没加载前默认背景颜色
#define SeaImageBackgroundColorBeforeDownload [UIColor colorFromHexadecimal:@"e6e6e6"]

///导航栏tintColor
#define SeaTintColor [SeaBasicInitialization sea_tintColor]

//分割线颜色
#define SeaSeparatorColor [SeaBasicInitialization sea_separatorLineColor]

#endif /* SeaColorMacro_h */
