//
//  SeaTextListCell.m
//  zhqt
//
//  Created by 罗海雄 on 17/9/4.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import "SeaTextListCell.h"

@interface SeaTextListCell ()

///内容右边约束 和 container
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right_container_layoutConstraint;

///内容右边约束 和 箭头
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *right_arrow_layoutConstraint;

@end

@implementation SeaTextListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    self.content_label.text = nil;
}

- (void)setArrowHidden:(BOOL)arrowHidden
{
    if(_arrowHidden != arrowHidden)
    {
        _arrowHidden = arrowHidden;
        self.arrow_imageView.hidden = _arrowHidden;
        if(_arrowHidden)
        {
            self.selectionStyle = UITableViewCellSelectionStyleNone;
            self.right_container_layoutConstraint.priority = UILayoutPriorityDefaultHigh;
            self.right_arrow_layoutConstraint.priority = UILayoutPriorityDefaultLow;
        }
        else
        {
            self.selectionStyle = UITableViewCellSelectionStyleGray;
            self.right_container_layoutConstraint.priority = UILayoutPriorityDefaultLow;
            self.right_arrow_layoutConstraint.priority = UILayoutPriorityDefaultHigh;
        }
    }
}

@end
