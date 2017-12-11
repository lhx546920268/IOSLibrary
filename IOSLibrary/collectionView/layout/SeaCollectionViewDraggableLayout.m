//
//  SeaCollectionViewDraggableLayout.m
//  Sea
//
//  Created by 罗海雄 on 15/9/15.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import "SeaCollectionViewDraggableLayout.h"
#import "UIImage+Utilities.h"
#import "UIView+Utils.h"

///拖拽方向
typedef NS_ENUM(NSInteger, SeaCollectionViewDraggableLayoutDragDirection)
{
    ///上
    SeaCollectionViewDraggableLayoutDragDirectionTop,

    ///下
    SeaCollectionViewDraggableLayoutDragDirectionBottom,

    ///左
    SeaCollectionViewDraggableLayoutDragDirectionLeft,

    ///右
    SeaCollectionViewDraggableLayoutDragDirectionRight,
};

@interface SeaCollectionViewDraggableLayout ()<UIGestureRecognizerDelegate>

/**要移动的item
 */
@property(nonatomic,strong) NSIndexPath *selectedItem;

/**起始位置
 */
@property(nonatomic,strong) NSIndexPath *fromItem;

/**目标位置
 */
@property(nonatomic,strong) NSIndexPath *toItem;

/**模拟一个移动的视图，通过把选中的item生成图片
 */
@property(nonatomic,strong) UIImageView *simulationView;

/**自动滚动计时器
 */
@property(nonatomic,strong) NSTimer *scrollingTimer;

/**拖拽的起点
 */
@property(nonatomic,assign) CGPoint dragPoint;

/**拖拽方向
 */
@property(nonatomic,assign) SeaCollectionViewDraggableLayoutDragDirection dragDirection;

@end

@implementation SeaCollectionViewDraggableLayout

/**UICollectionView 布局之前会调用此方法，可在此地添加需要的手势
 */
- (void)prepareLayout
{
    if(!self.longGestureRecognizer)
    {
        _longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        _longGestureRecognizer.delegate = self;


        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        _panGestureRecognizer.delegate = self;


        //让collectionView的手势相对于长按手势失败
        for(UIGestureRecognizer *gesture in self.collectionView.gestureRecognizers)
        {
            [gesture requireGestureRecognizerToFail:_longGestureRecognizer];
        }

        [self.collectionView addGestureRecognizer:_longGestureRecognizer];
        [self.collectionView addGestureRecognizer:_panGestureRecognizer];

        self.dragSpeed = 8.0;
    }
}

//获取代理，直接使用 self.collectionView.delegate 会报错
- (id<SeaCollectionViewDraggableLayoutDelegate>)sea_delegate
{
    return (id<SeaCollectionViewDraggableLayoutDelegate>) self.collectionView.delegate;
}

//设置当前选中itemlayout属性
- (void)setupCurLayoutAttributes:(UICollectionViewLayoutAttributes*) attributes
{
    if(attributes.representedElementCategory != UICollectionElementCategoryCell)
        return;

    if(self.toItem != nil && attributes.indexPath.section == self.toItem.section && attributes.indexPath.row == self.toItem.row)
    {
        attributes.hidden = YES;
    }
    else
    {
        attributes.hidden = NO;
    }
}

#pragma mark- super method

- (UICollectionViewLayoutAttributes*)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    [self setupCurLayoutAttributes:attributes];

    return attributes;
}

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];

    for(UICollectionViewLayoutAttributes *attribute in attributes)
    {
        [self setupCurLayoutAttributes:attribute];
    }

    return attributes;
}

#pragma mark- handle gesture

