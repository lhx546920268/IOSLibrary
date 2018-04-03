//
//  SeaCollectionViewController.m

//

#import "SeaCollectionViewController.h"
#import "UIView+SeaEmptyView.h"
#import "UICollectionView+Utils.h"

@interface SeaCollectionViewController ()


@end

@implementation SeaCollectionViewController

@synthesize collectionView = _collectionView;
@synthesize flowLayout = _flowLayout;

- (id)initWithFlowLayout:(UICollectionViewFlowLayout*) layout
{
    self = [super initWithNibName:nil bundle:nil];
    if(self){
        self.curPage = 1;
        self.layout = layout;
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithFlowLayout:nil];
}


#pragma mark- public method

- (UICollectionViewFlowLayout*)flowLayout
{
    if(!_flowLayout){
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
    }
    
    return _flowLayout;
}

- (UICollectionViewLayout*)layout
{
    if(!_layout){
        return self.flowLayout;
    }
    
    return _layout;
}

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
    }
}

/**初始化视图 子类必须调用该方法
 */
- (void)initialization
{
    [super initialization];
    [self initCollectionView];
    self.scrollView = _collectionView;
}

- (void)registerNib:(Class)clazz
{
    [self.collectionView registerNib:clazz];
}


- (void)registerClass:(Class) clazz
{
    [self.collectionView registerClass:clazz];
}

- (void)registerHeaderClass:(Class) clazz
{
    [self.collectionView registerHeaderClass:clazz];
}

- (void)registerHeaderNib:(Class) clazz
{
    [self.collectionView registerHeaderNib:clazz];
}

- (void)registerFooterClass:(Class) clazz
{
    [self.collectionView registerFooterClass:clazz];
}

- (void)registerFooterNib:(Class) clazz
{
    [self.collectionView registerFooterNib:clazz];
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
