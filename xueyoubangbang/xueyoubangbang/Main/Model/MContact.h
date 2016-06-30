//
//  MContact.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MContact : NSObject
@property (nonatomic,copy) NSString *header_photo;
@property (nonatomic) NSInteger isfriend;
@property (nonatomic,copy) NSString *relation;
@property (nonatomic,copy) NSString *sortLetters;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *username;
+(MContact *)objectWithDictionary:(NSDictionary *)dic;
@end
