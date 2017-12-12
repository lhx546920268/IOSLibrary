//
//  SeaMenuItemInfo.m

//

#import "SeaMenuItemInfo.h"
#import "SeaBasic.h"

@implementation SeaMenuItemInfo

- (void)dealloc
{
    
}

/**构造方法
 *@param title 标题
 *@return 已初始化的 SeaMenuItemInfo
 */
+ (id)infoWithTitle:(NSString*) title
{
    SeaMenuItemInfo *info = [[SeaMenuItemInfo alloc] init];
    info.title = title;
    
    return info;
}

@end
