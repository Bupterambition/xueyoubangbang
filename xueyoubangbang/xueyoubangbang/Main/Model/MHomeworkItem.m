//
//  MHomeworkItem.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/26.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MHomeworkItem.h"

@implementation MHomeworkItem

-(id)init
{
    self = [super init];
    if(self)
    {
        _pictures = @[];
        _firstimg = nil;
        _picturesUIImage = @[];
    }
    return self;
}

+(MHomeworkItem *)objectWithDictionary:(NSDictionary *)dic
{
    MHomeworkItem *m = [JsonToModel objectFromDictionary:dic className:@"MHomeworkItem"];
    m.audioData = nil;
    NSMutableArray *t = [NSMutableArray array];
    if(![CommonMethod isBlankString:m.imgs])
    {
        NSArray *temp = [m.imgs componentsSeparatedByString:@","];
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
    
    m.firstUIImage = nil;
    m.picturesUIImage = @[];
    return m;

}
@end
