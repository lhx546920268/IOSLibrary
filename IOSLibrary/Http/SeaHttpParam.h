//
//  SeaHttpRequestParam.h

//

#import <Foundation/Foundation.h>

/**请求参数类型
 */
typedef NS_ENUM(NSInteger, SeaHttpParamType)
{
    /// 字符串
    SeaHttpParamTypeDefault = 0,
    
    /// 文件
    SeaHttpParamTypeFile = 1,
};


/**请求参数
 */
@interface SeaHttpParam : NSObject

/**参数值 NSString 、 NSNumber、 NSSData
 */
@property(nonatomic,strong) id<NSObject> value;

/**参数
 */
@property(nonatomic,strong) NSString *key;

/**参数类型
 */
@property(nonatomic,assign) SeaHttpParamType paramType;

/**参数是否有效
 */
@property(nonatomic,readonly) BOOL paramIsAvaliable;

/**获取二进制的参数值
 */
@property(nonatomic,readonly) NSData *NSDataValue;

/**构造方法 paramType 为SeaHttpParamTypeDefault
 *@param value 参数值 NSString 或 NSNumber
 *@param key 参数
 *@return 一个实例
 */
+ (instancetype)paramWithValue:(id) value key:(NSString*) key;

/**构造方法 paramType 为SeaHttpRequestParamTypeFile
 *@param filePath 参数值,文件全路径
 *@param key 参数
 *@return 一个实例
 */
+ (instancetype)paramWithFilePath:(NSString*) filePath key:(NSString*) key;

/**构造方法
 *@param value 参数值 NSString 或 NSNumber
 *@param key 参数
 *@param type 参数类型
 *@return 一个实例
 */
+ (instancetype)paramWithValue:(id) value key:(NSString*) key paramType:(SeaHttpParamType) type;



@end
