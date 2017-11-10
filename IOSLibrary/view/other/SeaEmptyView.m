//
//  SeaEmptyView.m
//  StandardShop
//
//  Created by 罗海雄 on 16/7/14.
//  Copyright © 2016年 qianseit. All rights reserved.
//

#import "SeaEmptyView.h"
#import <objc/runtime.h>
#import "SeaBasic.h"

@interface SeaEmptyView ()

///内容
@property(nonatomic,readonly) UIView *contentView;

@end

@implementation SeaEmptyView
{
    ///图标
    UIImageView *_iconImageView;
    
    ///文字
    UILabel *_textLabel;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initlization];
    }

    return self;
}

///初始化默认数据
- (void)initlization
{
    if(!self.contentView)
    {
        self.backgroundColor = SeaViewControllerBackgroundColor;
        self.clipsToBounds = YES;
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.translatesAutoresizingMaskIntoConstraints = NO;

        [self addSubview:_contentView];

        NSDictionary *views = NSDictionaryOfVariableBindings(_contentView);

        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10.0-[_contentView]-10.0-|" options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    }
}

- (UILabel*)textLabel
{
    if(!_textLabel)
    {
        _textLabel = [[UILabel alloc] init];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.translatesAutoresizingMaskIntoConstraints = NO;
        _textLabel.textColor = [UIColor grayColor];
        _textLabel.font = [UIFont fontWithName:SeaMainFontName size:17.0];
        _textLabel.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:_textLabel];

        NSDictionary *views = NSDictionaryOfVariableBindings(_textLabel);
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_textLabel]-0-|" options:0 metrics:nil views:views]];

        if(_iconImageView)
        {
            [self.contentView removeConstraint:self.iconImageView.sea_bottomLayoutConstraint];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0]];
        }
        else
        {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
        }
        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_textLabel attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    }

    return _textLabel;
}

- (UIImageView*)iconImageView
{
    if(!_iconImageView)
    {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.contentView addSubview:_iconImageView];

        [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];

        if(_textLabel)
        {
            [self.contentView removeConstraint:_textLabel.sea_topLayoutConstraint];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_textLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.iconImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:10.0]];
        }
        else
        {
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:_iconImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0]];
            [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.contentView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_iconImageView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
        }
    }

    return _iconImageView;
}

- (void)setCustomView:(UIView *)customView
{
    if(_customView != customView)
    {
        [_customView removeFromSuperview];
        _customView = customView;
        _customView.translatesAutoresizingMaskIntoConstraints = NO;

        [self.contentView addSubview:_customView];

        NSDictionary *views = NSDictionaryOfVariableBindings(_customView);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[_customView]-0-|" options:0 metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-0-[_customView(%f)]-0-|", _customView.frame.size.height] options:0 metrics:nil views:views]];
    }
}

@end

///空视图key
static char SeaEmptyViewKey;

///是否显示空视图kkey
static char SeaShouldShowEmptyViewKey;

///偏移量
static char SeaEmptyViewInsetsKey;
static char SeaEmptyViewDelegateKey;

@implementation UIScrollView (emptyView)

- (SeaEmptyView*)sea_emptyView
{
    return objc_getAssociatedObject(self, &SeaEmptyViewKey);
}

