//
//  UIFont+Utilities.h

//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface UIFont (Utilities)

/**把CTFont转成 uifont
 */
+ (UIFont*)fontWithCTFont:(CTFontRef)ctFont;


/**字体是否相等
 */
- (BOOL)isEqualToFont:(UIFont*) font;

@end
