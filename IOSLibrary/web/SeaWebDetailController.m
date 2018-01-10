//
//  SeaWebDetailController.m
//  IOSLibrary
//
//  Created by 罗海雄 on 17/9/12.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import "SeaWebDetailController.h"
#import "UIView+Utils.h"

@implementation SeaWebDetailController

//web初始化高
- (instancetype)initWithFrame:(CGRect) frame
{
    self = [super init];
    if(self)
    {
        _webView = [[UIWebView alloc] initWithFrame:frame];
        _webView.delegate = self;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scalesPageToFit = NO;
        _webView.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

//设置父视图
- (void)setSuperview:(UIView*) superview
{
    if(_webView != superview)
    {
        [_webView removeFromSuperview];
        [superview addSubview:_webView];
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(!_webDidLoad)
    {
        _webDidLoad = YES;
        CGFloat height = 0;
        webView.height = 1;
        height = webView.scrollView.contentSize.height;
        
        webView.height = height;
        
        !self.webDidLoadHandler ?: self.webDidLoadHandler(height);
    }
}

@end
