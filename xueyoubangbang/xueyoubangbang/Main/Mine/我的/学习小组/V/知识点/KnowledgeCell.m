//
//  KnowledgeCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/5.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "KnowledgeCell.h"

@implementation KnowledgeCell

- (void)awakeFromNib {
    self.knowledgeLabel.textColor = [UIColor blackColor];
    self.knowledgeLabel.adjustsFontSizeToFitWidth = YES;
    self.percentLabel.textColor = [UIColor blackColor];
}

@end
