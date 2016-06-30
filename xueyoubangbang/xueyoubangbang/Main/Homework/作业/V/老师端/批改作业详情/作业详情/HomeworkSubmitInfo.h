//
//  HomeworkSubmitInfo.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SingleStudentHomeworkInfo;
@interface HomeworkSubmitInfo : UITableViewCell
- (void)loadInfo:(SingleStudentHomeworkInfo*)data;

- (void)loadInfo:(NSString*)groupName withScore:(NSString*)score;
@end
