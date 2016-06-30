//
//  UIHomeworkEditCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkEditCell.h"

@implementation UIHomeworkEditCell

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)deletePic:(UIButton *)sender {
    if ([self.homeworkEditDelegate respondsToSelector:@selector(didTouchDelete:)]) {
        [self.homeworkEditDelegate didTouchDelete:self.currentPath];
    }
}

@end
