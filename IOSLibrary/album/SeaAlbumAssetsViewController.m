//
//  SeaPhotoAlbumAssetsViewController.m

//

#import "SeaAlbumAssetsViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SeaAlbumDelegate.h"
#import "SeaAlbumAssetsCell.h"
#import "SeaAlbumGroupListView.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImagePickerController+Utils.h"
#import "UIViewController+Utils.h"
#import "UIView+Utils.h"
#import "UIButton+Utils.h"
#import "UIImage+Utils.h"
#import "SeaBasic.h"
#import "UIScrollView+SeaEmptyView.h"
#import "SeaTools.h"
#import "SeaImageGenerator.h"

@interface SeaAlbumAssetsViewController ()<SeaAlbumGroupListViewDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>

//选中的图片资源信息
@property(nonatomic,strong) NSMutableArray<ALAsset*> *selectedAssetInfos;

//图片资源信息
@property(nonatomic,strong) NSMutableArray<ALAsset*> *assetInfos;

/**图片分组信息
 */
@property(nonatomic,strong) NSMutableArray<ALAssetsGroup*> *groupInfos;

/**分组视图
 */
@property(nonatomic,strong) SeaAlbumGroupListView *listView;

/**标题按钮
 */
@property(nonatomic,strong) UIButton *titleButton;

@end

@implementation SeaAlbumAssetsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.maxSelectedCount = 1;
        self.numberOfItemsPerRow = 3;
        self.gridInterval = 3.0;
    }
    
    return self;
}

/**相册资源单例，必须使用单例，否则在 ios8.0 会出现崩溃
 */
+ (ALAssetsLibrary*)sharedAssetsLibrary
{
    static dispatch_once_t once = 0;
    static ALAssetsLibrary *library = nil;
    
    //在整个app的生命周期中只执行一次
    dispatch_once(&once, ^(void){
        
        library = [[ALAssetsLibrary alloc] init];
    });
    
    return library;
}

#pragma mark- 相机

