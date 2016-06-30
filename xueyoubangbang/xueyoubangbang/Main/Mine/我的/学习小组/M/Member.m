//
//  Member.m
//  xueyoubangbang
//
//  Created by Bob on 15/8/30.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "Member.h"
#import "NSDate+Format.h"
#import "NSString+Stackoverflow.h"
@implementation Member
- (NSString *)accuratesigntime{
    if (_accuratesigntime == nil) {
        _accuratesigntime = @"";
    }
    else{
        if (_accuratesigntime.length >9) {
            _accuratesigntime = [_accuratesigntime transTimeWithOriginFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"HH:mm"];
        }
    }
    return _accuratesigntime;
}
@end
