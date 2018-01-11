//
//  SeaCollectionViewController.m

//

#import "SeaCollectionViewController.h"
#import "UIView+SeaEmptyView.h"

@interface SeaCollectionViewController ()


@end

@implementation SeaCollectionViewController
{
    UICollectionView *_collectionView;
}

/**构造方法
 *@param layout 布局方式，传nil会使用默认的布局
 *@return 一个初始化的 SeaCollectionViewController 对象
 */
- (id)initWithFlowLayout:(UICollectionViewFlowLayout*) layout
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        self.curPage = 1;
        if(layout == nil){
            _layout = [[UICollectionViewFlowLayout alloc] init];
            _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
            _layout.minimumInteritemSpacing = 0;
            _layout.minimumLineSpacing = 0;
        }else{
            self.layout = layout;
        }
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithFlowLayout:nil];
}


#pragma mark- public method

- (UICollectionView*)collectionView
{
    [self initCollectionView];
    return _collectionView;
}

- (void)initCollectionView
{
    if(_collectionView == nil){
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.backgroundView = nil;
        _collectionView.sea_emptyViewDelegate = self;
        self.scrollView = _collectionView;
    }
}

/**初始化视图 子类必须调用该方法
 */
- (void)initialization
{
    [self initCollectionView];
    [self.view addSubview:_collectionView];
}

- (void)registerNib:(Class)clazz
{
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(clazz) bundle:nil] forCellReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerNib:(UINib *)nib forCellReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
}

- (void)registerClass:(Class)cellClas
{
    [self registerClass:cellClas forCellReuseIdentifier:NSStringFromClass(cellClas)];
}

- (void)registerClass:(Class)cellClass forCellReuseIdentifier:(NSString *)identifier
{
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (void)registerNib:(Class) clazz forSupplementaryViewOfKind:(NSString*) kind
{
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(clazz) bundle:nil] forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(clazz)];
}

- (void)registerNib:(UINib*) nib forSupplementaryViewOfKind:(NSString*) kind withReuseIdentifier:(NSString*) identifier
{
    [self.collectionView registerNib:nib forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
}

- (void)registerClass:(Class) cellClas forSupplementaryViewOfKind:(NSString*) kind
{
    [self registerClass:cellClas forSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass(cellClas)];
}

- (void)registerClass:(Class) cellClass forSupplementaryViewOfKind:(NSString*) kind withReuseIdentifier:(NSString*) identifier
{
    [self.collectionView registerClass:cellClass forSupplementaryViewOfKind:kind withReuseIdentifier:identifier];
}

#pragma mark- UICollectionView delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];

    return cell;
}


@end
