//
//  SeaSystemSound.m
//

#import "SeaSystemSound.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "SeaBasic.h"


#define _tritoneSoundName_ @"sms-received1" //三全音
#define _sendMessageSoundName_ @"SentMessage" //发送 短信的声音 嘘嘘
#define _tweetSoundName_ @"tweet_sent" //鸟鸣声

NSString *const SeaSystemSoundTritoneSound = @"sms-received1.caf";
NSString *const SeaSystemSoundSendMessageSound = @"SentMessage.caf";
NSString *const SeaSystemSoundTweetSound = @"tweet_sent.caf";

static void soundFinished(SystemSoundID soundID, void* path)
{
    AudioServicesDisposeSystemSoundID(soundID);
}

@interface SeaSystemSound ()
{
    ///三全音
    SystemSoundID _tritoneSoundID;
    
    ///发短信声音
    SystemSoundID _sendMessageSoundID;
    
    ///鸟鸣声
    SystemSoundID _tweetSoundID;
}

@end

@implementation SeaSystemSound

#pragma mark- dealloc

- (void)dealloc
{
    if(_tritoneSoundID != 0)
    {
        AudioServicesDisposeSystemSoundID(_tritoneSoundID);
    }
    
    if(_tweetSoundID != 0)
    {
        AudioServicesDisposeSystemSoundID(_tweetSoundID);
    }
    
    if(_sendMessageSoundID != 0)
    {
        AudioServicesDisposeSystemSoundID(_sendMessageSoundID);
    }
}

#pragma mark- public method

/**播放三全音
 */
- (void)playTritoneSound
{
    if(_tritoneSoundID == 0)
    {
        [self createSystemSoundID:&_tritoneSoundID withFileName:SeaSystemSoundTritoneSound];
    }

    [self playSystemSoundWithID:_tritoneSoundID];
}

/**播放 发短信的声音
 */
- (void)playTweetSound
{
    if(_tweetSoundID == 0)
    {
        [self createSystemSoundID:&_tweetSoundID withFileName:SeaSystemSoundTweetSound];
    }

    [self playSystemSoundWithID:_tweetSoundID];
}

/**播放鸟鸣声
 */
- (void)playSendMessageSound
{
    if(_sendMessageSoundID == 0)
    {
        [self createSystemSoundID:&_sendMessageSoundID withFileName:SeaSystemSoundSendMessageSound];
    }
    
    [self playSystemSoundWithID:_sendMessageSoundID];
}

#pragma mark- private method

/**创建系统声音
 */
- (void)createSystemSoundID:(SystemSoundID*) soundID withFileName:(NSString*) fileName
{
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@", fileName];
    
    if(path)
    {
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], soundID);
        if(error != kAudioServicesNoError)
        {
            soundID = 0;
            NSLog(@"%@声音初始化失败", fileName);
        }
        else
        {
//            AudioServicesPropertyID flag = 0;
//            AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &soundID, sizeof(AudioServicesPropertyID), &flag);
        }
    }
    else
    {
        NSLog(@"%@声音初始化失败", fileName);
    }
}

/**播放系统声音
 */
- (void)playSystemSoundWithID:(SystemSoundID) soundID
{
    dispatch_main_async_safe(^(void){
        
        //            UInt32 sessionCategory = kAudioSessionCategory_AmbientSound;    // 1
        //
        //            AudioSessionSetProperty (
        //                                     kAudioSessionProperty_AudioCategory,                        // 2
        //                                     sizeof (sessionCategory),                                   // 3
        //                                     &sessionCategory                                            // 4
        //                                     );
        //
        AudioServicesPlaySystemSound(soundID);
    });
}

#pragma mark- class method

//震动
+ (void)systemShake
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

//系统声音
+ (void)systemSoundWithName:(NSString *)name
{
    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@",name];
    [SeaSystemSound systemSoundWithPath:path];
}

///播放本地声音
+ (void)systemSoundWithURL:(NSString*) url
{
    [SeaSystemSound systemSoundWithPath:url];
}

///播放系统声音
+ (void)systemSoundWithPath:(NSString*) path
{
    dispatch_main_async_safe((^(void)
    {
        SystemSoundID soundID;
        OSStatus error = AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundID);
        if(error == kAudioServicesNoError)
        {
            
            AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundFinished, (__bridge void *)path);
            //                    AudioServicesPropertyID flag = 0;
            //                    AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(SystemSoundID), &soundID, sizeof(AudioServicesPropertyID), &flag);
            //AudioServicesPlayAlertSound(soundID);
            AudioServicesPlaySystemSound(soundID);
            //  NSLog(@"播放系统声音");
        }
        else
        {
            NSLog(@"播放系统声音出错%d",(int)error);
        }
        
    }));
}

@end
