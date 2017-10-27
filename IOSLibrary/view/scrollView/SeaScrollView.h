//
//  SeaScrollView.h

//

#import <UIKit/UIKit.h>
#import "SeaScrollViewCell.h"

@class SeaScrollView;

/**内容可复用的scrollView代理
 */
@protocol SeaScrollViewDelegate <NSObject>

/** cell的数量
 */
- (NSInteger)numberOfCellsInScrollView:(SeaScrollView*) scrollView;

/** cell的配置 返回的cell可以有两种类型 SeaScrollViewCell 和 SeaFullImagePreviewCell
 */
- (id)scrollView:(SeaScrollView*) scrollView cellForIndex:(NSInteger) index;

@optional

/**停止拖动 停止减速
 */
- (void)scrollView:(SeaScrollView*) scrollView didEndDeceleratingAndDraggingAtIndex:(NSInteger) index;

/**点击cell
 */
- (void)scrollView:(SeaScrollView *)scrollView didSelectCellAtIndex:(NSInteger)index;

/**双击cell
 */
- (void)scrollView:(SeaScrollView *)scrollView didDoubleTapCellAtIndex:(NSInteger)index;

@end

/**内容可复用的scrollView 可循环滚动 用于一屏一页的数据
 */
@interface SeaScrollView : UIView<UIScrollViewDelegate>

/**可复用的cells，成员是 SeaScrollViewCell对象
 */
@property(nonatomic,readonly) NSMutableSet *recyleCells;

/**视图可见的cells , 成员是 SeaScrollViewCell对象
 */
@property(nonatomic,readonly) NSMutableSet *visibleCells;

/**滚动视图
 */
@property(nonatomic,readonly) UIScrollView *scrollView;

/**当前可见cell下标
 */
@property(nonatomic,assign) NSInteger visibleIndex;

/**是否可以循环滚动 default is 'NO'
 */
@property(nonatomic,assign) BOOL enableScrollCircularly;

/**是否显示页码 default is 'NO'
 */
@property(nonatomic,assign) BOOL showPageControl;

/**页码
 */
@property(nonatomic,readonly) UIPageControl *pageControl;

@property(nonatomic,weak) id<SeaScrollViewDelegate> delegate;

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

/**获取可复用的 cell
 */
- (id)dequeueRecycledCell;

/**滚动到指定的cell
 */
- (void)scrollToIndex:(NSInteger) index animated:(BOOL) flag;

/**通过下标获取 cell 如果cell是在可见范围内
 */
- (id)cellForIndex:(NSInteger) index;

@end
