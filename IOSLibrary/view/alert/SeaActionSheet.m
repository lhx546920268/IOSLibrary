//
//  SeaActionSheet.m
//  Sea
//
//  Created by 罗海雄 on 15/8/5.
//  Copyright (c) 2015年 Sea. All rights reserved.
//

#import "SeaActionSheet.h"
#import "SeaHighlightView.h"
#import "SeaHighlightButton.h"
#import "SeaBasic.h"

//系统默认的蓝色
#define UIKitTintColor [UIColor colorWithRed:0 green:0.4784314 blue:1.0 alpha:1.0]

//边距
#define SeaActionSheetMargin 10.0

//文本边距
#define SeaActionSheetHeaderTextMargin 10.0

//圆角
#define SeaActionSheetCornerRadius 8.0

//按钮高度
#define SeaActionSheetButtonHeight 45.0

#pragma mark- header

/**弹窗表头
 */
@interface SeaActionSheetHeader : UIView

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

@end

@implementation SeaActionSheetHeader

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, SeaScreenWidth - SeaActionSheetMargin * 2, 0)];
    if(self)
    {
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(SeaActionSheetHeaderTextMargin, SeaActionSheetHeaderTextMargin, self.width - SeaActionSheetHeaderTextMargin * 2, 0)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _titleLabel.frame = CGRectMake(SeaActionSheetHeaderTextMargin, SeaActionSheetHeaderTextMargin, self.width - SeaActionSheetHeaderTextMargin * 2, self.height - SeaActionSheetHeaderTextMargin * 2);
}

@end

#pragma mark- 取消按钮

@interface SeaActionSheetCancelButton : SeaHighlightView

/**标题
 */
@property(nonatomic,readonly) UILabel *titleLabel;

@end


@implementation SeaActionSheetCancelButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = SeaActionSheetCornerRadius;
        self.layer.masksToBounds = YES;
        self.highlightView.layer.cornerRadius = self.layer.cornerRadius;
        self.highlightView.layer.masksToBounds = self.layer.masksToBounds;
        self.highlightView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.4];
        
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_titleLabel];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _titleLabel.frame = self.bounds;
}

@end

#pragma mark- cell

@interface SeaActionSheetCell : UITableViewCell

/**分割线
 */
@property(nonatomic, readonly) UIView *line;

@end

@implementation SeaActionSheetCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleGray;
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SeaScreenWidth, SeaSeparatorHeight)];
        _line.backgroundColor = SeaSeparatorColor;
        _line.userInteractionEnabled = NO;
        [self.contentView addSubview:_line];
    }
    
    return self;
}

@end

#pragma mark- actionSheet

@interface SeaActionSheet ()<UITableViewDelegate,UITableViewDataSource>

/**其他按钮标题，数组元素是 NSString
 */
@property(nonatomic, strong) NSArray *otherButtonTitles;

/**列表
 */
@property(nonatomic, strong) UITableView *tableView;

/**表头
 */
@property(nonatomic, strong) SeaActionSheetHeader *header;

/**取消按钮
 */
@property(nonatomic, strong) SeaActionSheetCancelButton *cancelButton;

/**取消按钮
 */
@property(nonatomic, strong) NSString *cancelButtonTitle;

/**标题
 */
@property(nonatomic, strong) NSString *title;

/**内容视图
 */
@property(nonatomic, strong) UIView *contentView;

/**黑色背景
 */
@property(nonatomic, strong) UIView *backgroundView;

@end

@implementation SeaActionSheet

/**构造方法
 *@param title 顶部标题
 *@param delegate 弹窗代理
 *@param cancelButtonTitle 取消按钮标题
 *@param otherButtonTitles 其他按钮标题，数组元素是 NSString
 *@return 一个实例
 */
- (id)initWithTitle:(NSString*) title delegate:(id<SeaActionSheetDelegate>)delegate cancelButtonTitle:(NSString *) cancelButtonTitle otherButtonTitles:(NSArray*) otherButtonTitles
{
    self = [super initWithFrame:CGRectMake(0, 0, SeaScreenWidth, 0)];
    if(self)
    {
        self.title = title;
        self.cancelButtonTitle = cancelButtonTitle;
        self.otherButtonTitles = otherButtonTitles;
        
        [self initlization];
    }
    
    return self;
}

