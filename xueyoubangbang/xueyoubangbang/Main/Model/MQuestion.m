//
//  MQuestion.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MQuestion.h"
#import "MAnswer.h"

@implementation MQuestion
-(id)init
{
    self = [super init];
    if(self)
    {
        _answerlist = @[];
        _pictures = @[];
        //10000003
        
    }
    return self;
}

+(MQuestion *)objectWithDictionary:(NSDictionary *)dic
{
    MQuestion *qu = [JsonToModel objectFromDictionary:dic className:@"MQuestion"];
    
    if( [qu.answerlist isKindOfClass:[NSNull class]] || qu.answerlist == nil)
    {
        qu.answerlist = @[];
    }
    else
    {
        NSArray *answerDic = qu.answerlist;
        NSMutableArray *answerObj = [NSMutableArray array];
        for (int i = 0; i < answerDic.count; i++) {
            [answerObj addObject:[MAnswer objectWithDictionary:[answerDic objectAtIndex:i]] ];
        }
        qu.answerlist = answerObj;
    }
    
    NSMutableArray *t = [NSMutableArray array];
    if(![CommonMethod isBlankString:qu.imgs])
    {
        NSArray *temp = [qu.imgs componentsSeparatedByString:@","];
        for (NSString *img in temp) {
            if(![CommonMethod isBlankString:img])
            [t addObject:img];
        }
        qu.pictures = t;
    }
    else
    {
        qu.pictures = @[];
    }
    
    
    return qu;
}
- (NSArray *)getPicArray{
    if ([CommonMethod isBlankString:self.imgs]) {
        return nil;
    }
    if ([self.imgs hasSuffix:@","]) {
        self.imgs = [self.imgs substringToIndex:self.imgs.length -1];
        return [self getPicArray];
    }
    if ([self.imgs hasPrefix:@","]) {
        self.imgs = [self.imgs substringFromIndex:1];
        return [self getPicArray];
    }
    NSArray * pics = [self.imgs componentsSeparatedByString:@","];
    NSLog(@"%@",pics);
    return pics;
}

@end
