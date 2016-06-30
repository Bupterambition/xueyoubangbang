//
//  UIHomeworkCheckCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckHomeWorkStudent;
@interface UIHomeworkCheckCell : UITableViewCell
- (void)loadData:(CheckHomeWorkStudent*)data withHomeworkTitle:(NSString*)title;
@end
