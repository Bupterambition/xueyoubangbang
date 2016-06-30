//
//  InterActCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "InterActCell.h"
#import "InterActCollectionCell.h"
#import "AudioPlayer.h"
#import "NSString+Stackoverflow.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface InterActCell()<UICollectionViewDataSource,UICollectionViewDelegate,AudioPlayerDelegate>
@end
@implementation InterActCell{
    MQuestion *question;
    AudioPlayer *recorder;
    NSArray *imageArr;
    BOOL ifPlayAudio;
    NSInteger picNum;
}

- (void)awakeFromNib {
    self.headerImg.layer.masksToBounds = YES;
    self.headerImg.layer.cornerRadius = 20;
    self.imgsDisplay.delegate = self;
    self.imgsDisplay.dataSource = self;
    [self.imgsDisplay registerNib:[UINib nibWithNibName:@"InterActCollectionCell" bundle:nil]forCellWithReuseIdentifier:@"InterActCollectionCell"];
   // [self.imgsDisplay reloadData];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadData:(MQuestion*)data withIndex:(NSIndexPath*)index{
    question = data;
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(data.header_photo)]];
    self.qusetionDec.text = data.desc;//index.section%2 == 0?@"这里还不得不提到一个 UILabel 的蛋疼问题，当 UILabel 行数大于0时，需要指定 preferredMaxLayoutWidth 后它才知道自己什么时候该折行。这是个“鸡生蛋蛋生鸡”的问题，因为 UILabel 需要知道 superview 的宽度才能折行，而 superview 的宽度还依仗着子 view 宽度的累加才能确定。这个问题好像到 iOS8 才能够自动解决（不过我们找到了解决": data.desc;
    question.imgs = [NSString stringWithFormat:@",%@",question.imgs];
    self.answerNum.text = [NSString stringWithFormat:@"%@回答",question.answernum];
    if (![CommonMethod isBlankString:data.audio]) {
        if (recorder == nil) {
            recorder = [[AudioPlayer alloc] init];
        }
        recorder.audioUrl = question.audio;
        recorder.audioDelegate = self;
        imageArr = @[[UIImage imageNamed:@"answer_voice3"],
                     [UIImage imageNamed:@"answer_voice2"],
                     [UIImage imageNamed:@"answer_voice1"],
                     [UIImage imageNamed:@"answer_voice2"]];
        ifPlayAudio = NO;
    }
    self.classLabel.text = data.class_name?data.class_name:@"未知";
    self.timeLabel.text = [data.inserttime transTimeWithOriginFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"HH:mm"];
    picNum = 0;
    picNum =  [[data getPicArray] count];
    self.imgsDisplay.hidden = NO;
    if (![CommonMethod isBlankString:data.audio]) {
        picNum += 1;
    }
    if (picNum == 0){
        self.imgsDisplay.hidden = YES;
    }
    else if (picNum >3){
        [self.imgsDisplay reloadData];
    }
    else{
        [self.imgsDisplay reloadData];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return picNum;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    InterActCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"InterActCollectionCell" forIndexPath:indexPath];
    NSLog(@"当前picNum:%ld",picNum);
    NSLog(@"currentIndex:%ld",self.currentIndex.section);
    NSLog(@"CollectionViewIndex:%ld",indexPath.row);
    NSLog(@"%@",question.audio);
    if (question.audio.length>0 && indexPath.row == picNum - 1) {
        cell.imageView.image = IMAGE(@"voice_icon");
        cell.imageView.animationImages = imageArr;
        cell.imageView.animationDuration = 1.6;
        return cell;
    }
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg([question getPicArray][indexPath.row])] placeholderImage:DEFAULT_PIC];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (![CommonMethod isBlankString:question.audio] && indexPath.row == [question getPicArray].count){
        [self didPlayAudio];
        return;
    }
    if ([self.actDelegate respondsToSelector:@selector(didTouchHomeworkPic: withIndex:)]) {
        [self.actDelegate didTouchHomeworkPic:indexPath.row withIndex:self.currentIndex];
    }
}

#pragma mark - event response
- (IBAction)didTouchAddNote:(UIButton *)sender {
    if ([self.actDelegate respondsToSelector:@selector(didTouchAddNote:)]) {
        [self.actDelegate didTouchAddNote:self.currentIndex];
    }
}

- (void)didPlayAudio{
    if (ifPlayAudio) {
        InterActCollectionCell *cell = (InterActCollectionCell*)[self.imgsDisplay cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[question getPicArray].count inSection:0]];
        if (cell.imageView.isAnimating) {
            [cell.imageView stopAnimating];
        }
    }
    else{
        InterActCollectionCell *cell = (InterActCollectionCell*)[self.imgsDisplay cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[question getPicArray].count inSection:0]];
        [cell.imageView startAnimating];
    }
    ((void(*)(id,SEL, unsigned long))objc_msgSend)(recorder, @selector(doPlayOrStop:),nil);
    ifPlayAudio = !ifPlayAudio;
}
#pragma mark - AudioPlayerDelegate
- (void)didFinishedPlay{
    ifPlayAudio = NO;
    InterActCollectionCell *cell = (InterActCollectionCell*)[self.imgsDisplay cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[question getPicArray].count inSection:0]];
    if (cell.imageView.isAnimating) {
        [cell.imageView stopAnimating];
    }
}
@end
