//
//  UIHomeworkAddViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/31.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAddViewController.h"
#import "UIDropListView.h"
#import "MClass.h"
#import "MSubject.h"
#import "NSDate+Format.h"
#import "UIHomeworkDetailCellTableViewCell.h"
#import "MHomework.h"
#import "UIHomeworkAddItemController.h"
#import "UIListTableViewCell.h"
#import "UIHomeworkDetailCell2.h"
@interface UIHomeworkAddViewController ()<DropListViewDelegate,UITextFieldDelegate>
{
    UITableView *table;
    UIDropListView *dropList;
    
    NSArray *dropListDataClass;
    NSArray *dropListTitleClass;
    UIDatePicker *datePicker;
    UIView *pickerContainer;
    
    NSInteger dropListIndex;
    
    NSArray *dropListDataSubject ;
    NSArray *dropListTitleSubejct;
    
    UILabel *middelLabel0;
    UILabel *middelLabel1;
    UITextField *middelTextField2;
    UILabel *middelLabel3;
    
    NSString *currentClassId;
    NSString *currentClassName;
    NSString *currentSubjectId;
    NSString *currentSubjectName;
    NSString *currentTitle;
    NSString *currentTime;
    
    NSArray *pickerData;
    
    MHomework *_homework;
}
@end
@implementation UIHomeworkAddViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self createViews];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [table reloadData];
}

- (void)loadData
{
    _homework = [[MHomework alloc] init];
    MHomeworkItem *item = [[MHomeworkItem alloc] init];
    item.title = @"第1项";
    _homework.itemlist = [NSMutableArray arrayWithArray:@[item]];
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"作业详情";
    table = CREATE_TABLE(UITableViewStyleGrouped);
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.bounds.size.height - kNavigateBarHight);
    [self.view addSubview:table];
    table.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIButton *btnAddItem = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddItem.backgroundColor = [UIColor whiteColor];
    [btnAddItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    btnAddItem.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    [btnAddItem setTitle:@"添加一条" forState:UIControlStateNormal];
    [btnAddItem addTarget:self action:@selector(doAddItem) forControlEvents:UIControlEventTouchUpInside];
    
    table.tableFooterView = btnAddItem;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发布" style:UIBarButtonItemStylePlain target:self action:@selector(doPublish)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _homework.itemlist.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 4;
            break;
            
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section > 0)
    {
        return [UIHomeworkDetailCell2 cellHeight];
    }
    return 44;
}


