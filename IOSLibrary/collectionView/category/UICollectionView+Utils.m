//
//  UICollectionView+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/3/30.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UICollectionView+Utils.h"

@implementation UICollectionView (Utils)

- (void)registerNib:(Class)clazz
{
    NSString *name = NSStringFromClass(clazz);
    [self registerNib:[UINib nibWithNibName:name bundle:nil] forCellWithReuseIdentifier:name];
}

- (void)registerClass:(Class)cellClas
{
    [self registerClass:cellClas forCellWithReuseIdentifier:NSStringFromClass(cellClas)];
}

- (void)registerHeaderClass:(Class) clazz
{
    [self registerClass:clazz forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerHeaderNib:(Class) clazz
{
    NSString *name = NSStringFromClass(clazz);
    [self registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:name];
}

- (void)registerFooterClass:(Class) clazz
{
    [self registerClass:clazz forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerFooterNib:(Class) clazz
{
    NSString *name = NSStringFromClass(clazz);
    [self registerNib:[UINib nibWithNibName:name bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:name];
}


@end
