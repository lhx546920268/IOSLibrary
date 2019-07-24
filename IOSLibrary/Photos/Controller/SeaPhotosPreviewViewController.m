//
//  SeaPhotosPreviewViewController.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/11.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import "SeaPhotosPreviewViewController.h"
#import "SeaPhotosOptions.h"
#import "SeaPhotosPreviewCell.h"
#import "SeaPhotosPreviewHeader.h"
#import "SeaPhotosToolBar.h"
#import <Photos/Photos.h>
#import "SeaContainer.h"
#import "UIViewController+Utils.h"
#import "SeaPhotosCheckBox.h"
#import "SeaBasic.h"
#import "UIView+SeaAutoLayout.h"
#import "SeaTiledImageView.h"

@interface SeaPhotosPreviewViewController ()

///头部
@property(nonatomic, strong) SeaPhotosPreviewHeader *header;

///图片管理
@property(nonatomic, strong) PHCachingImageManager *imageManager;

///上一个预缓存的中心下标
@property(nonatomic, assign) NSInteger previousPrecachingIndex;

///停止缓存的
@property(nonatomic, strong) NSMutableArray<PHAsset*> *stopCachingAssets;

///开始缓存的
@property(nonatomic, strong) NSMutableArray<PHAsset*> *startCachingAssets;

///底部工具条
@property(nonatomic, strong) SeaPhotosToolBar *photosToolBar;

@end

@implementation SeaPhotosPreviewViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateAssetCaches];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.previousPrecachingIndex = NSNotFound;
    //多选
    if(self.photosOptions.intention == SeaPhotosIntentionMultiSelection){
        self.selectedAssets = [NSMutableArray arrayWithCapacity:self.photosOptions.maxCount];
    }
    
    [self.view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap)]];
    
    [self initialization];
}

- (void)initialization
{
    self.container.safeLayoutGuide = SeaSafeLayoutGuideNone;
    
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    [self registerClass:SeaPhotosPreviewCell.class];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    [super initialization];
    
    self.header = [SeaPhotosPreviewHeader new];
    [self.header.backButton addTarget:self action:@selector(sea_back) forControlEvents:UIControlEventTouchUpInside];
    [self.header.checkBox addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleCheck)]];
    [self.view addSubview:self.header];
    
    [self.header sea_leftToSuperview];
    [self.header sea_rightToSuperview];
    [self.header sea_topToSuperview];
    [self.header sea_heightToSelf:self.sea_statusBarHeight + 44];
    
    self.photosToolBar = [SeaPhotosToolBar new];
    self.photosToolBar.backgroundColor = self.header.backgroundColor;
    self.photosToolBar.previewButton.hidden = YES;
    self.photosToolBar.divider.hidden = YES;
    [self.photosToolBar.useButton addTarget:self action:@selector(handleUse) forControlEvents:UIControlEventTouchUpInside];
    self.photosToolBar.count = (int)self.selectedAssets.count;
    [self.view addSubview:self.photosToolBar];
    
    [self.photosToolBar sea_leftToSuperview];
    [self.photosToolBar sea_rightToSuperview];
    [self.photosToolBar sea_bottomToSuperview];
    
    CGFloat bottom = 0;
    if(@available(iOS 11, *)){
        bottom = UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom;
    }
    [self.photosToolBar sea_heightToSelf:45 + bottom];
    
    [self updateTitle];
}

//MARK: action

///点击
- (void)handleTap
{
    [self setToolBarAndHeaderHidden:!self.header.hidden];
}

///设置工具条隐藏
- (void)setToolBarAndHeaderHidden:(BOOL) hidden
{
    if(!hidden){
        self.header.hidden = hidden;
        self.photosToolBar.hidden = hidden;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.header.sea_topLayoutConstraint.constant = hidden ? -self.header.frame.size.height : 0;
        self.photosToolBar.sea_bottomLayoutConstraint.constant = hidden ? -self.photosToolBar.frame.size.height : 0;
        [self.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        self.header.hidden = hidden;
        self.header.hidden = hidden;
    }];
}

//选中
- (void)handleCheck
{
    self.header.checkBox.checked = !self.header.checkBox.checked;
    PHAsset *asset = self.assets[self.selectedIndex];
    if(self.header.checkBox.checked){
        [self removeAsset:asset];
    }else{
        [self.selectedAssets addObject:asset];
    }
    self.photosToolBar.count = (int)self.selectedAssets.count;
}

///使用
- (void)handleUse
{
    [self useAssets:self.selectedAssets];
}

///使用图片
- (void)useAssets:(NSArray<PHAsset*>*) assets
{
    self.sea_showNetworkActivity = YES;
    self.sea_backImageView.userInteractionEnabled = NO;
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    WeakSelf(self)
    __block NSInteger totalCount = assets.count;
    NSMutableArray *datas = [NSMutableArray arrayWithCapacity:totalCount];
    
    for(PHAsset *selectedAsset in assets){
        [self.imageManager requestImageDataForAsset:selectedAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            totalCount --;
            if(imageData){
                [datas addObject:imageData];
            }
            if(totalCount <= 0){
                [weakSelf onImageDataLoad:datas];
            }
        }];
    }
}

