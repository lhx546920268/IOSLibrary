//

//
//

#import "UITextView+Utilities.h"
#import "SeaBasic.h"

@implementation UITextView (Utilities)

/**内容改变 在代理textDidChange调用
 *@param count 限制的文字数量
 */
- (void)textDidChangeWithLimitedCount:(NSInteger) count
{
    if (self.markedTextRange == nil && self.text.length > count)
    {
        NSString *str = [self.text substringWithRange:NSMakeRange(0, count)];
        self.text = str;
    }
}

/**是否替换内容 在代理shouldChangeTextInRange中调用
 *@param range 替换的范围
 *@param text 新的内容
 *@param count 限制的文字数量
 *@return 是否替换
 */
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text withLimitedCount:(NSInteger) count
{
    UITextRange *textRange = [self markedTextRange];
    
    NSString *markText = [self textInRange:textRange];
    
    NSString *new = [self.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger length = new.length - (textRange.empty ? 0 : markText.length + 1);
    
    NSInteger res = count - length;
    
    if(res > 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = count - self.text.length;
        if(len < 0)
            len = 0;
        if(len > text.length)
            len = text.length;
        
        NSString *str = [self.text stringByReplacingCharactersInRange:range withString:[text substringWithRange:NSMakeRange(0, len)]];
        NSRange selectedRange = self.selectedRange;
        self.text = str;
        self.selectedRange = selectedRange;
        
        return NO;
    }
}

/**设置默认的附加视图
 *@param target 方法执行者
 *@param action 方法
 */
- (void)setDefaultInputAccessoryViewWithTarget:(id) target action:(SEL) action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _width_, 35.0)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    CGFloat buttonWidth = 60.0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(_width_ - buttonWidth, 0, buttonWidth, 35.0)];
    [view addSubview:button];
    self.inputAccessoryView = view;
    
}

@end
