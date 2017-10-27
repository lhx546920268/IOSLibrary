//
//  SeaImageFilterColorMatrix.h
//  WuMei
//
//  Created by 罗海雄 on 15/7/27.
//  Copyright (c) 2015年 QSIT. All rights reserved.
//

#import <UIKit/UIKit.h>

///系统滤镜 可以在xcode 文档中搜索 core image filter reference

/**颜色矩阵滤镜
 */
@interface SeaImageFilterColorMatrix : NSObject

/**滤镜名称
 *@retrun 数组元素是 NSString
 */
+ (NSArray*)filterNames;

/**通过滤镜名称下标获取颜色矩阵
 *@param index 滤镜名称下标
 *@return 颜色矩阵
 */
+ (const float*) colorMartrixForIndex:(NSInteger) index;

/**通过颜色矩阵获取滤镜图片
 *@param inImage 原图
 *@param colorMatrix 颜色矩阵
 *@return 结果图片
 */
+ (UIImage*)imageWithImage:(UIImage*)inImage withColorMatrix:(const float*) colorMatrix;

/**系统滤镜名称
 */
+ (NSArray*)systemFilterNames;

/**通过下标获取滤镜图片
 *@param inImage 要生成滤镜的图片
 *@param context 上下文
 *@param index 对应 systemFilterNames 的下标
 */
+ (UIImage*)imageWithImage:(UIImage*) inImage inContent:(CIContext*) context forIndex:(NSInteger) index;

@end
