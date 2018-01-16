//
//  SeaNavigationBarTitleView.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/16.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 IOS 11.0后 导航栏的标题栏， 在ios11后 导航栏的图层结构已发生变化，使用这个可以调整标题栏大小
 */
@interface SeaNavigationBarTitleView : UIView

/**
 内容大小 default is 'UILayoutFittingExpandedSize'
 */
@property(nonatomic, assign) CGSize contentSize;

@end
