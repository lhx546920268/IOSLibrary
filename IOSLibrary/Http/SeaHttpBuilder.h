//
//  SeaHttpBuilder.h
//  IOSLibrary
//
//  Created by 罗海雄 on 2017/12/20.
//  Copyright © 2017年 罗海雄. All rights reserved.
//

#import <Foundation/Foundation.h>

///打印请求信息，release产品自动改为不打印body信息
#ifndef __OPTIMIZE__
#define SeaHttpLogConfig 1
#else
#define SeaHttpLogConfig 0
#endif

/**postBody数据格式
 */
typedef NS_ENUM(NSInteger, SeaPostFormat)
{
    ///默认
    SeaPostFormatURLEncoded = 0,
    
    ///表单 上传文件时必须这个
    SeaPostFormatMultipartFormData = 1,
    
    ///json
    SeaPostFormatJSON = 2,
};

/**
 构建 NSURLRequest 只支持 GET POST 请求
 */
@interface SeaHttpBuilder : NSObject

/**postBody数据格式 default is 'SeaPostFormatURLEncoded',如果有文件需要上传，将自动设置为 SeaPostFormatMultipartFormData
 */
@property(nonatomic,assign) SeaPostFormat postFormat;

/**网络请求封装
 */
@property(nonatomic,readonly, strong) NSMutableURLRequest *request;

/**
 请求方法
 */
@property(nonatomic,strong) NSString *httpMethod;

/**
 cookie 值
 */
@property(nonatomic,strong) NSArray<NSHTTPCookie*> *cookies;

/**
 额外的请求头
 */
@property(nonatomic,strong) NSDictionary<NSString*, NSString*> *headers;

/**要上传的数据大小 必须要 buildPostBody 后才有，get请求为0
 */
@property(nonatomic,readonly) long long uploadSize;

/**请求的URL
 */
@property( nonatomic,readonly) NSString *URL;

#pragma mark- init

/**
 通过请求URL构建

 @param URL 请求路径
 @return 一个实例
 */
- (instancetype)initWithURL:(NSString*) URL;

/**initWithURL:(NSString*) URL
 */
+ (instancetype)buildertWithURL:(NSString*) URL;


#pragma mark- 添加 请求 参数

/**添加 请求参数 参数名可以重复
 *@param value 参数值，支持 NSString,NSNumber, NSData
 *@param key 参数名
 */
- (void)addValue:(id<NSObject>)value forKey:(NSString*)key;

/**添加 请求参数 参数名不能重复，会删除已存在的参数
 *@param value 参数值，支持 NSString,NSNumber, NSData
 *@param key 参数名
 */
- (void)setValue:(id<NSObject>)value forKey:(NSString*)key;

/**添加文件上传 参数名可以重复
 *@param filePath 本地文件全路径
 *@param key 参数名
 */
- (void)addFile:(NSString*)filePath forKey:(NSString*)key;

/**添加文件上传 参数名不能重复，会删除已存在的参数
 *@param filePath 本地文件全路径
 *@param key 参数名
 */
- (void)setFile:(NSString*)filePath forKey:(NSString*)key;

/**通过NSDictionary 添加请求参数
 *@param dic 含有请求参数的字典
 */
- (void)addValuesFromDictionary:(NSDictionary<NSString*, id<NSObject>>*) dic;

/**添加多个文件 同一个参数
 *@param files 数组元素是文件本地路径 NSString
 *@param fileKey 文件参数名
 */
- (void)addFiles:(NSArray<NSString*>*) files fileKey:(NSString*) fileKey;

/**添加多个文件，不同的参数
 *@param dic 含有文件参数的字典
 */
- (void)addFilesFromDictionary:(NSDictionary<NSString*, NSString*>*) dic;

#pragma mark- 删除 请求 参数

/**删除 请求参数
 *@param key 参数名
 */
- (void)removeValueForKey:(NSString*)key;

/**删除 要上传的文件参数
 *@param key 参数名
 */
- (void)removeFileForKey:(NSString*)key;


@end
