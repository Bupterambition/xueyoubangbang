//
//  NSString+Stackoverflow.m
//  CoreModel
//
//  Created by 成林 on 15/3/29.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import "NSString+Stackoverflow.h"

@implementation NSString (Stackoverflow)


-(NSArray *)toArray:(BOOL)isString{
    if ([CommonMethod isBlankString:self]) {
        return [NSMutableArray array];
    }
    
    NSString *seperator = @",";
    
    NSArray *arr = [self componentsSeparatedByString:seperator];
    
    if(isString) return arr;
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:arr.count];

    if(arr == nil || arr.count == 0) return nil;
    
    [arr enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL *stop) {
        
        NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSDataBase64DecodingIgnoreUnknownCharacters];
        
        [arrM addObject:data];
    }];
    
    return arrM;
}

-(NSString *)transTimeWithOriginFormat:(NSString*)originFormat toFormat:(NSString*)format{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:originFormat];
    NSDate *tempData = [df dateFromString:self];
    [df setDateFormat:format];
    NSString *result = [df stringFromDate:tempData];
    return result;
}
- (NSDate*)transTimeWithFormat:(NSString*)originFormat{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:originFormat];
    NSDate *tempData = [df dateFromString:self];
    return tempData;
}


-(unsigned long long)unsignedLongLongValue{
    
    return self.longLongValue;
}


@end
