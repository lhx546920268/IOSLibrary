//
//  SeaPhotosViewController.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/1.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaTableViewController.h"
#import "SeaPhotosOptions.h"

///相册
@interface SeaPhotosViewController : SeaTableViewController

///选项
@property(nonatomic, readonly) SeaPhotosOptions *photosOptions;

@end

