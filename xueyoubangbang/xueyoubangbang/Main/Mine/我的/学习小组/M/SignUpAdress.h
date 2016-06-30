//
//  SignUpAdress.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignUpAdress : NSObject
@property (copy, nonatomic) NSString *address;
@property (assign, nonatomic) CGFloat latitude;
@property (assign, nonatomic) CGFloat atitude;
@property (assign, nonatomic) CLLocationCoordinate2D signupLocation;
@end
