//
//  UIMineUserDetailViewController.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIMineUserDetailViewController : UIViewController
@property (nonatomic , copy) NSString *userid;
@property (nonatomic, strong) MUser *mUser;
@property (nonatomic, assign) NSInteger roles;
@end
