//
//  UIMineAddNoteViewController.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIInterActAskViewController : UIViewController
/**
 *  是否是从作业详情界面push过来
 */
@property (nonatomic, assign) BOOL ifFromHomework;
@property (nonatomic, copy) NSMutableArray *picUrlArray;
@property (nonatomic, copy) NSString *audioUrl;
@property (nonatomic, copy) NSString *subject_id;
@property (nonatomic, copy) NSString *itemInfo;
/**
 *  是否从我的回答push过来
 */
@property (nonatomic, assign) BOOL ifFromMyAnswer;
@property (nonatomic, copy) NSString *questionid;
@end
