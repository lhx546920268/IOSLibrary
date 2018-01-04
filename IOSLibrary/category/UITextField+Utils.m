//
//  UITextField+Utils.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/4.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "UITextField+Utils.h"
#import "UIView+Utils.h"
#import <objc/runtime.h>
#import "SeaBasic.h"
#import "UIView+SeaAutoLayout.h"

//系统默认的蓝色
#define UIKitTintColor [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0]

static char SeaForbidSelectorsKey;
static char SeaChineseAsTwoCharWhenInputLimitKey;
static char SeaInputLimitMaxKey;
static char SeaPreviousTextKey;
static char SeaForbidInputChineseKey;

@implementation UITextField (Utils)

#pragma mark- 内嵌视图

- (void)sea_setLeftViewWithImageName:(NSString*) imageName padding:(CGFloat)padding
{
    self.leftViewMode = UITextFieldViewModeAlways;
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height - image.size.height) / 2.0, image.size.width + padding, image.size.height)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = image;
    self.leftView = imageView;
}

- (void)sea_setRightViewWithImageName:(NSString*) imageName padding:(CGFloat)padding
{
    self.rightViewMode = UITextFieldViewModeAlways;
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height - image.size.height) / 2.0, image.size.width + padding, image.size.height)];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.image = image;
    self.rightView = imageView;
}

- (void)sea_setDefaultSeparator
{
    return [self sea_setSeparatorWithColor:SeaSeparatorColor height:SeaSeparatorHeight];
}

- (void)sea_setSeparatorWithColor:(UIColor *)color height:(CGFloat)height
{
    UIView *separator = self.sea_separator;
    separator.backgroundColor = color;
    separator.sea_heightLayoutConstraint.constant = height;
    
    return separator;
}

- (UIView*)sea_separator
{
    UIView *separator = objc_getAssociatedObject(self, _cmd);
    if(!separator){
        separator = [UIView new];
        [self addSubview:separator];
        
        [separator sea_leftToSuperview];
        [separator sea_rightToSuperview];
        [separator sea_bottomToSuperview];
        [separator sea_heightToSelf:SeaSeparatorHeight];
        
        objc_setAssociatedObject(self, _cmd, separator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return separator;
}

#pragma mark- 文本限制

/**在textField的代理中调用
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param count 输入框最大可输入字数
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitedCount:(NSInteger) count
{
    if(self.forbidInputChinese)
    {
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^(void){
            
            [self unmarkText];
        });
    }
    UITextRange *textRange = [self markedTextRange];
    
    NSString *markText = [self textInRange:textRange];
    
    NSString *new = [self.text stringByReplacingCharactersInRange:range withString:string];
    
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
        if(len > string.length)
            len = string.length;
        
        NSString *str = [self.text stringByReplacingCharactersInRange:range withString:[string substringWithRange:NSMakeRange(0, len)]];
        self.text = str;
        
        return NO;
    }
}

/**在textField的代理中调用,把中文当成两个字符
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param count 输入框最大可输入字数
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitedCountChinesseAsTwoChar:(NSInteger) count
{
    UITextRange *textRange = [self markedTextRange];
    
    NSString *markText = [self textInRange:textRange];
    
    NSString *new = [self.text stringByReplacingCharactersInRange:range withString:string];
    
    NSInteger textLength = new.lengthWithChineseAsTwoChar;
    
    NSInteger length =  - (textRange.empty ? 0 : markText.lengthWithChineseAsTwoChar + 1);
    
    NSInteger res = count - length;
    
    
    if(res > 0)
    {
        return YES;
    }
    else
    {
        
        ///截取输入的字符串
        NSInteger len = 0;
        NSInteger index = 0;
        NSInteger maxLen = string.lengthWithChineseAsTwoChar - (textLength - count);
        
        if(maxLen > 0)
        {
            for(NSUInteger i = 0;i < string.length;i ++)
            {
                unichar c = [string characterAtIndex:i];
                
                ///判断是否是中文
                if(c > 0x4e00 && c < 0x9fff)
                {
                    len += 2;
                }
                else
                {
                    len ++;
                }
                index ++;
                if(len >= maxLen)
                    break;
            }
        }
        
        NSString *str = [string substringWithRange:NSMakeRange(0, MIN(index, string.length))];
        self.text = [new stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length + string.length) withString:str];
        self.selectedRange = NSMakeRange(range.location + str.length, 0);
        
        return NO;
    }
}


/**设置默认的附加视图
 *@param target 方法执行者
 *@param action 方法
 */
- (void)setDefaultInputAccessoryViewWithTarget:(id) target action:(SEL) action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SeaScreenWidth, 35.0)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    CGFloat buttonWidth = 60.0;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:UIKitTintColor forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setFrame:CGRectMake(SeaScreenWidth - buttonWidth, 0, buttonWidth, 35.0)];
    [view addSubview:button];
    self.inputAccessoryView = view;
}