//拍照
- (void)camera
{
    if([UIImagePickerController sea_canUseCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    if([self.delegate respondsToSelector:@selector(albumDidFinishSelectImages:)]){
        [self.delegate albumDidFinishSelectImages:[NSArray arrayWithObject:image]];
    }
    
    if(self.delegate){
        [self sea_back];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark- 加载视图


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"相册";
    self.sea_showBackItem = YES;
    
    self.assetInfos = [NSMutableArray array];
    
    self.sea_showPageLoading = YES;
    
    ALAssetsLibrary *library = [SeaAlbumAssetsViewController sharedAssetsLibrary];
    
    self.groupInfos = [NSMutableArray array];

    //遍历相册资源，获取相册分组信息
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        
        //遍历完成
        if(group == nil){
            //显示图片数量最多的分组
            NSInteger count = 0;
            for(ALAssetsGroup *g in self.groupInfos){
                if(g.numberOfAssets > count){
                    self.group = g;
                    count = g.numberOfAssets;
                }
            }
            
            [self assetFromGroup];
        }else{
            [group setAssetsFilter:[ALAssetsFilter allPhotos]];
            
            //只要有图片的分组
            if(group.numberOfAssets > 0){
                [self.groupInfos addObject:group];
            }
        }
    }failureBlock:^(NSError *error){
        
        [self initialization];
    }];
}

- (void)initialization
{
    self.sea_showPageLoading = NO;
    self.selectedAssetInfos = [NSMutableArray array];

    int size = (self.view.width - self.gridInterval * (self.numberOfItemsPerRow + 1)) / self.numberOfItemsPerRow;
    self.flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowLayout.minimumInteritemSpacing = self.gridInterval;
    self.flowLayout.minimumLineSpacing = self.gridInterval;
    self.flowLayout.sectionInset = UIEdgeInsetsMake(self.gridInterval, self.gridInterval, self.gridInterval, self.gridInterval);
    self.flowLayout.itemSize = CGSizeMake(size, size);
    
    [self.collectionView registerClass:[SeaAlbumAssetsThumbnail class] forCellWithReuseIdentifier:@"cell"];
    
    [super initialization];
    
    
    if(self.groupInfos.count > 1){
        
        NSDictionary *attrs = self.navigationController.navigationBar.titleTextAttributes;
        UIColor *color = attrs[NSForegroundColorAttributeName];
        UIImage *arrow = [SeaImageGenerator triangleWithColor:color size:CGSizeMake(10, 8)];
        
        UIButton *titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        titleButton.frame = CGRectMake(0, 0, 100.0, 30.0);
        [titleButton setTitle:@"相册" forState:UIControlStateNormal];
        [titleButton setTitleColor:self.sea_iconTintColor forState:UIControlStateNormal];
        
        UIFont *font = attrs[NSFontAttributeName];
        if(![font isKindOfClass:[UIFont class]]){
            font = [UIFont systemFontOfSize:17];
        }
        
        titleButton.titleLabel.font = font;
        [titleButton setImage:arrow forState:UIControlStateNormal];
        [titleButton sea_setImagePosition:SeaButtonImagePositionRight margin:2.0];
        titleButton.adjustsImageWhenDisabled = NO;
        titleButton.tintColor = self.sea_iconTintColor;
        titleButton.adjustsImageWhenHighlighted = NO;
        
        [titleButton addTarget:self action:@selector(seeGroup:) forControlEvents:UIControlEventTouchUpInside];
        
        self.navigationItem.titleView = titleButton;
        self.titleButton = titleButton;
    }else{
        self.title = @"相册";
    }

    self.collectionView.sea_shouldShowEmptyView = YES;
    //[self setBarItemsWithTitle:@"拍照" icon:nil action:@selector(camera) position:SeaNavigationItemPositionRight];
    
    if(_assetInfos.count > 0){
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_assetInfos.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
    }
    
//    CGFloat margin = 10.0;
//    
//    UIImage *image = [UIImage imageNamed:@"camera_red_btn"];
//    //左下角拍照按钮
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
//    [button setFrame:CGRectMake(margin, self.contentHeight - margin - image.size.height , image.size.width, image.size.height)];
//    [self.view addSubview:button];
    
    if(!self.settings){
        [self sea_setRightItemWithTitle:@"使用" action:@selector(useMultiImage)];
    }
}

//从相册分组中获取照片信息
- (void)assetFromGroup
{
    if(self.group){
        NSMutableArray *infos = [NSMutableArray array];
        [self.group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
            
            if(result){
                [infos addObject:result];
            }else{
                //遍历完成
                self.assetInfos = infos;
                
                if(self.collectionView.superview){
                    [self.collectionView reloadData];
                }else{
                    [self initialization];
                }
            }
        }];
    }else{
        [self initialization];
    }
}

//查看相册分组列表
- (void)seeGroup:(UIButton*) button
{
    if(!self.listView){
        _listView = [[SeaAlbumGroupListView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.screenWidth, UIScreen.screenHeight - self.sea_statusBarHeight - self.sea_navigationBarHeight) groups:self.groupInfos];
        _listView.delegate = self;
        [self.view addSubview:_listView];
    }
    
    button.selected = !button.selected;
    _listView.show = !_listView.show;
}

///使用多张图片
- (void)useMultiImage
{
    if(self.selectedAssetInfos.count == 0){
        [self sea_alertMsg:@"请选择图片"];
        return;
    }
    
    [self useImages];
}

#pragma mark- SeaEmptyView delegate

- (void)emptyViewWillAppear:(SeaEmptyView *)view
{
    NSString *msg = nil;
    if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied){
        msg = [NSString stringWithFormat:@"无法访问您的照片，请在本机的“设置-隐私-照片”中设置,允许%@访问您的照片", appName()];
    }else{
        msg = @"暂无照片信息";
    }
    view.textLabel.text = msg;
}

#pragma mark- SeaAlbumGroupListView delegate

- (void)albumGroupListView:(SeaAlbumGroupListView *)view didSelectGroup:(ALAssetsGroup *)group
{
    self.group = group;
    [self assetFromGroup];
}

