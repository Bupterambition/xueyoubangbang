//
//  UIListTableViewCell.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIListTableViewCell.h"
#import "AudioPlayer.h"
@interface UIListTableViewCell()
{
    AudioPlayer    *audio;
    UILabel         *descLabel;
}
@end
@implementation UIListTableViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self createView];
    }
    return self;
}

#define cellH  100
- (void)layoutSubviews
{
    if(![CommonMethod isBlankString:self.imageUrl]|| _image)
    {
        self.imageView.frame = CGRectMake(10, 10, cellH - 20, cellH - 20);
    }
    else
    {
        self.imageView.frame = CGRectMake(0, 10, 0, 0);
    }
    
    if(![CommonMethod isBlankString:self.audioUrl] || _audioData)
    {
        audio.hidden = NO;
        audio.frame = CGRectMake([self.imageView rightX] + 10, cellH - 10 - audio.frame.size.height, audio.frame.size.width, audio.frame.size.height);
    }
    
    descLabel.frame = CGRectMake([self.imageView rightX] + 10, self.imageView.frame.origin.y, SCREEN_WIDTH - [self.imageView rightX], cellH - audio.frame.origin.y);
    
    
}

- (void)createView
{
    descLabel = [[UILabel alloc] init];
    [self.contentView addSubview:descLabel];
    descLabel.numberOfLines = 3;
    
    audio = [[AudioPlayer alloc] init];
    audio.hidden = YES;
    [self.contentView addSubview:audio];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
}


- (void)setImageUrl:(NSString *)imageUrl image:(UIImage *)image desc:(NSString *)desc audioUrl:(NSString *)audioUrl audioData:(NSData *)audioData
{
    _imageUrl = imageUrl;
    _desc = desc;
    _audioUrl = audioUrl;
    _image = image;
    _audioData = audioData;
    if(image)
    {
        self.imageView.image = image;
    }
    else if(![CommonMethod isBlankString:imageUrl])
    {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(imageUrl)]];
    }
    
    descLabel.text = desc;
    
    audio.audioUrl = audioUrl;
    audio.amrAudio = audioData;
}

+ (CGFloat)cellHeight
{
    return cellH;
}


@end
