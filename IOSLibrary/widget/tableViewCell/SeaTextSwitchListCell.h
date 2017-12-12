//
//  WMTextSwitchListCell.h
//  zhqt
//
//  Created by 罗海雄 on 17/9/4.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeaTextSwitchListCell;

///标题 开关 代理
@protocol SeaTextSwitchListCellDelegate <NSObject>

///点击开关
- (void)textSwitchListCellSwitchDidChange:(SeaTextSwitchListCell*) cell;

@end

///标题 开关
@interface SeaTextSwitchListCell : UITableViewCell

///标题
@property (weak, nonatomic) IBOutlet UILabel *title_label;

///开关控制器
@property (weak, nonatomic) IBOutlet UISwitch *switch_control;

@property (weak, nonatomic) id<SeaTextSwitchListCellDelegate> delegate;

@end
