//
//  UIColor+colorUtilities.m

//

#import "UIColor+colorUtilities.h"
#import "SeaBasic.h"

@implementation UIColor (colorUtilities)

/**获取颜色的RGB值 透明度 只有当颜色是由RGB组成的才有返回
 *@return 成功返回一个字典 rgb键值 否则返回nil
 */
- (NSDictionary*)getColorRGB
{
    
    CGFloat R, G, B, alpha;
    
    BOOL success = [self getRed:&R green:&G blue:&B alpha:&alpha];

    if(success)
    {
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithFloat:R], _colorRedKey_,
                             [NSNumber numberWithFloat:G], _colorGreenKey_,
                             [NSNumber numberWithFloat:B], _colorBlueKey_,
                             [NSNumber numberWithFloat:alpha], _colorAlphaKey_,
                             nil];
        return dic;
    }

    return nil;
}

/**颜色是否相同
 *@param color 要比较的颜色
 */
- (BOOL)isEqualToColor:(UIColor*) color
{
    NSDictionary *dic1 = [self getColorRGB];
    NSDictionary *dic2 = [color getColorRGB];
    
    if(dic1 == nil || dic2 == nil)
        return NO;
    
    CGFloat R1 = [[dic1 objectForKey:_colorRedKey_] floatValue];
    CGFloat G1 = [[dic1 objectForKey:_colorGreenKey_] floatValue];
    CGFloat B1 = [[dic1 objectForKey:_colorBlueKey_] floatValue];
    CGFloat A1 = [[dic1 objectForKey:_colorAlphaKey_] floatValue];
    
    CGFloat R2 = [[dic2 objectForKey:_colorRedKey_] floatValue];
    CGFloat G2 = [[dic2 objectForKey:_colorGreenKey_] floatValue];
    CGFloat B2 = [[dic2 objectForKey:_colorBlueKey_] floatValue];
    CGFloat A2 = [[dic2 objectForKey:_colorAlphaKey_] floatValue];
    
    if(R1 == R2 && B1 == B2 && G1 == G2 && A1 == A2)
    {
        return YES;
    }
    
    return NO;
}

/**获取颜色色彩 饱和度 亮度
 */
- (HSBType)HSB
{
    HSBType hsb;
    
    hsb.hue = 0;
    hsb.saturation = 0;
    hsb.brightness = 0;
    
    CGColorSpaceModel model = CGColorSpaceGetModel(CGColorGetColorSpace([self CGColor]));
    
    if ((model == kCGColorSpaceModelMonochrome) || (model == kCGColorSpaceModelRGB))
    {
        const CGFloat *c = CGColorGetComponents([self CGColor]);
        
        float x = fminf(c[0], c[1]);
        x = fminf(x, c[2]);
        
        float b = fmaxf(c[0], c[1]);
        b = fmaxf(b, c[2]);
        
        if (b == x)
        {
            hsb.hue = 0;
            hsb.saturation = 0;
            hsb.brightness = b;
        }
        else
        {
            float f = (c[0] == x) ? c[1] - c[2] : ((c[1] == x) ? c[2] - c[0] : c[0] - c[1]);
            int i = (c[0] == x) ? 3 : ((c[1] == x) ? 5 : 1);
            
            hsb.hue = ((i - f /(b - x))/6);
            hsb.saturation = (b - x)/b;
            hsb.brightness = b;
        }
    }
    
    return hsb;
}

/**获取颜色的16进制
 *@return 16进制颜色值，FFFFFF
 */
- (NSString*)hexadecimalValue
{
    NSDictionary *dic = [self getColorRGB];
    if(dic != nil)
    {
        int R = [[dic objectForKey:_colorRedKey_] floatValue] * 255;
        int G = [[dic objectForKey:_colorGreenKey_] floatValue] * 255;
        int B = [[dic objectForKey:_colorBlueKey_] floatValue] * 255;
        
        return [UIColor hexadecimalValueFromR:R G:G B:B];
    }
    return @"000000";
}

/**通过RGB值获取颜色的16进制
 *@param R 红色 0~255
 *@param G 绿色 0~255
 *@param B 蓝色 0~255
 *@return 16进制颜色值，FFFFFF
 */
