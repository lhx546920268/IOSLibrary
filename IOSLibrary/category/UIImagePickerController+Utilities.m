//
//  UIImagePickerController+Utilities.m
//  WestMailDutyFee
//
//  Created by 罗海雄 on 15/8/27.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "UIImagePickerController+Utilities.h"
#import "SeaAlertView.h"
#import <AVFoundation/AVFoundation.h>
#import "SeaBasic.h"

@implementation UIImagePickerController (Utilities)

/**是否允许拍照
 */
+ (BOOL)canUseCamera
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:@"您的手机无法拍照" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    else if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied)
    {
        NSString *msg = [NSString stringWithFormat:@"无法使用您的相机，请在本机的“设置-隐私-相机”中设置,允许%@使用您的相机", appName()];
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:[UIApplication sharedApplication].delegate cancelButtonTitle:nil otherButtonTitles:@"取消", @"去设置", nil];
        [alertView show];
        
        return NO;
    }
    
    return YES;
}

@end
