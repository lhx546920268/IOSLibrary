//
//  SeaTextLoadingListCell.h
//  zhqt
//
//  Created by 罗海雄 on 17/9/4.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///带有加载的列表
@interface SeaTextLoadingListCell : UITableViewCell

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///内容
@property (weak, nonatomic) IBOutlet UILabel *content_label;

///加载中
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *act_view;

///
@property (assign, nonatomic) BOOL loading;

@end
