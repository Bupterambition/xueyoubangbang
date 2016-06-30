//
//  MHomework.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MHomework.h"
#import "MHomeworkItem.h"
@implementation MHomework

-(id)init
{
    self = [super init];
    if(self)
    {
        _itemlist = [NSMutableArray array];
    }
    return self;
}

+(MHomework*)objectWithDictionary:(NSDictionary *)dic
{
    MHomework *h = [JsonToModel objectFromDictionary:dic className:@"MHomework"];
    h.class_name = dic[@"class_name"];
    NSMutableArray *itemList = [NSMutableArray array];
    if([h.itemlist isKindOfClass:[NSNull class]])
    {
        h.itemlist = [NSMutableArray array];
    }
    for (int j = 0; j<h.itemlist.count; j++) {
        MHomeworkItem *item = [MHomeworkItem objectWithDictionary:[h.itemlist objectAtIndex:j]];
        [itemList addObject:item];
    }
    h.itemlist = itemList;
    return h;
}

@end
