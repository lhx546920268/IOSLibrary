//
//  SeaPhotosViewController.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/1.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosViewController.h"
#import <Photos/Photos.h>
#import "SeaBasic.h"
#import "UIScrollView+SeaEmptyView.h"
#import "SeaTools.h"
#import "UIViewController+Utils.h"
#import "SeaPhotosCollection.h"

@interface SeaPhotosViewController ()<PHPhotoLibraryChangeObserver>

///所有图片
@property(nonatomic, strong) PHFetchResult<PHAsset*> *allPhotos;

///智能相册
@property(nonatomic, strong) PHFetchResult<PHAssetCollection*> *smartAlbums;

///用户自定义相册
@property(nonatomic, strong) PHFetchResult<PHCollection*> *userAlbums;

///列表信息
@property(nonatomic, strong) NSArray<SeaPhotosCollection*> *datas;

///相册资源获取选项
@property(nonatomic, strong) PHFetchOptions *fetchOptions;

@end

@implementation SeaPhotosViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self){
        _photosOptions = [SeaPhotosOptions new];
        _fetchOptions = [PHFetchOptions new];
        _fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
}

- (void)dealloc
{
    [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
}

- (void)initialization
{
    
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

- (void)sea_reloadData
{
    [super sea_reloadData];
    self.sea_showPageLoading = YES;
    [self loadPhotos];
}

///加载相册信息
- (void)loadPhotos
{
    self.allPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:self.fetchOptions];
    self.smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:self.fetchOptions];
    self.userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
    
    [self generateDatas];
}

///生成列表数据
- (void)generateDatas
{
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:1 + self.smartAlbums.count + self.userAlbums.count];
    SeaPhotosCollection *photosCollection = [SeaPhotosCollection new];
    photosCollection.title = @"所有图片";
    photosCollection.assets = self.allPhotos;
    [datas addObject:photosCollection];
    
    [self addAssetsFromColletions:self.smartAlbums withDatas:datas];
    [self addAssetsFromColletions:self.userAlbums withDatas:datas];
    
    self.datas = datas;
    if(self.isInit){
        [self.tableView reloadData];
    }else{
        [self initialization];
    }
}

///添加相册资源信息
- (void)addAssetsFromColletions:(NSArray<PHCollection*>*) collections withDatas:(NSMutableArray*) datas
{
    for(PHCollection *collection in collections){
        SeaPhotosCollection *photosCollection = [SeaPhotosCollection new];
        photosCollection.title = collection.localizedTitle;
        photosCollection.assets = [PHAsset fetchAssetsInAssetCollection:collection options:self.fetchOptions];
        [datas addObject:photosCollection];
    }
}

@end
