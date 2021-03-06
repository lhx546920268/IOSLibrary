//
//  UINavigationItem+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/19.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "UINavigationItem+Utils.h"
#import <objc/runtime.h>
#import "SeaBasic.h"
#import "UIViewController+Utils.h"

@implementation UINavigationItem (Utils)

+ (void)load
{
    if([UIDevice currentDevice].systemVersion.floatValue < 11){
        SEL selectors[] = {
            
            @selector(setLeftBarButtonItem:animated:),
            @selector(setLeftBarButtonItems:animated:),
            @selector(leftBarButtonItem),
            @selector(leftBarButtonItems),
            
            @selector(setRightBarButtonItem:animated:),
            @selector(setRightBarButtonItems:animated:),
            @selector(rightBarButtonItem),
            @selector(rightBarButtonItems)
        };
        
        int count = sizeof(selectors) / sizeof(SEL);
        for(int i = 0;i < count;i ++){
            
            SEL selector1 = selectors[i];
            SEL selector2 = NSSelectorFromString([NSString stringWithFormat:@"sea_%@", NSStringFromSelector(selector1)]);
            Method method1 = class_getInstanceMethod(self, selector1);
            Method method2 = class_getInstanceMethod(self, selector2);
            method_exchangeImplementations(method1, method2);
        }
    }
}

- (void)sea_setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem animated:(BOOL)animated
{
    if(leftBarButtonItem){
        //只有当 item是自定义item 和 图标，系统item 才需要修正
        
        UIBarButtonItem *fixedItem = [self fixedBarButtonItem];
        if(!(leftBarButtonItem.customView || leftBarButtonItem.image || [self isSystemItem:leftBarButtonItem])){
            fixedItem.width -= 8;
        }
        
        if(leftBarButtonItem.customView.tag == SeaBackItemTag){
            fixedItem.width -= SeaNavigationBarMargin;
        }
        [self sea_setLeftBarButtonItems:@[fixedItem, leftBarButtonItem] animated:animated];
    }else{
        [self sea_setLeftBarButtonItem:leftBarButtonItem animated:animated];
    }
}

- (void)sea_setLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)leftBarButtonItems animated:(BOOL)animated
{
    if(leftBarButtonItems.count > 0){
        
        UIBarButtonItem *item = [leftBarButtonItems firstObject];
        NSMutableArray *items = [NSMutableArray arrayWithArray:leftBarButtonItems];
        
        UIBarButtonItem *fixedItem = [self fixedBarButtonItem];
        
        //只有当第一个 item是自定义item 和 图标，系统item 才需要修正
        if(!(item.customView || item.image || [self isSystemItem:item])){
            fixedItem.width += 8;
        }
        
        [items insertObject:fixedItem atIndex:0];
        [self sea_setLeftBarButtonItems:items animated:animated];
    }else{
        [self sea_setLeftBarButtonItems:leftBarButtonItems animated:animated];
    }
}

- (void)sea_setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem animated:(BOOL)animated
{
    if(rightBarButtonItem){
        
        UIBarButtonItem *item = [self fixedBarButtonItem];
        
        //只有当 item是自定义item 和 图标，系统item 才需要修正
        if(!(rightBarButtonItem.customView || rightBarButtonItem.image || [self isSystemItem:rightBarButtonItem])){
            item.width += 8;
        }
        [self sea_setRightBarButtonItems:@[item, rightBarButtonItem] animated:animated];
    }else{
        [self sea_setRightBarButtonItem:rightBarButtonItem animated:animated];
    }

}

- (void)sea_setRightBarButtonItems:(NSArray<UIBarButtonItem *> *) rightBarButtonitems animated:(BOOL)animated
{
    if(rightBarButtonitems.count > 0){
        
        NSMutableArray *items = [NSMutableArray arrayWithArray:rightBarButtonitems];
        UIBarButtonItem *item = [rightBarButtonitems firstObject];
        
        UIBarButtonItem *fixedItem = [self fixedBarButtonItem];;
        //只有当第一个 item是自定义item 和 图标，系统item 才需要修正
        if(!(item.customView || item.image || [self isSystemItem:item])){
            fixedItem.width += 8;
        }
        [items insertObject:fixedItem atIndex:0];
        [self sea_setRightBarButtonItems:items animated:animated];
    }else{
        [self sea_setRightBarButtonItems:rightBarButtonitems animated:animated];
    }
}

///获取修正间距的item
- (UIBarButtonItem*)fixedBarButtonItem
{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    item.width = -(UIScreen.mainScreen.scale == 2 ? 16 : 20);
    return item;
}

///判断是否是system item
- (BOOL)isSystemItem:(UIBarButtonItem*) item
{
    return item.width == 0 && !item.image && !item.customView && !item.title;
}

#pragma mark- getter

- (UIBarButtonItem*)sea_leftBarButtonItem
{
    NSArray *items = self.leftBarButtonItems;
    if(items.count > 1){
        return [items lastObject];
    }else{
        return [self sea_leftBarButtonItem];
    }
}

- (NSArray<UIBarButtonItem*>*)sea_leftBarButtonItems
{
    NSArray *items = [self sea_leftBarButtonItems];
    if(items.count > 1){
        UIBarButtonItem *item = [items firstObject];
        if(item.width > 0){
            return [items subarrayWithRange:NSMakeRange(1, items.count - 1)];
        }
    }
    
    return items;
}

- (UIBarButtonItem*)sea_rightBarButtonItem
{
    NSArray *items = self.rightBarButtonItems;
    if(items.count > 1){
        return [items lastObject];
    }else{
        return [self sea_rightBarButtonItem];
    }
}

- (NSArray<UIBarButtonItem*>*)sea_rightBarButtonItems
{
    NSArray *items = [self sea_rightBarButtonItems];
    if(items.count > 1){
        UIBarButtonItem *item = [items firstObject];
        if(item.width > 0){
            return [items subarrayWithRange:NSMakeRange(1, items.count - 1)];
        }
    }
    
    return items;
}

@end
