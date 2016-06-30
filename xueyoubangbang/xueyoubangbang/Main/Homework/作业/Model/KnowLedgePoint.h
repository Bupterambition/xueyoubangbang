//
//  KnowLedgePoint.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/13.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KnowLedgePoint : NSObject
@property (nonatomic, copy) NSString *knowledgepointid;
@property (nonatomic, copy) NSString *knowledgepointname;
@property (nonatomic, copy) NSString *upknowledgepointid;
@property (nonatomic, copy) NSString *hasnextlevel;
@property (nonatomic, strong) NSArray *subknowledgepointslist;
@end
