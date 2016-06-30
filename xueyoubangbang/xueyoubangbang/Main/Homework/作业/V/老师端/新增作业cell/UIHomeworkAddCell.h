//
//  UIHomeworkAddCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeworkAddDelegate.h"
@class NewHomeworkInfo,NewHomeworkItem;
@interface UIHomeworkAddCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *editField;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *editImageView;
@property (weak, nonatomic) id<UIHomeworkAddDelegate> UIHomeworkAddDelegate;
- (void)loadHomeworkForTitle:(NewHomeworkInfo*)data withIndex:(NSIndexPath*)index;
- (void)loadHomeworkForStudent:(NewHomeworkInfo*)data withIndex:(NSIndexPath*)index;
@end