///图片加载完成
- (void)onImageDataLoad:(NSArray*) datas
{
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:datas.count];
    
    WeakSelf(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for(NSData *data in datas){
            SeaPhotosPickResult *result = [SeaPhotosPickResult resultWithData:data options:self.photosOptions];
            if(result){
                [results addObject:result];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.sea_showNetworkActivity = NO;
            !weakSelf.photosOptions.completion ?: weakSelf.photosOptions.completion(results);
            [weakSelf dismissViewControllerAnimated:YES completion:nil];
        });
    });
}

//MARK: 操作

///是否选中asset
- (BOOL)containAsset:(PHAsset*) asset
{
    for(PHAsset *selectedAsset in self.selectedAssets){
        if([selectedAsset.localIdentifier isEqualToString:asset.localIdentifier]){
            return YES;
        }
    }
    
    return NO;
}

///删除某个asset
- (void)removeAsset:(PHAsset*) asset
{
    for(NSInteger i = 0;i < self.selectedAssets.count;i ++){
        PHAsset *selectedAsset = self.selectedAssets[i];
        if([selectedAsset.localIdentifier isEqualToString:asset.localIdentifier]){
            [self.selectedAssets removeObjectAtIndex:i];
            break;
        }
    }
}

///当前下标
- (NSInteger)selectedIndex
{
    return floor(self.collectionView.contentOffset.x / UIScreen.screenWidth);
}

//MARK: caching

///更新缓存
- (void)updateAssetCaches
{
    if(self.isViewLoaded && self.view.window && self.assets.count > 0){
        
        if(!self.startCachingAssets){
            self.startCachingAssets = [NSMutableArray array];
        }
        if(!self.stopCachingAssets){
            self.stopCachingAssets = [NSMutableArray array];
        }
        
        NSInteger selectedIndex = self.selectedIndex;
        
        //滑动距离太短
        if(self.previousPrecachingIndex != NSNotFound && abs((int)self.previousPrecachingIndex - (int)selectedIndex) <= 1){
            return;
        }
        
        [self.stopCachingAssets removeAllObjects];
        [self.startCachingAssets removeAllObjects];
        
        if(self.previousPrecachingIndex != NSNotFound){
            
            if(self.previousPrecachingIndex > selectedIndex){
                if(selectedIndex - 2 <= 0){
                    [self.startCachingAssets addObject:self.assets[selectedIndex - 2]];
                }
                
                if(self.previousPrecachingIndex + 2 < self.assets.count){
                    [self.stopCachingAssets addObject:self.assets[self.previousPrecachingIndex + 2]];
                }
            }else{
                if(self.previousPrecachingIndex - 2 <= 0){
                    [self.stopCachingAssets addObject:self.assets[self.previousPrecachingIndex - 2]];
                }
                
                if(selectedIndex + 2 < self.assets.count){
                    [self.startCachingAssets addObject:self.assets[selectedIndex + 2]];
                }
            }
        }else{
            for(NSInteger i = selectedIndex - 1;i >= 0 && i >= selectedIndex - 2;i --){
                [self.startCachingAssets addObject:self.assets[i]];
            }
            
            for(NSInteger i = selectedIndex + 1;i < self.assets.count && i <= selectedIndex + 2;i ++){
                [self.startCachingAssets addObject:self.assets[i]];
            }
        }
        
        
        if(self.stopCachingAssets.count > 0){
            [self.imageManager stopCachingImagesForAssets:self.stopCachingAssets targetSize:self.collectionView.frame.size contentMode:PHImageContentModeAspectFill options:nil];
        }
        
        if(self.startCachingAssets.count > 0){
            [self.imageManager startCachingImagesForAssets:self.startCachingAssets targetSize:self.collectionView.frame.size contentMode:PHImageContentModeAspectFill options:nil];
        }
        
        self.previousPrecachingIndex = selectedIndex;
    }
}

///更新标题
- (void)updateTitle
{
    self.header.titleLabel.text = [NSString stringWithFormat:@"%d/%d", (int)(self.selectedIndex + 1), (int)self.assets.count];
}

//MARK: UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self updateAssetCaches];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

//MARK: UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.assets.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frame.size;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SeaPhotosPreviewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([SeaPhotosPreviewCell class]) forIndexPath:indexPath];
    
    cell.scrollView.zoomScale = 1.0;
    cell.scrollView.contentSize = cell.bounds.size;
    
    PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
    cell.asset = asset;
    
    [self.imageManager requestImageForAsset:asset targetSize:collectionView.frame.size contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        
        if([asset.localIdentifier isEqualToString:cell.asset.localIdentifier]){
            cell.imageView.image = result;
        }
    }];
    
    return cell;
}

@end
