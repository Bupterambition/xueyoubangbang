//
//  SelectorAnswerCollectionViewCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "SelectorAnswerCollectionViewCell.h"

@implementation SelectorAnswerCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)displayAnswer:(NSString*)answer{
    if ([answer isEqualToString:@"0"]) {
        self.answerImage.image = IMAGE(@"work_erro");
    }
    else{
        self.answerImage.image = IMAGE(@"work_correct");
    }
}
@end
