//
//  UICollectionView+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/3/30.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///
@interface UICollectionView (Utils)

///方便的注册 cell reuseIdentifierd都是类的名称

- (void)registerNib:(Class)clazz;
- (void)registerClass:(Class)cellClas;

- (void)registerHeaderClass:(Class) clazz;
- (void)registerHeaderNib:(Class) clazz;

- (void)registerFooterClass:(Class) clazz;
- (void)registerFooterNib:(Class) clazz;

@end