/**在textField的代理中调用，限制只能输入一个小数点，并且第一个输入不能是小数点，无法输入除了数字和.以外的字符
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param limitedNum 输入框可输入的最大值
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitedNum:(double) limitedNum
{
    if(![string isEqualToString:@"."] && ![string isNumText])
    {
        return NO;
    }
    NSRange containRange = [string rangeOfString:@"."];
    
    if(containRange.location != NSNotFound)
    {
        //只能输入一个小数点
        containRange = [self.text rangeOfString:@"."];
        if(containRange.location != NSNotFound)
            return NO;
        
        //第一个输入不能是小数点
        if(self.text.length == 0)
        {
            if([string sea_firstCharacter] == [@"." sea_firstCharacter])
            {
                return NO;
            }
        }
    }
    
    
    NSString *new = [self.text stringByReplacingCharactersInRange:range withString:string];
    double value = [new doubleValue];
    
    return value <= limitedNum;
}

#pragma mark- 格式化

/**添加文本变化通知 用于中文输入限制，因为输入中文的时候 textField的代理是没有调用的
 */
- (void)addTextDidChangeNotification
{
    if(![self targetForAction:@selector(textFieldEditDidChange:) withSender:self])
    {
        [self addTarget:self action:@selector(textFieldEditDidChange:) forControlEvents:UIControlEventEditingChanged];
        self.previousText = self.text;
    }
}


///输入变化
- (void)textFieldEditDidChange:(id) sender
{
    NSInteger inputLimitMax = self.inputLimitMax;
    
    if(inputLimitMax == 0)
        return;
    // 简体中文输入，包括简体拼音，健体五笔，简体手写 //获取高亮部分
    UITextRange *markedRange = [self markedTextRange];
    
    if(!self.previousText)
    {
        self.previousText = self.text;
    }
    
    if(markedRange)
        return;
    
    NSString *text = self.text;
    NSInteger textLength = 0;
    
    ///中文输入限制
    if(self.chineseAsTwoCharWhenInputLimit)
    {
        textLength = text.lengthWithChineseAsTwoChar;
        if(textLength >= inputLimitMax)
        {
            NSInteger length = text.length - self.previousText.length;
            
            if(length < 0)
                length = 0;
            
            NSInteger loc = self.selectedRange.location - length;
            
            ///获取输入的text
            NSString *inputString = [text substringWithRange:NSMakeRange(loc, length)];
            
            ///截取输入的字符串
            NSInteger len = 0;
            NSInteger index = 0;
            NSInteger maxLen = inputString.lengthWithChineseAsTwoChar - (textLength - inputLimitMax);
            
            if(maxLen > 0)
            {
                for(NSUInteger i = 0;i < inputString.length;i ++)
                {
                    unichar c = [inputString characterAtIndex:i];
                    
                    ///判断是否是中文
                    if(c > 0x4e00 && c < 0x9fff)
                    {
                        len += 2;
                    }
                    else
                    {
                        len ++;
                    }
                    if(len > maxLen)
                        break;
                    
                    index ++;
                    
                    if(len == maxLen)
                        break;
                }
            }
            
            NSString *newString = [inputString substringWithRange:NSMakeRange(0, index)];
            
            self.text = [text stringByReplacingCharactersInRange:NSMakeRange(loc, inputString.length) withString:newString];
            
            ///设定光标位置
            self.selectedRange = NSMakeRange(MIN(self.text.length, loc + index), 0);
        }
        
    }
    else if(text.length > inputLimitMax)
    {
        textLength = text.length;
        NSInteger length = text.length - self.previousText.length;
        if(length < 0)
            length = 0;
        
        NSInteger loc = self.selectedRange.location - length;
        
        ///获取输入的text
        NSString *inputString = [text substringWithRange:NSMakeRange(loc, MAX(0, length))];
        
        ///截取输入的字符串
        NSInteger maxLen = inputString.length - (textLength - inputLimitMax);
        
        NSString *newString = [inputString substringWithRange:NSMakeRange(0, MAX(0, maxLen))];
        
        self.text = [text stringByReplacingCharactersInRange:NSMakeRange(loc, inputString.length) withString:newString];
        
        ///设定光标位置
        self.selectedRange = NSMakeRange(MIN(self.text.length, loc + newString.length), 0);
    }
    
    self.previousText = self.text;
}

