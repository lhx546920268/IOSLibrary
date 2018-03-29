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

static char SeaForbiddenActionsKey;
static char SeaMaxLengthKey;
static char SeaTextTypeKey;
static char SeaExtraStringKey;

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

- (UIView*)sea_setDefaultSeparator
{
    return [self sea_setSeparatorWithColor:SeaSeparatorColor height:SeaSeparatorWidth];
}

- (UIView*)sea_setSeparatorWithColor:(UIColor *)color height:(CGFloat)height
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
        [separator sea_heightToSelf:SeaSeparatorWidth];
        
        objc_setAssociatedObject(self, _cmd, separator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return separator;
}

- (void)setDefaultInputAccessoryView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 35.0)];
    view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [button setTitle:@"完成" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(handleTapInputAccessoryView:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    
    [button sea_rightToSuperview];
    [button sea_topToSuperview];
    [button sea_bottomToSuperview];
    [button sea_widthToSelf:60];
    
    self.inputAccessoryView = view;
}

///点击完成
- (void)handleTapInputAccessoryView:(id) sender
{
    [self resignFirstResponder];
}

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
    
    if (newString.length >= count + ceil((double)count / (double)interval)){
        return NO;
    }
    
    [self setText:newString];
    
    return NO;
}

- (BOOL)telPhoneNumberShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *text = self.text;
    
    NSInteger stringLength = string.length;
    
    ///判断是否是删除
    if(string.length == 0 && text.length >= 4){
        ///删除-时，应该删除前面的数字
        NSString *deleteString = [self.text substringWithRange:range];
        if([deleteString isEqualToString:@"-"]){
            range.length ++;
            range.location --;
        }
    }
    
    NSString *number = [text stringByReplacingCharactersInRange:range withString:string];
    
    ///去掉超出范围的内容
    if(number.length > 30){
        NSInteger length = number.length - 30;
        stringLength -= length;
        NSRange deleteRange = NSMakeRange(range.location + string.length - length, length);
        if(deleteRange.location + deleteRange.length <= number.length){
            number = [number stringByReplacingCharactersInRange:deleteRange withString:@""];
        }
    }
    
    number = [number stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    if(number.length >= 4){
        NSInteger codeIndex = 0;
        ///区号3位
        if([number hasPrefix:@"02"] || [number hasPrefix:@"01"] || [number hasPrefix:@"85"]){
            codeIndex = 3;
        }else if(number.length > 4){
            ///区号四位
            codeIndex = 4;
        }
        
        if(codeIndex != 0){
            NSRange selectedRange = self.sea_selectedRange;
            self.text = [number stringByReplacingCharactersInRange:NSMakeRange(codeIndex, 0) withString:@"-"];
            
            ///把光标定回以前的位置
            if(selectedRange.location > 0 && selectedRange.location != self.text.length - stringLength){
                selectedRange.location -= range.length - stringLength;
                selectedRange.length = 0;
                
                self.sea_selectedRange = selectedRange;
            }
            
            return NO;
        }
    }
    
    return YES;
}

#pragma mark- 文本限制

- (BOOL)sea_shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //删除
    NSString *extraString = self.sea_extraString;
    if(string.length == 0 && range.location >= self.text.length - extraString.length){
        self.sea_selectedRange = NSMakeRange(self.text.length - extraString.length, 0);
        return NO;
    }
    return YES;
}

- (void)setSea_maxLength:(NSUInteger) length
{
    objc_setAssociatedObject(self, &SeaMaxLengthKey, @(length), OBJC_ASSOCIATION_RETAIN);
    [self shouldObserveEditingChange];
}

- (NSUInteger)sea_maxLength
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaMaxLengthKey);
    return number ? [number unsignedIntegerValue] : NSUIntegerMax;
}

- (void)setSea_textType:(SeaTextType) textType
{
    objc_setAssociatedObject(self, &SeaTextTypeKey, @(textType), OBJC_ASSOCIATION_RETAIN);
    [self shouldObserveEditingChange];
}

- (SeaTextType)sea_textType
{
    NSNumber *number = objc_getAssociatedObject(self, &SeaTextTypeKey);
    return number ? [number unsignedIntegerValue] : SeaTextTypeAll;
}

- (void)setSea_extraString:(NSString *) extraString
{
    objc_setAssociatedObject(self, &SeaExtraStringKey, extraString, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self shouldObserveEditingChange];
}

