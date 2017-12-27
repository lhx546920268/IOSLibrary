//
//  SeaFileManager.h
//

#import <UIKit/UIKit.h>

/**
 文件管理
 */
@interface SeaFileManager : NSObject

/**
 把图片写入临时文件 压缩比率为1.0 jpg格式
 
 *@param images 要写入文件的图片
 *@return 成功写入的文件路径
 */
+ (NSArray<NSString*>*)writeImages:(NSArray<UIImage*>*) images;

/**
 把图片写入临时文件 比例是 0.0 ~ 1.0 jpg格式
 
 *@param images 要写入文件的图片
 *@param scale 图片压缩比率 0.0 ~ 1.0
 *@return 成功写入的文件路径
 */
+ (NSArray<NSString*>*)writeImages:(NSArray<UIImage*>*) images scale:(float) scale;

/**
 把图片写入临时文件 比例是 0.0 ~ 1.0 jpg格式
 
 *@param images 要写入文件的图片
 *@param scale 图片压缩比率
 *@param failImages 写入失败的图片会加入到该数组
 *@return 成功写入的文件路径
 */
+ (NSArray<NSString*>*)writeImages:(NSArray<UIImage*>*) images scale:(float) scale failImages:(NSMutableArray<UIImage*>*) failImages;

/**
 把图片写入临时文件 比例是 0.0 ~ 1.0 jpg格式，可识别那张图片写入失败
 
 *@param images 要写入文件的图片，数组元素是UIImage对象
 *@param scale 图片压缩比率
 *@return 成功写入的文件，key 对应 images 的下标， value图片临时文件
 */
+ (NSDictionary<NSNumber*, NSString*>*)writeImagesReturnDictionary:(NSArray<UIImage*>*) images scale:(float) scale;

/**
 把图片写入临时文件 比例是 0.0 ~ 1.0 jpg格式
 
 *@param image 要写入文件的图片
 *@param scale 图片压缩比率
 *@return 成功写入的文件
 */
+ (NSString*)writeImage:(UIImage*) image scale:(float) scale;

/**
 批量删除文件
 
 *@param files 数组元素是 文件路径
 */
+ (void)deleteFiles:(NSArray<NSString*>*) files;

/**
 删除一个文件
 */
+ (void)deleteOneFile:(NSString*) file;

/**
 获取临时文件
 */
+ (NSString*)getTemporaryFile;

/**
 获取临时文件，添加后缀
 
 *@param suffix 文件后缀 如jpg
 */
+ (NSString*)getTemporaryFileWithSuffix:(NSString*) suffix;

/**
 通过url获取文件名称
 
 *@param URL 链接
 *@param suffix 文件后缀，如jpg
 *@return 文件完整路径
 */
+ (NSString*)fileNameForURL:(NSString*) URL suffix:(NSString*) suffix;

/**
 把临时图片文件移动到缓存文件夹中
 
 *@param files 临时图片文件
 *@param URLs 网络图片路径
 *@param suffix 文件后缀，如jpg
 *@param path 缓存路径
 */
+ (void)moveFiles:(NSArray<NSString*>*) files withURLs:(NSArray<NSString*>*) URLs suffix:(NSString*) suffix toPath:(NSString*) path;

/**
 对相关文件或目录设定 不备份iCloud属性
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL;

@end
