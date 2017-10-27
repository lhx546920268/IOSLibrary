//
//  SeaHttpOperation.h
//  BeautifulLife
//
//  Created by 罗海雄 on 17/8/23.
//  Copyright © 2017年 qianseit. All rights reserved.
//

#import <Foundation/Foundation.h>

/**http 构建类
 子类可重写对应的方法
 */
@interface SeaHttpOperation : NSObject

/**请求失败错误码，成功 SeaHttpErrorCodeNoError
 */
@property(nonatomic, assign) NSInteger errorCode;

/**请求URL
 */
- (nonnull NSString*)requestURL;

/**获取参数
 */
- (nullable NSMutableDictionary*)params;

/**获取文件
 */
- (nullable NSMutableDictionary*)files;

/**处理参数 比如签名
 */
- (void)processParams:(nullable NSMutableDictionary*) params files:(nullable NSMutableDictionary*)files;

/**请求标识 默认返回类的名称
 */
@property(nonnull, nonatomic, copy) NSString *name;

/**请求是否成功
 *@return 是否成功
 */
- (BOOL)resultFromData:(nullable NSData*) data;

///请求开始
- (void)onStart NS_REQUIRES_SUPER;

///请求成功
- (void)onSuccess NS_REQUIRES_SUPER;

///请求失败
- (void)onFail NS_REQUIRES_SUPER;

///请求完成
- (void)onComplete NS_REQUIRES_SUPER;

@end
