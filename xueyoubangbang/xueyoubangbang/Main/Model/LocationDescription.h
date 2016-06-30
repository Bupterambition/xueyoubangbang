//
//  LocationDescription.h
//  xueyoubangbang
//
//  Created by Bob on 15/8/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationDescription : NSObject
@property(nonatomic, assign) NSUInteger uid;
@property(nonatomic, copy) NSString *address;
@property(nonatomic, assign) NSUInteger geotable_id;
@property(nonatomic, assign) NSUInteger sign_number;
@property(nonatomic, copy) NSArray *location;
@end