- (void)setSea_emptyView:(SeaEmptyView *)sea_emptyView
{
    objc_setAssociatedObject(self, &SeaEmptyViewKey, sea_emptyView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSea_shouldShowEmptyView:(BOOL)sea_shouldShowEmptyView
{
    if(self.sea_shouldShowEmptyView != sea_shouldShowEmptyView)
    {
        objc_setAssociatedObject(self, &SeaShouldShowEmptyViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        if(sea_shouldShowEmptyView)
        {
            [self layoutEmtpyView];
        }
        else
        {
            [self.sea_emptyView removeFromSuperview];
            self.sea_emptyView = nil;
        }
    }
}

- (BOOL)sea_shouldShowEmptyView
{
    return [objc_getAssociatedObject(self, &SeaShouldShowEmptyViewKey) boolValue];
}

- (void)setSea_emptyViewInsets:(UIEdgeInsets)sea_emptyViewInsets
{
    UIEdgeInsets insets = self.sea_emptyViewInsets;
    if(!UIEdgeInsetsEqualToEdgeInsets(insets, sea_emptyViewInsets))
    {
        objc_setAssociatedObject(self, &SeaEmptyViewInsetsKey, [NSValue valueWithUIEdgeInsets:sea_emptyViewInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self layoutEmtpyView];
    }
}

- (UIEdgeInsets)sea_emptyViewInsets
{
    return [objc_getAssociatedObject(self, &SeaEmptyViewInsetsKey) UIEdgeInsetsValue];
}

- (void)setSea_emptyViewDelegate:(id<SeaEmptyViewDelegate>)sea_emptyViewDelegate
{
    SeaWeakObjectContainer *container = objc_getAssociatedObject(self, &SeaEmptyViewDelegateKey);
    if(!container)
    {
        container = [[SeaWeakObjectContainer alloc] init];
    }

    container.weakObject = sea_emptyViewDelegate;
    objc_setAssociatedObject(self, &SeaEmptyViewDelegateKey, container, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<SeaEmptyViewDelegate>)sea_emptyViewDelegate
{
    SeaWeakObjectContainer *container = objc_getAssociatedObject(self, &SeaEmptyViewDelegateKey);
    return container.weakObject;
}

///调整emptyView
- (void)layoutEmtpyView
{
    if(!self.sea_shouldShowEmptyView)
        return;
    
    if([self isEmptyData])
    {
        SeaEmptyView *emptyView = self.sea_emptyView;
        if(!emptyView)
        {
            emptyView = [[SeaEmptyView alloc] init];
            self.sea_emptyView = emptyView;
        }

        UIEdgeInsets insets = self.sea_emptyViewInsets;
        
        emptyView.frame = CGRectMake(insets.left, insets.top, self.width - insets.left - insets.right, self.height - insets.top - insets.bottom);
        emptyView.hidden = NO;

        id<SeaEmptyViewDelegate> delegate = self.sea_emptyViewDelegate;
        if([delegate respondsToSelector:@selector(emptyViewWillAppear:)])
        {
            [delegate emptyViewWillAppear:emptyView];
        }

        if(!emptyView.superview)
        {
            if(self.loadMoreControl)
            {
                [self insertSubview:emptyView aboveSubview:self.loadMoreControl];
            }
            else
            {
                [self insertSubview:emptyView atIndex:0];
            }
        }
    }
    else
    {
        [self.sea_emptyView removeFromSuperview];
    }
}

///当前是空数据 UIScrollView 一定是空的，其他的不一定
- (BOOL)isEmptyData
{
    return YES;
}

@end

///
static char SeaShouldShowEmptyViewWhenExistTableHeaderViewKey;
static char SeaShouldShowEmptyViewWhenExistTableFooterViewKey;
static char SeaShouldShowEmptyViewWhenExistSectionHeaderViewKey;
static char SeaShouldShowEmptyViewWhenExistSectionFooterViewKey;


@implementation UITableView (tableViewEmptyView)

#pragma mark- super method

- (void)layoutEmtpyView
{
    [super layoutEmtpyView];

    SeaEmptyView *emptyView = self.sea_emptyView;
    if(emptyView && emptyView.superview && !emptyView.hidden)
    {
        CGRect frame = emptyView.frame;
        CGFloat y = frame.origin.y;

        y += self.tableHeaderView.height;
        y += self.tableFooterView.height;

        frame.origin.y = y;
        frame.size.height = self.height - y;
        if(frame.size.height <= 0)
        {
            [emptyView removeFromSuperview];
        }
        else
        {
            emptyView.frame = frame;
        }
    }
}

- (BOOL)isEmptyData
{
    BOOL empty = YES;

    if(!self.sea_shouldShowEmptyViewWhenExistTableHeaderView && self.tableHeaderView)
    {
        empty = NO;
    }

    if(!self.sea_shouldShowEmptyViewWhenExistTableFooterView && self.tableFooterView)
    {
        empty = NO;
    }

    if(empty && self.dataSource)
    {
        NSInteger section = 1;
        if([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)])
        {
            section = [self.dataSource numberOfSectionsInTableView:self];
        }

        if([self.dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)])
        {
            for(NSInteger i = 0;i < section;i ++)
            {
                NSInteger row = [self.dataSource tableView:self numberOfRowsInSection:i];
                if(row > 0)
                {
                    empty = NO;
                    break;
                }
            }
        }

        ///行数为0，section 大于0时，可能存在sectionHeader
        if(empty && section > 0 && self.delegate)
        {
            if(!self.sea_shouldShowEmptyViewWhenExistSectionHeaderView && [self.delegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)])
            {
                for(NSInteger i = 0; i < section;i ++)
                {
                    UIView *view = [self.delegate tableView:self viewForHeaderInSection:i];
                    if(view)
                    {
                        empty = NO;
                        break;
                    }
                }
            }

            if(empty && !self.sea_shouldShowEmptyViewWhenExistSectionFooterView && [self.delegate respondsToSelector:@selector(tableView:viewForFooterInSection:)])
            {
                for(NSInteger i = 0; i < section;i ++)
                {
                    UIView *view = [self.delegate tableView:self viewForFooterInSection:i];
                    if(view)
                    {
                        empty = NO;
                        break;
                    }
                }
            }
        }
    }

    return empty;
}

#pragma mark- property

- (void)setSea_shouldShowEmptyViewWhenExistTableHeaderView:(BOOL)sea_shouldShowEmptyViewWhenExistTableHeaderView
{
    objc_setAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistTableHeaderViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyViewWhenExistTableHeaderView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_shouldShowEmptyViewWhenExistTableHeaderView
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistTableHeaderViewKey);
    if(number)
    {
        return [number boolValue];
    }

    return YES;
}

- (void)setSea_shouldShowEmptyViewWhenExistTableFooterView:(BOOL)sea_shouldShowEmptyViewWhenExistTableFooterView
{
    objc_setAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistTableFooterViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyViewWhenExistTableFooterView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_shouldShowEmptyViewWhenExistTableFooterView
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistTableFooterViewKey);
    if(number)
    {
        return [number boolValue];
    }

    return YES;
}


