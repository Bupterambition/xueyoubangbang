//
//  AnswerObject.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/29.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerObject : NSObject
@property (nonatomic,copy) NSString *answer_id;
@property (nonatomic,copy) NSString *question_id;
@property (nonatomic,copy) NSString *user_id;
@property (nonatomic,copy) NSString *txt;
@property (nonatomic,copy) NSString *audio;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *inserttime;
@property (nonatomic,copy) NSString *thumbup;
@property (nonatomic,copy) NSString *thumbdown;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *header_photo;
@end
