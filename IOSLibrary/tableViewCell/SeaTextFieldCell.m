//
//  SeaTextFieldCell.m
//  StandardFenXiao
//
//  Created by 罗海雄 on 15/12/1.
//  Copyright (c) 2015年 罗海雄. All rights reserved.
//

#import "SeaTextFieldCell.h"
#import "UIView+Utils.h"
#import "SeaCountDownButton.h"
#import "UIImageView+SeaImageCache.h"
#import "SeaBasic.h"

@implementation SeaTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.titleWidth = 80.0;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:SeaMainFontName size:15.0];
        [self.contentView addSubview:_titleLabel];
        
        _textField = [[UITextField alloc] init];
        _textField.borderStyle = UITextBorderStyleNone;
        _textField.font = _titleLabel.font;
        _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.contentView addSubview:_textField];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.frame = CGRectMake(SeaTextFieldCellMargin, 0, self.titleWidth, self.contentView.height);
    _textField.frame = CGRectMake(_titleLabel.right + SeaTextFieldCellInterval, 0, self.contentView.width - _titleLabel.right - SeaTextFieldCellInterval - SeaTextFieldCellMargin, self.contentView.height);
}

@end

@implementation SeaDownArrowTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *downArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down_arrow"]];
        
        self.textField.rightView = downArrow;
        
        self.textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    return self;
}

@end



@implementation SeaCountDownTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80.0, 30.0)];
        _countDownButton = [[SeaCountDownButton alloc] initWithFrame:CGRectMake(0, 0, 80.0, 30.0)];
        [_countDownButton addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:_countDownButton];
   
        self.textField.rightView = view;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
    }
    
    return self;
}

///获取验证码
- (void)getCode:(SeaCountDownButton*) btn
{
    !self.getCodeHandler ?: self.getCodeHandler();
}

- (void)dealloc
{
    [_countDownButton stopTimer];
}

@end

@implementation SeaImageCodeTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        _code_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64.0, 20.0)];
        _code_imageView.contentMode = UIViewContentModeScaleAspectFit;
        _code_imageView.userInteractionEnabled = YES;

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(codeDidChange:)];
        [_code_imageView addGestureRecognizer:tap];

        self.textField.rightView = _code_imageView;
        self.textField.rightViewMode = UITextFieldViewModeAlways;
    }

    return self;
}

- (void)setCodeURL:(NSString *)codeURL
{
    if(_codeURL != codeURL)
    {
        _codeURL = codeURL;
        [self refreshCode];
    }
}

- (void)codeDidChange:(id) sender
{
    if(self.codeURL)
    {
        self.textField.text = nil;
        //写在cookie里
        [_code_imageView sea_setImageWithURL:[NSString stringWithFormat:@"%@?%.0f", self.codeURL, [[NSDate date] timeIntervalSince1970]]];
    }
}

///刷新验证码
- (void)refreshCode
{
    [self codeDidChange:nil];
}

@end


@implementation SeaTextFieldInfo

- (NSString*)classString
{
    if(!_classString)
    {
        return NSStringFromClass([SeaTextFieldCell class]);
    }
    
    return _classString;
}

- (SeaTextFieldCell*)cell
{
    if(!_cell)
    {
        _cell = [[NSClassFromString(self.classString) alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];;
        if([_cell isKindOfClass:[SeaCountDownTextFieldCell class]])
        {
            self.countDownBtn = [(SeaCountDownTextFieldCell*)_cell countDownButton];
        }
    }
    
    return _cell;
}

@end