#define rightLable1Tag 10000
#define rightLable2Tag 10001
#define leftLabelTag 10002
#define middleLabelTag 10003
#define cell_h 44
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        
        if(indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3)
        {
            static NSString *CellIdentifier = @"cellIdentifier00";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                UILabel *leftLabel = [[UILabel alloc] init];
                leftLabel.frame = CGRectMake(20, 0, 80, cell_h);
                leftLabel.textAlignment = NSTextAlignmentLeft;
                leftLabel.tag = leftLabelTag;
                [cell.contentView addSubview:leftLabel];
                
                UIView *sep = [[UIView alloc] init];
                sep.backgroundColor = VIEW_BACKGROUND_COLOR;
                sep.frame = CGRectMake([leftLabel rightX] + 5, 10, 1, cell.frame.size.height - 20);
                [cell.contentView addSubview:sep];
                
                UILabel *middelLabel = [[UILabel alloc] init];
                middelLabel.frame = CGRectMake([sep rightX] + 10, 0, 180, cell_h);
                middelLabel.textAlignment = NSTextAlignmentLeft;
                middelLabel.tag = middleLabelTag;
                [cell.contentView addSubview:middelLabel];
                middelLabel.font = FONT_CUSTOM(12);
            }
            UILabel *leftLb = (UILabel *)[cell viewWithTag:leftLabelTag];
            UILabel *middleLb = (UILabel *)[cell viewWithTag:middleLabelTag];
            if(indexPath.row == 0)
            {
                leftLb.text = @"选择班级";
                middleLb.text = currentClassName;
            }
            else if(indexPath.row == 1){
                leftLb.text = @"选择科目";
                middleLb.text = currentSubjectName;
            }
            else
            {
                leftLb.text = @"提交时间";
                middleLb.text= currentTime;
            }
            
            return cell;
        }
        else
        {
            static NSString *CellIdentifier = @"cellIdentifier01";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                
                UILabel *leftLabel = [[UILabel alloc] init];
                leftLabel.frame = CGRectMake(20, 0, 80, cell_h);
                leftLabel.textAlignment = NSTextAlignmentLeft;
                leftLabel.tag = leftLabelTag;
                [cell.contentView addSubview:leftLabel];
                
                UIView *sep = [[UIView alloc] init];
                sep.backgroundColor = VIEW_BACKGROUND_COLOR;
                sep.frame = CGRectMake([leftLabel rightX] + 5, 10, 1, cell.frame.size.height - 20);
                [cell.contentView addSubview:sep];
                
                UITextField * middelField = [[UITextField alloc] init];
                middelField.tag = middleLabelTag;
                middelField.frame = CGRectMake([sep rightX] + 10, 0, 150, cell_h);
                middelField.delegate = self;
                [cell.contentView addSubview:middelField];
            }
            UILabel *leftLb = (UILabel *)[cell viewWithTag:leftLabelTag];
            UITextField *middleLb = (UITextField *)[cell viewWithTag:middleLabelTag];
            leftLb.text = @"题目名称";
            middleLb.text = currentTitle;
            return cell;
        }
        
    }
    else{
//        NSString *CellIdentifier = @"cellIdentifier1";
//        //        UIHomeworkDetailCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        //        if (nil == cell) {
//        
//        UIHomeworkDetailCellTableViewCell * cell = [[UIHomeworkDetailCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//        if(indexPath.section > 1)
//        {
//            [cell.rightTopButton addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
//            [cell.rightTopButton setTitle:@"删除" forState:UIControlStateNormal];
//            [cell.rightTopButton setTitleColor:STYLE_COLOR forState:UIControlStateNormal];
//        }
//        else
//        {
//            cell.rightTopButton.hidden = YES;
//        }
////        cell.rightTopButton.hidden = YES;
//        cell.rightIcon.hidden = YES;
//        MHomeworkItem *hi = [_homework.itemlist objectAtIndex:indexPath.section - 1];
//        [cell settingData:hi];
//        cell.leftTopLabel.text = hi.title;
//        return cell;
        NSString *CellIdentifier = @"cellIdentifier1";
        UIHomeworkDetailCell2 *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(nil == cell)
        {
            cell = [[UIHomeworkDetailCell2 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.ifAddWorkVC = YES;
        [cell.rightTopButton addTarget:self action:@selector(doDelete:) forControlEvents:UIControlEventTouchUpInside];
        [cell.rightTopButton setTitle:@"删除" forState:UIControlStateNormal];
        [cell.rightTopButton setTitleColor:STYLE_COLOR forState:UIControlStateNormal];
        cell.rightIcon.hidden = YES;
        MHomeworkItem *hi = [_homework.itemlist objectAtIndex:indexPath.section - 1];
        cell.homeworkItem = hi;
        return cell;

    }
    return nil;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    currentTitle = textField.text;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(UITextField *)getTitleField
{
    UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    UITextField *field = (UITextField *) [cell.contentView viewWithTag:middleLabelTag];
    return field;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0 || indexPath.row == 1)
        {
            dropListIndex = indexPath.row;
            [self showDropList:indexPath.row];
        }
        else if (indexPath.row == 3)
        {
            [self showDatePicker];
        }
    }
    else
    {
        
         currentTitle = [self getTitleField].text;
        UIHomeworkAddItemController *ctrl = [[UIHomeworkAddItemController alloc] init];
        ctrl.homeworkItem = [_homework.itemlist objectAtIndex:indexPath.section - 1];
        [self.navigationController pushViewController:ctrl animated:YES];
        
       
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self.view findFirstResponder] resignFirstResponder];
}

