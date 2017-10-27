//
//  SeaCollectionViewAlignFlowLayout.h
//  StandardFenXiao
//
//  Created by 罗海雄 on 16/6/17.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///UICollectionViewFlowLayout item对其方式
typedef NS_ENUM(NSInteger, SeaCollectionViewItemAlignment)
{
    ///默认的
    SeaCollectionViewItemAlignmentDefault = 0,

    ///左对其
    SeaCollectionViewItemAlignmentLeft,
};

@class SeaCollectionViewFlowLayout;

///自定义流布局代理
@protocol SeaCollectionViewFlowLayoutDelegate <UICollectionViewDelegateFlowLayout>

@optional

///是否需要悬浮 只有当 sectionHeaderSuspending == YES时，这个才有效，default is 'YES'
- (BOOL)collectionViewFlowLayout:(SeaCollectionViewFlowLayout*) layout shouldSuspendHeaderForSection:(NSInteger) section;

@end

///自定义流布局
@interface SeaCollectionViewFlowLayout : UICollectionViewFlowLayout

///sectionHeader 是否需要悬浮，default is 'NO'
@property(nonatomic,assign) BOOL sectionHeaderSuspending;

///对其方式 default is 'SeaCollectionViewItemAlignmentDefault'
@property(nonatomic,assign) SeaCollectionViewItemAlignment itemAlignment;

@end
