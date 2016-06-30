//
//  UIQuestionAnswerTableViewCell.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIQuestionAnswerTableViewCell.h"
#import "AudioPlayer.h"
@interface UIQuestionAnswerTableViewCell()
{
    UIView *topContainer;
    UIView *mainContainer;
    NSMutableArray *_imageViews;
}
@end

@implementation UIQuestionAnswerTableViewCell
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

- (void)createViews
{
    
    //头部
    UIView *top = [[UIView alloc] init];
    [self.contentView addSubview:top];
    topContainer = top;
    //头像
    UIImageView *header = [[UIImageView alloc] init];
    [top addSubview:header];
    self.header = header;
    //昵称
    UILabel *lable1 = [[UILabel alloc] init];
    [top addSubview:lable1];
    lable1.font = FONT_CUSTOM(14);
    self.lable1 = lable1;
    //时间
    UILabel *lable2 = [[UILabel alloc] init];
    [top addSubview:lable2];
    lable2.font = FONT_CUSTOM(12);
    lable2.textColor = UIColorFromRGB(0xe5e5e5);
    self.lable2 = lable2;
    
    
    //正文
    UIView *contentContainer = [[UIView alloc] init];
    [self.contentView addSubview:contentContainer];
    mainContainer = contentContainer;
    
    //正文文字
    UILabel *contentLable = [[UILabel alloc] init];
    contentLable.font = FONT_CUSTOM(16);
    contentLable.numberOfLines = 0;
    [contentContainer addSubview:contentLable];
    self.contentLable = contentLable;
    
    
    
        //音频
//     UIView *voiceView = [[UIView alloc]init];
//     voiceView.backgroundColor = [UIColor redColor];
//     voiceView.layer.cornerRadius = 5;
//    [contentContainer addSubview:voiceView];
//    self.voiceView = voiceView;

}

#define pictureHeight

- (void)settingData:(MAnswer *)answer
{
//    self.header.image = answer.image;
    self.lable1.text = answer.username;
    self.lable2.text = [CommonMethod timeToNow:answer.inserttime ];
    self.contentLable.text = answer.txt;
    [self.header loadWithURL:[NSURL URLWithString:UrlResString(answer.header_photo)]];
    
    [self settingFrame:answer];
    
}

- (void)settingFrame:(MAnswer *)answer
{
    UIQuestionAnswerTableViewCellFrame *frame = [[UIQuestionAnswerTableViewCellFrame alloc] initWithAnswer:answer];
    
    self.header.frame = frame.headerFrame;
    self.lable1.frame = frame.lable1Frame;
    self.lable2.frame = frame.lable2Frame;
    self.contentLable.frame = frame.contentLableFrame;
//    self.picture.frame = frame.picutureFrame;

    
    //图片
    CGFloat imageViewY = _contentLable.frame.size.height + _contentLable.frame.origin.y + self.lable2.bottomY;
    CGFloat imageWidth = (SCREEN_WIDTH - 10 * 4) / 3;
    CGFloat imageHeight = imageWidth;
    CGFloat imageX = 10;
    _imageViews = [NSMutableArray array];
    //    _question.pictures = @[@"/Question/2015-03-29/5516e2b26d72a.png",@"/Question/2015-03-29/5516e2b26f1e4.png",@"/Question/2015-03-29/5516e2b26f1e4.png",@"/Question/2015-03-29/5516e2b26f1e4.png",@"/Question/2015-03-29/5516e2b26f1e4.png",@"/Question/2015-03-29/5516e2b26f1e4.png",@"/Question/2015-03-29/5516e2b26f1e4.png"];
    for (int i = 0;i<answer.pictures.count ;i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
//        if(fmodf(i,3) == 0)
//        {
//            imageX = SCREEN_WIDTH / 2 - imageWidth / 2;
//            if(i == 0)
//            {
//                imageViewY = _contentLable.frame.size.height + _contentLable.frame.origin.y + 10;;
//            }
//            else
//            {
//                imageViewY += imageHeight + 10;
//            }
//        }
//        else
//        {
            imageX += imageWidth + 10;
//        }
        
        imageView.frame = CGRectMake(imageX, imageViewY, imageWidth, imageHeight);
        
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self.contentView addSubview:imageView];
        
        [_imageViews addObject:imageView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:gesture];
        
        [imageView setDefaultLoadingView];
        
        [imageView loadWithURL:[NSURL URLWithString:UrlResString( [answer.pictures objectAtIndex:i])]];
        break;
        
    }

    if(![CommonMethod isBlankString:answer.audio])
    {
        AudioPlayer *audio = [[AudioPlayer alloc] init];
        audio.frame = frame.voiceFrame;
        audio.audioUrl = answer.audio;
        [mainContainer addSubview:audio];

    }
    
    topContainer.frame = frame.topContainerFrame;
    mainContainer.frame = frame.contentContainerFrame;
    
}

- (void)tapHandle:(UITapGestureRecognizer *)tap {
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
//    imageViewer.delegate = self;
    [imageViewer showWithImageViews:_imageViews selectedView:(UIImageView *)tap.view];
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

@interface UIQuestionAnswerTableViewCellFrame()
{
}
@end

@implementation UIQuestionAnswerTableViewCellFrame
//@synthesize topContainerFrame,headerFrame,lable2Frame,lable1Frame,contentLableFrame,picutureFrame,contentContainerFrame,cellHeight;
-(id)initWithAnswer:( MAnswer*)answer
{
    self = [super init];
    if(self){
        [self setAnswer:answer];
    }
    return self;
}

-(void)setAnswer:(MAnswer *)answer
{
    _topContainerFrame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
    
    _headerFrame = CGRectMake(4, 4, 40,40);
    
    _lable1Frame = CGRectMake(_headerFrame.origin.x + _headerFrame.size.width + 4, 4, 150, 20);
    
    
    _lable2Frame = CGRectMake(_lable1Frame.origin.x , _lable1Frame.origin.y + _lable1Frame.size.height + 4, 150, 20);
    
    CGSize mainTextSize = [CommonMethod sizeWithString:answer.txt font:FONT_CUSTOM(16) maxSize:CGSizeMake(SCREEN_WIDTH - 40, MAXFLOAT)];
    _contentLableFrame = CGRectMake(20, 4, mainTextSize.width, mainTextSize.height + 20);

    //    NSLog(@"contentLableFrame = %@",NSStringFromCGRect(contentLableFrame));
    _pictureH = 0;
    CGFloat hPerLine = (SCREEN_WIDTH - 4 *kPaddingLeft) / 3;
    if(answer.pictures != nil && answer.pictures.count > 0){
        
        _pictureH = 100 + kPaddingTop;
        
    }
    
    if(![ CommonMethod isBlankString:answer.audio]){
        _voiceFrame = CGRectMake(4, _contentLableFrame.size.height + _pictureH + 5, kAudioWidth, kAudioHeight);
    }
    else
    {
        _voiceFrame = CGRectMake(4, _contentLableFrame.size.height + _pictureH + 5, 0, 0);
    }
    
    _contentContainerFrame = CGRectMake(0, _topContainerFrame.origin.y + _topContainerFrame.size.height, SCREEN_WIDTH, _contentLableFrame.size.height + _pictureH + _voiceFrame.size.height + 8);
    
    _cellHeight = _contentContainerFrame.origin.y + _contentContainerFrame.size.height;
    
}
@end
