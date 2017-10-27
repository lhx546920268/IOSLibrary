//
//  UIFont+Utilities.m

//

#import "UIFont+Utilities.h"

@implementation UIFont (Utilities)

/**把CTFont转成 uifont
 */
+ (UIFont*)fontWithCTFont:(CTFontRef)ctFont
{
    CFStringRef fontName = CTFontCopyPostScriptName(ctFont);
    CGFloat fontSize = CTFontGetSize(ctFont);
    
    UIFont *ret = [UIFont fontWithName:(__bridge NSString*)fontName size:fontSize];
    CFRelease(fontName);
    return ret;
}


/**字体是否相等
 */
- (BOOL)isEqualToFont:(UIFont*) font
{
    return [self.fontName isEqualToString:font.fontName] && self.pointSize == font.pointSize;
}

@end
