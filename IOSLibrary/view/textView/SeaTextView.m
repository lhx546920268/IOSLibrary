//
//  SSTextView.m
//  SSToolkit
//
//  Created by Sam Soffes on 8/18/10.
//  Copyright 2010-2011 Sam Soffes. All rights reserved.
//

#import "SeaTextView.h"
#import "SeaBasic.h"

#define _controlHeight_ 30

@interface SeaTextView ()

//滚动次数
@property(nonatomic,assign) NSInteger scrollCount;

///占位
@property(nonatomic,strong) UILabel *placeHolderLabel;

- (void)_initialize;
- (void)_updateShouldDrawPlaceholder;
- (void)_textChanged:(NSNotification *)notification;


@end


@implementation SeaTextView
{
	BOOL _shouldDrawPlaceholder;
}


#pragma mark - Accessors

@synthesize placeholder = _placeholder;
@synthesize placeholderTextColor = _placeholderTextColor;

- (void)setText:(NSString *)text
{
    [super setText:text];
    
    NSString *str = [NSString stringWithFormat:@"%d", (int)self.text.length];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%d", str, (int)self.maxCount]];
    [attr addAttribute:NSForegroundColorAttributeName value:WMGreenColor range:NSMakeRange(0, str.length)];
    self.numLabel.attributedText = attr;
    
	[self _updateShouldDrawPlaceholder];
    [self setNeedsLayout];
}


- (void)setPlaceholder:(NSString *)placeholder
{
	if ([placeholder isEqual:_placeholder])
    {
		return;
	}
	
	_placeholder = [placeholder copy];
    
    if(_shouldDrawPlaceholder)
    {
        _shouldDrawPlaceholder = NO;
    }

    [self updatePlaceHolder];
    
	[self _updateShouldDrawPlaceholder];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont
{
    if(![_placeholderFont isEqualToFont:placeholderFont])
    {
        _placeholderFont = placeholderFont;
        [self updatePlaceHolder];
    }
}

- (void)setPlaceholderTextColor:(UIColor *)placeholderTextColor
{
    if(![_placeholderTextColor isEqualToColor:placeholderTextColor])
    {
        _placeholderTextColor = placeholderTextColor;
        self.placeHolderLabel.textColor = _placeholderTextColor;
    }
}

- (void)setPlaceholderOffset:(CGPoint)placeholderOffset
{
    if(!CGPointEqualToPoint(_placeholderOffset, placeholderOffset))
    {
        _placeholderOffset = placeholderOffset;
        
        [self.placeHolderLabel sea_layoutConstraintForAttribute:NSLayoutAttributeLeading].constant = _placeholderOffset.x;
        [self.placeHolderLabel sea_layoutConstraintForAttribute:NSLayoutAttributeTrailing].constant = _placeholderOffset.x;
        self.placeHolderLabel.sea_topLayoutConstraint.constant = placeholderOffset.y;
    }
}

///更新
- (void)updatePlaceHolder
{
    if([NSString isEmpty:self.placeholder])
        return;
    if(!self.placeHolderLabel)
    {
        self.placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel.textColor = self.placeholderTextColor;
        self.placeHolderLabel.font = self.placeholderFont;
        self.placeHolderLabel.hidden = YES;
        self.placeHolderLabel.numberOfLines = 0;
        self.placeHolderLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.placeHolderLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_placeHolderLabel);
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-%f-[_placeHolderLabel]-%f-|", _placeholderOffset.x, _placeholderOffset.x] options:0 metrics:nil views:views]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeHolderLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-%f-[_placeHolderLabel]", _placeholderOffset.y] options:0 metrics:nil views:views]];
        
    }

    self.placeHolderLabel.text = self.placeholder;
}


#pragma mark - NSObject

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}


#pragma mark - UIView

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
    {
        self.limitable = NO;
		[self _initialize];
	}
	return self;
}


- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
    {
		[self _initialize];
        self.limitable = NO;
	}
	return self;
}

#pragma mark- property

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _numLabel.frame = CGRectMake(self.width - _numLabel.width - 6.0, self.height - _numLabel.height, _numLabel.width, _numLabel.height);
    [self updatePlaceHolder];
}

