//
//  AudioPlayer.h
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


@interface AudioPlayer : UIView
@property (nonatomic,retain) UIButton *playerButton;
@property (nonatomic,retain)     NSData *amrAudio; //amr
@property (nonatomic,copy)  NSString *    audioUrl;
@property (nonatomic,weak)  id contrllerView;
@property (nonatomic,weak) id<AudioPlayerDelegate> audioDelegate;
@end
