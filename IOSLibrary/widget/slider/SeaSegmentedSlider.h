//
//  SeaSegmentedSlider.h

//

#import <UIKit/UIKit.h>

/**分段滑杆
 */
@interface SeaSegmentedSlider : UIControl

-(id) initWithFrame:(CGRect) frame Titles:(NSArray *) titles;

-(void) setTitlesColor:(UIColor *)color;
-(void) setTitlesFont:(UIFont *)font;
-(void) setHandlerColor:(UIColor *)color;

@property(nonatomic, strong) UIColor *progressColor;
@property(nonatomic, assign) int selectedIndex;

@end
