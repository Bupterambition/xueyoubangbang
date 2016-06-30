//
//  InterActDetailCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/29.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AnswerObject;
@interface InterActDetailCell : UITableViewCell
@property (strong, nonatomic) NSIndexPath *currentIndex;
- (void)loadData:(AnswerObject *)data;
@end
