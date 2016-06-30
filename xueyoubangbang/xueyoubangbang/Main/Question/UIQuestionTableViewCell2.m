//
//  UIQuestionTableViewCell2.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIQuestionTableViewCell2.h"
#import "AudioPlayer.h"
@interface UIQuestionTableViewCell2()
{
    AudioPlayer    *audio;
    UILabel         *descLabel;
    
    UILabel *_leftTop1;
    UILabel *_leftTop2;
    UILabel *_nicknameLabel;
    UILabel *_rightBottom;
    UIImageView *_userHeader;
    
    UIView  *bottomContainer;
}


@end

@implementation UIQuestionTableViewCell2

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self createView];
    }
    return self;
}

#define cellH  160
#define leftTop1Width 60
#define leftTop2Width 100
#define headerImageWidth 60
#define headerImageHeight 60
#define titleLableWidth 200
#define titleLableHeight 50
#define rightBottomWidth 60
#define topH 30
#define left 20
#define bottomH 30
- (void)layoutSubviews
{
    if(![CommonMethod isBlankString:_question.firstimg])
    {
        self.imageView.frame = CGRectMake(10 , 10 + [_leftTop1 bottomY], cellH - 80, cellH - 80);
    }
    else
    {
        self.imageView.frame = CGRectMake(0, 10 + [_leftTop1 bottomY] ,0, 0);
    }
    
    if(![CommonMethod isBlankString:_question.audio])
    {
        audio.hidden = NO;
        audio.frame = CGRectMake([self.imageView rightX] + 10, cellH - bottomH - 10 - audio.frame.size.height, audio.frame.size.width, audio.frame.size.height);
    }
    else
    {
        audio.hidden = YES;
        audio.frame = CGRectMake([self.imageView rightX] + 10, cellH - bottomH - 10 - audio.frame.size.height, audio.frame.size.width, audio.frame.size.height);
    }
    descLabel.frame = CGRectMake([self.imageView rightX] + 10, self.imageView.frame.origin.y, SCREEN_WIDTH - [self.imageView rightX], cellH - bottomH - audio.frame.origin.y);
    
    bottomContainer.frame = CGRectMake(0, [audio bottomY] + 10, SCREEN_WIDTH, bottomH);
}

- (void)createView
{
    
    _leftTop1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, leftTop1Width, topH)];
    [self.contentView addSubview:_leftTop1];
    _leftTop1.font = FONT_CUSTOM(12);
    _leftTop2 = [[UILabel alloc] initWithFrame:CGRectMake(10 + 10 + leftTop1Width, 0, leftTop2Width, topH)];
    [self.contentView addSubview:_leftTop2];
    _leftTop2.font = FONT_CUSTOM(12);
    UIView *seperate = [[UIView alloc]initWithFrame:CGRectMake(left, topH - 1, SCREEN_WIDTH - 2 * left, 1)];
    seperate.backgroundColor = VIEW_BACKGROUND_COLOR;
    [self.contentView addSubview:seperate];
    
    
    
    descLabel = [[UILabel alloc] init];
    [self.contentView addSubview:descLabel];
    descLabel.numberOfLines = 3;
    
    audio = [[AudioPlayer alloc] init];
    audio.hidden = YES;
    [self.contentView addSubview:audio];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    
    bottomContainer = [[UIView alloc]initWithFrame:CGRectMake(0, [audio bottomY] + 10 + 1, SCREEN_WIDTH, bottomH)];
    [self.contentView addSubview:bottomContainer];
    
    _userHeader = [[UIImageView alloc] initWithFrame:CGRectMake(left, 0, 20, 20)];
    [bottomContainer addSubview:_userHeader];
    
    _nicknameLabel = [[UILabel alloc] initWithFrame:CGRectMake([_userHeader rightX] + 10, 0, 100, 20)];
    [bottomContainer addSubview:_nicknameLabel];
    _nicknameLabel.font = FONT_CUSTOM(12);
    
    _rightBottom = [[UILabel alloc] initWithFrame:CGRectMake(250, 0, 100, 20)];
    _rightBottom.font = FONT_CUSTOM(12);
    [bottomContainer addSubview:_rightBottom];
}

- (void)setQuestion:(MQuestion *)question
{
    _question = question;
    
    _leftTop1.text = question.subject_name;
    _leftTop2.text = [ CommonMethod timeToNow:question.inserttime];

    _nicknameLabel.text = question.username;

    _rightBottom.text = [NSString stringWithFormat:@"%ld个回答",question.answerlist.count];
    [_userHeader sd_setImageWithURL:[NSURL URLWithString:UrlResString(question.header_photo)] placeholderImage:DEFAULT_HEADER];
    
    if(![CommonMethod isBlankString:question.firstimg])
    {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(question.firstimg)]];
    }
    
    descLabel.text = question.desc;
    
    audio.audioUrl = question.audio;
    
}


+ (CGFloat)cellHeight:(MQuestion *)question
{
    return cellH;
}

@end
