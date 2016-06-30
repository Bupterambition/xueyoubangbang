//
//  MAnswer.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/25.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MAnswer.h"

@implementation MAnswer

+ (MAnswer *)objectWithDictionary:(NSDictionary *)dic
{
    MAnswer *m = [JsonToModel objectFromDictionary:dic className:@"MAnswer"];
    
    NSMutableArray *t = [NSMutableArray array];
    if(![CommonMethod isBlankString:m.image])
    {
        NSArray *temp = [m.image componentsSeparatedByString:@","];
        for (NSString *img in temp) {
            if(![CommonMethod isBlankString:img])
                [t addObject:img];
        }
        m.pictures = t;
    }
    else
    {
        m.pictures = @[];
    }

    
    return m;
}

@end
