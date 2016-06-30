//
//  LFFlowLayout.m
//  xueyoubangbang
//
//  Created by Bob on 16/1/14.
//  Copyright (c) 2016年 sdzhu. All rights reserved.
//

#import "LFFlowLayout.h"
#define kItemWidth 100

@implementation LFFlowLayout

-(instancetype)init
{
    if(self=[super init]){
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    // 设置为水平滚动
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    // 设置每个Item之间的距离
    self.minimumLineSpacing = 100;
    // 重新设置Item的尺寸，不然的话，有等比例缩小的可能
    self.itemSize = CGSizeMake(kItemWidth, kItemWidth);
}

#pragma mark - 重写父类的方法
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

// 获取CollectionView的所有Item项，进行相印的处理(移动过程中，控制各个Item的缩放比例)
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat inset = (self.collectionView.frame.size.width - kItemWidth) * 0.5;
    // 设置第一个和最后一个默认居中显示
    self.collectionView.contentInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
    CGRect visibleRect;
    visibleRect.origin =self.collectionView.contentOffset;
    visibleRect.size = self.collectionView.frame.size;
    
    CGFloat collectionViewCenterX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // 只处理正在界面上面显示的Item
        if(!CGRectIntersectsRect(visibleRect, attrs.frame)) continue;
        
        // 计算各个Item的缩放比例(距离中线越近，缩放比例就越大)
        CGFloat scale;
        // 防止突变的情况(当Item的中心与collectionView中心的距离大于等于collectionView宽度的一半时，Item不缩放，平稳过度)
        if(ABS(attrs.center.x - collectionViewCenterX) >= self.collectionView.frame.size.width * 0.5){
            scale = 1;
        }
        else{
            scale = 1 + 0.8 * (1 - ABS(attrs.center.x - collectionViewCenterX) / (self.collectionView.frame.size.width * 0.5));
        }
        attrs.transform3D = CATransform3DMakeScale(scale, scale, 1);
    }
    
    
    return array;
}

// 当UICollectionView停止的那一刻ContentOffset的值(控制UICollectionView停止时，有一个Item一定居中显示)
// 1.proposedContentOffset默认的ContentOffset
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    //1. 获取UICollectionView停止的时候的可视范围
    CGRect contentFrame;
    contentFrame.size = self.collectionView.frame.size;
    contentFrame.origin = proposedContentOffset;
    
    NSArray *array = [self layoutAttributesForElementsInRect:contentFrame];
    
    //2. 计算在可视范围的距离中心线最近的Item
    CGFloat minCenterX = CGFLOAT_MAX;
    CGFloat collectionViewCenterX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if(ABS(attrs.center.x - collectionViewCenterX) < ABS(minCenterX)){
            minCenterX = attrs.center.x - collectionViewCenterX;
        }
    }
    
    //3. 补回ContentOffset，则正好将Item居中显示
    return CGPointMake(proposedContentOffset.x + minCenterX, proposedContentOffset.y);
}
@end
