//
//  UIWebView+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/8.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UIWebView+Utils.h"

@implementation UIWebView (Utils)

/**清除数据 在 dealloc 中调用
 */
- (void)clean
{
    [self loadHTMLString:@"" baseURL:nil];
    self.delegate = nil;
    [self stopLoading];
    [self removeFromSuperview];
}

- (NSString*)title
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

- (NSString*)curURL
{
    return [self.request.URL absoluteString];
}

- (CGFloat)contentHeight
{
    [self sizeThatFits:CGSizeZero];
    return [[self stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
}

- (CGFloat)contentWidth
{
    //js获取body宽度
    return [[self stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth"] floatValue];
}

/**获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
 */
- (NSString *)htmlAdjustWithPageHtml:(NSString *)html
{
    if(!html)
        return nil;
    return [[UIWebView adjustScreenHtmlString] stringByAppendingString:html];
    //    NSMutableString *str = [NSMutableString stringWithString:html];
    //    //计算要缩放的比例
    //    CGFloat initialScale = self.frame.size.width / self.contentWidth;
    //    //将</head>替换为meta+head
    //    NSString *stringForReplace = [NSString stringWithFormat:@"<meta name=\"viewport\" content=\" initial-scale=%f, minimum-scale=0.1, maximum-scale=2.0, user-scalable=yes\"></head>",initialScale];
    //
    //    NSRange range =  NSMakeRange(0, str.length);
    //    //替换
    //    [str replaceOccurrencesOfString:@"</head>" withString:stringForReplace options:NSLiteralSearch range:range];
    //    return str;
}

/**适配屏幕的html字符串，把它加在html的前面
 */
+ (NSString*)adjustScreenHtmlString
{
    return @"<style>img {width:100%;}</style><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"/>";
    
    ///<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'/>
    ///<style>* {max-width:100%%;}* {font-size:1.0em;}</style>
}

@end
