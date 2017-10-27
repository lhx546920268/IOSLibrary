//
//  NSAttributedString+Utlities.m

//
//

#import "NSAttributedString+Utlities.h"
#import <CoreText/CoreText.h>
#import "NSString+Utilities.h"

@implementation NSAttributedString (Utlities)

/**获取富文本框大小
 *@param width 每行最大宽度
 *@return 富文本框大小
 */
- (CGSize)boundsWithConstraintWidth:(CGFloat) width
{
    return [self boundingRectWithSize:CGSizeMake(width, 8388608.0) options:NSStringDrawingTruncatesLastVisibleLine |
            NSStringDrawingUsesLineFragmentOrigin |
            NSStringDrawingUsesFontLeading  context:nil].size;
}

/**获取coreText 富文本文本框大小
 *@param width 文本框宽度限制
 *@return 文本框大小
 */
- (CGSize)coreTextBoundsWithConstraintWidth:(CGFloat)width
{
    NSString *string = self.string;
    if([NSString isEmpty:string])
        return CGSizeZero;
    
    CGFloat totalHeight = 0;
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    if(framesetter == NULL)
        return CGSizeZero;
    
    CGRect drawRect = CGRectMake(0, 0, width, 8388608.0);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, drawRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    if(frame == NULL)
    {
        CFRelease(framesetter);
        if(path != NULL)
            CFRelease(path);
        return CGSizeZero;
    }
    
    CFRelease(framesetter);
    CFRelease(path);
    
    //获取行数和没行的起点
    CFArrayRef lines = CTFrameGetLines(frame);
    NSInteger count = CFArrayGetCount(lines);
    CGPoint lineOrigins[count];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, 0), lineOrigins);
    
    CGPoint lastLineOrigin = lineOrigins[count - 1]; //获取最后一行的起始坐标
    
    CGFloat descent;
    
    CTLineRef lastLine = CFArrayGetValueAtIndex(lines, count - 1);
    CTLineRef firstLine = CFArrayGetValueAtIndex(lines, 0);
    
    CTLineGetTypographicBounds(lastLine, NULL, &descent, NULL);
    
    CGFloat totalWidth = width;
    if(count == 1)
    {
        totalWidth = CTLineGetTypographicBounds(firstLine, NULL, NULL, NULL);
    }
    
    
    totalHeight += CGRectGetMaxY(drawRect) - lastLineOrigin.y + descent + 1.0;
    CFRelease(frame);
    
    return CGSizeMake(totalWidth, totalHeight);

}

@end
