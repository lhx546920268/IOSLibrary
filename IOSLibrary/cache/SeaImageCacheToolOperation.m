//
//  SeaImageCacheToolOperation.m

//

#import "SeaImageCacheToolOperation.h"

@implementation SeaImageCacheToolOperation

- (id)init
{
    self = [super init];
    if(self)
    {
        self.requirements = [NSMutableSet set];
    }
    
    return self;
}

@end


@implementation SeaImageCacheToolRequirement

@end