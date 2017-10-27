//
//  SeaTextLoadingListCell.m
//  zhqt
//
//  Created by 罗海雄 on 17/9/4.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import "SeaTextLoadingListCell.h"

@implementation SeaTextLoadingListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.content_label.text = nil;
}

- (void)setLoading:(BOOL)loading
{
    if(_loading != loading)
    {
        _loading = loading;
        self.content_label.hidden = _loading;
        self.act_view.hidden = !_loading;
        self.selectionStyle = _loading ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray;
    }
}

@end
