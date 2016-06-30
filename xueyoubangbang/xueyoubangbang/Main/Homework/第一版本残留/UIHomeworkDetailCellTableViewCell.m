//
//  UIHomeworkDetailCellTableViewCell.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkDetailCellTableViewCell.h"
#import "AudioPlayer.h"
@interface UIHomeworkDetailCellTableViewCell()
{
    
}

@end
@implementation UIHomeworkDetailCellTableViewCell
/**
 *  构造方法(在初始化对象的时候会调用)
 *  一般在这个方法中添加需要显示的子控件
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self createViews];
    }
    return self;
}

#define topH 40
- (void)createViews
{
    //左上角
    
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_message_remind"]];
    leftIcon.frame = CGRectMake(10, topH / 2 - leftIcon.frame.size.height / 2, leftIcon.frame.size.width, leftIcon.frame.size.height);
    [self.contentView addSubview:leftIcon];
    
    UILabel *leftTopLabel = [[UILabel alloc] init];
    leftTopLabel.frame = CGRectMake([leftIcon rightX] + 10, 0, 60, topH);
    [self.contentView addSubview:leftTopLabel];
    self.leftTopLabel = leftTopLabel;
    
    if([rolesUser isEqualToString:roleStudent])
    {
        //右上角
        UIButton *rightTopButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [rightTopButton setTitle:@"问一下" forState:UIControlStateNormal];
        rightTopButton.frame = CGRectMake(SCREEN_WIDTH - 60 , 0, 60,topH);
        [rightTopButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:rightTopButton];
        self.rightTopButton = rightTopButton;
        
        UIImageView *rigthIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homework_question"]];
        rigthIcon.frame = CGRectMake(rightTopButton.frame.origin.x - rigthIcon.frame.size.width, topH / 2 - rigthIcon.frame.size.height / 2, rigthIcon.frame.size.width, rigthIcon.frame.size.height);
        [self.contentView addSubview:rigthIcon];
        self.rightIcon = rigthIcon;
    }
//    else if([])
    
    UIView *seperate = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft, 40, SCREEN_WIDTH - 2 * kPaddingLeft, 1)];
    seperate.backgroundColor = VIEW_BACKGROUND_COLOR;
    [self.contentView addSubview:seperate];
    
    //正文图片
    UIImageView *picture = [[UIImageView alloc] init];
    [self.contentView addSubview:picture];
    self.picture = picture;
    
    //正文文字
    UILabel *mainLabel = [[UILabel alloc] init];
    [self.contentView addSubview:mainLabel];
    self.mainTextLabel = mainLabel;
}

- (void)settingData:(MHomeworkItem *)item
{
//    [self.picture setImageWithURL:[NSURL URLWithString:item.imgs]];
    self.mainTextLabel.text = item.desc;
    
    [self settingFrame:item];
}

- (void)settingFrame:(MHomeworkItem *)item
{
    UIHomeworkDetailTableViewCellFrame *frame = [[UIHomeworkDetailTableViewCellFrame alloc] initWithHomeworkItem:item];
    
    self.mainTextLabel.frame = frame.mainTextF;
     self.picture.frame = frame.picturesF;
    
    if(![CommonMethod isBlankString:item.audio] || item.audioData != nil)
    {
        AudioPlayer *audio = [[AudioPlayer alloc] init];
        audio.frame = frame.voiceF;
        audio.audioUrl = item.audio;
        audio.amrAudio = item.audioData;
        [self.contentView addSubview:audio];
        
    }
    
    if(![CommonMethod isBlankString: item.firstimg])
    {
        [self.picture sd_setImageWithURL:[NSURL URLWithString:UrlResString(item.firstimg)]];
    }
    else if(![item.firstUIImage isKindOfClass:[NSNull class]])
    {
        self.picture.image = item.firstUIImage;
    }
}


- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@implementation UIHomeworkDetailTableViewCellFrame

- (id)initWithHomeworkItem:(MHomeworkItem *)item
{
    self = [super init];
    if(self)
    {
        [self setHomework:item];
    }
    return self;
}

+ (UIFont *)fontMainText
{
    return FONT_CUSTOM(16);
}


- (void)setHomework:(MHomeworkItem *)item
{
    //图片
    
    //图片、语音
    
    //图片、语音、文字
    
    //图片、文字
    
    //语音
    
    //语音、文字
    
    //文字
    
    CGSize textSize = [CommonMethod sizeWithString:item.desc font:[UIHomeworkDetailTableViewCellFrame fontMainText] maxSize:CGSizeMake(SCREEN_WIDTH - kPaddingLeft * 2,MAXFLOAT)];
    _mainTextF = CGRectMake(10,  10 + topH , SCREEN_WIDTH - kPaddingLeft * 2, textSize.height);
    
    if(![ CommonMethod isBlankString:item.audio] || item.audioData != nil){
        _voiceF = CGRectMake(4, _mainTextF.size.height + _mainTextF.origin.y + 20, kAudioWidth, kAudioHeight);
    }
    else
    {
        _voiceF = CGRectMake(4, _mainTextF.size.height + _mainTextF.origin.y + 20, 0, 0);
    }
    
    if(![CommonMethod isBlankString:item.firstimg] || item.firstUIImage != nil)
    {
        _picturesF = CGRectMake(kPaddingLeft, 10 +  _voiceF.origin.y + _voiceF.size.height, SCREEN_WIDTH - kPaddingLeft * 2, 200);
    }
    else
    {
        _picturesF = CGRectMake(kPaddingLeft, 10 + _voiceF.origin.y + _voiceF.size.height, 0, 0);
    }
    
    _middelContainerH = 10 + _picturesF.size.height + _picturesF.origin.y + 10;
    

    _bottomContainerY = topH + _middelContainerH;
    _cellHeight = topH + _middelContainerH;
}


@end
