//
//  NewHomeWorkSend.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreArchive.h"
@interface NewHomeWorkSend : NSObject
CoreArchiver_MODEL_H
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *groupid;
@property (nonatomic, copy) NSString *subjectid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *submittime;
@property (nonatomic, copy) NSString *knowledgepoints;
@property (nonatomic, copy) NSString *knowledges;
@property (nonatomic, strong) NSMutableArray *items;
@end
