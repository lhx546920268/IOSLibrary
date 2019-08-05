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
#import "UIImage+Utils.h"
#import "SeaAlertController.h"

@interface SeaPhotosPreviewViewController ()<SeaPhotosPreviewCellDelegate>

///头部
@property(nonatomic, strong) SeaPhotosPreviewHeader *header;

///上一个预缓存的中心下标
@property(nonatomic, assign) NSInteger previousPrecachingIndex;

///停止缓存的
@property(nonatomic, strong) NSMutableArray<PHAsset*> *stopCachingAssets;

///开始缓存的
@property(nonatomic, strong) NSMutableArray<PHAsset*> *startCachingAssets;

///底部工具条
@property(nonatomic, strong) SeaPhotosToolBar *photosToolBar;

///加载图片选项
@property(nonatomic, strong) PHImageRequestOptions *imageRequestOptions;

@end

@implementation SeaPhotosPreviewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.blackColor;
    
    PHImageRequestOptions *options = [PHImageRequestOptions new];
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    self.imageRequestOptions = options;
    
    self.previousPrecachingIndex = NSNotFound;
    
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
    self.photosToolBar.countLabel.textColor = UIColor.whiteColor;
    [self.photosToolBar.useButton setTitleColor:UIColor.whiteColor forState:UIControlStateNormal];
    [self.photosToolBar.useButton addTarget:self action:@selector(handleUse) forControlEvents:UIControlEventTouchUpInside];
    self.photosToolBar.count = (int)self.selectedAssets.count;
    [self.view addSubview:self.photosToolBar];
    
    [self.photosToolBar sea_leftToSuperview];
    [self.photosToolBar sea_rightToSuperview];
    [self.photosToolBar sea_bottomToSuperview];
    
    [self updateTitle];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    if(self.visiableIndex > 0 && self.visiableIndex < self.assets.count){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.visiableIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
        self.visiableIndex = 0;
        [self updateTitle];
    }
}

//MARK: action

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
    PHAsset *asset = self.assets[self.selectedIndex];
    if(self.header.checkBox.checked){
        self.header.checkBox.checked = NO;
        [self removeAsset:asset];
    }else{
        if(self.selectedAssets.count >= self.photosOptions.maxCount){
            
            [[SeaAlertController alertWithTitle:[NSString stringWithFormat:@"您最多能选择%d张图片", (int)self.photosOptions.maxCount]
                                        message:nil
                              cancelButtonTitle:nil
                              otherButtonTitles:@[@"我知道了"]] show];
            
        }else{
            [self.selectedAssets addObject:asset];
            self.header.checkBox.checkedText = [NSString stringWithFormat:@"%d", (int)self.selectedAssets.count];
            [self.header.checkBox setChecked:YES animated:YES];
        }
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
        [PHImageManager.defaultManager requestImageDataForAsset:selectedAsset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
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
   
            [weakSelf.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
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

///获取某个asset的下标
- (NSInteger)indexOfAsset:(PHAsset*) asset
{
    for(NSInteger i = 0;i < self.selectedAssets.count;i ++){
        PHAsset *selectedAsset = self.selectedAssets[i];
        if([selectedAsset.localIdentifier isEqualToString:asset.localIdentifier]){
            return i;
        }
    }
    
    return NSNotFound;
}

///当前下标
- (NSInteger)selectedIndex
{
    return floor(MAX(0, self.collectionView.contentOffset.x) / UIScreen.screenWidth);
}

///更新标题
- (void)updateTitle
{
    self.header.titleLabel.text = [NSString stringWithFormat:@"%d/%d", (int)(self.selectedIndex + 1), (int)self.assets.count];
    PHAsset *asset = self.assets[self.selectedIndex];
    if([self containAsset:asset]){
        self.header.checkBox.checkedText = [NSString stringWithFormat:@"%d", (int)[self indexOfAsset:asset] + 1];
        self.header.checkBox.checked = YES;
    }else{
        self.header.checkBox.checked = NO;
    }
}

//MARK: UIScrollViewDelegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate){
        [self updateTitle];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateTitle];
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
    
    cell.loading = YES;
    cell.delegate = self;
    
    PHAsset *asset = [self.assets objectAtIndex:indexPath.item];
    cell.asset = asset;
    
    CGSize size = [UIImage sea_fitImageSize:CGSizeMake(asset.pixelWidth, asset.pixelHeight) size:CGSizeMake(collectionView.frame.size.width * SeaImageScale, 0) type:SeaImageFitTypeWidth];
    [PHImageManager.defaultManager requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFit options:self.imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {

        if([asset.localIdentifier isEqualToString:cell.asset.localIdentifier]){
            [cell onLoadImage:result];
        }
    }];
    
    return cell;
}

- (void)photosPreviewCellDidClick:(SeaPhotosPreviewCell *)cell
{
    [self setToolBarAndHeaderHidden:!self.header.hidden];
}

@end
