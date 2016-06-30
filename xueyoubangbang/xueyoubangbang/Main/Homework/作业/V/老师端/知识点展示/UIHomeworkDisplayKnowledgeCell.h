//
//  UIHomeworkDisplayKnowledgeCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeworkDisplayCellDelegate.h"
@class KnowLedgePoint;
@interface UIHomeworkDisplayKnowledgeCell : UICollectionViewCell
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, weak) id<UIHomeworkDisplayCellDelegate> knowledgeCellDelagate;
@property (weak, nonatomic) IBOutlet UILabel *knowledgeLabel;
- (void)loadKnowledge:(KnowLedgePoint*)data;

@end
