//
//  UIWebView+Utils.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/8.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWebView (Utils)

/**清除数据 在 dealloc 中调用
 */
- (void)clean;

/**网页标题
 */
@property(nonatomic,readonly) NSString *title;

/**当前网页路径
 */
@property(nonatomic,readonly) NSString *curURL;

/**内容高度
 */
@property(nonatomic,readonly) CGFloat contentHeight;

/**内容宽度
 */
@property(nonatomic,readonly) CGFloat contentWidth;

/**获取宽度已经适配于webView的html。这里的原始html也可以通过js从webView里获取
 *@return 返回新的html
 */
- (NSString *)htmlAdjustWithPageHtml:(NSString *)html;

/**适配屏幕的html字符串，把它加在html的前面
 */
+ (NSString*)adjustScreenHtmlString;

@end
