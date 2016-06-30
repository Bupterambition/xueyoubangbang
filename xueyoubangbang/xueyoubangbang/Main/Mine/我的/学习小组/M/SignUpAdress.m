//
//  SignUpAdress.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "SignUpAdress.h"
#import <CoreLocation/CoreLocation.h>
@implementation SignUpAdress
- (CLLocationCoordinate2D)signupLocation{
    return CLLocationCoordinate2DMake(_latitude,_atitude);
}
@end
