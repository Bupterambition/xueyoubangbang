//
//  NewHomeworkItem.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreArchive.h"
@interface NewHomeworkItem : NSObject
CoreArchiver_MODEL_H
@property (nonatomic,copy) NSString *item_id;
@property (nonatomic,copy) NSString *homework_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *inserttime;
@property (nonatomic,copy) NSString *audio;
@property (nonatomic,copy) NSString *selectnum;
@property (nonatomic,assign) NSInteger choicenum;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *firstimg;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,strong) NSMutableArray *testPics;
@property (nonatomic,strong) NSMutableArray *testAnswer;
@property (nonatomic,strong) NSMutableArray *testMutilAnswer;
- (NSArray *)getPicArray;
@end
