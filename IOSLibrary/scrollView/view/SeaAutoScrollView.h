//
//  SeaAutoScrollView.h

//

#import <UIKit/UIKit.h>

@class SeaAutoScrollView;

/**自动滚动的scrollView 代理
 */
@protocol SeaAutoScrollViewDelegate <NSObject>

/** cell的数量
 */
- (NSInteger)numberOfCellsInScrollView:(SeaAutoScrollView*) scrollView;

/** cell的配置 
 *@param indexPath ios 8.3中 此值 collectionView:cellForItemAtIndexPath： 和dequeueReusableCellWithReuseIdentifier：forIndexPath: 两个必须一致，否则会造成cell消失的问题
 *@param index 数据源下标
 */
- (UICollectionViewCell*)scrollView:(SeaAutoScrollView*) scrollView cellForIndexPath:(NSIndexPath*) indexPath atIndex:(NSInteger) index;

@optional

/**点击cell
 */
- (void)scrollView:(SeaAutoScrollView *)scrollView didSelectCellAtIndex:(NSInteger)index;

@end


@interface SeaPageControl : UIPageControl


@end

/**自动滚动的scrollView 可用于广告栏
 */
@interface SeaAutoScrollView : UIView

/**滚动视图
 */
@property(nonatomic,readonly) UICollectionView *collectionView;

/**动画间隔 default is '5.0'
 */
@property(nonatomic,assign) NSTimeInterval animatedTimeInterval;

/**当前可见cell下标
 */
@property(nonatomic,assign) NSInteger visibleIndex;

/**是否可以循环滚动 default is 'YES' 1个cell时不循环
 */
@property(nonatomic,assign) BOOL enableScrollCircularly;

/**是否需要自动滚动 default is 'YES'
 */
@property(nonatomic,assign) BOOL enableAutoScroll;

/**是否显示页码 default is 'NO'
 */
@property(nonatomic,assign) BOOL showPageControl;

/**页码
 */
@property(nonatomic,readonly) SeaPageControl *pageControl;

@property(nonatomic,weak) id<SeaAutoScrollViewDelegate> delegate;

/**是否在拖动
 */
@property(nonatomic,readonly) BOOL dragging;
/**是否在减速
 */
@property(nonatomic,readonly) BOOL decelerating;

/**cell的数量
 */
@property(nonatomic,readonly) NSInteger numberOfCells;

/**重新加载数据
 */
- (void)reloadData;

/**滚动到指定的cell
 */
- (void)scrollToIndex:(NSInteger) index animated:(BOOL) flag;

/**通过下标获取 cell 如果cell是在可见范围内
 */
- (UICollectionViewCell*)cellForIndex:(NSInteger) index;

/**开始动画
 */
- (void)startAnimate;

/**停止动画
 */
- (void)stopAnimate;

@end
