//
//  SeaAlbumGroupListView.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/23.
//  Copyright (c) 2015年 luohaixiong. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaAlbumGroupListView, ALAssetsGroup;

@protocol SeaAlbumGroupListViewDelegate <NSObject>

//选择分组
- (void)albumGroupListView:(SeaAlbumGroupListView*) view didSelectGroup:(ALAssetsGroup*) group;

//视图消失
- (void)albumGroupListViewDidDismiss:(SeaAlbumGroupListView *)view;

@end

/**相册分组列表信息
 */
@interface SeaAlbumGroupListView : UIView<UITableViewDataSource,UITableViewDelegate>

/**以分组信息初始化
 *@param groups 图片分组信息 数组元素是 ALAssetsGroup 对象
 */
- (id)initWithFrame:(CGRect)frame groups:(NSArray*) groups;

/**是否显示
 */
@property(nonatomic,assign) BOOL show;

@property(nonatomic,weak) id<SeaAlbumGroupListViewDelegate> delegate;

@end