/**在textField的代理中调用
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param interval 格式化间隔，如4个字符空一格
 *@param count 输入框最大可输入字数
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string formatTextWithInterval:(int) interval limitCount:(NSInteger) count
{
    NSString *text = [self text];
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
        return NO;
    }
    
    text = [text stringByReplacingCharactersInRange:range withString:string];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    NSString *newString = @"";
    while (text.length > 0) {
        NSString *subString = [text substringToIndex:MIN(text.length, interval)];
        newString = [newString stringByAppendingString:subString];
        if (subString.length == interval) {
            newString = [newString stringByAppendingString:@" "];
        }
        text = [text substringFromIndex:MIN(text.length, interval)];
    }
    
    newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
    
    if (newString.length >= count + ceil((double)count / (double)interval))
    {
        return NO;
    }
    
    [self setText:newString];
    
    return NO;
}

/**在textField的代理中调用，限制只能输入一个小数点，并且可补全字符串
 *@param range 文本变化的范围
 *@param string 替换的文字
 *@param limitedNum 输入框可输入的最大值
 *@param repairString 补全字符
 */
- (BOOL)textShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string limitedNum:(double) limitedNum repairString:(NSString*) repairString
{
    if(![string isEqualToString:@"."] && ![string isNumText])
    {
        return NO;
    }
    
    NSRange containRange = [string rangeOfString:@"."];
    
    if(containRange.location != NSNotFound)
    {
        //只能输入一个小数点
        containRange = [self.text rangeOfString:@"."];
        if(containRange.location != NSNotFound)
            return NO;
        
        //第一个输入不能是小数点
        if(self.text.length == 0)
        {
            if([string sea_firstCharacter] == [@"." sea_firstCharacter])
            {
                return NO;
            }
        }
    }
    
    //要删除补全的字符
    if ( string.length == 0 && range.length == 1 && [[self.text substringWithRange:range] isEqualToString:repairString])
    {
        [self setSelectedRange:NSMakeRange(range.location, 0)];
        return NO;
    }
    
    NSString *newString = [[self.text stringByReplacingCharactersInRange:range withString:string] stringByReplacingOccurrencesOfString:repairString withString:@""];
    
    NSInteger location = 0;
    if([newString doubleValue] <= limitedNum)
    {
        if(newString.length != 0)
        {
            newString = [newString stringByAppendingString:repairString];
        }
        self.text = newString;
        location = range.location + string.length;
        
        if(location >= repairString.length && location >= self.text.length)
        {
            location -= repairString.length;
        }
    }
    else
    {
        location = range.location;
    }
    
    [self setSelectedRange:NSMakeRange(location, 0)];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
    
    return NO;
}

/**固定电话格式化
 *@param range 文本变化的范围
 *@param string 替换的文字
 */
