//
//  MQuestion.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MQuestion : NSObject

@property (nonatomic,retain) NSArray *answerlist;
@property (nonatomic,copy) NSString *audio;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *firstimg;
@property (nonatomic,copy) NSString *answernum;
@property (nonatomic,copy) NSString *header_photo;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSArray *pictures;
@property (nonatomic,copy) NSString *inserttime;
@property (nonatomic,copy) NSString *question_id;
@property (nonatomic,copy) NSString *groupname;
@property (nonatomic,copy) NSString *subject_id;
@property (nonatomic,copy) NSString *subject_name;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *class_name;
- (NSArray *)getPicArray;
+(MQuestion *)objectWithDictionary:(NSDictionary *)dic;
@end
