//
//  ClassEditView.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/22.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClassEditView : UIView<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (nonatomic,retain) UITextField *field1;
@property (nonatomic,readonly,retain) UILabel *label2;
@property (nonatomic,readonly,retain) UILabel *label3;
@property (nonatomic,readonly,retain) UIButton *btnCancel;
@property (nonatomic,readonly,retain) UIButton *btnSure;
@property (nonatomic,readonly,retain) UITableView *table;
@property (nonatomic,readonly,retain) UITableView *tableResult;
//@property (nonatomic,retain) NSMutableArray *schoolArray;
//@property (nonatomic,retain) NSDictionary *gradeDic;
//@property (nonatomic,retain) NSMutableDictionary *classDic;

@property (nonatomic,copy) NSString *currentSchoolId;
@property (nonatomic,copy) NSString *currentScooolName;
@property (nonatomic,copy) NSString *currentGrade;
@property (nonatomic,copy) NSString *currentClass;

- (void)removeTableResult;
@end
