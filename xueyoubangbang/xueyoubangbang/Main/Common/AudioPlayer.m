//
//  AudioPlayer.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/31.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "AudioPlayer.h"
#import "RecordAudio.h"

@interface AudioPlayer()<AVAudioPlayerDelegate>
{
    RecordAudio *audio;
    NSTimer *animateTimer;
    NSArray *imageArr;
    NSInteger imageIndex;
}

@end

@implementation AudioPlayer

-(id)init
{

    
    self = [super init];
    if(self)
    {
        [self initial];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    CGSize size = [UIImage imageNamed:@"answer_voice3"].size;
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, size.width , size.height)];
    if(self)
    {
        [self initial];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    CGSize size = [UIImage imageNamed:@"answer_voice3"].size;
    [super setFrame: CGRectMake(frame.origin.x, frame.origin.y, size.width, size.height)];
}

- (void)initial
{
    imageIndex = 0;
    imageArr = @[[UIImage imageNamed:@"answer_voice3"],
                 [UIImage imageNamed:@"answer_voice2"],
                 [UIImage imageNamed:@"answer_voice1"],
                 [UIImage imageNamed:@"answer_voice2"]];
    
    audio = [[RecordAudio alloc] initWithoutRecorder];
    audio.playerDelegate = self;
    
    _playerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_playerButton];
    CGSize size = [UIImage imageNamed:@"answer_voice3"].size;
    _playerButton.frame = CGRectMake(0, 0, size.width , size.height);    //    [_playerButton setTitle:@"播放" forState:UIControlStateNormal];
//    [_playerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_playerButton addTarget:self action:@selector(doPlayOrStop:) forControlEvents:UIControlEventTouchUpInside];
//    _playerButton.hidden = YES;
    
//    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
//    [_playerButton addGestureRecognizer:gesture];

    
    [_playerButton setBackgroundImage:[imageArr objectAtIndex:imageIndex] forState:UIControlStateNormal];
    [self addSubview:_playerButton];
}

//- (void)tapHandle:(UITapGestureRecognizer *)tap {
//    [self doPlayOrStop];
//}

- (void)doPlayOrStop:(id)sender
{
    if(self.amrAudio == nil)
    {
        if([self.contrllerView isKindOfClass:[UIViewController class]])
        {
            [MBProgressHUD showHUDAddedTo:((UIViewController*) self.contrllerView).view animated:YES];
        }
        NSDate *now = [NSDate date];
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyyMMdd"];
        NSString *dir = [df stringFromDate:now];

        NSString *saveDir = [@"audio" stringByAppendingPathComponent:dir];
        NSString *name = [NSString stringWithFormat:@"%ld.amr", (long) [[ NSDate date ] timeIntervalSince1970]];
        
        [AFNetClient GlobalDownloadURL:UrlResStringForImg(self.audioUrl) saveFilePath:saveDir saveFileName:name success:^(NSURLResponse *response, NSString *filePath) {
            if([self.contrllerView isKindOfClass:[UIViewController class]])
            {
                [MBProgressHUD hideAllHUDsForView:((UIViewController*) self.contrllerView).view animated:YES];
            }            self.amrAudio = [NSData dataWithContentsOfFile:filePath];
            [self play];
        } failure:^(NSURLResponse *response, NSError *error) {
            if([self.contrllerView isKindOfClass:[UIViewController class]])
            {
                [MBProgressHUD hideAllHUDsForView:((UIViewController*) self.contrllerView).view animated:YES];
            }
            [CommonMethod showAlert:@"下载失败"];
        }];
    }
    else if(self.amrAudio.length>0)
    {
        [self play];
    }
    
}

- (void)play
{
    if(animateTimer)
    {
        [animateTimer invalidate];
        imageIndex = 0;
        [_playerButton setBackgroundImage:[imageArr objectAtIndex:imageIndex] forState:UIControlStateNormal];
    }
    
    if(audio.avPlayer != nil)
    {
        [audio stopPlay];
    }
    else
    {
        [animateTimer invalidate];
        animateTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doAnimate) userInfo:nil repeats:YES];
        
        if(self.amrAudio != nil && self.amrAudio.length > 0)
        {
            [audio play:self.amrAudio];
        }
    }
    
}

- (void)stop
{
    [audio stopPlay];
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
    [_playerButton setBackgroundImage:[imageArr objectAtIndex:imageIndex] forState:UIControlStateNormal];
    if ([self.audioDelegate respondsToSelector:@selector(didFinishedPlay)]) {
        [self.audioDelegate didFinishedPlay];
    }
}
@end
