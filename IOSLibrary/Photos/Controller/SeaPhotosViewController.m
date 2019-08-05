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
#import "SeaPhotosListCell.h"
#import "NSObject+Utils.h"
#import "UIColor+Utils.h"
#import "SeaPhotosGridViewController.h"

@interface SeaPhotosViewController ()<PHPhotoLibraryChangeObserver>

///所有图片
@property(nonatomic, strong) PHFetchResult<PHAsset*> *allPhotos;

///智能相册
@property(nonatomic, strong) PHFetchResult<PHAssetCollection*> *smartAlbums;

///用户自定义相册
@property(nonatomic, strong) PHFetchResult<PHCollection*> *userAlbums;

///列表信息
@property(nonatomic, strong) NSMutableArray<SeaPhotosCollection*> *datas;

///相册资源获取选项
@property(nonatomic, strong) PHFetchOptions *fetchOptions;

///图片管理
@property(nonatomic, strong) PHCachingImageManager *imageManager;

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
    
    if(self.navigationController.presentingViewController){
        [self sea_setRightItemWithTitle:@"取消" action:@selector(handleCancel)];
    }
    
    self.navigationItem.title = @"相册";
    [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
    [self sea_reloadData];
}

- (void)dealloc
{
    [PHPhotoLibrary.sharedPhotoLibrary unregisterChangeObserver:self];
    [self.imageManager stopCachingImagesForAllAssets];
}

- (void)initialization
{
    self.imageManager = [PHCachingImageManager new];
    self.imageManager.allowsCachingHighQualityImages = NO;
    
    self.sea_showPageLoading = NO;
    [self registerClass:SeaPhotosListCell.class];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 70;
    self.tableView.sea_shouldShowEmptyView = YES;
    
    [super initialization];
}

//MARK: action

///取消
- (void)handleCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//MARK: PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    //相册内容改变了
    BOOL shouldRelad = NO;
    if(self.allPhotos){
        PHFetchResultChangeDetails *details = [changeInstance changeDetailsForFetchResult:self.allPhotos];
        if(details){
            self.allPhotos = details.fetchResultAfterChanges;
            shouldRelad = YES;
        }
    }
    
    PHFetchResultChangeDetails *details = [changeInstance changeDetailsForFetchResult:self.smartAlbums];
    if(details){
        self.smartAlbums = details.fetchResultAfterChanges;
        shouldRelad = YES;
    }
    
    details = [changeInstance changeDetailsForFetchResult:self.userAlbums];
    if(details){
        self.userAlbums = details.fetchResultAfterChanges;
        shouldRelad = YES;
    }
    
    if(shouldRelad){
        [self generateDatas];
    }
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
    
    WeakSelf(self)
    if([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined){
        //没有权限 先申请授权
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if(status == PHAuthorizationStatusAuthorized){
                [weakSelf loadPhotos];
            }else{
                [weakSelf initialization];
            }
        }];
    }else{
        [weakSelf loadPhotos];
    }
}

///加载相册信息
- (void)loadPhotos
{
    WeakSelf(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        if(weakSelf.photosOptions.shouldDisplayAllPhotos){
            weakSelf.allPhotos = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:self.fetchOptions];
        }
        weakSelf.smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        weakSelf.userAlbums = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf generateDatas];
        });
    });
    
}

///生成列表数据
- (void)generateDatas
{
    NSMutableArray *datas = [NSMutableArray array];
    if(self.allPhotos.count > 0){
        SeaPhotosCollection *photosCollection = [SeaPhotosCollection new];
        photosCollection.title = @"所有图片";
        photosCollection.assets = self.allPhotos;
        [datas addObject:photosCollection];
    }
    
    [self addAssetsFromColletions:self.smartAlbums withDatas:datas];
    [self addAssetsFromColletions:self.userAlbums withDatas:datas];
    
    self.datas = datas;
    if(self.isInit){
        [self.tableView reloadData];
    }else{
        [self initialization];
    }
    
    if(self.photosOptions.displayFistCollection && self.datas.count > 0){
        SeaPhotosGridViewController *vc = [SeaPhotosGridViewController new];
        vc.photosOptions = self.photosOptions;
        vc.collection = self.datas.firstObject;
        
        [self.navigationController setViewControllers:@[self, vc]];
    }
}

///添加相册资源信息
- (void)addAssetsFromColletions:(PHFetchResult*) collections withDatas:(NSMutableArray*) datas
{
    for(PHAssetCollection *collection in collections){
        if([collection isKindOfClass:PHAssetCollection.class]){
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:self.fetchOptions];
            if(result.count > 0 || self.photosOptions.shouldDisplayEmptyCollection){
                SeaPhotosCollection *photosCollection = [SeaPhotosCollection new];
                photosCollection.title = collection.localizedTitle;
                photosCollection.assets = result;
                [datas addObject:photosCollection];
            }
        }
    }
}

//MARK: UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datas.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeaPhotosListCell *cell = [tableView dequeueReusableCellWithIdentifier:SeaPhotosListCell.sea_nameOfClass forIndexPath:indexPath];
    
    SeaPhotosCollection *collection = self.datas[indexPath.row];
    cell.titleLabel.text = collection.title;
    cell.countLabel.text = [NSString stringWithFormat:@"(%d)", (int)collection.assets.count];
    
    if(collection.assets.count > 0){
        cell.thumbnailImageView.backgroundColor = UIColor.clearColor;
        cell.thumbnailImageView.image = nil;
        
        PHAsset *asset = [collection.assets objectAtIndex:0];
        cell.assetLocalIdentifier = asset.localIdentifier;
        
        [self.imageManager requestImageForAsset:asset targetSize:CGSizeMake(60, 60) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            if([asset.localIdentifier isEqualToString:cell.assetLocalIdentifier]){
                cell.thumbnailImageView.image = result;
            }
        }];
    }else{
        cell.thumbnailImageView.backgroundColor = SeaImageBackgroundColorBeforeDownload;
        cell.thumbnailImageView.image = nil;
        cell.assetLocalIdentifier = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SeaPhotosGridViewController *vc = [SeaPhotosGridViewController new];
    vc.photosOptions = self.photosOptions;
    vc.collection = self.datas[indexPath.item];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
