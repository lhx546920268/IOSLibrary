//
//  SeaPhotoListViewController.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/6/27.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotoListViewController.h"
#import <Photos/Photos.h>
#import "SeaBasic.h"
#import "UIScrollView+SeaEmptyView.h"
#import "SeaTools.h"

@interface SeaPhotoListViewController ()<PHPhotoLibraryChangeObserver>

@end

@implementation SeaPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
}

- (void)dealloc
{
    [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
}

//MARK: PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    //相册内容改变了
}

//MARK: SeaEmptyViewDelegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    NSString *msg = nil;
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusDenied){
        msg = [NSString stringWithFormat:@"无法访问您的照片，请在本机的“设置-隐私-照片”中设置,允许%@访问您的照片", appName()];
    }else{
        msg = @"暂无照片信息";
    }
    view.textLabel.text = msg;
}

//MARK: load

///加载相册信息
- (void)loadPhotos
{
    PHFetchOptions *options = [PHFetchOptions new];
    options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    
    PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:options];
    
    [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:options];
}

@end
