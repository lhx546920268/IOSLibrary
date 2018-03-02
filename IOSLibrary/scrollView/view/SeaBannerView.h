//
//  SeaBannerView.h

//

#import <UIKit/UIKit.h>

@class SeaBannerView;

/**
 banner 代理
 */
@protocol SeaBannerViewDelegate <NSObject>

/**
 cell的数量
 */
- (NSInteger)numberOfCellsInBannerView:(SeaBannerView*) bannerView;

/**
 cell的配置
 *@param indexPath ios 8.3中 此值 collectionView:cellForItemAtIndexPath： 和dequeueReusableCellWithReuseIdentifier：forIndexPath: 两个必须一致，否则会造成cell消失的问题
 *@param index 数据源下标
 */
- (UICollectionViewCell*)bannerView:(SeaBannerView*) bannerView cellForIndexPath:(NSIndexPath*) indexPath atIndex:(NSInteger) index;

@optional

/**点击cell
 */
- (void)bannerView:(SeaBannerView *)scrollView didSelectCellAtIndex:(NSInteger)index;

@end


/**
 自定义页码
 */
@interface SeaPageControl : UIPageControl

/**
 点大小 default is '10'
 */
@property(nonatomic, assign) CGSize pointSize;

@end

/**
 banner
 */
@interface SeaBannerView : UIView

/**
 滚动视图
 */
@property(nonatomic,readonly) UICollectionView *collectionView;

/**
 滚动方向 default is 'UICollectionViewScrollDirectionHorizontal'
 */
@property(nonatomic,readonly) UICollectionViewScrollDirection scrollDirection;

/**
 动画间隔 default is '5.0'
 */
@property(nonatomic,assign) NSTimeInterval animatedTimeInterval;

/**
 当前可见cell下标
 */
@property(nonatomic,assign) NSInteger visibleIndex;

/**
 是否可以循环滚动 default is 'YES' 1个cell时不循环
 */
@property(nonatomic,assign) BOOL enableScrollCircularly;

/**
 是否需要自动滚动 default is 'YES'
 */
@property(nonatomic,assign) BOOL enableAutoScroll;

/**
 是否显示页码 default is 'NO'
 */
@property(nonatomic,assign) BOOL showPageControl;

/**
 页码
 */
@property(nonatomic,readonly) SeaPageControl *pageControl;

/**
 代理
 */
@property(nonatomic,weak) id<SeaBannerViewDelegate> delegate;

/**
 是否在拖动
 */
@property(nonatomic,readonly) BOOL dragging;

/**
 是否在减速
 */
@property(nonatomic,readonly) BOOL decelerating;

/**
 cell的数量
 */
@property(nonatomic,readonly) NSInteger numberOfCells;

/**
 重新加载数据
 */
- (void)reloadData;

/**
 滚动到指定的cell
 */
- (void)scrollToIndex:(NSInteger) index animated:(BOOL) flag;

/**
 通过下标获取 cell 如果cell是在可见范围内
 */
- (UICollectionViewCell*)cellForIndex:(NSInteger) index;

/**
 创建一个实例

 @param scrollDirection 滚动方向
 @return 一个实例
 */
- (instancetype)initWithScrollDirection:(UICollectionViewScrollDirection) scrollDirection;

///注册cell
- (void)registerNib:(Class) clazz;
- (void)registerNib:(UINib*) nib forCellReuseIdentifier:(NSString*) identifier;
- (void)registerClass:(Class) cellClas;
- (void)registerClass:(Class) cellClass forCellReuseIdentifier:(NSString*) identifier;

///复用cell
- (__kindof UICollectionViewCell*)dequeueReusableCellWithClass:(Class) cellClass forIndexPath:(NSIndexPath*) indexPath;
- (__kindof UICollectionViewCell*)dequeueReusableCellWithReuseIdentifier:(NSString*) identifier forIndexPath:(NSIndexPath*) indexPath;

@end
