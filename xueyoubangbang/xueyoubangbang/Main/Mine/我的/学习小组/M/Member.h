//
//  Member.h
//  xueyoubangbang
//
//  Created by Bob on 15/8/30.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Member : NSObject
@property (nonatomic, copy) NSString * userid;
@property (nonatomic, copy) NSString * username;
@property (nonatomic, copy) NSString * header_photo;
@property (nonatomic, copy) NSString * pinYin;
@property (nonatomic, copy) NSString * accuratesigntime;
@property (nonatomic, assign) BOOL Signup;

@end
