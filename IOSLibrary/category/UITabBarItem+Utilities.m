//
//  UITabBarItem+Utilities.m

//

#import "UITabBarItem+Utilities.h"

@implementation UITabBarItem (Utilities)

/**初始化方法 兼容 ios6.0
 *@param title 标题
 *@param normalImage 没选时的图片
 *@param selectedImage 选中的图片
 */
+ (id)tabBarItemWithTitle:(NSString*) title normalImage:(UIImage*) normalImage selectedImage:(UIImage*) selectedImage
{
     UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:title image:[normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
     return item;
}

@end
