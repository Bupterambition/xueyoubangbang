//
//  Note.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "Note.h"

@implementation Note
- (NSArray *)getPicArray{
    if ([self.imgs isEqualToString:@""]) {
        return nil;
    }
    if ([self.imgs hasSuffix:@","]) {
        self.imgs = [self.imgs substringToIndex:self.imgs.length -1];
    }
    return [self.imgs componentsSeparatedByString:@","];
}
- (NSMutableArray*)testPics{
    if (_testPics == nil) {
        _testPics = [NSMutableArray array];
    }
    return _testPics;
}

@end
