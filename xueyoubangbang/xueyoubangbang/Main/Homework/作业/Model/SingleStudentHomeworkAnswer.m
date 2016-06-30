//
//  SingleStudentHomeworkAnswer.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "SingleStudentHomeworkAnswer.h"

@implementation SingleStudentHomeworkAnswer
- (NSNumber *)noSelectoranswer{
    if (_noSelectoranswer == nil) {
        _noSelectoranswer = @0;
    }
    return _noSelectoranswer;
}

- (NSMutableArray*)checkPics{
    if (_checkPics == nil) {
        _checkPics = [NSMutableArray array];
    }
    return _checkPics;
}

- (NSString*)answer{
    if (_update_answer == nil || [_update_answer isEqualToString:@""]) {
        return _answer;
    }
    else{
        return _update_answer;
    }
}
@end
