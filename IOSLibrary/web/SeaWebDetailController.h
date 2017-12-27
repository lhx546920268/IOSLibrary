//
//  SeaWebDetailController.h
//  StandardShop
//
//  Created by 罗海雄 on 17/9/12.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

///使用web作为详情
@interface SeaWebDetailController : NSObject<UIWebViewDelegate>

///webview
@property(nonatomic, readonly) UIWebView *webView;

//web是否已加载完成
@property(nonatomic, readonly) BOOL webDidLoad;

//web加载完成 需要刷新ui
@property(nonatomic, copy) void(^webDidLoadHandler)(CGFloat webContentHeight);

//设置父视图
- (void)setSuperview:(UIView*) superview;

//web初始化高
- (instancetype)initWithFrame:(CGRect) frame;

@end
