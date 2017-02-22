//
//  LVRecordTool.h
//  RecordAndPlayVoice
//
//  Created by PBOC CS on 15/3/14.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class EMMessage;
@class LVRecordTool;
@protocol LVRecordToolDelegate <NSObject>

@optional
- (void)recordTool:(LVRecordTool *)recordTool didstartRecoring:(CGFloat)no;

- (void)recordToolDidStopPlaying:(LVRecordTool *)recordTool;

@end

@interface LVRecordTool : NSObject

/** 录音工具的单例 */
+ (instancetype)sharedRecordTool;

/** 开始录音 */
- (void)startRecording;

/** 停止录音 */
- (NSURL *)stopRecording;

/** 播放录音文件 */
- (void)playRecordingFile:(NSData *)file;
- (void)playVoiceMessage: (EMMessage *)message;

/** 停止播放录音文件 */
- (void)stopPlaying;

/** 销毁录音文件 */
- (void)destructionRecordingFile;

@property (nonatomic, weak) EMMessage *message;

/** 录音对象 */
@property (nonatomic, strong) AVAudioRecorder *recorder;
/** 播放器对象 */
@property (nonatomic, strong) AVAudioPlayer *player;

/** 更新图片的代理 */
@property (nonatomic, assign) id<LVRecordToolDelegate> delegate;

/** 更新图片的代理 */
@property (nonatomic, assign, readonly) BOOL isRecording;


@property (nonatomic, assign) id<LVRecordToolDelegate> PlayingDelegate;

@end
