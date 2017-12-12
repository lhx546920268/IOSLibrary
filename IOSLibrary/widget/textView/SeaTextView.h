//
//  SSTextView.h

//
#import <UIKit/UIKit.h>


/** UITextView的子类，支持像UITextField那样的placeholder.
 */
@interface SeaTextView : UITextView

/**当文本框中没有内容时，显示placeholder，The default value is 'nil'.
 */
@property (nonatomic, copy) NSString *placeholder;


/**placeholder 的字体颜色. default is '[UIColor colorWithWhite:0.702f alpha:0.7]'.
 */
@property (nonatomic, retain) UIColor *placeholderTextColor;
/** placeholder的字体
 */
@property (nonatomic, retain) UIFont *placeholderFont;

/** placeholder画的起始位置 default is 'CGPointMake(8.0f, 8.0f)'
 */
@property (nonatomic, assign) CGPoint placeholderOffset;


/**是否限制输入字数 default is 'NO'
 */
@property (nonatomic,assign) BOOL limitable;
@property (nonatomic,readonly) UILabel *numLabel;

/**限制输入的字数大小
 */
@property (nonatomic,assign) NSInteger maxCount;

#pragma mark- 文本限制

/**内容改变
 */
- (void)textDidChange;

/**是否替换内容
 *@param range 替换的范围
 *@param text 新的内容
 *@return 是否替换
 */
- (BOOL)shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end
