//
//  SeaPhotosGridViewController.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/1.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosGridViewController.h"
#import "SeaPhotosOptions.h"
#import "SeaPhotosGridCell.h"
#import "SeaPhotosCollection.h"
#import <Photos/Photos.h>
#import "SeaBasic.h"
#import "UIScrollView+SeaEmptyView.h"
#import "NSObject+Utils.h"
#import "SeaPhotosCheckBox.h"
#import "SeaAlertController.h"

@interface SeaPhotosGridViewController ()<PHPhotoLibraryChangeObserver, SeaPhotosGridCellDelegate>

//选中的图片唯一标识符
@property(nonatomic,strong) NSMutableArray<NSString*> *selectedAssetLocalIdentifiers;

///图片管理
@property(nonatomic, strong) PHCachingImageManager *imageManager;

///上一个预缓存的区域
@property(nonatomic, assign) CGRect previousPrecachingRect;

///停止缓存的
@property(nonatomic, strong) NSMutableArray<PHAsset*> *stopCachingAssets;

///开始缓存的
@property(nonatomic, strong) NSMutableArray<PHAsset*> *startCachingAssets;

@end

@implementation SeaPhotosGridViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateAssetCaches];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title = self.collection.title;
    self.selectedAssetLocalIdentifiers = [NSMutableArray array];
    [PHPhotoLibrary.sharedPhotoLibrary registerChangeObserver:self];
    
    [self initialization];
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
    
    CGFloat spacing = self.photosOptions.gridInterval;
    self.flowLayout.minimumLineSpacing = spacing;
    self.flowLayout.minimumInteritemSpacing = spacing;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(spacing, spacing, spacing, spacing);
    CGFloat size = floor((UIScreen.screenWidth - (self.photosOptions.numberOfItemsPerRow + 1) * spacing) / self.photosOptions.numberOfItemsPerRow);
    self.flowLayout.itemSize = CGSizeMake(size, size);
    
    [self registerClass:SeaPhotosGridCell.class];
    
    self.collectionView.sea_shouldShowEmptyView = YES;
    
    [super initialization];
}

//MARK: PHPhotoLibraryChangeObserver

- (void)photoLibraryDidChange:(PHChange *)changeInstance
{
    //相册内容改变了
    PHFetchResultChangeDetails *details = [changeInstance changeDetailsForFetchResult:self.collection.assets];
    if(details){
        self.collection.assets = details.fetchResultAfterChanges;
        [self.collectionView reloadData];
    }
}

//MARK: SeaEmptyViewDelegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    view.textLabel.text = @"暂无照片信息";
}

//MARK: caching

