//
//  UIQuestionDetailTableViewCell.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/29.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIQuestionDetailTableViewCell.h"

@implementation UIQuestionDetailTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
//        [self createView];
    }
    return self;
}

//- (void)createView
//{
//    //题面
//    UIView *questionView = [[UIView alloc] init];
//    
//    //题面内容文字
//    UIView *content = [[UIView alloc] init];
//    UILabel *textLable = [[UILabel alloc] init];
//    CGFloat const textWidth = 280;
//    textLable.numberOfLines = 0;
//    textLable.text = self.question.desc;
//    CGSize textLableSize = [CommonMethod sizeWithString:textLable.text font:textLable.font maxSize:CGSizeMake(textWidth, MAXFLOAT)];
//    textLable.frame = CGRectMake(10, 10, textWidth, textLableSize.height);
//    [content addSubview:textLable];
//    
//    //图片
//    CGFloat imageViewY = textLable.frame.size.height + textLable.frame.origin.y + 10;
//    //    for (int i = 0; i<_question.pictures.count; i++) {
//    //        UIImageView *imageView = [[UIImageView alloc] initWithImage:[_question.pictures objectAtIndex:i]];
//    //        imageView.frame = CGRectMake(10, imageViewY, imageView.frame.size.width, imageView.frame.size.height);
//    //        [content addSubview:imageView];
//    //        imageViewY += imageView.frame.size.height + 10;
//    //    }
//    
//    //音频
//    CGFloat voiceViewY = imageViewY + 10;
//    //    for (int i = 0; i<_question.voices.count; i++) {
//    //        UIView *voiceView = [[UIView alloc]init];
//    //        voiceView.backgroundColor = [UIColor redColor];
//    //        voiceView.layer.cornerRadius = 5;
//    //        voiceView.frame = CGRectMake(10, voiceViewY, 100, 40);
//    //        [content addSubview:voiceView];
//    //        voiceViewY += voiceView.frame.size.height + 10;
//    //    }
//    
//    
//    content.frame = CGRectMake(0, 0, SCREEN_WIDTH, voiceViewY);
//    [questionView addSubview:content];
//    
//    questionView.frame = CGRectMake(0,0, SCREEN_WIDTH, content.frame.size.height + content.frame.origin.y + 10);
//    //    question.backgroundColor = [UIColor redColor];
//    
//    
//    questionHeight = questionView.frame.size.height;
//    return questionView;
//
//}
//
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
