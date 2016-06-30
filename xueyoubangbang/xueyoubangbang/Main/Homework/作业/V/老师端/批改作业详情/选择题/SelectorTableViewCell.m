//
//  SelectorTableViewCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "SelectorTableViewCell.h"
#import "SelectorAnswerCollectionViewCell.h"
@interface SelectorTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *seletorDisplay;
@end
@implementation SelectorTableViewCell{
    NSArray *selectorAnswers;
}

- (void)awakeFromNib {
    [self.seletorDisplay registerNib:[UINib nibWithNibName:@"SelectorAnswerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"SelectorAnswerCollectionViewCell"];
    self.seletorDisplay.delegate = self;
    self.seletorDisplay.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)loadSelectorAnswer:(NSString*)selectAnswer{
    selectorAnswers = [NSArray arrayWithArray:[selectAnswer componentsSeparatedByString:@","]];
    [self.seletorDisplay reloadData];
}
#pragma mark - UICollectionViewDataSource,UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [selectorAnswers count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SelectorAnswerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SelectorAnswerCollectionViewCell" forIndexPath:indexPath];
    [cell displayAnswer:selectorAnswers[indexPath.row]];
    cell.selectorItem.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    return cell;
}
@end