//初始化
- (void)initlization
{
    _mainColor = [UIColor whiteColor];
    _titleFont = [UIFont fontWithName:SeaMainFontName size:13.0];
    _titleTextColor = [UIColor colorWithWhite:0.85 alpha:1.0];
    _butttonFont = [UIFont fontWithName:SeaMainFontName size:17.0];
    _buttonTextColor = UIKitTintColor;
    
    _destructiveButtonFont = [UIFont fontWithName:SeaMainFontName size:17.0];
    _destructiveButtonTextColor = [UIColor redColor];
    
    _cancelButtonFont = [UIFont fontWithName:SeaMainFontName size:20.0];
    _cancelButtonTextColor = UIKitTintColor;
    
    //标题
    CGFloat titleHeight = [self headerHeight];
    
    //tableView高度
    CGFloat tableViewHeight = MIN(_otherButtonTitles.count * SeaActionSheetButtonHeight + titleHeight, SeaScreenHeight - SeaStatusHeight - 44.0 - SeaActionSheetMargin * 3 - SeaActionSheetButtonHeight);
    
    //内容
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(SeaActionSheetMargin, 0, self.width - SeaActionSheetMargin * 2, tableViewHeight + SeaActionSheetMargin * 2 + SeaActionSheetButtonHeight)];
    _contentView.backgroundColor = [UIColor clearColor];
    _contentView.clipsToBounds = YES;
    
    if(self.title != nil)
    {
        _header = [[SeaActionSheetHeader alloc] init];
        _header.titleLabel.text = self.title;
        _header.titleLabel.textColor = self.titleTextColor;
        _header.titleLabel.font = self.titleFont;
        _header.height = titleHeight;
    }
    
    
    //按钮列表
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _contentView.width, tableViewHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = SeaActionSheetButtonHeight;
    _tableView.tableHeaderView = _header;
    _tableView.layer.cornerRadius = SeaActionSheetCornerRadius;
    _tableView.layer.masksToBounds = YES;
    _tableView.backgroundColor = _mainColor;
    [_contentView addSubview:_tableView];
    
    _tableView.bounces = _tableView.contentSize.height > _tableView.height;
    
    if(self.cancelButtonTitle == nil)
    {
        self.cancelButtonTitle = @"取消";
    }
    
    //取消按钮
    _cancelButton = [[SeaActionSheetCancelButton alloc] initWithFrame:CGRectMake(0, _tableView.bottom + SeaActionSheetMargin, _contentView.width, SeaActionSheetButtonHeight)];
    _cancelButton.titleLabel.font = _cancelButtonFont;
    _cancelButton.titleLabel.textColor = _cancelButtonTextColor;
    _cancelButton.titleLabel.text = _cancelButtonTitle;
    [_cancelButton addTarget:self action:@selector(dismiss)];
    _cancelButton.backgroundColor = _mainColor;
    [_contentView addSubview:_cancelButton];
}

/**获取表头高度
 */
- (CGFloat)headerHeight
{
    if(self.title == nil)
    {
        return 0;
    }
    else
    {
        CGSize size = [self.title stringSizeWithFont:_titleFont contraintWith:self.header.titleLabel.width];
        return MAX(size.height + SeaActionSheetHeaderTextMargin * 2, SeaActionSheetButtonHeight);
    }
}

#pragma mark- public method

/**显示
 */
- (void)showInView:(UIView*) view
{
    self.height = view.height;
    [view addSubview:self];
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    _backgroundView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [_backgroundView addGestureRecognizer:tap];
    [self insertSubview:_backgroundView atIndex:0];
    
    _contentView.top = self.height;
    [self addSubview:_contentView];
    
    [UIView animateWithDuration:0.25 animations:^(void){
       
        _backgroundView.alpha = 1.0;
        _contentView.top = self.height - _contentView.height;
    }];
}

/**关闭
 */
- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^(void){
        
        _backgroundView.alpha = 0.0;
        _contentView.top = self.height;
    }completion:^(BOOL finish){
       
        [self removeFromSuperview];
    }];
}

#pragma mark- property

/**主题颜色
 */
- (void)setMainColor:(UIColor *)mainColor
{
    if(![_mainColor isEqualToColor:mainColor])
    {
        if(mainColor == nil)
            mainColor = [UIColor whiteColor];
        _mainColor = mainColor;
        self.tableView.backgroundColor = _mainColor;
        self.cancelButton.backgroundColor = _mainColor;
    }
}

