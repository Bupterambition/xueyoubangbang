//
//  MessageObject.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageObject : NSObject
@property (nonatomic, strong)NSMutableArray *question;
@property (nonatomic, strong)NSMutableArray *homeworkToDo;
@property (nonatomic, strong)NSMutableArray *homeworkChecked;
@property (nonatomic, strong)NSMutableArray *applyForGroup;
@property (nonatomic, strong)NSMutableArray *applyForFriends;
@property (nonatomic, strong)NSMutableArray *homeworkFinished;
- (NSInteger)getAllMessageNum;
@end
