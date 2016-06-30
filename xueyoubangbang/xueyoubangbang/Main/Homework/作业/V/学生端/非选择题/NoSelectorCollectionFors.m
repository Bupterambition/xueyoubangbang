//
//  NoSelectorCollectionFors.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "NoSelectorCollectionFors.h"

@implementation NoSelectorCollectionFors

- (void)awakeFromNib {
    // Initialization code
}
- (IBAction)didTouchDelete:(UIButton *)sender {
    if ([self.homeworkDeleteDelegate respondsToSelector:@selector(didTouchDelete:)]) {
        [self.homeworkDeleteDelegate didTouchDelete:self.currentPath];
    }
}

@end
