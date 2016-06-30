//
//  UIHomeworkAnwser.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAnwserFors.h"
@interface UIHomeworkAnwserFors ()
@property (weak, nonatomic) IBOutlet UILabel *title;
@end
@implementation UIHomeworkAnwserFors

- (void)changeTitleToSelector{
    self.title.text =@"—选择题";
}

- (void)changeTitleToMutilSelector{
    self.title.text =@"—不定项选择题";
}

- (void)changeTitleToNoselector{
    self.title.text =@"—非选择题";
}
- (void)disappear{
    for (NSInteger index = 1001; index<1005; index++) {
        UILabel *t = (UILabel*)[self viewWithTag:index];
        [t removeFromSuperview];
    }
}
@end
