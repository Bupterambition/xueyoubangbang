//
//  UIHomeworkKnowledgeAddViewController.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewHomeWorkSend.h"
@interface UIHomeworkKnowledgeAddViewController : UIViewController
@property (nonatomic, strong) NSMutableArray *displayKnowledgePoints;
@property (nonatomic, strong) NewHomeWorkSend* baseHomeWork;
@end
