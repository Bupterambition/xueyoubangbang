//
//  NewHomeworkFileSend.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CoreArchive.h"
#import "NSArray+CoreModel.h"
#import "NSString+Stackoverflow.h"
@interface NewHomeworkFileSend : NSObject
CoreArchiver_MODEL_H
@property (nonatomic, copy) NSString *item_title;
@property (nonatomic, copy) NSString *item_info;
@property (nonatomic, copy) NSString *item_type;
@property (nonatomic, copy) NSString *item_answer;
@property (nonatomic, copy) NSString *item_audio;
@property (nonatomic, copy) NSString *item_imgscnt;
@property (nonatomic, copy) NSString *true_img;
@property (nonatomic, copy) NSString *item_choicenum;
- (NSInteger)picNum;
- (NSArray *)stringToArray;
- (void)transferArrayToString:(NSArray *)array;
- (void)transferDataTOString:(NSData*)rawData;
- (NSData*)getAudioData;
@end
