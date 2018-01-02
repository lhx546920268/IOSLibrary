//
//  UIColor+colorUtilities.h

//

#import <UIKit/UIKit.h>

#define _colorRedKey_ @"R"
#define _colorGreenKey_ @"G"
#define _colorBlueKey_ @"B"
#define _colorAlphaKey_ @"Alpha"

#define _colorHueKey_ @"hue"
#define _colorSaturationKey_ @"saturation"
#define _colorBrightness_ @"brightness"

//色彩 饱和度 亮度
typedef struct
{
    CGFloat hue;
    CGFloat saturation;
    CGFloat brightness;
} HSBType;

@interface UIColor (colorUtilities)

/**获取颜色的RGB值 透明度
 *@return 成功返回一个字典 rgb键值 value NSNumber对象 否则nil
 */
- (NSDictionary*)sea_colorARGB;

/**颜色是否相同
 *@param color 要比较的颜色
 */
- (BOOL)isEqualToColor:(UIColor*) color;

/**获取颜色色彩 饱和度 亮度
 */
-(HSBType)sea_colorHSB;

/**获取颜色的16进制
 *@return 16进制颜色值，FFFFFF
 */
- (NSString*)sea_colorHex;

/**通过RGB值获取颜色的16进制
 *@param R 红色 0~255
 *@param G 绿色 0~255
 *@param B 蓝色 0~255
 *@return 16进制颜色值，FFFFFF
 */
+ (NSString*)sea_colorHexFromRed:(int) R green:(int) G  blue:(int) B;

/**通过16进制颜色值获取颜色 透明度为 1.0
 *@return 一个 UIColor对象
 */
+ (UIColor*)sea_colorFromHex:(NSString*) hexadecimal;

/**通过16进制颜色值获取颜色
 *@param alpha 透明度
 *@return 一个 UIColor对象
 */
+ (UIColor*)sea_colorFromHex:(NSString*) hexadecimal alpha:(CGFloat) alpha;

/**获取16进制值
 *@param adecimal 10进制
 *@return 16进制值
 */
+ (NSString*)sea_hexFromDecimal:(int) adecimal;

/**获取10进制
 *@param hexadecimal 16进制值
 *@return 10进制值
 */
+ (NSInteger)sea_decimalFromHex:(char) hexadecimal;

/**以整数rpg初始化
 *@param r 红色 0 ~ 255
 *@param g 绿色 0 ~ 255
 *@param b 蓝色 0 ~ 255
 *@param a 透明度 0 ~ 1.0
 *@return 一个初始化的颜色对象
 */
+ (UIColor*)sea_colorWithRed:(int) r green:(int) g blue:(int) b alpha:(CGFloat) a;

@end
