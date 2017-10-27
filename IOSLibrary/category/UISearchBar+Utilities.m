//
//  UISearchBar+Utilities.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/10/26.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "UISearchBar+Utilities.h"

@implementation UISearchBar (Utilities)

- (UITextField*)sea_searchedTextField
{
    return [self valueForKey:@"searchField"];
}

- (UIButton*)sea_searchedCancelButton
{
    return [self valueForKey:@"cancelButton"];
}

@end
