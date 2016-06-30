//
//  UIHomeworkAddDetailCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAddDetailCell.h"
#import "NewHomeworkFileSend.h"
#import "AudioRecorder.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSMutableArray+Capacity.h"
#import "UIHomeworkAddDetailDisplayCellTest.h"
#import "UIHomeworkAddDetailDisplayCell.h"
@interface UIHomeworkAddDetailCell()<UICollectionViewDataSource,AudioPlayerDelegate,UICollectionViewDelegate>
@property (nonatomic, weak) IBOutlet UILabel *item_info;
@property (nonatomic, strong) NewHomeworkFileSend *itemData;
@property (nonatomic, weak) IBOutlet UICollectionView *picDisplay;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong)NSArray *picArray;
@end
@implementation UIHomeworkAddDetailCell{
    AudioRecorder *recorder;
    NSArray *imageArr;
    BOOL ifPlayAudio;
    BOOL ifReload;
}

- (void)awakeFromNib {
    [self.picDisplay registerNib:[UINib nibWithNibName:@"UIHomeworkAddDetailDisplayCellTest" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkAddDetailDisplayCellTest"];
    [self.picDisplay registerNib:[UINib nibWithNibName:@"UIHomeworkAddDetailDisplayCell" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkAddDetailDisplayCell"];
    self.picDisplay.scrollEnabled = NO;
    self.picDisplay.delegate = self;
    self.picDisplay.dataSource = self;
    ifReload = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)loadItemDataForHeight:(NewHomeworkFileSend*)data{
    self.itemData = data;
    self.item_info.text = data.item_info;
    self.item_info.adjustsFontSizeToFitWidth = YES;
}

- (void)loadItemData:(NewHomeworkFileSend*)data withCapacity:(NSInteger)capacity{
    ifReload = NO;
    if (self.imageArray == nil || self.imageArray.count != capacity) {
        self.imageArray = [NSMutableArray initMutilAnswerWithCapacity:capacity];
    }
    self.itemData = data;
    self.item_info.text = data.item_info;
    self.item_info.adjustsFontSizeToFitWidth = YES;
    if ([self.itemData item_audio] != nil) {
        if (recorder == nil) {
            recorder = [[AudioRecorder alloc] init];
            imageArr = @[(id)[UIImage imageNamed:@"answer_voice1"].CGImage,
                         (id)[UIImage imageNamed:@"answer_voice2"].CGImage,
                         (id)[UIImage imageNamed:@"answer_voice3"].CGImage,
                         (id)[UIImage imageNamed:@"answer_voice1"].CGImage];
        }
        recorder.audioDelegate = self;
        recorder.amrAudio = [self.itemData getAudioData];
        ifPlayAudio = NO;
    }
    self.picDisplay.hidden = NO;
    NSInteger picNum = [data picNum];
    if (picNum == 0){
        self.picDisplay.hidden = YES;
    }
    else if (picNum >3){
        self.picDisplay.hidden = NO;
//        self.picArray = [self.itemData stringToArray];
        weak(weakself);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            strong(strongself);
            strongself.picArray = [strongself.itemData stringToArray];
            if ([strongself.imageArray[strongself.currentIndex.section -1] count] == 0) {
                [strongself.picArray enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
                    [strongself.imageArray[strongself.currentIndex.section -1] addObject:[UIImage imageWithData:obj]];
                }];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                ifReload = YES;
                [strongself.picDisplay reloadData];
            });
            

        });
//        if ([self.imageArray[self.currentIndex.section -1] count] == 0) {
//            [self.picArray enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
//                [self.imageArray[self.currentIndex.section -1] addObject:[UIImage imageWithData:obj]];
//            }];
//        }
//        [self.picDisplay reloadData];
    }
    else{
//        self.picArray = [self.itemData stringToArray];
        self.picDisplay.hidden = NO;
        weak(weakself);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            strong(strongself);
            strongself.picArray = [strongself.itemData stringToArray];
            if ([strongself.imageArray[strongself.currentIndex.section -1] count] == 0) {
                [strongself.picArray enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
                    [strongself.imageArray[strongself.currentIndex.section -1] addObject:[UIImage imageWithData:obj]];
                }];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                ifReload = YES;
                [strongself.picDisplay reloadData];
            });
        });
//        if ([self.imageArray[self.currentIndex.section -1] count] == 0) {
//            [self.picArray enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
//                [self.imageArray[self.currentIndex.section -1] addObject:[UIImage imageWithData:obj]];
//            }];
//        }
//        [self.picDisplay reloadData];
    }
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return ifReload?[self.itemData picNum]:0;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIHomeworkAddDetailDisplayCellTest *cell = (UIHomeworkAddDetailDisplayCellTest*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UIHomeworkAddDetailDisplayCellTest" forIndexPath:indexPath];
    if (self.itemData.item_audio != nil && indexPath.row == [self.itemData.item_imgscnt integerValue]) {
        [cell loadVoice:IMAGE(@"voice_icon")];
        return cell;
    }
    if ([self.imageArray[self.currentIndex.section -1] count] != 0) {
        [cell loadImg:self.imageArray[self.currentIndex.section -1][indexPath.row] withKey:[NSString stringWithFormat:@"item_%ld_%ld",self.currentIndex.section,indexPath.row]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (self.itemData.item_audio != nil && indexPath.row == [self.itemData.item_imgscnt integerValue]){
        [self didPlayAudio];
        return;
    }
    if ([self.addDetailDelegate respondsToSelector:@selector(didTouchHomeworkPic: withIndex:)]) {
        [self.addDetailDelegate didTouchHomeworkPic:indexPath.row withIndex:self.currentIndex];
    }
}
- (void)didPlayAudio{
    if (ifPlayAudio) {
        UIHomeworkAddDetailDisplayCellTest *cell = (UIHomeworkAddDetailDisplayCellTest*)[self.picDisplay cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.itemData picNum]-1 inSection:0]];
        [cell.contentView.layer removeAllAnimations];
    }
    else{
        UIHomeworkAddDetailDisplayCellTest *cell = (UIHomeworkAddDetailDisplayCellTest*)[self.picDisplay cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.itemData picNum]-1 inSection:0]];
        CAKeyframeAnimation *anmation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
        anmation.values = imageArr;
        anmation.duration = 2;
        anmation.repeatCount = 999;
        anmation.autoreverses = YES;
        [cell.contentView.layer addAnimation:anmation forKey:@"contents"];
    }
    ((void(*)(id,SEL, unsigned long))objc_msgSend)(recorder, @selector(doPlayOrStop),nil);
    ifPlayAudio = !ifPlayAudio;
}
#pragma mark - AudioPlayerDelegate
- (void)didFinishedPlay{
    ifPlayAudio = NO;
    UIHomeworkAddDetailDisplayCellTest *cell = (UIHomeworkAddDetailDisplayCellTest*)[self.picDisplay cellForItemAtIndexPath:[NSIndexPath indexPathForItem:[self.itemData picNum]-1 inSection:0]];
    [cell.contentView.layer removeAllAnimations];
}
@end
