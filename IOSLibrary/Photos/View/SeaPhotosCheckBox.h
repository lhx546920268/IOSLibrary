//
//  SeaPhotosCheckBox.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2019/7/2.
//  Copyright © 2019 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///相册选中
@interface SeaPhotosCheckBox : UIView

///是否选中
@property(nonatomic, assign) BOOL checked;

///选中文字字体
@property(nonatomic, strong) UIFont *font;

///选中的文字
@property(nonatomic, copy) NSString *checkedText;

///内边距
@property(nonatomic, assign) UIEdgeInsets contentInsets;

///设置选中
- (void)setChecked:(BOOL)checked animated:(BOOL) animated;

@end

