//
//  MessageFinishCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckHomeWorkStudent;
@interface MessageFinishCell : UITableViewCell
- (void)loadData:(CheckHomeWorkStudent*)data withIndex:(NSIndexPath*)index;
@end
