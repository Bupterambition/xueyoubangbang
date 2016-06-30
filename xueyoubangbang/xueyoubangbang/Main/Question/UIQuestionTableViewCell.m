//
//  UIQuestionTableViewCell.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIQuestionTableViewCell.h"
#import "MQuestion.h"
#import "UIImageView+AFNetworking.h"
#import "AudioPlayer.h"
@interface UIQuestionTableViewCell()
{
    UIView *middleContaner;
    UIView *bottomContainer;
}
@end
@implementation UIQuestionTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self createView];
    }
    return self;
}

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
- (void)createView
{
    
//    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    
    _leftTop1 = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, leftTop1Width, topH)];
    [self.contentView addSubview:_leftTop1];
    _leftTop1.font = FONT_CUSTOM(12);
    _leftTop2 = [[UILabel alloc] initWithFrame:CGRectMake(10 + 10 + leftTop1Width, 0, leftTop2Width, topH)];
    [self.contentView addSubview:_leftTop2];
    _leftTop2.font = FONT_CUSTOM(12);
    UIView *seperate = [[UIView alloc]initWithFrame:CGRectMake(left, topH - 1, SCREEN_WIDTH - 2 * left, 1)];
    seperate.backgroundColor = VIEW_BACKGROUND_COLOR;
    [self.contentView addSubview:seperate];
    
    
    middleContaner = [[UIView alloc] initWithFrame:CGRectMake(0, topH + 1, SCREEN_WIDTH, 0)];
    [self.contentView addSubview:middleContaner];
    _pictureView = [[UIImageView alloc] init];
    _pictureView.contentMode = UIViewContentModeScaleAspectFit;
    [middleContaner addSubview:_pictureView];
//    _voiceView = [[UIView alloc] init];
//    _voiceView.backgroundColor = STYLE_COLOR;
//    _voiceView.layer.cornerRadius = 5;
//    [middleContaner addSubview:_voiceView];
    _mainTextLabel = [[UILabel alloc] init];
    [middleContaner addSubview:_mainTextLabel];
    
    
    bottomContainer = [[UIView alloc]initWithFrame:CGRectMake(0, topH + 1, SCREEN_WIDTH, bottomH)];
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

- (void)settingData:(MQuestion *)question
{
   
    self.leftTop1.text = question.subject_name;
    self.leftTop2.text = [ CommonMethod timeToNow:question.inserttime];
//    self.pictures = question.imgs;
    self.mainTextLabel.text = question.desc;
//    self.userHeader.image = question.header;
    self.nicknameLabel.text = question.username;
//    self.rightBottom.text = [NSString stringWithFormat:@"%d个回答",question.answerlist.count];
    self.rightBottom.text = [NSString stringWithFormat:@"%lu个回答",(unsigned long)question.answerlist.count];
    [_userHeader sd_setImageWithURL:[NSURL URLWithString:UrlResString(question.header_photo)] placeholderImage:DEFAULT_HEADER];
    
    [self settingFrame:question];
}

- (void)settingFrame:(MQuestion *)question
{
    UIQuestionTableViewCellFrame *frame = [[UIQuestionTableViewCellFrame alloc] initWithQuestion:question];
    middleContaner.frame = CGRectMake(middleContaner.frame.origin.x, middleContaner.frame.origin.y, middleContaner.frame.size.width, frame.middelContainerH);
    self.pictureView.frame = frame.picturesF;
//    self.voiceView.frame = frame.voiceF;
    self.mainTextLabel.frame = frame.mainTextF;
    
    if(![CommonMethod isBlankString:question.firstimg])
    {
        [self.pictureView sd_setImageWithURL:[NSURL URLWithString:UrlResString(question.firstimg)]];
    }

    if(![CommonMethod isBlankString:question.audio])
    {
        AudioPlayer *audio = [[AudioPlayer alloc] init];
        audio.frame = frame.voiceF;
        audio.audioUrl = question.audio;
        [middleContaner addSubview:audio];
    }
    
    bottomContainer.frame = CGRectMake(bottomContainer.frame.origin.x, frame.bottomContainerY, bottomContainer.frame.size.width, bottomContainer.frame.size.height);
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


@implementation UIQuestionTableViewCellFrame

- (id)initWithQuestion:(MQuestion *)question
{
    self = [super init];
    if(self)
    {
        [self setQuestion:question];
    }
    return self;
}

+ (UIFont *)fontMainText
{
    return FONT_CUSTOM(16);
}

#define pictureH 75
- (void)setQuestion:(MQuestion *)question
{
    //图片
    
    //图片、语音
    
    //图片、语音、文字
    
    //图片、文字
    
    //语音
    
    //语音、文字
    
    //文字
    
    CGSize textSize = [CommonMethod sizeWithString:question.desc font:[UIQuestionTableViewCellFrame fontMainText] maxSize:CGSizeMake(SCREEN_WIDTH - kPaddingLeft * 2,MAXFLOAT)];
    _mainTextF = CGRectMake(10,  10, SCREEN_WIDTH - kPaddingLeft * 2, textSize.height);
    
    
    if(![ CommonMethod isBlankString:question.audio]){
        _voiceF = CGRectMake(4, _mainTextF.size.height + _mainTextF.origin.y , kAudioWidth, kAudioHeight);
    }
    else
    {
        _voiceF = CGRectMake(4, _mainTextF.size.height +_mainTextF.origin.y , 0, 0);
    }
    
    if(![CommonMethod isBlankString:question.firstimg])
    {
        _picturesF = CGRectMake(kPaddingLeft, kPaddingTop + _voiceF.origin.y + _voiceF.size.height, SCREEN_WIDTH - kPaddingLeft * 2, 200);
    }
    else
    {
        _picturesF = CGRectMake(kPaddingLeft, kPaddingTop + _voiceF.origin.y + _voiceF.size.height, 0, 0);
    }
    
    if(_picturesF.size.height == 0)
    {
        _middelContainerH = _voiceF.origin.y + _voiceF.size.height + 10;
    }
    else
    {
        _middelContainerH = 10 + _picturesF.size.height + _picturesF.origin.y + 10;
    }
    
    
    
    _bottomContainerY = topH + _middelContainerH;
    _cellHeight = topH + _middelContainerH + bottomH;
}

@end