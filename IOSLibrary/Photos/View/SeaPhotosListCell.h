//
//  SeaPhotosListCell.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/2.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>


///相册列表
@interface SeaPhotosListCell : UITableViewCell

///缩略图
@property(nonatomic, readonly) UIImageView *thumbnailImageView;

///标题
@property(nonatomic, readonly) UILabel *titleLabel;

///数量
@property(nonatomic, readonly) UILabel *countLabel;

///asset标识符
@property(nonatomic, strong) NSString *assetLocalIdentifier;

@end

