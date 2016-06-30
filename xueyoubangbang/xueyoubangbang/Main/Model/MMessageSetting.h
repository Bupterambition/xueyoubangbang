//
//  MMessageSetting.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/5.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMessageSetting : NSObject
@property (nonatomic) BOOL wholeOn;
@property (nonatomic) BOOL homeworkOn;
@property (nonatomic,retain) NSMutableArray *homeworkTime;

+ (MMessageSetting *)objectiWithDictionary:(NSDictionary *)dic;
- (NSDictionary *)toDictionary;

@end
