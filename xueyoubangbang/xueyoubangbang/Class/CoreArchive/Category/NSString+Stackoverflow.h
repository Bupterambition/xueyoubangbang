//
//  NSString+Stackoverflow.h
//  CoreModel
//
//  Created by 成林 on 15/3/29.
//  Copyright (c) 2015年 muxi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Stackoverflow)

-(NSString *)transTimeWithOriginFormat:(NSString*)originFormat toFormat:(NSString*)format;

-(NSArray *)toArray:(BOOL)isString;


-(unsigned long long)unsignedLongLongValue;

- (NSDate*)transTimeWithFormat:(NSString*)originFormat;
@end
