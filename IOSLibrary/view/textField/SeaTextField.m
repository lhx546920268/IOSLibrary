//
//  SeaTextField.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/9.
//  Copyright (c) 2015年 qianseit. All rights reserved.
//

#import "SeaTextField.h"
#import "NSString+Utilities.h"
#import "UIView+Utils.h"

@interface SeaTextField ()

///是否是自身设置 selectedTextRange
@property(nonatomic,assign) BOOL isSelfSetSelectedTextRange;

///光标位置
@property(nonatomic,assign) NSRange selectedRange;

///补全字体宽度
@property(nonatomic,assign) CGSize repairSize;

///编辑区域
@property(nonatomic,assign) CGRect editRect;

@end

@implementation SeaTextField

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initialization];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initialization];
    }
    return self;
}

///初始化
- (void)initialization
{
    self.repairPosition = SeaTextFieldRepairPositionFront;
    self.repairString = @"元";
    self.repairSize = [self.repairString stringSizeWithFont:self.font contraintWith:self.width];
}

- (void)setRepairString:(NSString *)repairString
{
    if([_repairString isEqualToString:repairString])
    {
        _repairString = [repairString copy];
        
        if([self actionsForTarget:self forControlEvent:UIControlEventTouchUpInside].count == 0)
        {
            [self addTarget:self action:@selector(contentDidChange:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (void)setSelectedTextRange:(UITextRange *)selectedTextRange
{
    [super setSelectedTextRange:selectedTextRange];
    
    if(self.repairString.length > 0 && !self.isSelfSetSelectedTextRange)
    {
        switch (self.repairPosition)
        {
            case SeaTextFieldRepairPositionFront :
            {
                
            }
                break;
            case SeaTextFieldRepairPositionBack :
            {
                
            }
                break;
        }
    }
    
    self.isSelfSetSelectedTextRange = NO;
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
    self.isSelfSetSelectedTextRange = YES;
    UITextPosition *start = [self positionFromPosition:[self beginningOfDocument]
                                                offset:range.location];
    
    UITextPosition *end = [self positionFromPosition:start
                                              offset:range.length];
    
    [self setSelectedTextRange:[self textRangeFromPosition:start toPosition:end]];
}

#pragma mark- private medthod

///内容改变
- (void)contentDidChange:(UITextField*) textField
{
    
}


@end
