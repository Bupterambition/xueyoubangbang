//
//  UIQustionAskViewController.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIDropListView.h"
#import "MHomeworkItem.h"
@protocol popDelegate<NSObject>
@optional
- (void)popFromViewController:(UIViewController*) controller WithUserinfo:(id)userinfo;
@end

@interface UIQuestionAskViewController : UIViewController<DropListViewDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>
@property (nonatomic,retain) MHomeworkItem *homeworkItem;
@property (nonatomic,weak) id<popDelegate> popDelegate;
@end