- (NSString*)sea_extraString
{
    return objc_getAssociatedObject(self, &SeaExtraStringKey);
}

///获取光标位置
- (NSRange)sea_selectedRange
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
- (void)setSea_selectedRange:(NSRange) range
{
    UITextPosition *start = [self positionFromPosition:self.beginningOfDocument
                                                offset:range.location];
    UITextPosition *end = [self positionFromPosition:start
                                              offset:range.length];
    
    [self setSelectedTextRange:[self textRangeFromPosition:start toPosition:end]];
}

- (void)setSea_forbiddenActions:(NSArray<NSString*>*) actions
{
    objc_setAssociatedObject(self, &SeaForbiddenActionsKey, actions, OBJC_ASSOCIATION_RETAIN);
}

- (NSArray<NSString*>*)sea_forbiddenActions
{
    return objc_getAssociatedObject(self, &SeaForbiddenActionsKey);
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    NSArray *actions = self.sea_forbiddenActions;
    if(actions.count > 0){
        if([actions containsObject:NSStringFromSelector(action)]){
            return NO;
        }
    }
    
    if(action == @selector(paste:)){
        return YES;
    }
    
    if(self.text.length > 0){
        NSRange range = self.sea_selectedRange;
        if(range.length > 0){
            if(action == @selector(cut:) || action == @selector(copy:) || action == @selector(selectAll:)){
                return YES;
            }
        }else{
            if(action == @selector(select:) || action == @selector(selectAll:)){
                return YES;
            }
        }
    }
    
    return NO;
}

#pragma mark- Edit change

///是否需要监听输入变化
- (void)shouldObserveEditingChange
{
    SEL action = @selector(textFieldTextDidChange:);
    if(!(self.sea_textType & SeaTextTypeAll) || self.sea_maxLength > 0){
        if(![self targetForAction:action withSender:self]){
            [self addTarget:self action:action forControlEvents:UIControlEventEditingChanged];
        }
    }else{
        [self removeTarget:self action:action forControlEvents:UIControlEventEditingChanged];
    }
}

///文字输入改变
- (void)textFieldTextDidChange:(UITextField*) textField
{
    NSString *text = textField.text;
    
    //有输入法情况下忽略
    if(!textField.markedTextRange && text.length != 0){
        
        SeaTextType type = textField.sea_textType;
        
        NSUInteger maxLength = textField.sea_maxLength;
        NSRange range = textField.sea_selectedRange;
        
        if([text isEqualToString:@"."]){
            textField.text = @"";
            return;
        }
        
        //小数
        if(type == SeaTextTypeDecimal){
            NSUInteger pointIndex = [text sea_lastIndexOfCharacter:'.'];
            if(pointIndex != NSNotFound){
                //有多个点，删除前面的点
                NSRange pointRange = [text rangeOfString:@"."];
                if(pointRange.location != pointIndex){
                    NSString *result = [text stringByReplacingOccurrencesOfString:@"." withString:@"" options:NSLiteralSearch range:NSMakeRange(0, pointIndex)];
                    if(pointRange.location < range.location){
                        range.location -= text.length - result.length;
                    }
                    text = result;
                }
            }
        }
        
        //额外的字符串
        NSString *extraString = self.sea_extraString;
        if(extraString.length > 0 && text.length >= extraString.length){
            if([text isEqualToString:extraString]){
                textField.text = @"";
                return;
            }else{
                NSRange extraRange = NSMakeRange(text.length - extraString.length, extraString.length);
                NSString *extra = [text substringWithRange:extraRange];
                if([extra isEqualToString:extraString]){
                    text = [text stringByReplacingCharactersInRange:extraRange withString:@""];
                }
            }
        }
        
        //删除超过长度的字符串
        if(text.length > maxLength){
            NSUInteger length = text.length - maxLength;
            
            //NSUInteger 没有负值
            NSUInteger location = range.location >= length ? range.location - length : 0;
            
            range.location = location;
            text = [text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
        }
        
        text = [text sea_stringByFilterWithType:type];
        
        //添加额外字符串
        if(text.length > 0 && extraString.length > 0){
            text = [text stringByAppendingString:extraString];
            if(range.location > text.length - extraString.length){
                range.location = text.length - extraString.length;
            }
        }
        
        textField.text = text;
        if(range.location < text.length){
            textField.sea_selectedRange = range;
        }
    }
}

@end