- (void)setSea_shouldShowEmptyViewWhenExistSectionHeaderView:(BOOL)sea_shouldShowEmptyViewWhenExistSectionHeaderView
{
    objc_setAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionHeaderViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyViewWhenExistSectionHeaderView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_shouldShowEmptyViewWhenExistSectionHeaderView
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionHeaderViewKey);
    if(number)
    {
        return [number boolValue];
    }

    return NO;
}


- (void)setSea_shouldShowEmptyViewWhenExistSectionFooterView:(BOOL)sea_shouldShowEmptyViewWhenExistSectionFooterView
{
    objc_setAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionFooterViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyViewWhenExistSectionFooterView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_shouldShowEmptyViewWhenExistSectionFooterView
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionFooterViewKey);
    if(number)
    {
        return [number boolValue];
    }

    return NO;
}

#pragma mark- swizzle

+ (void)load
{
    SEL selectors[] = {

        @selector(reloadData),
        @selector(reloadSections:withRowAnimation:),
        @selector(insertRowsAtIndexPaths:withRowAnimation:),
        @selector(insertSections:withRowAnimation:),
        @selector(deleteRowsAtIndexPaths:withRowAnimation:),
        @selector(deleteSections:withRowAnimation:)
    };

    for(NSInteger i = 0;i < sizeof(selectors) / sizeof(SEL);i ++)
    {
        SEL selector1 = selectors[i];
        SEL selector2 = NSSelectorFromString([NSString stringWithFormat:@"sea_empty_%@", NSStringFromSelector(selector1)]);

        Method method1 = class_getInstanceMethod(self, selector1);
        Method method2 = class_getInstanceMethod(self, selector2);

        method_exchangeImplementations(method1, method2);
    }
}

- (void)sea_empty_reloadData
{
    [self layoutEmtpyView];
    [self sea_empty_reloadData];
}

- (void)sea_empty_reloadSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self layoutEmtpyView];
    [self sea_empty_reloadSections:sections withRowAnimation:animation];
}

- (void)sea_empty_insertRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self layoutEmtpyView];
    [self sea_empty_insertRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)sea_empty_insertSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self layoutEmtpyView];
    [self sea_empty_insertSections:sections withRowAnimation:animation];
}

- (void)sea_empty_deleteRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation
{
    [self layoutEmtpyView];
    [self sea_empty_deleteRowsAtIndexPaths:indexPaths withRowAnimation:animation];
}

- (void)sea_empty_deleteSections:(NSIndexSet *)sections withRowAnimation:(UITableViewRowAnimation)animation
{
    [self layoutEmtpyView];
    [self sea_empty_deleteSections:sections withRowAnimation:animation];
}

@end

@implementation UICollectionView (collectionViewEmptyView)

