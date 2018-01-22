//
//  SeaTextView.m
//  IOSLibrary
//
//  Created by 罗海雄 on 2018/1/8.
//  Copyright © 2018年 罗海雄. All rights reserved.
//

#import "SeaTextView.h"
#import "NSString+Utils.h"
#import "SeaBasic.h"

@protocol UITextPasteConfigurationSupporting;

@interface SeaTextView()<UITextPasteDelegate>

@end

@implementation SeaTextView


- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialization];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        [self initialization];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self updatePlaceholder];
}

- (void)setFont:(UIFont *)font
{
    [super setFont:font];
    if(!_placeholderFont){
        _placeholderFont = font;
        [self updatePlaceholder];
    }
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if ([placeholder isEqual:_placeholder]){
        return;
    }
    
    _placeholder = [placeholder copy];
    [self updatePlaceholder];
}

- (void)setPlaceholderFont:(UIFont *) font
{
    if(_placeholderFont != font){
        _placeholderFont = font;
        if(!_placeholderFont){
            _placeholderFont = self.font;
        }
        [self updatePlaceholder];
    }
}

- (void)setPlaceholderTextColor:(UIColor *) textColor
{
    if(!textColor)
        textColor = SeaPlaceholderTextColor;
    _placeholderTextColor = textColor;
    [self updatePlaceholder];
}

- (void)setPlaceholderOffset:(CGPoint) offset
{
    if(!CGPointEqualToPoint(_placeholderOffset, offset)){
        _placeholderOffset = offset;
        [self updatePlaceholder];
    }
}

- (void)setMaxLength:(NSUInteger)maxLength
{
    if(_maxLength != maxLength){
        _maxLength = maxLength;
        [self updatePlaceholder];
    }
}

- (void)setShouldDisplayTextLength:(BOOL)shouldDisplayTextLength
{
    if(_shouldDisplayTextLength != shouldDisplayTextLength){
        _shouldDisplayTextLength = shouldDisplayTextLength;
        [self updatePlaceholder];
    }
}

- (void)setTextLengthAttributes:(NSDictionary *)textLengthAttributes
{
    if(textLengthAttributes.count == 0)
        textLengthAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:SeaMainFontName size:13.0], NSFontAttributeName, [UIColor lightGrayColor], NSForegroundColorAttributeName, nil];
    _textLengthAttributes = textLengthAttributes;
    [self updatePlaceholder];
}

#pragma mark - NSObject

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark- draw

///ios 9 在 iphone5s 上会出现一条横线
- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    
    //绘制placeholder
    if(![NSString isEmpty:self.placeholder] && self.text.length == 0){
        
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                               self.placeholderFont, NSFontAttributeName, self.placeholderTextColor, NSForegroundColorAttributeName, nil];
        [_placeholder drawInRect:CGRectMake(_placeholderOffset.x, _placeholderOffset.y, width - _placeholderOffset.x * 2, height - _placeholderOffset.y * 2)
                  withAttributes:attrs];
    }
    
    //绘制输入的文字数量和限制
    if(self.shouldDisplayTextLength && self.maxLength != NSUIntegerMax){
        
        CGFloat padding = 8;
        NSString *text = [self textByRemoveMarkedRange];
        NSString *string = [NSString stringWithFormat:@"%d/%d", (int)text.length, (int)self.maxLength];
        
        NSDictionary *attrs = self.textLengthAttributes;
        CGSize size = [string sizeWithAttributes:attrs];
        [string drawInRect:CGRectMake(width - size.width - padding, height - size.height - padding, size.width, size.height) withAttributes: attrs];
    }
}

///获取去除markedText的 text
- (NSString*)textByRemoveMarkedRange
{
    NSString *text = self.text;
    UITextRange *markedTextRange = self.markedTextRange;
    if(markedTextRange){
        const NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:markedTextRange.start];
        const NSInteger length = [self offsetFromPosition:markedTextRange.start toPosition:markedTextRange.end];
        
        NSRange range = NSMakeRange(location, length);
        text = [text stringByReplacingCharactersInRange:range withString:@""];
    }
    
    return text;
}

#pragma mark- private method

///初始化
- (void)initialization
{
    _maxLength = NSUIntegerMax;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sea_textDidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    self.placeholderFont = [UIFont fontWithName:SeaMainFontName size:15.0];
    self.placeholderTextColor = nil;
    self.placeholderOffset = CGPointMake(8.0f, 8.0f);
    self.textLengthAttributes = nil;
    
    if(@available(iOS 11.0, *)){
        self.pasteDelegate = self;
    }
}

///更新placeholder
- (void)updatePlaceholder
{
    [self setNeedsDisplay];
}

///文字输入改变
- (void)sea_textDidChange:(NSNotification *)notification
{
    [self updatePlaceholder];
    
    NSString *text = self.text;
    
    //有输入法情况下忽略
    if(!self.markedTextRange && text.length != 0 && self.maxLength != NSUIntegerMax){
        
        NSUInteger maxLength = self.maxLength;
        
        //删除超过长度的字符串
        if(text.length > maxLength){
            NSUInteger length = text.length - maxLength;
            NSRange range = self.selectedRange;
            
            //NSUInteger 没有负值
            NSUInteger location = range.location >= length ? range.location - length : 0;
            
            range.location = location;
            text = [text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
            self.text = text;
            if(range.location < text.length){
                self.selectedRange = range;
            }
        }
    }
}

#pragma mark- UITextPasteDelegate

///ios 11才有
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
- (BOOL)textPasteConfigurationSupporting:(id<UITextPasteConfigurationSupporting>)textPasteConfigurationSupporting shouldAnimatePasteOfAttributedString:(NSAttributedString *)attributedString toRange:(UITextRange *)textRange
{
    return false;
}
#pragma clang diagnostic pop

@end
