//
//  SeaCollectionViewController.h

//

#import "SeaScrollViewController.h"
#import "UICollectionView+SeaCellSize.h"

/**网格视图控制器
 */
@interface SeaCollectionViewController : SeaScrollViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

/**
 构造方法
 *@param layout 布局方式，传nil会使用默认的布局
 *@return 一个初始化的 SeaCollectionViewController 对象
 */
- (id)initWithFlowLayout:(UICollectionViewLayout*) layout;

/**
 信息列表
 */
@property(nonatomic,readonly) UICollectionView *collectionView;

/**
 布局方式 default is 'UICollectionViewFlowLayout'
 */
@property(nonatomic,strong) UICollectionViewLayout *layout;

/**
 默认流布局方式
 */
@property(nonatomic,readonly) UICollectionViewFlowLayout *flowLayout;

///注册cell
- (void)registerNib:(Class) clazz;
- (void)registerClass:(Class) clazz;

- (void)registerHeaderClass:(Class) clazz;
- (void)registerHeaderNib:(Class) clazz;

- (void)registerFooterClass:(Class) clazz;
- (void)registerFooterNib:(Class) clazz;

/// 系统的需要添加 __kindof 否则代码不会提示
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
