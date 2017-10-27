//
//  WMTextSwitchListCell.m
//  zhqt
//
//  Created by 罗海雄 on 17/9/4.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import "SeaTextSwitchListCell.h"
#import "SeaBasic.h"

@implementation SeaTextSwitchListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.switch_control.onTintColor = _appMainColor_;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

///开关
- (IBAction)switchDidChange:(id)sender
{
    if([self.delegate respondsToSelector:@selector(textSwitchListCellSwitchDidChange:)])
    {
        [self.delegate textSwitchListCellSwitchDidChange:self];
    }
}

@end
