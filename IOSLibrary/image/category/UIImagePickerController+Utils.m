//
//  UIImagePickerController+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UIImagePickerController+Utils.h"
#import <AVFoundation/AVFoundation.h>
#import "UIAlertController+Utils.h"
#import "SeaTools.h"

@implementation UIImagePickerController (Utils)

+ (BOOL)sea_canUseCamera
{
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]){
        [UIAlertController sea_alertWithTitle:@"" message:@"您的手机无法拍照" buttonTitles:@"确定", nil];
        return NO;
    }else if ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] == AVAuthorizationStatusDenied){
        NSString *msg = [NSString stringWithFormat:@"无法使用您的相机，请在本机的“设置-隐私-相机”中设置,允许%@使用您的相机", appName()];
        
        
        [UIAlertController sea_alertWithTitle:nil message:msg handler:^(int index){
            switch (index) {
                case 1 :
                    openSystemSettings();
                    break;
                    
                default:
                    break;
            }
        } buttonTitles:@"取消",  @"去设置", nil];
        
        return NO;
    }
    
    return YES;
}

@end
