//
//  AudioRecorder.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/31.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "AudioRecorder.h"
#import "RecordAudio.h"
@interface AudioRecorder()<AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    
    RecordAudio *recordAudio;
    NSTimer *animateTimer;
    NSArray *imageArr;
    int imageIndex;
}
@end
@implementation AudioRecorder

static double startRecordTime=0;
static double endRecordTime=0;
-(id)init
{
    self = [super init];
    if(self)
    {
        [self initial];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _recordButton.frame = CGRectMake(self.frame.size.width / 2 - 180 / 2, 10, 180, self.frame.size.height - 20);
    CGSize size = [UIImage imageNamed:@"answer_voice3"].size;
    _playerButton.frame = CGRectMake(20, self.frame.size.height / 2 - size.height / 2, size.width , size.height);
    _playerButton.frame = CGRectMake(20, frame.size.height / 2 - size.height / 2, size.width, size.height);
    _deleteButton.frame = CGRectMake(self.frame.size.width - 100 - 20, 10, 100, self.frame.size.height - 20);
}

- (void)initial
{
    imageIndex = 0;
    imageArr = @[[UIImage imageNamed:@"answer_voice3"],
                 [UIImage imageNamed:@"answer_voice2"],
                 [UIImage imageNamed:@"answer_voice1"],
                 [UIImage imageNamed:@"answer_voice2"]];
    
    self.backgroundColor = [UIColor whiteColor];
    _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_recordButton];
    _recordButton.frame = CGRectMake(self.frame.size.width / 2 - 180 / 2, 0, 180, self.frame.size.height);
    [_recordButton setTitle:@"按住添加语音" forState:UIControlStateNormal];
    [_recordButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_recordButton addTarget:self action:@selector(btnDown) forControlEvents:UIControlEventTouchDown];
    [_recordButton addTarget:self action:@selector(btnUp:) forControlEvents:UIControlEventTouchUpInside];
    _recordButton.layer.borderColor = VIEW_BACKGROUND_COLOR.CGColor;
    _recordButton.layer.borderWidth = 1;
    _recordButton.titleLabel.font = FONT_CUSTOM(14);
    
    _playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_playerButton];
    CGSize size = [UIImage imageNamed:@"answer_voice3"].size;
    _playerButton.frame = CGRectMake(20, self.frame.size.height / 2 - size.height / 2, size.width , size.height);
//    [_playerButton setTitle:@"播放" forState:UIControlStateNormal];
    [_playerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playerButton addTarget:self action:@selector(doPlayOrStop) forControlEvents:UIControlEventTouchUpInside];
    _playerButton.hidden = YES;
    [_playerButton setBackgroundImage:[UIImage imageNamed:@"answer_voice3"] forState:UIControlStateNormal];

    
    _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_deleteButton];
    [_deleteButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _deleteButton.frame = CGRectMake(self.frame.size.width - 100 - 20, 0, 100, self.frame.size.height);
    [_deleteButton setTitle:@"重新添加语音" forState:UIControlStateNormal];
    [_deleteButton addTarget:self action:@selector(doDelete) forControlEvents:UIControlEventTouchUpInside];
    _deleteButton.hidden = YES;
    _deleteButton.layer.borderColor = VIEW_BACKGROUND_COLOR.CGColor;
    _deleteButton.layer.borderWidth = 1;
    _deleteButton.titleLabel.font = FONT_CUSTOM(14);

    recordAudio = [[RecordAudio alloc] init];
    recordAudio.playerDelegate = self;
    
}

- (void)startRecord
{
    
    AVAudioSession *avSession = [AVAudioSession sharedInstance];
    
    if ([avSession respondsToSelector:@selector(requestRecordPermission:)])
    {
        
        [avSession requestRecordPermission:^(BOOL available)
        {
            
            if (available)
            {
                if(!self.isRecording)
                {
                    self.isRecording = YES;
                    [_recordButton setTitle:@"正在录音" forState:UIControlStateNormal];
                
                    [recordAudio stopPlay];
                    [recordAudio startRecord];
                    startRecordTime = [NSDate timeIntervalSinceReferenceDate];
                    
                    self.amrAudio=nil;
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIView *audioView = [[UIApplication sharedApplication].keyWindow viewWithTag:1009];
                    [audioView removeFromSuperview];
                    [[[UIAlertView alloc] initWithTitle:@"无法录音" message:@"请在“设置-隐私-麦克风”选项中允许学有帮帮访问你的麦克风" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
                });
            }
        }];
        
    }
    
}


- (void)stopRecord
{

    NSURL *url = [recordAudio stopRecord];
    
    if (url != nil) {
        self.amrAudio = EncodeWAVEToAMR([NSData dataWithContentsOfURL:url],1,16);
        
    }

}

- (void)btnDown
{
    _recordButton.backgroundColor=[UIColor grayColor];
    [self startRecord];
}

- (void)btnUp:(id)sender
{
    _recordButton.backgroundColor=[UIColor whiteColor];
    self.isRecording = NO;
    [_recordButton setTitle:@"按住添加语音" forState:UIControlStateNormal];
    endRecordTime = [NSDate timeIntervalSinceReferenceDate];

    endRecordTime -= startRecordTime;
    if (endRecordTime<1.00f) {
        NSLog(@"录音时间过短");
        [CommonMethod showAlert:@"录音时间过短"];
        return;
    }
    
    _deleteButton.hidden = NO;
    _playerButton.hidden = NO;
    _recordButton.hidden = YES;
    [self stopRecord];
}

- (void)doPlayOrStop
{
    if(animateTimer)
    {
        [animateTimer invalidate];
        imageIndex = 0;
        [_playerButton setBackgroundImage:[UIImage imageNamed:@"answer_voice3"] forState:UIControlStateNormal];
    }
    
    if(recordAudio.avPlayer != nil)
    {
        [recordAudio stopPlay];
    }
    else
    {
        [animateTimer invalidate];
        animateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doAnimate) userInfo:nil repeats:YES];

        if(self.amrAudio != nil && self.amrAudio.length > 0)
        {
            [recordAudio play:self.amrAudio];
        }
    }

}


- (void)doAnimate
{
    imageIndex = fmod(imageIndex + 1, 4);
    [_playerButton setBackgroundImage:[imageArr objectAtIndex:imageIndex] forState:UIControlStateNormal];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [animateTimer invalidate];
    imageIndex = 0;
    if ([self.audioDelegate respondsToSelector:@selector(didFinishedPlay)]) {
        [self.audioDelegate didFinishedPlay];
    }
}



- (void)doDelete
{
    _deleteButton.hidden = YES;
    _playerButton.hidden = YES;
    _recordButton.hidden = NO;
    self.amrAudio = nil;
}

@end
