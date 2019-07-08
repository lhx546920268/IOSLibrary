//
//  SeaPhotosGridViewController.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/1.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaCollectionViewController.h"


@class SeaPhotosOptions, SeaPhotosCollection;

///相册网格列表
@interface SeaPhotosGridViewController : SeaCollectionViewController

///资源信息
@property(nonatomic, strong) SeaPhotosCollection *collection;

///选项
@property(nonatomic, strong) SeaPhotosOptions *photosOptions;

@end

