//
//  UIHomeworkDisplayKnowledgeCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkDisplayKnowledgeCell.h"
#import "KnowLedgePoint.h"
@implementation UIHomeworkDisplayKnowledgeCell{
    NSArray *colorPool;
}

- (void)awakeFromNib {
    colorPool = @[@0x7ecef4, @0x84ccc9, @0x88abda,@0x7dc1dd,@0xb6b8de];
    self.knowledgeLabel.adjustsFontSizeToFitWidth = YES;
    self.knowledgeLabel.layer.masksToBounds = YES;
    self.knowledgeLabel.layer.cornerRadius = 5;
    self.knowledgeLabel.textColor = [UIColor whiteColor];
    self.knowledgeLabel.backgroundColor = UIColorFromRGB([colorPool[arc4random()%5] integerValue]);
}
- (IBAction)didTouchDelete:(UIButton *)sender {
    if ([self.knowledgeCellDelagate respondsToSelector:@selector(didTouchDeleteKnowledge:)]) {
        [self.knowledgeCellDelagate didTouchDeleteKnowledge:self.index];
    }
}
- (void)loadKnowledge:(KnowLedgePoint*)data{
    self.knowledgeLabel.text = data.knowledgepointname;
}

@end
