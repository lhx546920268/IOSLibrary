//
//  SeaHttpOperation.m
//  BeautifulLife
//
//  Created by 罗海雄 on 17/8/23.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import "SeaHttpOperation.h"

@implementation SeaHttpOperation

/**请求URL
 */
- (nonnull NSString*)requestURL
{
    return @"";
}

/**获取参数
 */
- (nullable NSMutableDictionary*)params
{
    return nil;
}

/**获取文件
 */
- (nullable NSMutableDictionary*)files
{
    return nil;
}

- (nonnull NSString*)name
{
    if(_name == nil)
    {
        return NSStringFromClass([self class]);
    }
    
    return _name;
}

/**处理参数 比如签名
 */
- (void)processParams:(nullable NSMutableDictionary*) params files:(nullable NSMutableDictionary*)files
{
    
}

/**请求是否成功
 *@return 是否成功
 */
- (BOOL)resultFromData:(nullable NSData*) data
{
    return YES;
}

///请求开始
- (void)onStart
{
    
}

///请求成功
- (void)onSuccess
{
    
}

///请求失败
- (void)onFail
{
    
}

///请求完成
- (void)onComplete
{
    
}

@end
