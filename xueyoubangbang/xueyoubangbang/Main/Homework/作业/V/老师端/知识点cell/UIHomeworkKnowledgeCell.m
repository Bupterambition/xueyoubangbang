//
//  UIHomeworkKnowledgeCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkKnowledgeCell.h"
#import "KnowLedgePoint.h"
@implementation UIHomeworkKnowledgeCell{
    NSArray *colorPool;
}

- (void)awakeFromNib {
    colorPool = @[@0x7ecef4, @0x84ccc9, @0x88abda,@0x7dc1dd,@0xb6b8de];
    self.knowLabel.adjustsFontSizeToFitWidth = YES;
    self.knowLabel.layer.masksToBounds = YES;
    self.knowLabel.layer.cornerRadius = 5;
    self.knowLabel.textColor = [UIColor whiteColor];
    self.knowLabel.backgroundColor = UIColorFromRGB([colorPool[arc4random()%5] integerValue]);
}

- (void)loadKnowledge:(KnowLedgePoint*)data{
    self.knowLabel.text = data.knowledgepointname;
}
@end
