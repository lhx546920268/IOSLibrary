//
//  SeaFileManager.m
//

#import "SeaFileManager.h"
#import "SeaImageCacheTool.h"
#import <sys/xattr.h>
#import "SeaBasic.h"
#import "NSString+Utilities.h"
#import "NSDate+Utilities.h"


@implementation SeaFileManager

/**把图片写入临时文件 压缩比率为1.0 jpg格式
 *@param imageArray 要写入文件的图片，数组元素是UIImage对象
 *@return 成功写入的文件，数组元素是 图片临时文件，NSString对象
 */
+ (NSArray*)writeImageInTemporaryFile:(NSArray*) imageArray
{
    return [SeaFileManager writeImageInTemporaryFile:imageArray withCompressedScale:1.0];
}

/**把图片写入临时文件 比例是 0.0 ~ 1.0 jpg格式
 *@param imageArray 要写入文件的图片，数组元素是UIImage对象
 *@param scale 图片压缩比率
 *@return 成功写入的文件，数组元素是 图片临时文件，NSString对象
 */
+ (NSArray*)writeImageInTemporaryFile:(NSArray*) imageArray withCompressedScale:(float) scale
{
    return [SeaFileManager writeImageInTemporaryFile:imageArray withCompressedScale:scale failImages:nil];
}

/**把图片写入临时文件 比例是 0.0 ~ 1.0 jpg格式
 *@param imageArray 要写入文件的图片，数组元素是UIImage对象
 *@param scale 图片压缩比率
 *@param failImages 写入失败的图片，数组元素是 UIImage
 *@return 成功写入的文件，数组元素是 图片临时文件，NSString对象
 */
+ (NSArray*)writeImageInTemporaryFile:(NSArray*) imageArray withCompressedScale:(float) scale failImages:(NSMutableArray*) failImages
{
    scale = MIN(scale, 1.0);
    
    NSString *filePath = NSTemporaryDirectory();
    NSMutableArray *fileArray = [[NSMutableArray alloc] init];

    
    for(NSInteger i = 0; i < imageArray.count; i ++)
    {
        UIImage *image = [imageArray objectAtIndex:i];
        NSString *fileName = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"tempImage%@.%@", [NSDate getTimeAndRandom], @"jpg"]];
        
        NSData *imageData = UIImageJPEGRepresentation(image, scale);

        NSError *error = nil;
        if([imageData writeToFile:fileName options:NSDataWritingAtomic error:&error])
        {
            [fileArray addObject:fileName];
        }
        else
        {
            NSLog(@"error = %@",error);
            [failImages addObject:image];
        }
    }
    
    return fileArray;
}

/**把图片写入临时文件 比例是 0.0 ~ 1.0 jpg格式，可识别那张图片写入失败
 *@param imageArray 要写入文件的图片，数组元素是UIImage对象
 *@param scale 图片压缩比率
 *@return 成功写入的文件，key 是 NSNumber 对应 images 的下标， value图片临时文件，NSString对象
 */
+ (NSDictionary*)writeImages:(NSArray*) imageArray inTemporaryFileWithCompressedScale:(float) scale
{
    if(imageArray.count == 0)
        return nil;
    scale = MIN(scale, 1.0);
    
    NSString *filePath = NSTemporaryDirectory();
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:imageArray.count];
    for(NSInteger i = 0; i < imageArray.count; i ++)
    {
        UIImage *image = [imageArray objectAtIndex:i];
        NSString *fileName = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"tempImage%@.%@", [NSDate getTimeAndRandom], @"jpg"]];
        
        NSData *imageData = UIImageJPEGRepresentation(image, scale);
        
        NSError *error = nil;
        if([imageData writeToFile:fileName options:NSDataWritingAtomic error:&error])
        {
            [dic setObject:fileName forKey:[NSNumber numberWithInteger:i]];
        }
        else
        {
            NSLog(@"error = %@",error);
        }
    }
    
    return dic;
}