#pragma mark- super method

- (BOOL)isEmptyData
{
    BOOL empty = YES;

    if(empty && self.dataSource)
    {
        NSInteger section = 1;
        if([self.dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)])
        {
            section = [self.dataSource numberOfSectionsInCollectionView:self];
        }

        if([self.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)])
        {
            for(NSInteger i = 0;i < section;i ++)
            {
                NSInteger items = [self.dataSource collectionView:self numberOfItemsInSection:i];
                if(items > 0)
                {
                    empty = NO;
                    break;
                }
            }
        }

        ///item为0，section 大于0时，可能存在sectionHeader
        if(empty && section > 0)
        {
            if(!self.sea_shouldShowEmptyViewWhenExistSectionHeaderView && [self.dataSource respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
            {
                for(NSInteger i = 0; i < section;i ++)
                {
                    UIView *view = [self.dataSource collectionView:self viewForSupplementaryElementOfKind:UICollectionElementKindSectionHeader atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                    if(view)
                    {
                        empty = NO;
                        break;
                    }
                }
            }

            if(empty && !self.sea_shouldShowEmptyViewWhenExistSectionFooterView && [self.delegate respondsToSelector:@selector(collectionView:viewForSupplementaryElementOfKind:atIndexPath:)])
            {
                for(NSInteger i = 0; i < section;i ++)
                {
                    UIView *view = [self.dataSource collectionView:self viewForSupplementaryElementOfKind:UICollectionElementKindSectionFooter atIndexPath:[NSIndexPath indexPathForItem:0 inSection:i]];
                    if(view)
                    {
                        empty = NO;
                        break;
                    }
                }
            }
        }
    }
    
    return empty;
}

#pragma mark- property

- (void)setSea_shouldShowEmptyViewWhenExistSectionHeaderView:(BOOL)sea_shouldShowEmptyViewWhenExistSectionHeaderView
{
    objc_setAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionHeaderViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyViewWhenExistSectionHeaderView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_shouldShowEmptyViewWhenExistSectionHeaderView
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionHeaderViewKey);
    if(number)
    {
        return [number boolValue];
    }

    return NO;
}


- (void)setSea_shouldShowEmptyViewWhenExistSectionFooterView:(BOOL)sea_shouldShowEmptyViewWhenExistSectionFooterView
{
    objc_setAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionFooterViewKey, [NSNumber numberWithBool:sea_shouldShowEmptyViewWhenExistSectionFooterView], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sea_shouldShowEmptyViewWhenExistSectionFooterView
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaShouldShowEmptyViewWhenExistSectionFooterViewKey);
    if(number)
    {
        return [number boolValue];
    }

    return NO;
}

#pragma mark- swizzle

+ (void)load
{
    SEL selectors[] = {

        @selector(reloadData),
        @selector(reloadSections:),
        @selector(insertItemsAtIndexPaths:),
        @selector(insertSections:),
        @selector(deleteItemsAtIndexPaths:),
        @selector(deleteSections:),
    };

    for(NSInteger i = 0;i < sizeof(selectors) / sizeof(SEL);i ++)
    {
        SEL selector1 = selectors[i];
        SEL selector2 = NSSelectorFromString([NSString stringWithFormat:@"sea_empty_%@", NSStringFromSelector(selector1)]);

        Method method1 = class_getInstanceMethod(self, selector1);
        Method method2 = class_getInstanceMethod(self, selector2);

        method_exchangeImplementations(method1, method2);
    }
}

- (void)sea_empty_reloadData
{
    [self layoutEmtpyView];
    [self sea_empty_reloadData];
}

- (void)sea_empty_reloadSections:(NSIndexSet *)sections
{
    [self layoutEmtpyView];
    [self sea_empty_reloadSections:sections];
}

- (void)sea_empty_insertItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self layoutEmtpyView];
    [self sea_empty_insertItemsAtIndexPaths:indexPaths];
}

- (void)sea_empty_insertSections:(NSIndexSet *)sections
{
    [self layoutEmtpyView];
    [self sea_empty_insertSections:sections];
}

- (void)sea_empty_deleteItemsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [self layoutEmtpyView];
    [self sea_empty_deleteItemsAtIndexPaths:indexPaths];
}

- (void)sea_empty_deleteSections:(NSIndexSet *)sections
{
    [self layoutEmtpyView];
    [self sea_empty_deleteSections:sections];
}

@end