//长按手势，获取要移动的item
- (void)handleLongPress:(UILongPressGestureRecognizer*) longPress
{
    if(longPress.state == UIGestureRecognizerStateBegan)
    {
        _editing = YES;

        CGPoint point = [longPress locationInView:self.collectionView];

        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];

        if([[self sea_delegate] respondsToSelector:@selector(collectionView:layout:willBeginMoveItemAtIndexPath:)])
        {
            [[self sea_delegate] collectionView:self.collectionView layout:self willBeginMoveItemAtIndexPath:indexPath];
        }

        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];

        //创建模拟视图
        UIImage *image = [UIImage imageFromView:cell];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.frame];

        imageView.image = image;

        self.simulationView = imageView;

        [self.collectionView addSubview:self.simulationView];

        self.selectedItem = indexPath;
        self.fromItem = indexPath;
        self.toItem = indexPath;

        [UIView animateWithDuration:0.25 animations:^(void)
         {
             self.simulationView.transform = CGAffineTransformMakeScale(1.2, 1.2);
         }
                         completion:^(BOOL finish)
         {
             if([[self sea_delegate] respondsToSelector:@selector(collectionView:layout:didBeginMoveItemAtIndexPath:)])
             {
                 [[self sea_delegate] collectionView:self.collectionView layout:self didBeginMoveItemAtIndexPath:indexPath];
             }
         }];

        //刷新collectionView 的布局
        [self invalidateLayout];
    }
    else if (longPress.state == UIGestureRecognizerStateEnded)
    {

        if([[self sea_delegate] respondsToSelector:@selector(collectionView:layoutWillEndEdit:fromIndexPath:toIndexPath:)])
        {
            [[self sea_delegate] collectionView:self.collectionView layoutWillEndEdit:self fromIndexPath:self.selectedItem toIndexPath:self.toItem];
        }

        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:self.toItem];

        [UIView animateWithDuration:0.25 animations:^(void)
         {
             self.simulationView.transform = CGAffineTransformMakeScale(1.0, 1.0);

             //transform 和 frame 冲突
             self.simulationView.center = attributes.center;
         }
                         completion:^(BOOL finish)
         {
             _editing = NO;

             NSIndexPath *selectedItem = self.selectedItem;
             NSIndexPath *toItem = self.toItem;

             self.selectedItem = nil;
             self.fromItem = nil;
             self.toItem = nil;
             [self invalidateLayout];
             [self.simulationView removeFromSuperview];
             self.simulationView = nil;

             if([[self sea_delegate] respondsToSelector:@selector(collectionView:layoutDidEndEdit:fromIndexPath:toIndexPath:)])
             {
                 [[self sea_delegate] collectionView:self.collectionView layoutDidEndEdit:self fromIndexPath:selectedItem toIndexPath:toItem];
             }

         }];
    }
}

//平移手势，移动item
- (void)handlePan:(UIPanGestureRecognizer*) pan
{
    CGPoint point = [pan locationInView:self.collectionView];
    switch (pan.state)
    {
        case UIGestureRecognizerStateBegan :
        {
            self.dragPoint = point;
        }
        case UIGestureRecognizerStateChanged :
        {
            self.simulationView.center = point;

            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];

            //这个位置没有item
            if(indexPath != nil)
            {
                //判断是否可移动到这个位置
                BOOL can = YES;
                if([[self sea_delegate] respondsToSelector:@selector(collectionView:layout:canMoveItemAtIndexPath:toIndexPath:)])
                {
                    can = [[self sea_delegate] collectionView:self.collectionView layout:self canMoveItemAtIndexPath:self.selectedItem toIndexPath:indexPath];
                }

                if(can)
                {
                    self.fromItem = self.toItem;

                    self.toItem = indexPath;

                    if([[self sea_delegate] respondsToSelector:@selector(collectionView:layout:didMoveItemAtIndexPath:toIndexPath:)])
                    {
                        [[self sea_delegate] collectionView:self.collectionView layout:self didMoveItemAtIndexPath:self.fromItem toIndexPath:self.toItem];
                    }
                    else
                    {
                        //抛出警告，最好实现 collectionView:layout:didMoveItemAtIndexPath:toIndexPath:
                        NSLog(@"warning: 最好实现 collectionView:layout:didMoveItemAtIndexPath:toIndexPath:，否则collectionView 中的内容会发生错乱");
                    }

                    [self.collectionView moveItemAtIndexPath:self.fromItem toIndexPath:self.toItem];
                }
            }

            CGPoint offset = self.collectionView.contentOffset;
            switch (self.scrollDirection)
            {
                case UICollectionViewScrollDirectionVertical:
                {
                    ///滚动范围超出边界
                    if(offset.y >= 0 && offset.y <= self.collectionView.contentSize.height - self.collectionView.height)
                    {
                        CGRect bounds = self.collectionView.bounds;
                        CGRect rect = self.simulationView.frame;

                        ///
                        if(rect.origin.y <= bounds.origin.y)
                        {
                            self.dragDirection = SeaCollectionViewDraggableLayoutDragDirectionTop;
                            [self startTimer];
                        }
                        else if(rect.origin.y + rect.size.height >= bounds.origin.y + bounds.size.height)
                        {
                            self.dragDirection = SeaCollectionViewDraggableLayoutDragDirectionBottom;
                            [self startTimer];
                        }
                        else
                        {
                            [self stopTimer];
                        }
                    }
                }
                    break;
                case UICollectionViewScrollDirectionHorizontal:
                {
                    ///滚动范围超出边界
                    if(offset.x >= 0 && offset.x <= self.collectionView.contentSize.width - self.collectionView.width)
                    {
                        CGRect bounds = self.collectionView.bounds;
                        CGRect rect = self.simulationView.frame;

                        ///
                        if(rect.origin.x <= bounds.origin.x)
                        {
                            self.dragDirection = SeaCollectionViewDraggableLayoutDragDirectionLeft;
                            [self startTimer];
                        }
                        else if(rect.origin.x + rect.size.width >= bounds.origin.x + bounds.size.width)
                        {
                            self.dragDirection = SeaCollectionViewDraggableLayoutDragDirectionRight;
                            [self startTimer];
                        }
                        else
                        {
                            [self stopTimer];
                        }
                    }
                }
                    break;
            }
        }
            break;
        default:
        {
            [self stopTimer];
        }
            break;
    }
}

