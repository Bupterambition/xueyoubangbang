//
//  SingleStudentHomeworkAnswer.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SingleStudentHomeworkAnswer : NSObject
@property (nonatomic, copy) NSString *homeworkitemid;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *homeworkid;
@property (nonatomic, copy) NSString *inserttime;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *selectanswer;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, copy) NSString *update_answer;
@property (nonatomic, assign) NSInteger Revised;
/**
 *  review时为非选择题答案,简答题对错 0/1/2 错/半对/对
 */
@property (nonatomic, copy) NSString *answerscore;
@property (nonatomic, strong) NSNumber *noSelectoranswer;

@property (nonatomic, strong) NSMutableArray *checkPics;
@end
