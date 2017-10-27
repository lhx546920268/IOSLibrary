//
//  SeaSystemSound.h
//  sea
//
//

#import <UIKit/UIKit.h>

///三全音
UIKIT_EXTERN NSString *const SeaSystemSoundTritoneSound;

///发送 短信的声音 嘘嘘
UIKIT_EXTERN NSString *const SeaSystemSoundSendMessageSound;

///鸟鸣声
UIKIT_EXTERN NSString *const SeaSystemSoundTweetSound;

/**系统声音操作
 */
@interface SeaSystemSound : NSObject

/**播放三全音
 */
- (void)playTritoneSound;

/**播放 发短信的声音
 */
- (void)playTweetSound;

/**播放鸟鸣声
 */
- (void)playSendMessageSound;

#pragma mark- class method

///震动
+ (void)systemShake;

///系统声音
+ (void)systemSoundWithName:(NSString*) name;

///播放本地声音
+ (void)systemSoundWithURL:(NSString*) url;

@end
