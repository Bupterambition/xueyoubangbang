//
//  UIHomeworkAddDetailCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkStudentDetailCell.h"
#import "NewHomeworkItem.h"
#import "UIHomeworkAddDetailDisplayCell.h"
#import "AudioPlayer.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface UIHomeworkStudentDetailCell()<UICollectionViewDataSource,UICollectionViewDelegate,AudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *item_info;
@property (weak, nonatomic) IBOutlet UICollectionView *picDisplay;
@property (strong,nonatomic) NewHomeworkItem *checkItemData;
@end
@implementation UIHomeworkStudentDetailCell{
    AudioPlayer *recorder;
    SDImageCache *imageCache;
    NSArray *imageArr;
    BOOL ifPlayAudio;
}

- (void)awakeFromNib {
    [self.picDisplay registerNib:[UINib nibWithNibName:@"UIHomeworkAddDetailDisplayCell" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkAddDetailDisplayCell"];
    self.picDisplay.delegate = self;
    self.picDisplay.dataSource = self;
    imageCache = [SDImageCache sharedImageCache];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadItemDataForCheck:(NewHomeworkItem*)data{
    self.checkItemData = data;
    self.item_info.text = data.desc;
    if (![CommonMethod isBlankString:data.audio]) {
        if (recorder == nil) {
            recorder = [[AudioPlayer alloc] init];
        }
        recorder.audioDelegate = self;
        recorder.audioUrl = self.checkItemData.audio;
        imageArr = @[[UIImage imageNamed:@"answer_voice3"],
                     [UIImage imageNamed:@"answer_voice2"],
                     [UIImage imageNamed:@"answer_voice1"],
                     [UIImage imageNamed:@"answer_voice2"]];
    }
    self.picDisplay.hidden = NO;
    NSInteger picNum = [data getPicArray].count ;
    picNum += [CommonMethod isBlankString:data.audio]?0:1;
    if (picNum == 0){
        self.picDisplay.hidden = YES;
    }
    else if (picNum >3){
        [self.picDisplay reloadData];
    }
    else{
        [self.picDisplay reloadData];
    }
    [self.picDisplay reloadData];
}
#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.checkItemData getPicArray].count + ([CommonMethod isBlankString:self.checkItemData.audio]?0:1);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIHomeworkAddDetailDisplayCell *cell = (UIHomeworkAddDetailDisplayCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UIHomeworkAddDetailDisplayCell" forIndexPath:indexPath];
    if (![CommonMethod isBlankString:self.checkItemData.audio] && indexPath.row == [self.checkItemData getPicArray].count) {
        cell.picView.image = IMAGE(@"voice_icon");
        cell.picView.animationImages = imageArr;
        cell.picView.animationDuration = 2;
        [cell modifyImageModeForVoice];
        return cell;
    }
    [cell modifyImageModeForImage];
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg([self.checkItemData getPicArray][indexPath.row])] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [imageCache storeImage:image forKey:imageURL.absoluteString];
    }];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (![CommonMethod isBlankString:self.checkItemData.audio] && indexPath.row == [self.checkItemData getPicArray].count){
        [self didPlayAudio];
        return;
    }
    if ([self.checkDetailDelegate respondsToSelector:@selector(didTouchHomeworkPic: withIndex:)]) {
        [self.checkDetailDelegate didTouchHomeworkPic:indexPath.row withIndex:self.currentIndex];
    }
}

#pragma mark - event response
- (void)didPlayAudio{
    if (ifPlayAudio) {
        UIHomeworkAddDetailDisplayCell *cell = (UIHomeworkAddDetailDisplayCell*)[self.picDisplay cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.checkItemData getPicArray].count inSection:0]];
        if (cell.picView.isAnimating) {
            [cell.picView stopAnimating];
        }
    }
    else{
        UIHomeworkAddDetailDisplayCell *cell = (UIHomeworkAddDetailDisplayCell*)[self.picDisplay cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.checkItemData getPicArray].count inSection:0]];
        [cell.picView startAnimating];
    }
    ((void(*)(id,SEL, unsigned long))objc_msgSend)(recorder, @selector(doPlayOrStop:),nil);
    ifPlayAudio = !ifPlayAudio;
}
- (IBAction)askQuestion:(UIButton *)sender {
    if ([self.checkDetailDelegate respondsToSelector:@selector(didTouchAskQuestion:)]) {
        [self.checkDetailDelegate didTouchAskQuestion:self.currentIndex];
    }
}

- (IBAction)addNote:(id)sender {
    if ([self.checkDetailDelegate respondsToSelector:@selector(didTouchAddNote:)]) {
        [self.checkDetailDelegate didTouchAddNote:self.currentIndex];
    }
}
#pragma mark - AudioPlayerDelegate
- (void)didFinishedPlay{
    ifPlayAudio = NO;
    UIHomeworkAddDetailDisplayCell *cell = (UIHomeworkAddDetailDisplayCell*)[self.picDisplay cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.checkItemData getPicArray].count inSection:0]];
    if (cell.picView.isAnimating) {
        [cell.picView stopAnimating];
    }
}
@end
