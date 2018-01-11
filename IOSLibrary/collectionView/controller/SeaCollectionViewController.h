//
//  SeaCollectionViewController.h

//

#import "SeaScrollViewController.h"
#import "UICollectionView+SeaCellSize.h"

/**网格视图控制器
 */
@interface SeaCollectionViewController : SeaScrollViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>

/**构造方法
 *@param layout 布局方式，传nil会使用默认的布局
 *@return 一个初始化的 SeaCollectionViewController 对象
 */
- (id)initWithFlowLayout:(UICollectionViewLayout*) layout;

/**信息列表
 */
@property(nonatomic,readonly) UICollectionView *collectionView;

/**布局方式
 */
@property(nonatomic,strong) UICollectionViewFlowLayout *layout;

///注册cell
- (void)registerNib:(Class) clazz;
- (void)registerNib:(UINib*) nib forCellReuseIdentifier:(NSString*) identifier;
- (void)registerClass:(Class) cellClas;
- (void)registerClass:(Class) cellClass forCellReuseIdentifier:(NSString*) identifier;

- (void)registerNib:(Class) clazz forSupplementaryViewOfKind:(NSString*) kind;
- (void)registerNib:(UINib*) nib forSupplementaryViewOfKind:(NSString*) kind withReuseIdentifier:(NSString*) identifier;
- (void)registerClass:(Class) cellClas forSupplementaryViewOfKind:(NSString*) kind;
- (void)registerClass:(Class) cellClass forSupplementaryViewOfKind:(NSString*) kind withReuseIdentifier:(NSString*) identifier;

/// 系统的需要添加 __kindof 否则代码不会提示
- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