- (BOOL)telPhoneNumberShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = self.text;
    
    NSInteger stringLength = string.length;
    
    ///判断是否是删除
    if(string.length == 0 && text.length >= 4)
    {
        ///删除-时，应该删除前面的数字
        NSString *deleteString = [self.text substringWithRange:range];
        if([deleteString isEqualToString:@"-"])
        {
            range.length ++;
            range.location --;
        }
    }
    
    NSString *number = [text stringByReplacingCharactersInRange:range withString:string];
    
    ///去掉超出范围的内容
    if(number.length > 30)
    {
        NSInteger length = number.length - 30;
        stringLength -= length;
        NSRange deleteRange = NSMakeRange(range.location + string.length - length, length);
        if(deleteRange.location + deleteRange.length <= number.length)
        {
            number = [number stringByReplacingCharactersInRange:deleteRange withString:@""];
        }
    }
    
    number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if(number.length >= 4)
    {
        NSInteger codeIndex = 0;
        ///区号3位
        if([number hasPrefix:@"02"] || [number hasPrefix:@"01"] || [number hasPrefix:@"85"])
        {
            codeIndex = 3;
        }
        else if(number.length > 4)
        {
            ///区号四位
            codeIndex = 4;
        }
        
        if(codeIndex != 0)
        {
            NSRange selectedRange = self.selectedRange;
            self.text = [number stringByReplacingCharactersInRange:NSMakeRange(codeIndex, 0) withString:@"-"];
            
            ///把光标定回以前的位置
            if(selectedRange.location > 0 && selectedRange.location != self.text.length - stringLength)
            {
                selectedRange.location -= range.length - stringLength;
                selectedRange.length = 0;
                
                self.selectedRange = selectedRange;
            }
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark- property

- (void)setForbidSelectors:(NSString *)forbidSelectors
{
    objc_setAssociatedObject(self, &SeaForbidSelectorsKey, forbidSelectors, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray*)forbidSelectors
{
    return objc_getAssociatedObject(self, &SeaForbidSelectorsKey);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSArray *forbidSelectors = self.forbidSelectors;
    if(forbidSelectors.count > 0)
    {
        if([forbidSelectors containsObject:NSStringFromSelector(action)])
        {
            return NO;
        }
    }
    
    if(action == @selector(paste:))
    {
        return YES;
    }
    
    if(self.text.length > 0)
    {
        NSRange range = self.selectedRange;
        if(range.length > 0)
        {
            if(action == @selector(cut:) || action == @selector(copy:) || action == @selector(selectAll:))
            {
                return YES;
            }
        }
        else
        {
            if(action == @selector(select:) || action == @selector(selectAll:))
            {
                return YES;
            }
        }
    }
    
    
    return NO;
}

///获取光标位置
- (NSRange)selectedRange
{
    UITextPosition *beginning = self.beginningOfDocument;
    
    UITextRange *selectedRange = self.selectedTextRange;
    UITextPosition *selectionStart = selectedRange.start;
    UITextPosition *selectionEnd = selectedRange.end;
    
    const NSInteger location = [self offsetFromPosition:beginning toPosition:selectionStart];
    const NSInteger length = [self offsetFromPosition:selectionStart toPosition:selectionEnd];
    
    return NSMakeRange(location, length);
}

///设置光标位置
- (void)setSelectedRange:(NSRange) range
{
    UITextPosition *start = [self positionFromPosition:[self beginningOfDocument]
                                                offset:range.location];
    
    UITextPosition *end = [self positionFromPosition:start
                                              offset:range.length];
    
    [self setSelectedTextRange:[self textRangeFromPosition:start toPosition:end]];
}

///输入限制时是否把中文当成两个字符 default is 'NO'
- (void)setChineseAsTwoCharWhenInputLimit:(BOOL)chineseAsTwoCharWhenInputLimit
{
    objc_setAssociatedObject(self, &SeaChineseAsTwoCharWhenInputLimitKey, [NSNumber numberWithBool:chineseAsTwoCharWhenInputLimit], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)chineseAsTwoCharWhenInputLimit
{
    return [objc_getAssociatedObject(self, &SeaChineseAsTwoCharWhenInputLimitKey) boolValue];
}

///最大输入限制 default is '0'，无输入限制
- (void)setInputLimitMax:(NSInteger)inputLimitMax
{
    objc_setAssociatedObject(self, &SeaInputLimitMaxKey, [NSNumber numberWithInteger:inputLimitMax], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)inputLimitMax
{
    return [objc_getAssociatedObject(self, &SeaInputLimitMaxKey) integerValue];
}

///输入改变前的文本
- (void)setPreviousText:(NSString *)previousText
{
    objc_setAssociatedObject(self, &SeaPreviousTextKey, previousText, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString*)previousText
{
    return objc_getAssociatedObject(self, &SeaPreviousTextKey);
}

///禁止输入中文
- (void)setForbidInputChinese:(BOOL)forbidInputChinese
{
    objc_setAssociatedObject(self, &SeaForbidInputChineseKey, [NSNumber numberWithBool:forbidInputChinese], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)forbidInputChinese
{
    return [objc_getAssociatedObject(self, &SeaForbidInputChineseKey) boolValue];
}


@end
