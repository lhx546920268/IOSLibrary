//
//  SeaAlbumGroupListCell.h
//  WuMei
//
//  Created by 罗海雄 on 15/8/7.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SeaAlbumGroupListCellImageSize 50
#define SeaAlbumGroupListCellMargin 5.0

/**相册分组列表信息
 */
@interface SeaAlbumGroupListCell : UITableViewCell

/**图片
 */
@property(nonatomic,readonly) UIImageView *iconImageView;

/**名称
 */
@property(nonatomic,readonly) UILabel *nameLabel;


@end
