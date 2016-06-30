//
//  NoSelectorForsCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "NoSelectorForsCell.h"
#import "NoSelectorCollectionFors.h"
#import "NoSelectorCollectionForsTwo.h"
@interface NoSelectorForsCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *displayView;
@property (copy, nonatomic) NSArray *picArray;
@end
@implementation NoSelectorForsCell

- (void)awakeFromNib {
    self.picArray = [NSArray array];
    self.displayView.delegate = self;
    self.displayView.dataSource = self;
    [self.displayView registerNib:[UINib nibWithNibName:@"NoSelectorCollectionFors" bundle:nil] forCellWithReuseIdentifier:@"NoSelectorCollectionFors"];
    [self.displayView registerNib:[UINib nibWithNibName:@"NoSelectorCollectionForsTwo" bundle:nil] forCellWithReuseIdentifier:@"NoSelectorCollectionForsTwo"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (void)loadPic:(NSArray*)photos{
    self.picArray = photos;
    [self.displayView reloadData];
}
#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.picArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.picArray.count) {
        NoSelectorCollectionFors *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoSelectorCollectionForsTwo" forIndexPath:indexPath];
        return cell;
    }
    else{
        NoSelectorCollectionFors *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"NoSelectorCollectionFors" forIndexPath:indexPath];
        cell.homeworkDeleteDelegate = self;
        cell.currentPath = indexPath;
        cell.homeworkImage.image = [UIImage imageWithData:self.picArray[indexPath.row]];
        return cell;
    }
    
}
#pragma mark - UICollectionViewCellDelegate
- (void)didTouchDelete:(NSIndexPath*)index{
    if ([self.noSelectorForsCellDelegate respondsToSelector:@selector(didTouchHomeworkPic: withIndex:)]) {
        [self.noSelectorForsCellDelegate didTouchDelete:index.row withIndex:self.index];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    if (indexPath.row != self.picArray.count){
        if ([self.noSelectorForsCellDelegate respondsToSelector:@selector(didTouchHomeworkPic: withIndex:)]) {
            [self.noSelectorForsCellDelegate didTouchHomeworkPic:indexPath.row withIndex:self.index];
        }
    }
    else{
        if ([self.noSelectorForsCellDelegate respondsToSelector:@selector(didTouchPicWithIndex:)]) {
            [self.noSelectorForsCellDelegate didTouchPicWithIndex:self.index];
        }
    }
    
}
@end
