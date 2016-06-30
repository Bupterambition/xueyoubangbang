//
//  UIFriendsViewController.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIInterActMemberViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate,UISearchBarDelegate>
@property (nonatomic, strong) NSData* audioData;
@property (nonatomic, copy) NSMutableArray *picArray;
@property (nonatomic, copy) NSString *subjectid;
@property (nonatomic, copy) NSString *item_info;
/**
 *  是否是从作业详情界面push过来
 */
@property (nonatomic, assign) BOOL ifFromHomework;
@property (nonatomic, copy) NSMutableArray *picUrlArray;
@property (nonatomic, copy) NSString *audioUrl;
@end
