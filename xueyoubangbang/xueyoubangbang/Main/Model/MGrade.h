//
//  MGrade.h
//  xueyoubangbang
//
//  Created by kelvinlu on 15/6/22.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGrade : NSObject
@property (nonatomic,copy) NSString *grade;
@property (nonatomic,copy) NSString *name;



+(MGrade *)objectWithDictionary:(NSDictionary *)dic;
@end
