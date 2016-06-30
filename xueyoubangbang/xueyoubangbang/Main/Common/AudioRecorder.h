//
//  AudioRecorder.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/31.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AudioPlayerDelegate <NSObject>
@optional
- (void)didFinishedPlay;
@end

#import <AVFoundation/AVFoundation.h>

@interface AudioRecorder : UIView
@property (nonatomic,retain) UIButton *recordButton;
@property (nonatomic,retain) UIButton *playerButton;
@property (nonatomic,retain) UIButton *deleteButton;
@property (nonatomic) BOOL isRecording;
@property (nonatomic,weak) id<AudioPlayerDelegate> audioDelegate;
@property (nonatomic,weak) id<AVAudioRecorderDelegate> delegate;
@property (nonatomic,retain)     NSData *amrAudio; //amr

@end
