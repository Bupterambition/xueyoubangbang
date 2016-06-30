//
//  MSubject.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSubject : NSObject
@property (nonatomic,copy) NSString *nickname;
@property (nonatomic,copy) NSString *subject_id;
@property (nonatomic,copy) NSString *subject_name;
@property (nonatomic,copy) NSString *icon;
+(MSubject *)objectWithDictionary:(NSDictionary *)dic;
+(MSubject *)objectWithId:(NSString *)subject_id name:(NSString *)subject_name nickname:(NSString *)nickname icon:(NSString *)icon;
@end
