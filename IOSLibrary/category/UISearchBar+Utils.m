//
//  UISearchBar+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UISearchBar+Utils.h"

@implementation UISearchBar (Utils)

- (UITextField*)sea_searchedTextField
{
    return [self valueForKey:@"searchField"];
}

- (UIButton*)sea_searchedCancelButton
{
    return [self valueForKey:@"cancelButton"];
}

@end
