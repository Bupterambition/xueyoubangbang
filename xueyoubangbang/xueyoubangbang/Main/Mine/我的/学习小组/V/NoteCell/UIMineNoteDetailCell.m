//
//  UIHomeworkAddDetailCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineNoteDetailCell.h"
#import "Note.h"
#import "UIHomeworkAddDetailDisplayCell.h"
#import "AudioPlayer.h"
#import <objc/runtime.h>
#import <objc/message.h>
@interface UIMineNoteDetailCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *item_info;
@property (nonatomic, strong) Note *itemData;
@property (weak, nonatomic) IBOutlet UICollectionView *picDisplay;

@end
@implementation UIMineNoteDetailCell{
    AudioPlayer *recorder;
}

- (void)awakeFromNib {
    [self.picDisplay registerNib:[UINib nibWithNibName:@"UIHomeworkAddDetailDisplayCell" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkAddDetailDisplayCell"];
    self.picDisplay.delegate = self;
    self.picDisplay.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadItemData:(Note*)data{
    self.itemData = data;
    self.item_info.attributedText = [self generalText];
    if (![CommonMethod isBlankString:data.audio]) {
        recorder = [[AudioPlayer alloc] init];
        recorder.audioUrl = data.audio;
    }
    [self.picDisplay reloadData];
}
- (NSAttributedString*)generalText{
    NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor orangeColor]
                                                                forKey:NSForegroundColorAttributeName];
    NSAttributedString *info;
    info = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"#%@#",[self getSubject]]
                                           attributes:attrsDictionary];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@""];
    [str appendAttributedString:info];
    [str appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.itemData.desc]]];
    return str;
}
- (NSString*)getSubject{
    NSDictionary* subjects =  @{@"1":@"语文",
                                @"2":@"数学",
                                @"3":@"英语",
                                @"4":@"物理",
                                @"5":@"化学",
                                @"6":@"生物",
                                @"7":@"政治",
                                @"8":@"历史",
                                @"9":@"地理"
                                };
    return subjects[[NSString stringWithFormat:@"%@",self.itemData.subjectid]];
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.itemData getPicArray].count + ([CommonMethod isBlankString:self.itemData.audio ]?0:1);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIHomeworkAddDetailDisplayCell *cell = (UIHomeworkAddDetailDisplayCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UIHomeworkAddDetailDisplayCell" forIndexPath:indexPath];
//    NSInteger tt = [self.itemData getPicArray].count;
    if (![CommonMethod isBlankString:self.itemData.audio] && indexPath.row == [self.itemData getPicArray].count) {
        cell.picView.image = IMAGE(@"voice_icon");
        return cell;
    }
    [cell.picView sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg([self.itemData getPicArray][indexPath.row])] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (![CommonMethod isBlankString:self.itemData.audio] && indexPath.row == [self.itemData getPicArray].count){
        [self didPlayAudio];
        return;
    }
    if ([self.checkDetailDelegate respondsToSelector:@selector(didTouchHomeworkPic: withIndex:)]) {
        [self.checkDetailDelegate didTouchHomeworkPic:indexPath.row withIndex:self.currentIndex];
    }
}
- (void)didPlayAudio{
    ((void(*)(id,SEL, unsigned long))objc_msgSend)(recorder, @selector(doPlayOrStop:),nil);
}
- (IBAction)deleteNote:(UIButton *)sender {
    if ([self.checkDetailDelegate respondsToSelector:@selector(didTouchDeleteNote:)]) {
        [self.checkDetailDelegate didTouchDeleteNote:self.currentIndex];
    }
}

@end
