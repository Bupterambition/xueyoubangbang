//
//  StudentGroup.h
//  xueyoubangbang
//
//  Created by Bob on 15/8/30.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentGroup : NSObject
@property (nonatomic, assign) NSInteger groupid;
@property (nonatomic, copy)   NSString * groupname;
@property (nonatomic, assign) NSInteger teacherid;
@property (nonatomic, copy)   NSString *describe;
@property (nonatomic, assign) NSInteger subjectid;
- (NSString*)getGroupID;
- (NSString*)getSubject;
@end
