//
//  SeaFileManager.m
//

#import "SeaFileManager.h"
#import "NSString+Utilities.h"
#import "NSDate+Utils.h"
#import "SeaImageCacheTool.h"
#import <sys/xattr.h>


@implementation SeaFileManager

+ (NSArray<NSString*>*)writeImages:(NSArray<UIImage*>*) images
{
    return [SeaFileManager writeImages:images scale:1.0];
}

+ (NSArray<NSString*>*)writeImages:(NSArray<UIImage*>*) images scale:(float) scale
{
    return [SeaFileManager writeImages:images scale:scale failImages:nil];
}

+ (NSArray<NSString*>*)writeImages:(NSArray<UIImage*>*) images scale:(float) scale failImages:(NSMutableArray<UIImage*>*) failImages
{
    scale = MIN(scale, 1.0);
    scale = MAX(scale, 0);
    
    NSString *filePath = NSTemporaryDirectory();
    NSMutableArray *files = [[NSMutableArray alloc] init];

    
    for(NSInteger i = 0; i < images.count; i ++){
        UIImage *image = [images objectAtIndex:i];
        NSString *fileName = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"tmpImage%@.%@", [NSDate getTimeAndRandom], @"jpg"]];
        
        NSData *imageData = UIImageJPEGRepresentation(image, scale);

        NSError *error = nil;
        if([imageData writeToFile:fileName options:NSDataWritingAtomic error:&error]){
            [files addObject:fileName];
        }
        else{
            NSLog(@"error = %@",error);
            [failImages addObject:image];
        }
    }
    
    return files;
}

+ (NSDictionary<NSNumber*, NSString*>*)writeImagesReturnDictionary:(NSArray<UIImage*>*) images scale:(float) scale
{
    if(images.count == 0)
        return nil;
    scale = MIN(scale, 1.0);
    scale = MAX(scale, 0);
    
    NSString *filePath = NSTemporaryDirectory();
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:images.count];
    for(NSInteger i = 0; i < images.count; i ++){
        UIImage *image = [images objectAtIndex:i];
        NSString *fileName = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"tmpImage%@.%@", [NSDate getTimeAndRandom], @"jpg"]];
        
        NSData *imageData = UIImageJPEGRepresentation(image, scale);
        
        NSError *error = nil;
        if([imageData writeToFile:fileName options:NSDataWritingAtomic error:&error]){
            [dic setObject:fileName forKey:[NSNumber numberWithInteger:i]];
        }
        else{
            NSLog(@"error = %@",error);
        }
    }
    
    return dic;
}

+ (NSString*)writeImage:(UIImage*) image scale:(float) scale
{
    scale = MIN(scale, 1.0);
    scale = MAX(scale, 0);
    
    NSString *filePath = NSTemporaryDirectory();
    
    
    NSString *fileName = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"tmpImage%@.%@", [NSDate getTimeAndRandom], @"jpg"]];
    
    NSData *imageData = UIImageJPEGRepresentation(image, scale);
    
    NSError *error = nil;
    if([imageData writeToFile:fileName options:NSDataWritingAtomic error:&error]){
        return fileName;
    }
    else{
        NSLog(@"error = %@",error);
    }

    return nil;
}

+ (void)deleteFiles:(NSArray<NSString*>*) files
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void){
        
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        for(NSString *file in files){
            [fileManager removeItemAtPath:file error:nil];
        }
    });
}

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

+ (NSString*)getTemporaryFileWithSuffix:(NSString*) suffix
{
    NSString *temp = NSTemporaryDirectory();
    NSString *time = [NSDate getTimeAndRandom];
    NSString *file = [NSString stringWithFormat:@"%@.%@",time, suffix];
    
    return [temp stringByAppendingPathComponent:file];
}

+ (NSString*)fileNameForURL:(NSString*) url suffix:(NSString *)suffix
{
    NSString *fileName = [url md5];
    
    if(![NSString isEmpty:suffix]){
        fileName = [fileName stringByAppendingFormat:@".%@",suffix];
    }
    return fileName;
}

+ (void)moveFiles:(NSArray<NSString*>*) files withURLs:(NSArray<NSString*>*) URLs suffix:(NSString*) suffix toPath:(NSString*) path
{
    if([NSString isEmpty:path])
        return;
    dispatch_block_t block = ^(void){
        NSFileManager *fileManager = [[NSFileManager alloc] init];
        
        for(NSInteger i = 0;i < files.count && i < URLs.count;i ++){
            NSString *file = [files objectAtIndex:i];
            NSString *url = [URLs objectAtIndex:i];
            
            NSString *toPath = [path stringByAppendingPathComponent:[SeaFileManager fileNameForURL:url suffix:suffix]];
            [fileManager moveItemAtPath:file toPath:toPath error:nil];
        }
    };
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), block);
}

+ (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    if(![[NSFileManager defaultManager] fileExistsAtPath:[URL path]])
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