/**标题字体
 */
- (void)setTitleFont:(UIFont *)titleFont
{
    if(![_titleFont isEqualToFont:titleFont])
    {
        if(titleFont == nil)
            titleFont = [UIFont systemFontOfSize:13.0];
        _titleFont = titleFont;
        
        self.tableView.tableHeaderView = nil;
        self.header.titleLabel.font = _titleFont;
        self.header.height = [self headerHeight];
    }
}

/**标题字体颜色
 */
- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    if(![_titleTextColor isEqualToColor:titleTextColor])
    {
        if(titleTextColor == nil)
            titleTextColor = [UIColor colorWithWhite:0.85 alpha:1.0];
        _titleTextColor = titleTextColor;
        
        self.header.titleLabel.textColor = _titleTextColor;
    }
}

/**按钮字体
 */
- (void)setButttonFont:(UIFont *)butttonFont
{
    if(![_butttonFont isEqualToFont:butttonFont])
    {
        if(butttonFont == nil)
            butttonFont = [UIFont fontWithName:SeaMainFontName size:16.0];
        _butttonFont = butttonFont;
        
        [self.tableView reloadData];
    }
}

/**按钮字体颜色
 */
- (void)setButtonTextColor:(UIColor *)buttonTextColor
{
    if(![_buttonTextColor isEqualToColor:buttonTextColor])
    {
        if(buttonTextColor == nil)
            buttonTextColor = UIKitTintColor;
        
        _buttonTextColor = buttonTextColor;
        
        [self.tableView reloadData];
    }
}

/**警示按钮字体
 */
- (void)setDestructiveButtonFont:(UIFont *)destructiveButtonFont
{
    if(![_destructiveButtonFont isEqualToFont:destructiveButtonFont])
    {
        if(destructiveButtonFont == nil)
            destructiveButtonFont = [UIFont fontWithName:SeaMainFontName size:16.0];
        _destructiveButtonFont = destructiveButtonFont;
        
        if(self.destructiveButtonIndex < _otherButtonTitles.count)
        {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.destructiveButtonIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }
}

/**警示按钮字体颜色
 */
- (void)setDestructiveButtonTextColor:(UIColor *)destructiveButtonTextColor
{
    if(![_destructiveButtonTextColor isEqualToColor:destructiveButtonTextColor])
    {
        if(destructiveButtonTextColor == nil)
            destructiveButtonTextColor = [UIColor redColor];
        _destructiveButtonTextColor = destructiveButtonTextColor;
        
        if(self.destructiveButtonIndex < _otherButtonTitles.count)
        {
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:self.destructiveButtonIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.tableView endUpdates];
        }
    }
}

/**取消按钮字体
 */
- (void)setCancelButtonFont:(UIFont *)cancelButtonFont
{
    if(![_cancelButtonFont isEqualToFont:cancelButtonFont])
    {
        if(cancelButtonFont == nil)
            cancelButtonFont = [UIFont fontWithName:SeaMainFontName size:16.0];
        
        _cancelButtonFont = cancelButtonFont;
        self.cancelButton.titleLabel.font = _cancelButtonFont;
    }
}

/**取消按钮字体颜色
 */
- (void)setCancelButtonTextColor:(UIColor *)cancelButtonTextColor
{
    if(![_cancelButtonTextColor isEqualToColor:cancelButtonTextColor])
    {
        if(cancelButtonTextColor == nil)
            cancelButtonTextColor = UIKitTintColor;
        _cancelButtonTextColor = cancelButtonTextColor;
        
        self.cancelButton.titleLabel.textColor = _cancelButtonTextColor;
    }
}

#pragma mark- UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _otherButtonTitles.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cell";
    
    SeaActionSheetCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil)
    {
        cell = [[SeaActionSheetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if(self.destructiveButtonIndex == indexPath.row)
    {
        cell.textLabel.textColor = self.destructiveButtonTextColor;
        cell.textLabel.font = self.destructiveButtonFont;
    }
    else
    {
        cell.textLabel.textColor = self.buttonTextColor;
        cell.textLabel.font = self.butttonFont;
    }
    
    cell.textLabel.text = [_otherButtonTitles objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if([self.delegate respondsToSelector:@selector(actionSheet:didSelectAtIndex:)])
    {
        [self.delegate actionSheet:self didSelectAtIndex:indexPath.row];
    }
    [self dismiss];
}

@end
