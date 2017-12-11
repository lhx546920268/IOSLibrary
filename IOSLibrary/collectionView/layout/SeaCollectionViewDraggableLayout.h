//
//  SeaCollectionViewFlowLayout.h
//  Sea
//
//  Created by 罗海雄 on 15/9/15.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import <UIKit/UIKit.h>

/**滑动重新刷新 collectionView的item位置 代理
 */
@protocol SeaCollectionViewDraggableLayoutDelegate <UICollectionViewDelegateFlowLayout>

/**移动item到某个位置，数据源要改变相应的位置
 */
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout didMoveItemAtIndexPath:(NSIndexPath*)indexPath toIndexPath:(NSIndexPath*) toIndexPath;

@optional

/**是否可移动某个item default is YES
 */
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout canMoveItemAtIndexPath:(NSIndexPath*)indexPath;

/**将要开始移动item
 */
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout willBeginMoveItemAtIndexPath:(NSIndexPath*)indexPath;

/**开始移动item
 */
- (void)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout didBeginMoveItemAtIndexPath:(NSIndexPath*)indexPath;

/**是否能从某个item移动到 另一个item deault is YES
 */
- (BOOL)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout canMoveItemAtIndexPath:(NSIndexPath*)indexPath toIndexPath:(NSIndexPath*) toIndexPath;

/**将要结束移动item
 */
- (void)collectionView:(UICollectionView *)collectionView layoutWillEndEdit:(UICollectionViewLayout*)collectionViewLayout fromIndexPath:(NSIndexPath*) fromIndexPath toIndexPath:(NSIndexPath*) toIndexPath;

/**结束移动item
 */
- (void)collectionView:(UICollectionView *)collectionView layoutDidEndEdit:(UICollectionViewLayout*)collectionViewLayout fromIndexPath:(NSIndexPath*) fromIndexPath toIndexPath:(NSIndexPath*) toIndexPath;

@end

/**可通过长按拖拽某个item collectionView的item位置，使用方法，和 UICollectionViewFlowLayout 一样使用，通过 [[SeaCollectionViewDraggableLayout alloc] init]
 */
@interface SeaCollectionViewDraggableLayout : UICollectionViewFlowLayout

/**长按手势
 */
@property(nonatomic,readonly) UILongPressGestureRecognizer *longGestureRecognizer;

/**平移手势
 */
@property(nonatomic,readonly) UIPanGestureRecognizer *panGestureRecognizer;

/**拖拽时，UICollectionView 的滚动速率 default is '8.0'
 */
@property(nonatomic,assign) CGFloat dragSpeed;

/**是否正在编辑
 */
@property(nonatomic,readonly) BOOL editing;


@end
