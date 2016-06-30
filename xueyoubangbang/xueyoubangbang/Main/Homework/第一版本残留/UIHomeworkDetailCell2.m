//
//  UIHomeworkDetailCell2.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkDetailCell2.h"
#import "AudioPlayer.h"
@interface UIHomeworkDetailCell2()
{
    AudioPlayer    *audio;
    UILabel         *descLabel;
}
@end
@implementation UIHomeworkDetailCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createView];
    }
    return self;
}


#define topH 40
#define cellH 160
- (void)createView
{
    //左上角
    
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_message_remind"]];
    leftIcon.frame = CGRectMake(10, topH / 2 - leftIcon.frame.size.height / 2, leftIcon.frame.size.width, leftIcon.frame.size.height);
    [self.contentView addSubview:leftIcon];
    
    UILabel *leftTopLabel = [[UILabel alloc] init];
    leftTopLabel.frame = CGRectMake([leftIcon rightX] + 10, 0, 60, topH);
    [self.contentView addSubview:leftTopLabel];
    self.leftTopLabel = leftTopLabel;

    
    //    if([rolesUser isEqualToString:roleStudent])
    //    {
    //右上角
    UIButton *rightTopButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [rightTopButton setTitle:@"问一下" forState:UIControlStateNormal];
    rightTopButton.frame = CGRectMake(SCREEN_WIDTH - 60 , 0, 60,topH);
    [rightTopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.contentView addSubview:rightTopButton];
    self.rightTopButton = rightTopButton;
    
    UIImageView *rigthIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homework_question"]];
    rigthIcon.frame = CGRectMake(rightTopButton.frame.origin.x - rigthIcon.frame.size.width, topH / 2 - rigthIcon.frame.size.height / 2, rigthIcon.frame.size.width, rigthIcon.frame.size.height);
    [self.contentView addSubview:rigthIcon];
    self.rightIcon = rigthIcon;
    //    }
    //    else if([])
    
    UIView *seperate = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, 40, SCREEN_WIDTH - 2 * kPaddingLeft, 1)];
    seperate.backgroundColor = VIEW_BACKGROUND_COLOR;
    [self.contentView addSubview:seperate];
    
    descLabel = [[UILabel alloc] init];
    [self.contentView addSubview:descLabel];

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    if(![CommonMethod isBlankString:self.imageUrl]|| _image)
    {
        self.imageView.frame = CGRectMake(10, topH + 10, cellH - topH - 20, cellH - topH - 20);
    }
    else if (self.desc && ![self.desc isEqualToString:@""])
    {
        self.imageView.frame = CGRectMake(0, topH, 0, 0);
        
    }
    else
    {
        if (self.ifAddWorkVC) {
            self.imageView.frame = CGRectMake(10, topH + 10, cellH - topH - 20, cellH - topH - 20);
            self.imageView.image = [UIImage imageNamed:@"homewoek_addpic"];
        }
        
    }
    
    if(![CommonMethod isBlankString:self.audioUrl] || _audioData)
    {
        audio.hidden = NO;
        audio.frame = CGRectMake([self.imageView rightX] + 10, cellH  - 10 - audio.frame.size.height, audio.frame.size.width, audio.frame.size.height);
    }
    
    descLabel.frame = CGRectMake([self.imageView rightX] + 10, self.imageView.frame.origin.y, SCREEN_WIDTH - [self.imageView rightX], 40);
    
    
}

- (void)setHomeworkItem:(MHomeworkItem *)homeworkItem
{
    _imageUrl = homeworkItem.firstimg;
    _desc = homeworkItem.desc;
    _audioUrl = homeworkItem.audio;
    _image = homeworkItem.firstUIImage;
    _audioData = homeworkItem.audioData;
    if(_image)
    {
        self.imageView.image = _image;
    }
    else if(![CommonMethod isBlankString:_imageUrl])
    {
        if (self.ifAddWorkVC) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(_imageUrl)] placeholderImage:[UIImage imageNamed:@"homewoek_addpic"] options:SDWebImageProgressiveDownload];
        }
        else{
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(_imageUrl)] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload];
        }
        
    }
    
    descLabel.text = _desc;
    
    audio.audioUrl = _audioUrl;
    audio.amrAudio = _audioData;
    
    self.leftTopLabel.text = homeworkItem.title;
    if(![CommonMethod isBlankString:self.imageUrl]|| _image)
    {
        self.imageView.frame = CGRectMake(10, topH + 10, cellH - topH - 20, cellH - topH - 20);
    }
    else if (self.desc && ![self.desc isEqualToString:@""])
    {
        self.imageView.frame = CGRectMake(0, topH, 0, 0);
        
    }
    else
    {
        if (self.ifAddWorkVC) {
            self.imageView.image = [UIImage imageNamed:@"homewoek_addpic"];
        }
        self.imageView.frame = CGRectMake(10, topH + 10, cellH - topH - 20, cellH - topH - 20);
    }
}

 + (CGFloat)cellHeight
{
    return cellH;
}


@end