///更新缓存
- (void)updateAssetCaches
{
    if(self.isViewLoaded && self.view.window && self.collection.assets.count > 0){
        
        if(!self.startCachingAssets){
            self.startCachingAssets = [NSMutableArray array];
        }
        if(!self.stopCachingAssets){
            self.stopCachingAssets = [NSMutableArray array];
        }
        
        CGSize size = self.collectionView.bounds.size;
        CGRect visibleRect = {self.collectionView.contentOffset, size};
        CGRect precachingRect = CGRectInset(visibleRect, 0, - size.height / 2.0);
        
        //滑动距离太短
        if(fabs(CGRectGetMidY(precachingRect) - CGRectGetMidY(self.previousPrecachingRect)) < size.height / 3.0){
            return;
        }
        
        [self.stopCachingAssets removeAllObjects];
        [self.startCachingAssets removeAllObjects];
        
        CGRect stopCachingRect = self.previousPrecachingRect;
        CGRect startCachingRect = precachingRect;
        
        //两个区域相交，移除后面的，保留中间交叉的，添加前面的
        if(CGRectIntersectsRect(precachingRect, self.previousPrecachingRect)){
            
            if(self.previousPrecachingRect.origin.y < precachingRect.origin.y){
                //向下滑动
                stopCachingRect = CGRectMake(0, CGRectGetMinY(precachingRect), size.width, self.previousPrecachingRect.origin.y - precachingRect.origin.y);
                startCachingRect = CGRectMake(0, CGRectGetMaxY(self.previousPrecachingRect), size.width, CGRectGetMaxY(precachingRect) - CGRectGetMaxY(self.previousPrecachingRect));
            }else{
                //向上滑动
                stopCachingRect = CGRectMake(0, CGRectGetMaxY(precachingRect), size.width, CGRectGetMaxY(self.previousPrecachingRect) - CGRectGetMaxY(precachingRect));
                stopCachingRect = CGRectMake(0, CGRectGetMinY(precachingRect), size.width, self.previousPrecachingRect.origin.y - precachingRect.origin.y);
            }
        }
        
        if(stopCachingRect.size.height > 0){
            NSArray *attrs = [self.flowLayout layoutAttributesForElementsInRect:stopCachingRect];
            for(UICollectionViewLayoutAttributes *attr in attrs){
                [self.stopCachingAssets addObject:[self.collection.assets objectAtIndex:attr.indexPath.item]];
            }
        }
        
        if(startCachingRect.size.height > 0){
            NSArray *attrs = [self.flowLayout layoutAttributesForElementsInRect:startCachingRect];
            for(UICollectionViewLayoutAttributes *attr in attrs){
                [self.startCachingAssets addObject:[self.collection.assets objectAtIndex:attr.indexPath.item]];
            }
        }
        
        if(self.stopCachingAssets.count > 0){
            [self.imageManager stopCachingImagesForAssets:self.stopCachingAssets targetSize:self.flowLayout.itemSize contentMode:PHImageContentModeAspectFill options:nil];
        }
        
        if(self.startCachingAssets.count > 0){
            [self.imageManager startCachingImagesForAssets:self.startCachingAssets targetSize:self.flowLayout.itemSize contentMode:PHImageContentModeAspectFill options:nil];
        }
    }
}

//MARK: UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateAssetCaches];
}

//MARK: UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.collection.assets.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaPhotosGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SeaPhotosGridCell.sea_nameOfClass forIndexPath:indexPath];
    
    PHAsset *asset = [self.collection.assets objectAtIndex:indexPath.item];
    cell.checked = [self.selectedAssetLocalIdentifiers containsObject:asset.localIdentifier];
    if(cell.checked){
        cell.checkBox.checkedText = [NSString stringWithFormat:@"%d", (int)[self.selectedAssetLocalIdentifiers indexOfObject:asset.localIdentifier] + 1];
    }else{
        cell.checkBox.checkedText = nil;
    }
    cell.delegate = self;
    cell.assetLocalIdentifier = asset.localIdentifier;
    
    [self.imageManager requestImageForAsset:asset targetSize:self.flowLayout.itemSize contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

        if([asset.localIdentifier isEqualToString:cell.assetLocalIdentifier]){
            cell.imageView.image = result;
        }
    }];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

//MARK: SeaPhotosGridCellDelegate

- (void)photosGridCellCheckedDidChange:(SeaPhotosGridCell *)cell
{
    if(cell.checked){
        cell.checked = NO;
        [self.selectedAssetLocalIdentifiers removeObject:cell.assetLocalIdentifier];
        [self.collectionView reloadData];
    }else{
        if(self.selectedAssetLocalIdentifiers.count >= self.photosOptions.maxCount){
            
            [[SeaAlertController alertWithTitle:[NSString stringWithFormat:@"您最多能选择%d张图片", self.photosOptions.maxCount]
                                        message:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@[@"我知道了"]] show];
            
        }else{
            [self.selectedAssetLocalIdentifiers addObject:cell.assetLocalIdentifier];
            cell.checkBox.checkedText = [NSString stringWithFormat:@"%d", (int)self.selectedAssetLocalIdentifiers.count];
            [cell setChecked:YES animated:YES];
        }
    }
}

@end