- (void)showDropList:(NSInteger) index
{
    if(dropList == nil){
        

        if(index == 0)
        {
            if(dropListTitleClass != nil)
            {
                [self createDropList:dropListTitleClass];
            }
            else
            {
                [AFNetClient GlobalGet:kUrlGetUserClass parameters:@{@"id":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
                    if(isUrlSuccess(dataDict))
                    {
                        NSLog(@"%@ = %@",kUrlGetUserClass,dataDict);
                        NSArray *list = [dataDict objectForKey:@"list"];
                        NSMutableArray *l = [NSMutableArray array];
                        if(![l isKindOfClass:[NSNull class]])
                        {
                            for (NSDictionary *dic in list) {
                                MClass *m = [MClass objectWithDictionary:dic];
                                [l addObject:m];
                            }
                        }
                        dropListDataClass = l;
                        
                        NSMutableArray *t = [NSMutableArray array];
                        for (MClass *m in l) {
                            [t addObject:m.class_name];
                        }
                        dropListTitleClass = t;
                        
                        [self createDropList:dropListTitleClass];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    ;
                }];

            }
        }
        else if (index ==1)
        {
            if(dropListDataSubject == nil)
            {
                dropListDataSubject = [[CommonMethod subjectDictionary] allValues];
                NSMutableArray *t = [NSMutableArray array];
                for (MSubject *m in dropListDataSubject) {
                    [t addObject:m.subject_name];
                }
                dropListTitleSubejct = t;
            }
            [self createDropList:dropListTitleSubejct];
        }
        else if(index == 2)
        {
            
        }
        
    }
    else
    {
        [dropList removeFromSuperview];
        dropList = nil;
    }

}

- (void)createDropList:(NSArray *)data
{
    CGFloat dropItemHeight = 40;
    CGFloat h = data.count >= 7 ? 7 * dropItemHeight:data.count * dropItemHeight;
    
    CGRect frame =  CGRectMake(100, table.frame.origin.y + cell_h, 200, h);
    dropList = [[UIDropListView alloc] initWithFrame:frame itemHeight:dropItemHeight data:data];
    dropList.layer.borderColor = VIEW_BACKGROUND_COLOR.CGColor;
    dropList.layer.borderWidth = 1;
    dropList.backgroundColor = [UIColor grayColor];
    dropList.delegate = self;
    [self.view addSubview:dropList];

}

- (void)onChooseItem:(NSInteger)row
{
    if(dropListIndex == 0)
    {
        MClass *class = [dropListDataClass objectAtIndex:row];
        currentClassId = class.class_info_id;
        currentClassName = class.class_name;
        
        UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        UILabel *label  = (UILabel *) [cell.contentView viewWithTag:middleLabelTag];
        label.text = currentClassName;
        
    }
    else if(dropListIndex == 1)
    {
        MSubject *m = [dropListDataSubject objectAtIndex:row];
        currentSubjectId = m.subject_id;
        currentSubjectName = m.subject_name;
        
        UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
        UILabel *label  = (UILabel *) [cell.contentView viewWithTag:middleLabelTag];
        label.text = currentSubjectName;
    }
    dropList = nil;
}


#pragma mark UIPickerViewDataSource,Delegate

- (void)showDatePicker
{
    if(pickerContainer == nil)
    {
        datePicker = [[UIDatePicker alloc] init];
        datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        datePicker.backgroundColor = [UIColor whiteColor];
        pickerContainer = [[UIView alloc] init];
        
        [pickerContainer addSubview:datePicker];
        
        UIView *topView = [[UIView alloc] init];
        [pickerContainer addSubview:topView];
        topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 49);
        topView.backgroundColor = [UIColor grayColor];
        
        UIButton *btnComplete = [UIButton buttonWithType:UIButtonTypeCustom];
        [topView addSubview:btnComplete];
        btnComplete.frame = CGRectMake(SCREEN_WIDTH - 10 - 100, 0, 100, 49);
        [btnComplete setTitle:@"完成" forState:UIControlStateNormal];
        [btnComplete addTarget:self action:@selector(doSureTime) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [topView addSubview:btnCancel];
        btnCancel.frame = CGRectMake(10, 0, 100, 49);
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(doCancelTime) forControlEvents:UIControlEventTouchUpInside];
        
    }
    pickerContainer.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, datePicker.frame.size.height + 50);
    datePicker.frame = CGRectMake(0, 50, SCREEN_WIDTH, datePicker.frame.size.height);
    [LayerCustom showWithView:pickerContainer];
}

- (void)hideDatePicker
{
    [LayerCustom hide];
}

- (void)doAddItem
{
    NSMutableArray *items = [NSMutableArray arrayWithArray:_homework.itemlist];
    
    MHomeworkItem *item = [[MHomeworkItem alloc] init];
    item.title = [NSString stringWithFormat:@"第%ld项",_homework.itemlist.count + 1];
    [items addObject:item];
    _homework.itemlist = items;
    [table reloadData];
}