#pragma mark- scroll timer

///开始计时器
- (void)startTimer
{
    if(!self.scrollingTimer)
    {
        self.scrollingTimer = [NSTimer timerWithTimeInterval:1.0 / 60.0 target:self selector:@selector(handleScroll:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.scrollingTimer forMode:NSRunLoopCommonModes];
        [self.scrollingTimer fire];
    }
}

///停止计时器
- (void)stopTimer
{
    if (self.scrollingTimer)
    {
        [self.scrollingTimer invalidate];
        self.scrollingTimer = nil;
    }
}

///滚动ScrollView到对应的位置
- (void)handleScroll:(NSTimer*) timer
{
    CGRect bounds = self.collectionView.bounds;
    CGPoint offset;
    CGPoint center = self.simulationView.center;

    CGFloat speed = self.dragSpeed;

    ///已经滚动到边界了
    CGSize contentSize = self.collectionView.contentSize;

    switch (self.dragDirection)
    {
        case SeaCollectionViewDraggableLayoutDragDirectionBottom :
        {
            offset.y = bounds.origin.y + speed;
            center.y += speed;

            if(offset.y >= contentSize.height - bounds.size.height)
            {
                offset.y = contentSize.height - bounds.size.height;
                [self stopTimer];
            }
        }
            break;
        case SeaCollectionViewDraggableLayoutDragDirectionTop :
        {
            offset.y = bounds.origin.y - speed;
            center.y -= speed;

            if(offset.y <= 0)
            {
                offset.y = 0;
                [self stopTimer];
            }
        }
            break;
        case SeaCollectionViewDraggableLayoutDragDirectionLeft :
        {
            offset.x = bounds.origin.x - speed;
            center.x -= speed;
            if (offset.x <= 0)
            {
                offset.x = 0;
                [self stopTimer];
            }
        }
            break;
        case SeaCollectionViewDraggableLayoutDragDirectionRight :
        {
            offset.x = bounds.origin.x + speed;
            center.x += speed;
            if (offset.x >= contentSize.width - bounds.size.width)
            {
                offset.x = contentSize.width - bounds.size.width;
                [self stopTimer];
            }
        }
            break;
        default:
            break;
    }

    self.collectionView.contentOffset = offset;
    self.simulationView.center = center;
}

#pragma mark- UIGestureRecognizer delegate

//判断是否可以开始手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if([gestureRecognizer isEqual:_longGestureRecognizer])
    {
        CGPoint point = [gestureRecognizer locationInView:self.collectionView];
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];

        //点击的位置不是cell
        if(indexPath == nil)
            return NO;

        //判断是否可以移动该item
        BOOL can = YES;
        if([[self sea_delegate] respondsToSelector:@selector(collectionView:layout:canMoveItemAtIndexPath:)])
        {
            can = [[self sea_delegate] collectionView:self.collectionView layout:self canMoveItemAtIndexPath:indexPath];
        }

        _editing = can;
        return can;
    }
    else if ([gestureRecognizer isEqual:_panGestureRecognizer])
    {
        return _editing;
    }

    return YES;
}

//让长按手势和平移手势共存，默认手势不共存
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)theGestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)theOtherGestureRecognizer
{
    if([self.longGestureRecognizer isEqual:theGestureRecognizer])
    {
        return [self.panGestureRecognizer isEqual:theOtherGestureRecognizer];
    }
    else if([self.panGestureRecognizer isEqual:theGestureRecognizer])
    {
        return [self.longGestureRecognizer isEqual:theOtherGestureRecognizer];
    }
    
    return NO;
}

@end
