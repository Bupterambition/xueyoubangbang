//
//  NewHomeworkItem.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "NewHomeworkItem.h"
#import "NSMutableArray+Capacity.h"
@implementation NewHomeworkItem
CoreArchiver_MODEL_M
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
- (NSMutableArray*)testAnswer{
    if (_testAnswer == nil) {
        _testAnswer = [NSMutableArray initAnswerWithCapacity:[self.selectnum integerValue]];
    }
    return _testAnswer;
}
- (NSMutableArray*)testMutilAnswer{
    if (_testMutilAnswer == nil) {
        _testMutilAnswer = [NSMutableArray initMutilAnswerWithCapacity:[self.selectnum integerValue]];
    }
    return _testMutilAnswer;
}
@end