- (void)doPublish
{
    [[self.view findFirstResponder] resignFirstResponder];
    if([CommonMethod isBlankString:currentClassId] || [CommonMethod isBlankString:currentSubjectId] || [CommonMethod isBlankString:currentTitle] || [CommonMethod isBlankString:currentTime])
    {
        [CommonMethod showAlert:@"信息不完整"];
        return;
    }

    
   // [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalMultiPartPost:kUrlAddHomework fileDataArr:[self getData] parameters:[self getPara] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDcit) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDcit))
        {
            [CommonMethod showAlert:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
            if([self.popDelegate respondsToSelector:@selector(popComplete:)])
            {
                [self.popDelegate popComplete:_homework];
            }
        }
        else
        {
            [CommonMethod showAlert:urlErrorMessage(dataDcit)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [CommonMethod showAlert:@"发布失败"];
    }];
}

- (NSDictionary *)getPara
{
    
    NSMutableDictionary *otherPara = [NSMutableDictionary dictionaryWithDictionary:@{@"classid":currentClassId,@"subjectid":currentSubjectId,@"title":currentTitle,@"submittime":currentTime,@"itemcnt": [NSNumber numberWithInteger: _homework.itemlist.count]}];
    
    for (int i = 0; i < _homework.itemlist.count; i++) {
        MHomeworkItem *item = [_homework.itemlist objectAtIndex:i];
        
        NSString *keyItemTitle = [NSString stringWithFormat:@"item_%d_title",i+1];
        NSString *valueItemTitle = item.title?item.title:@"";
        [otherPara setObject:valueItemTitle forKey:keyItemTitle];
        
        NSString *keyItemInfo = [NSString stringWithFormat:@"item_%d_info",i+1];
        NSString *valueItemInfo = item.desc?item.desc:@"";
        [otherPara setObject:valueItemInfo forKey:keyItemInfo];
        
        NSString *keyItemPicCount = [NSString stringWithFormat:@"item_%d_imgscnt",i+1];
        NSString *valueItemPicCount = [NSString stringWithFormat:@"%ld",item.picturesUIImage.count];
        [otherPara setObject:valueItemPicCount forKey:keyItemPicCount];

    }

    return [CommonMethod getParaWithOther:otherPara];
}

- (NSArray *)getData
{
    NSMutableArray *dataArr = [NSMutableArray array];
    for (int i = 0; i < _homework.itemlist.count; i++) {
        MHomeworkItem *item = [_homework.itemlist objectAtIndex:i];
        
        for (int j = 0; j<item.picturesUIImage.count; j++) {
            NSString *name = [NSString stringWithFormat:@"item_%d_img_%d",i+1,j+1];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",name];
            NSString *mimeType = @"image/jpeg";
            NSData *fileData = [((UIImage *) [item.picturesUIImage objectAtIndex:j]) toData];
            
            NSDictionary *dic = @{ @"name":name,@"fileName":fileName,@"mimeType":mimeType,@"fileData":fileData };
            
            [dataArr addObject:dic];
        }
        
        if(item.audioData != nil)
        {
            NSDictionary *audio = @{@"name": [NSString stringWithFormat:@"item_%d_audio",i+1],@"fileName":@"audio.amr",@"fileData":item.audioData,@"mimeType":@"audio/amr"};
            [dataArr addObject:audio];
        }

       
    }
    return dataArr;
}


- (void)doSureTime
{
    UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]];
    UILabel *lb = (UILabel *)[cell.contentView viewWithTag:middleLabelTag];
    lb.text = [datePicker.date format:@"MM月dd日  HH:mm"];
    [self hideDatePicker];
    
    currentTime = [datePicker.date format:@"yyyy-MM-dd HH:mm:ss"];
}

- (void)doCancelTime
{
    [self hideDatePicker];
}

- (void)doDelete:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    UIHomeworkDetailCellTableViewCell *cell = (UIHomeworkDetailCellTableViewCell *) btn.superview.superview;
    NSIndexPath *indexPath = [table indexPathForCell:cell];
//    MHomeworkItem *hi = [_homework.itemlist objectAtIndex:indexPath.section - 1];
    NSLog(@"doAsk section = %ld",indexPath.section);
    NSLog(@"doAsk row = %ld",indexPath.row);
//    NSLog(@"homeworkItem = %@",hi.desc);
    
    [_homework.itemlist removeObjectAtIndex:indexPath.section - 1];
//    [table deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [table reloadData];
}

@end
