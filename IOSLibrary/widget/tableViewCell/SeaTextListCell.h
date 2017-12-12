//
//  SeaTextListCell.h
//  zhqt
//
//  Created by 罗海雄 on 17/9/4.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

///普通文本列表 标题 内容，
@interface SeaTextListCell : UITableViewCell

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///内容
@property (weak, nonatomic) IBOutlet UILabel *content_label;

///箭头
@property (weak, nonatomic) IBOutlet UIImageView *arrow_imageView;

///设置箭头隐藏
@property (assign, nonatomic) BOOL arrowHidden;

@end
