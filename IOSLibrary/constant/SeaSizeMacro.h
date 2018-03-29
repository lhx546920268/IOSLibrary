//
//  SeaSizeMacro.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/10.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#ifndef SeaSizeMacro_h
#define SeaSizeMacro_h

/**
 全局尺寸宏定义
 */

///大小自适应
static const CGFloat SeaWrapContent = -1;

//选项卡高度
static const CGFloat SeaTabBarHeight = 49.0;

//状态栏高度
static const CGFloat SeaStatusHeight = 20.0;

//工具条高度
static const CGFloat SeaToolBarHeight = 44.0;

///分割线高度
#define SeaSeparatorWidth [SeaConstant separatorWidth]

///手机屏幕的宽度
#define SeaScreenWidth MIN([UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)

///手机屏幕的高度
#define SeaScreenHeight MAX([UIScreen mainScreen].bounds.size.height,[UIScreen mainScreen].bounds.size.width)

#endif /* SeaSizeMacro_h */