+ (NSString*)hexadecimalValueFromR:(int) R G:(int) G  B:(int) B
{
    NSString *hex = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                     [UIColor hexadecimalValueFromAdecimal:R / 16],
                     [UIColor hexadecimalValueFromAdecimal:R % 16],
                     [UIColor hexadecimalValueFromAdecimal:G / 16],
                     [UIColor hexadecimalValueFromAdecimal:G % 16],
                     [UIColor hexadecimalValueFromAdecimal:B / 16],
                     [UIColor hexadecimalValueFromAdecimal:B % 16]
                     ];
    return hex;
}

/**通过16进制颜色值获取颜色
 *@return 一个 UIColor对象
 */
+ (UIColor*)colorFromHexadecimal:(NSString*) hexadecimal
{
    return [UIColor colorFromHexadecimal:hexadecimal alpha:1.0];
}

/**通过16进制颜色值获取颜色
 *@param alpha 透明度
 *@return 一个 UIColor对象
 */
+ (UIColor*)colorFromHexadecimal:(NSString*) hexadecimal alpha:(CGFloat) alpha
{
    hexadecimal = [hexadecimal uppercaseString];
    if(hexadecimal.length >= 6)
    {
        NSInteger index = 0;
        if([hexadecimal hasPrefix:@"#"])
        {
            if(hexadecimal.length < 7)
                return nil;

            index = 1;
        }
        NSString *hexR = [hexadecimal substringWithRange:NSMakeRange(index, 2)];
        NSString *hexG = [hexadecimal substringWithRange:NSMakeRange(index + 2, 2)];
        NSString *hexB = [hexadecimal substringWithRange:NSMakeRange(index + 4, 2)];
        
        CGFloat R = [UIColor adecimalValueFromHexadecimal:[hexR sea_firstCharacter]] * 16 + [UIColor adecimalValueFromHexadecimal:[hexR characterAtIndex:1]];
        CGFloat G = [UIColor adecimalValueFromHexadecimal:[hexG sea_firstCharacter]] * 16 + [UIColor adecimalValueFromHexadecimal:[hexG characterAtIndex:1]];
        CGFloat B = [UIColor adecimalValueFromHexadecimal:[hexB sea_firstCharacter]] * 16 + [UIColor adecimalValueFromHexadecimal:[hexB characterAtIndex:1]];
        
        
        UIColor *color = [UIColor colorWithRed:R / 255.0f green:G / 255.0f blue:B / 255.0f alpha:alpha];
        
        return color;
    }
    else
    {
        return [UIColor colorWithRed:0 green:0 blue:0 alpha:alpha];
    }
}

/**获取16进制值
 *@param adecimal 10进制
 *@return 16进制值
 */
+ (NSString*)hexadecimalValueFromAdecimal:(int) adecimal
{
    switch (adecimal)
    {
        case 10 :
        {
            return @"A";
        }
            break;
        case 11 :
        {
            return @"B";
        }
        case 12 :
        {
            return @"C";
        }
        case 13 :
        {
            return @"D";
        }
            break;
        case 14 :
        {
            return @"E";
        }
            break;
        case 15 :
        {
            return @"F";
        }
            break;
        default:
        {
            return [NSString stringWithFormat:@"%d", adecimal];
        }
            break;
    }
}

/**获取10进制
 *@param hexadecimal 16进制
 *@return 10进制值
 */
+ (NSInteger)adecimalValueFromHexadecimal:(char)hexadecimal
{
    switch (hexadecimal)
    {
        case 'A' :
        {
            return 10;
        }
            break;
        case 'B' :
        {
            return 11;
        }
        case 'C' :
        {
            return 12;
        }
        case 'D' :
        {
            return 13;
        }
            break;
        case 'E' :
        {
            return 14;
        }
            break;
        case 'F' :
        {
            return 15;
        }
            break;
        default:
        {
            return [[NSString stringWithFormat:@"%c", hexadecimal] integerValue];
        }
            break;
    }
}

/**以整数rpg初始化
 *@param r 红色 0 ~ 255
 *@param g 绿色 0 ~ 255
 *@param b 蓝色 0 ~ 255
 *@param a 透明度 0 ~ 1.0
 *@return 一个初始化的颜色对象
 */
+ (UIColor*)colorWithR:(int) r G:(int) g B:(int) b a:(CGFloat) a
{
    r = MIN(255, abs(r));
    g = MIN(255, abs(g));
    b = MIN(255, abs(b));
    a = MIN(1.0, fabs(a));
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:a];
}

@end
