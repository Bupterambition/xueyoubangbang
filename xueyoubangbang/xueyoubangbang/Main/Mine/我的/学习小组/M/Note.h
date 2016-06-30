//
//  Note.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Note : NSObject
@property (nonatomic,copy) NSString *item_id;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *subjectid;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *inserttime;
@property (nonatomic,copy) NSString *audio;
@property (nonatomic,copy) NSString *firstimg;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSMutableArray *testPics;
@property (nonatomic,copy) NSMutableArray *testAnswer;
- (NSArray *)getPicArray;
@end