/**把图片写入临时文件 比例是 0.0 ~ 1.0 jpg格式
 *@param image 要写入文件的图片
 *@param scale 图片压缩比率
 *@return 成功写入的文件 图片临时文件
 */
+ (NSString*)writeImage:(UIImage*) image inTemporaryFileWithCompressedScale:(float) scale
{
    scale = MIN(scale, 1.0);
    
    NSString *filePath = NSTemporaryDirectory();
    
    
    NSString *fileName = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"tempImage%@.%@", [NSDate getTimeAndRandom], @"jpg"]];
    
    NSData *imageData = UIImageJPEGRepresentation(image, scale);
    
    NSError *error = nil;
    if([imageData writeToFile:fileName options:NSDataWritingAtomic error:&error])
    {
        return fileName;
    }
    else
    {
        NSLog(@"error = %@",error);
    }

    return nil;
}

/**删除文件
 *@param files 数组元素是 文件路径，NSString对象
 */
+ (void)deleteFiles:(NSArray*) files
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        for(NSString *file in files)
        {
            [fileManager removeItemAtPath:file error:nil];
        }
    });
}

/**删除一个文件
 */
+ (void)deleteOneFile:(NSString*) file
{
    if(![file isKindOfClass:[NSString class]])
        return;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        [fileManager removeItemAtPath:file error:nil];
    });
}


//获取临时文件
+ (NSString*)getTemporaryFile
{
    return [SeaFileManager getTemporaryFileWithSuffix:@"tmp"];
}

/**获取临时文件，添加后缀
 *@param suffix 文件后缀 如jpg
 */
+ (NSString*)getTemporaryFileWithSuffix:(NSString*) suffix
{
    NSString *temp = NSTemporaryDirectory();
    NSString *time = [NSDate getTimeAndRandom];
    NSString *file = [NSString stringWithFormat:@"%@.%@",time, suffix];
    
    return [temp stringByAppendingPathComponent:file];
}

/**通过url获取文件名称
 *@param url 链接
 *@param suffix 文件后缀，如jpg
 *@return 文件完整路径
 */
+ (NSString*)fileNameForURL:(NSString*) url suffix:(NSString *)suffix
{
    NSString *fileName = [url md5];
    
    if(![NSString isEmpty:suffix])
    {
        fileName = [fileName stringByAppendingFormat:@".%@",suffix];
    }
    return fileName;
}


/**把临时图片文件移动到缓存文件夹中
 *@param files 临时图片文件 数组元素是 文件路径 NSString对象
 *@param urls 网络图片路径 数组元素是 NSString对象，用于生成文件名
 *@param suffix 文件后缀，如jpg
 *@param path 缓存路径
 */
+ (void)moveFiles:(NSArray*) files withURLs:(NSArray*) urls suffix:(NSString *)suffix toPath:(NSString *)path
{
    if([NSString isEmpty:path])
        return;
    dispatch_block_t block = ^(void)
    {
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        for(NSInteger i = 0;i < files.count && i < urls.count;i ++)
        {
            NSString *file = [files objectAtIndex:i];
            NSString *url = [urls objectAtIndex:i];
            
            NSString *toPath = [path stringByAppendingPathComponent:[SeaFileManager fileNameForURL:url suffix:suffix]];
            [fileManager moveItemAtPath:file toPath:toPath error:nil];
        }
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

/**对相关文件或目录设定 不备份iCloud属性
 */
+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if(![[NSFileManager defaultManager] fileExistsAtPath: [URL path]])
        return NO;
    
//    if(_ios5_1_)
//    {
//        NSError *error = nil;
//        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
//                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
//        if(!success)
//        {
//            NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
//        }
//        
//        return success;
//    }
//    else
    //{
        const char *filePath = [[URL path] fileSystemRepresentation];
        
        const char *attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
   // }
}


@end
