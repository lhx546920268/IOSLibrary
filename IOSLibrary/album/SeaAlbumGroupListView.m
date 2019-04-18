//
//  SeaAlbumGroupListView.m
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 luohaixiong. All rights reserved.
//

#import "SeaAlbumGroupListView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "SeaAlbumGroupListCell.h"
#import "SeaBasic.h"
#import "UIViewController+Utils.h"
#import "UIView+Utils.h"

@interface SeaAlbumGroupListView ()

/**图片分组信息 数组元素是 ALAssetsGroup 对象
 */
@property(nonatomic,strong) NSArray *infos;

/**列表
 */
@property(nonatomic,strong) UITableView *tableView;

/**黑色半透明视图
 */
@property(nonatomic,strong) UIView *blackView;

//内容容器
@property(nonatomic,strong) UIView *container;

@end

@implementation SeaAlbumGroupListView

/**以分组信息初始化
 *@param groups 图片分组信息 数组元素是 ALAssetsGroup 对象
 */
- (id)initWithFrame:(CGRect)frame groups:(NSArray*) groups
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.infos = groups;
        
        //黑色半透明高度
        CGFloat rowHeight = SeaAlbumGroupListCellImageSize + SeaAlbumGroupListCellMargin;
        CGFloat buttonHeight = 0;
        CGFloat blackHeight = self.height - (MIN(_infos.count, 5) * rowHeight + SeaAlbumGroupListCellMargin + buttonHeight + SeaSeparatorWidth);
        
        CGFloat containerHeight = self.height - blackHeight;
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        container.backgroundColor = [UIColor whiteColor];
        container.clipsToBounds = YES;
        [self addSubview:container];
        self.container = container;
        
        //回收按钮
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(0, containerHeight - buttonHeight, self.width, buttonHeight);
//        [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
//        [button setImage:[UIImage imageNamed:@"arrow_red_up"] forState:UIControlStateNormal];
//        [container addSubview:button];
        
        //分割线
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, containerHeight - SeaSeparatorWidth, UIScreen.screenWidth, SeaSeparatorWidth)];
        line.backgroundColor = SeaSeparatorColor;
        [container addSubview:line];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, line.top) style:UITableViewStylePlain];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.rowHeight = rowHeight;
        [container addSubview:tableView];
        self.tableView = tableView;
        
        //
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - blackHeight, self.width, blackHeight)];
        view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        
        view.alpha = 0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
        [view addGestureRecognizer:tap];
        [self addSubview:view];
        self.blackView = view;
    }
    
    return self;
}

- (void)setShow:(BOOL)show
{
    if(_show != show)
    {
        _show = show;
        
        if(_show)
        {
            self.hidden = NO;
            [UIView animateWithDuration:0.25 animations:^(void){
               
                self.container.height = self.height - self.blackView.height;
                self.blackView.alpha = 1.0;
            }];
        }
        else
        {
            [UIView animateWithDuration:0.25 animations:^(void){
                
                self.container.height = 0;
                self.blackView.alpha = 0.0;
            }completion:^(BOOL finish){
                
                self.hidden = YES;
                if([self.delegate respondsToSelector:@selector(albumGroupListViewDidDismiss:)])
                {
                    [self.delegate albumGroupListViewDidDismiss:self];
                }
            }];
        }
    }
}

//回收
- (void)dismiss:(id) sender
{
    self.show = NO;
}

#pragma mark- UITableView delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = SeaAlbumGroupListCellImageSize + SeaAlbumGroupListCellMargin;
    if(indexPath.row == _infos.count - 1)
    {
        height += SeaAlbumGroupListCellMargin;
    }
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _infos.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    SeaAlbumGroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[SeaAlbumGroupListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    ALAssetsGroup *group = [_infos objectAtIndex:indexPath.row];
    cell.iconImageView.image = [UIImage imageWithCGImage:group.posterImage];
    cell.nameLabel.text = [[group valueForProperty:ALAssetsGroupPropertyName] stringByAppendingFormat:@"（%d）",(int)group.numberOfAssets];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ALAssetsGroup *group = [_infos objectAtIndex:indexPath.row];
    
    if([self.delegate respondsToSelector:@selector(albumGroupListView:didSelectGroup:)])
    {
        [self.delegate albumGroupListView:self didSelectGroup:group];
    }
    self.show = NO;
}

@end
