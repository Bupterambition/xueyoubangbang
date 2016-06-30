//
//  MAnswer.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/25.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MAnswer : NSObject
@property (nonatomic,copy) NSString *answer_id;
@property (nonatomic,copy) NSString *question_id;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *type;//image
@property (nonatomic,copy) NSString *txt;
@property (nonatomic,copy) NSString *audio;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *inserttime;
@property (nonatomic,copy) NSString *isbest;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *header_photo;

@property (nonatomic,retain) NSArray *pictures;

+ (MAnswer *)objectWithDictionary:(NSDictionary *)dic;
@end