- (void)albumGroupListViewDidDismiss:(SeaAlbumGroupListView *)view
{
    self.titleButton.selected = NO;
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _assetInfos.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    SeaAlbumAssetsThumbnail *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    ALAsset *asset = [_assetInfos objectAtIndex:indexPath.row];

    cell.imageView.image = [UIImage imageWithCGImage:asset.thumbnail];
    cell.tick = [self.selectedAssetInfos containsObject:asset];
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ALAsset *asset = [self.assetInfos objectAtIndex:indexPath.row];
    
    if(self.settings){
        [self.selectedAssetInfos removeAllObjects];
        [self.selectedAssetInfos addObject:asset];
        
        [self useImages];
    }else if(self.singleSelect){
        [self.selectedAssetInfos addObject:asset];
        [self useImages];
    }else{
        if([self.selectedAssetInfos containsObject:asset]){
            [self.selectedAssetInfos removeObject:asset];
            SeaAlbumAssetsThumbnail *cell = (SeaAlbumAssetsThumbnail*)[self.collectionView cellForItemAtIndexPath:indexPath];
            cell.tick = NO;
        }else{
            if(self.maxSelectedCount == 1){
                [self.selectedAssetInfos removeAllObjects];
                [self.selectedAssetInfos addObject:asset];
                [self.collectionView reloadData];
            }else{
                if(self.selectedAssetInfos.count >= self.maxSelectedCount){
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"您最多可选择%d图片", (int)self.maxSelectedCount] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    return;
                }
                
                [self.selectedAssetInfos addObject:asset];
                SeaAlbumAssetsThumbnail *cell = (SeaAlbumAssetsThumbnail*)[self.collectionView cellForItemAtIndexPath:indexPath];
                cell.tick = YES;
            }
        }
    }
}

#pragma mark- private method

//预览图片
- (void)previewImages
{
//    SeaAlbumBrowserViewController *browser = [[SeaAlbumBrowserViewController alloc] initWithAssets:self.selectedAssetInfos];
//    browser.delegate = self.delegate;
//    [self.navigationController pushViewController:browser animated:YES];
}

- (void)setSea_showNetworkActivity:(BOOL)sea_showNetworkActivity
{
    [super setSea_showNetworkActivity:sea_showNetworkActivity];
    self.navigationItem.leftBarButtonItem.enabled = !sea_showNetworkActivity;
    self.titleButton.userInteractionEnabled = !sea_showNetworkActivity;
}

//使用图片
- (void)useImages
{
    if(self.settings){
        self.sea_showNetworkActivity = YES;
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            UIImage *image = [UIImage sea_imageFromAsset:[self.selectedAssetInfos firstObject] options:SeaAssetImageOptionsResolutionImage];
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                self.sea_showNetworkActivity = NO;
                [self cropImage:image];
            });
        });
    }else{
        BOOL flag = NO;
        if([self.delegate respondsToSelector:@selector(albumDidFinishSelectImages:)]){
            flag = YES;
        }
        
        self.sea_showNetworkActivity = YES;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            NSMutableArray *images = nil;
            if(flag){
                images = [NSMutableArray arrayWithCapacity:self.selectedAssetInfos.count];
                for(ALAsset *asset in self.selectedAssetInfos){
                    UIImage *image = [UIImage sea_imageFromAsset:asset options:SeaAssetImageOptionsResolutionImage];
                    if(image){
                        [images addObject:image];
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^(void){
                
                self.sea_showNetworkActivity = NO;
                [self.delegate albumDidFinishSelectImages:images];
                
                if([self.delegate respondsToSelector:@selector(albumDidFinishSelectAssets:)]){
                    [self.delegate albumDidFinishSelectAssets:self.selectedAssetInfos];
                }
                
                [self sea_back];
            });
        });
    }
}

///裁剪图片
- (void)cropImage:(UIImage*) image
{
    if(image){
        self.settings.image = image;
        SeaImageCropViewController *imageCrop = [[SeaImageCropViewController alloc] initWithSettings:self.settings];
        imageCrop.delegate = self.delegate;
        [self.navigationController pushViewController:imageCrop animated:YES];
    }
}


@end
