//
//  IOSLibrary.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/10/25.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#ifndef IOSLibrary_h
#define IOSLibrary_h

#pragma mark- base

///必须在other linker flags 上加 -all_load 否则类目无法使用

#import <SeaViewController.h>
#import <UIView+Utils.h>

#pragma mark- category

#import <NSObject+Utils.h>
#import <NSString+Utils.h>
#import <NSDictionary+Utils.h>
#import <UISearchBar+Utils.h>
#import <NSMutableArray+Utils.h>
#import <UIColor+Utils.h>
#import <UITextView+Utils.h>
#import <UITextField+Utils.h>
#import <UIButton+Utils.h>

#pragma mark- loading

#import <UIView+SeaLoading.h>

#pragma mark- alert

#import <UIView+SeaToast.h>
#import <UIAlertController+Utils.h>
#import <UIView+SeaToast.h>
#import <SeaAlertController.h>

#pragma mark- base

#import <SeaNavigationController.h>
#import <SeaPageViewController.h>
#import <SeaDialogViewController.h>
#import <UIViewController+Utils.h>
#import <SeaWebViewController.h>
#import <SeaTabBarController.h>

#pragma mark- empty

#import <UIView+SeaEmptyView.h>
#import <UITableView+SeaEmptyView.h>
#import <UICollectionView+SeaEmptyView.h>
#import <UIScrollView+SeaEmptyView.h>

#pragma mark- auto layout

#import <UIView+SeaAutoLayout.h>

#pragma mark- tableView

#import <UITableView+Utils.h>
#import <UITableView+SeaRowHeight.h>
#import <SeaTableViewController.h>
#import <UITableViewCell+Utils.h>

#pragma mark- collectionView

#import <UICollectionView+SeaCellSize.h>
#import <SeaCollectionViewController.h>
#import <SeaCollectionViewFlowLayout.h>
#import <UICollectionView+Utils.h>

#import <SeaBasic.h>
#import <SeaObject.h>
#import <SeaTools.h>

#pragma mark- cache

#import <UIImageView+SeaImageCache.h>
#import <SeaTiledImageView+SeaImageCache.h>
#import <UIButton+SeaImageCache.h>
#import <SeaUserDefaults.h>

#import <SeaPresentTransitionDelegate.h>
#import <SeaPartialPresentTransitionDelegate.h>

#import <UIImage+Utils.h>
#import <SeaTiledImageView.h>

#pragma mark- http

#import <SeaMultiTasks.h>

#endif /* IOSLibrary_h */
