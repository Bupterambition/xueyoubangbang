//
//  UnfinishedCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UnfinishedCellDelegate <NSObject>
- (void)didTouchNotificationBtn:(NSIndexPath*)index;
@end
@class CheckHomeWorkStudent;
@interface UnfinishedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *notificationBtn;
@property (strong, nonatomic) NSIndexPath *currentIndex;
@property (weak, nonatomic) id<UnfinishedCellDelegate> unfinishedCellDelegate;
- (void)loadData:(CheckHomeWorkStudent*)data;
@end
