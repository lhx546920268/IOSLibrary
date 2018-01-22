//
//  UICollectionView+SeaCellSize.h
//  IOSLibrary
//
//  Created by 罗海雄 on 17/8/23.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///在计算cell大小时，要先配置cell内容，否则无法准确计算cell大小
typedef void(^SeaCellConfiguration)(__kindof UICollectionReusableView *cell);

///cell大小
@interface UICollectionView (SeaCellSize)

/**获取cell大小
 *@param identifier cell唯一标识
 *@param indexPath cell下标
 *@return cell大小
 */
- (CGSize)sea_cellSizeForIdentifier:(NSString*) identifier indexPath:(NSIndexPath*) indexPath configuration:(SeaCellConfiguration) configuration;

/**获取cell大小
 *@param identifier cell唯一标识
 *@param indexPath cell下标
 *@param constraintSize 最大，只能设置 宽度或高度
 *@return cell大小
 */
- (CGSize)sea_cellSizeForIdentifier:(NSString*) identifier indexPath:(NSIndexPath*) indexPath constraintSize:(CGSize) constraintSize configuration:(SeaCellConfiguration) configuration;

/**获取cell大小
 *@param identifier cell唯一标识
 *@param indexPath cell下标
 *@param width cell宽度
 *@return cell大小
 */
- (CGSize)sea_cellSizeForIdentifier:(NSString*) identifier indexPath:(NSIndexPath*) indexPath width:(CGFloat) width configuration:(SeaCellConfiguration) configuration;

/**获取cell大小
 *@param identifier cell唯一标识
 *@param indexPath cell下标
 *@param height cell高度
 *@return cell大小
 */
- (CGSize)sea_cellSizeForIdentifier:(NSString*) identifier indexPath:(NSIndexPath*) indexPath height:(CGFloat) height configuration:(SeaCellConfiguration) configuration;


///头部
- (NSIndexPath*)sea_headerIndexPathForSection:(NSInteger) section;

///底部
- (NSIndexPath*)sea_footerIndexPathForSection:(NSInteger) section;

@end