- (void)setLimitable:(BOOL)limitable
{
    if(_limitable != limitable)
    {
        _limitable = limitable;
        if(!_numLabel)
        {
            _numLabel = [[UILabel alloc] init];
            _numLabel.backgroundColor = [UIColor clearColor];
            [_numLabel setTextAlignment:NSTextAlignmentRight];
            _numLabel.textColor = [UIColor grayColor];
            _numLabel.translatesAutoresizingMaskIntoConstraints = NO;
            _numLabel.font = [UIFont fontWithName:SeaMainNumberFontName size:14.0];
            [self addSubview:_numLabel];
            
            NSDictionary *views = NSDictionaryOfVariableBindings(_numLabel);
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[_numLabel]-8-|" options:0 metrics:nil views:views]];
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_numLabel]-8-|" options:0 metrics:nil views:views]];
            
            NSString *str = [NSString stringWithFormat:@"%d", (int)self.text.length];
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%d", str, (int)self.maxCount]];
            [attr addAttribute:NSForegroundColorAttributeName value:WMGreenColor range:NSMakeRange(0, str.length)];
            _numLabel.attributedText = attr;

        }
        _numLabel.hidden = !_limitable;
    }
}

- (void)setMaxCount:(NSInteger)maxCount
{
    if(_maxCount != maxCount)
    {
        _maxCount = maxCount;
        NSString *str = [NSString stringWithFormat:@"%d", (int)self.text.length];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%d", str, (int)_maxCount]];
        [attr addAttribute:NSForegroundColorAttributeName value:WMGreenColor range:NSMakeRange(0, str.length)];
        self.numLabel.attributedText = attr;
    }
}


#pragma mark- draw

///ios 9 在 iphone5s 上回出现一条横线
//- (void)drawRect:(CGRect)rect
//{
//    [super drawRect:rect];
//    
//    if (_shouldDrawPlaceholder)
//    {
//        [_placeholder drawInRect:CGRectMake(_placeholderOffset.x, _placeholderOffset.y, self.frame.size.width - _placeholderOffset.x * 2, self.frame.size.height - _placeholderOffset.y * 2) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.placeholderFont, NSFontAttributeName, self.placeholderTextColor, NSForegroundColorAttributeName, nil]];
//    }
//    
//}


- (void)layoutSubviews
{
    [super layoutSubviews];

    _numLabel.frame = CGRectMake(_numLabel.left, self.bounds.origin.y + self.bounds.size.height - _numLabel.height - 8.0, _numLabel.width, _numLabel.height);
}

#pragma mark - Private

- (void)_initialize
{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_textChanged:) name:UITextViewTextDidChangeNotification object:self];
	
    self.placeholderFont = [UIFont fontWithName:SeaMainFontName size:15.0];
	self.placeholderTextColor = [UIColor colorWithWhite:0.702f alpha:0.7];
	_shouldDrawPlaceholder = NO;
    self.placeholderOffset = CGPointMake(8.0f, 8.0f);
}


- (void)_updateShouldDrawPlaceholder
{
  //  BOOL prev = _shouldDrawPlaceholder;
	_shouldDrawPlaceholder = self.placeholder && self.placeholderTextColor && self.text.length == 0;

    self.placeHolderLabel.hidden = !_shouldDrawPlaceholder;
//	if (prev != _shouldDrawPlaceholder) {
//		[self setNeedsDisplay];
//	}
}


- (void)_textChanged:(NSNotification *)notification
{
	[self _updateShouldDrawPlaceholder];
}

#pragma mark- 文本限制

/**内容改变
 */
- (void)textDidChange
{
    if (self.markedTextRange == nil && self.text.length > self.maxCount)
    {
        NSString *str = [self.text substringWithRange:NSMakeRange(0, self.maxCount)];
        self.text = str;
    }
    
    if(self.limitable)
    {
        NSString *str = [NSString stringWithFormat:@"%d", (int)self.text.length];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%d", str, (int)self.maxCount]];
        [attr addAttribute:NSForegroundColorAttributeName value:WMGreenColor range:NSMakeRange(0, str.length)];
        self.numLabel.attributedText = attr;
    }
}

/**是否替换内容
 *@param range 替换的范围
 *@param text 新的内容
 *@return 是否替换
 */
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    UITextRange *textRange = [self markedTextRange];
    
    NSString *markText = [self textInRange:textRange];
    
    NSString *new = [self.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger length = new.length - (textRange.empty ? 0 : markText.length + 1);
    
    NSInteger res = self.maxCount - MAX(length, 0);
    
    
    NSString *str = [NSString stringWithFormat:@"%d", (int)(self.maxCount - res)];
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%d", str, (int)self.maxCount]];
    [attr addAttribute:NSForegroundColorAttributeName value:WMGreenColor range:NSMakeRange(0, str.length)];
    
    
    self.numLabel.attributedText = attr;
    
    if(res > 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = self.maxCount - self.text.length;
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

@end
