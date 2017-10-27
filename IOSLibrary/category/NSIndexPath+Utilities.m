//
//  NSIndexPath+indexPathUtilities.m

//

#import "NSIndexPath+Utilities.h"

@implementation NSIndexPath (Utilities)

/**判断是否相等
 */
- (BOOL)isEqual:(id)object
{
    if([object isKindOfClass:[NSIndexPath class]])
    {
        NSIndexPath *indexPath = (NSIndexPath*) object;
        if(indexPath.row == self.row &&  indexPath.section == self.section)
        {
            return YES;
        }
    }
    
    return [super isEqual:object];
}

@end
