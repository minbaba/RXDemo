//
//  LVRecordTool.m
//  RecordAndPlayVoice
//
//  Created by PBOC CS on 15/3/14.
//  Copyright (c) 2015年 liuchunlao. All rights reserved.
//

#define LVRecordFielName @"lvRecord.wav"

#import "EMMessage.h"
#import "EMVoiceMessageBody.h"
#import "LVRecordTool.h"
#import "EMVoiceConverter.h"


@interface LVRecordTool () <AVAudioRecorderDelegate, AVAudioPlayerDelegate>


/** 录音文件地址 */
@property (nonatomic, strong) NSURL *recordFileUrl;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

//@property (nonatomic, strong) AVAudioSession *session;

@end

@implementation LVRecordTool


- (void)playVoiceMessage:(EMMessage *)message {
    
    self.message = message;
    EMVoiceMessageBody *body = (EMVoiceMessageBody *) message.body;
    NSURL *cafPath = [NSURL URLWithString:body.localPath];
    
    NSMutableArray *arr = [[body.localPath componentsSeparatedByString:@"/"] mutableCopy];
    [arr removeLastObject];
    [arr addObject:@"olodvoiceConvert"];
    NSString *str = [arr componentsJoinedByString:@"/"];
    if ([EMVoiceConverter isAMRFile:body.localPath]) {
        [[NSData dataWithContentsOfURL:cafPath] writeToFile:str atomically:YES];
        [EMVoiceConverter amrToWav:str wavSavePath:body.localPath];
    }
    
    NSData *data = [NSData dataWithContentsOfFile:body.localPath];
    if (data && data.length) {
        [self playRecordingFile:data];
    }
    
    
}

- (void)startRecording {
    // 录音时停止播放 删除曾经生成的文件
    [self stopPlaying];
    [self destructionRecordingFile];
    
    // 真机环境下需要的代码
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError;
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    
    if(session == nil)
        NSLog(@"Error creating session: %@", [sessionError description]);
    else
        [session setActive:YES error:nil];
    
//    self.session = session;
    
    [self.recorder record];
    
    self.timer = [NSTimer timerWithTimeInterval:0.05 target:self selector:@selector(updateImage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.timer fire];
}

- (void)updateImage {
    
    [self.recorder updateMeters];
    double lowPassResults = pow(10, (0.05 * [self.recorder peakPowerForChannel:0]));
    if ([self.delegate respondsToSelector:@selector(recordTool:didstartRecoring:)]) {
        [self.delegate recordTool:self didstartRecoring: lowPassResults];
    }
}

- (NSURL *)stopRecording {
    if ([self.recorder isRecording]) {
        [self.recorder stop];
        [self.timer invalidate];
        
        NSMutableArray *arr = [[_recordFileUrl.absoluteString componentsSeparatedByString:@"/"] mutableCopy];
        [arr removeLastObject];
        [arr addObject:@"olodvoiceConvert"];
        NSString *str = [arr componentsJoinedByString:@"/"];
        if (![EMVoiceConverter isAMRFile:_recordFileUrl.absoluteString]) {
            [[NSData dataWithContentsOfURL:_recordFileUrl] writeToFile:str atomically:YES];
            [EMVoiceConverter wavToAmr:str amrSavePath:_recordFileUrl.absoluteString];
        }
        
        return self.recordFileUrl;
    }
    
    else return nil;
}


- (void)playRecordingFile:(NSData *)file {
    // 播放时停止录音
    [self.recorder stop];
    
    // 正在播放就返回
    if ([self.player isPlaying]) [self.player stop];

    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    self.player = [[AVAudioPlayer alloc] initWithData:file error:nil];
    self.player.delegate = self;
    [self.player play];
}

- (void)stopPlaying {
    [self.player stop];
}

static id instance;
#pragma mark - 单例
+ (instancetype)sharedRecordTool {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[self alloc] init];
        }
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [super allocWithZone:zone];
        }
    });
    return instance;
}

#pragma mark - 懒加载
- (AVAudioRecorder *)recorder {
    if (!_recorder) {
        
        // 1.获取沙盒地址
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePath = [path stringByAppendingPathComponent:LVRecordFielName];
        self.recordFileUrl = [NSURL fileURLWithPath:filePath];
        
        // 3.设置录音的一些参数
        NSMutableDictionary *setting = [NSMutableDictionary dictionary];
        // 音频格式
        setting[AVFormatIDKey] = @(kAudioFormatLinearPCM);
        // 录音采样率(Hz) 如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
        setting[AVSampleRateKey] = @(8000.0);
        // 音频通道数 1 或 2
        setting[AVNumberOfChannelsKey] = @(1);
        // 线性音频的位深度  8、16、24、32
        setting[AVLinearPCMBitDepthKey] = @(16);
        //录音的质量
        setting[AVEncoderAudioQualityKey] = [NSNumber numberWithInt:AVAudioQualityMedium];
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:self.recordFileUrl settings:setting error:NULL];
        _recorder.delegate = self;
        _recorder.meteringEnabled = YES;
        
        [_recorder prepareToRecord];
    }
    return _recorder;
}

- (void)destructionRecordingFile {

    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (self.recordFileUrl) {
        [fileManager removeItemAtURL:self.recordFileUrl error:NULL];
    }
}

- (BOOL)isRecording {
    return self.recorder.isRecording;
}

#pragma mark - AVAudioRecorderDelegate
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag {
    if (flag) {
        [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
}

#pragma mark - 播放器代理
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    
    [[AVAudioSession sharedInstance] setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    if ([self.PlayingDelegate respondsToSelector:@selector(recordToolDidStopPlaying:)]) {
        [self.PlayingDelegate recordToolDidStopPlaying:self];
    }
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error {
    if ([self.PlayingDelegate respondsToSelector:@selector(recordToolDidStopPlaying:)]) {
        [self.PlayingDelegate recordToolDidStopPlaying:self];
    }
    
}


- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player withFlags:(NSUInteger)flags {
    if ([self.PlayingDelegate respondsToSelector:@selector(recordToolDidStopPlaying:)]) {
        [self.PlayingDelegate recordToolDidStopPlaying:self];
    }
}

@end
