//
//  UIHomeworkKnowledgeCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KnowLedgePoint;
@interface UIHomeworkKnowledgeCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *knowLabel;
- (void)loadKnowledge:(KnowLedgePoint*)data;
@end
