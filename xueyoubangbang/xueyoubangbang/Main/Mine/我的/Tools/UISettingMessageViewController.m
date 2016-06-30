//
//  UISettingMessageViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/3.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UISettingMessageViewController.h"
#import "MMessageSetting.h"
@interface UISettingMessageViewController()<UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    UITableView *table;
    NSMutableArray *data;
    MMessageSetting *setting;
    
    UIPickerView *datePicker;
    NSArray *pickerData;
    UIView *pickerContainer;
    
}
@end
@implementation UISettingMessageViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self reloadData];
    
    NSMutableArray *pickerComponent0 = [NSMutableArray array];
    for (int i = 0; i < 24; i ++) {
        NSString *time = [NSString stringWithFormat:@"%02d:00",i];
        [pickerComponent0 addObject:time];
    }

    pickerData = @[ pickerComponent0];

    
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"消息设置";
    
    table = CREATE_TABLE(UITableViewStyleGrouped);
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - kNavigateBarHight);
    [self.view addSubview:table];
    [self reload];
}

- (void)reload
{
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlGetSystemSwitch parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            NSDictionary *dic = [dataDict objectForKey:@"switchinfo"];
            NSNumber *remind_switch = [dic objectForKey:@"remind_switch"];
            NSNumber *msg_switch = [dic objectForKey:@"msg_switch"];
            
            [GlobalVar instance].messageSetting.wholeOn = remind_switch.integerValue;
            [GlobalVar instance].messageSetting.homeworkOn = msg_switch.integerValue;
            
            [GlobalVar instance].messageSetting = [GlobalVar instance].messageSetting;
            if(remind_switch.integerValue == 0 && msg_switch.integerValue !=0)
            {
                [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
                [AFNetClient GlobalGet:kUrlGetRemindTimeList parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
                    [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
                    if(isUrlSuccess(dataDict))
                    {
                        NSArray *list = [dataDict objectForKey:@"remindlist"];
                        NSMutableArray *t = [NSMutableArray array];
                        if(![list isKindOfClass:[NSNull class]])
                        {
                            for (NSDictionary *time in list) {
                                [t addObject:time ];
                            }
                        }
                        [GlobalVar instance].messageSetting.homeworkTime = t;
                        [GlobalVar instance].messageSetting = [GlobalVar instance].messageSetting;
                        
                        [self reloadData];
                        [table reloadData];
                    }
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
                }];
            }
            else
            {
                [self reloadData];
                [table reloadData];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 2)
    {
        return ((NSArray *)[data objectAtIndex:section]).count + 1;
    }
    return  ((NSArray *)[data objectAtIndex:section]).count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
    }
    
    if(indexPath.section == 0 || indexPath.section == 1)
    {
        UISwitch *swich = [[UISwitch alloc] init];
        cell.accessoryView = swich;
        swich.tag = indexPath.section;
        if(indexPath.section == 0)
        {
            [swich setOn:[GlobalVar instance].messageSetting.wholeOn animated:NO];
        }
        else
        {
            [swich setOn:[GlobalVar instance].messageSetting.homeworkOn animated:NO];
        }
        [swich addTarget:self action:@selector(swichChange:) forControlEvents:UIControlEventValueChanged];
        cell.textLabel.text = [[data objectAtIndex: indexPath.section] objectAtIndex:indexPath.row];
    }
    else
    {
        cell.accessoryView = nil;
        if(indexPath.row == 0)
        {
            cell.textLabel.text = nil;
        }
        else
        {
            cell.textLabel.text = nil;
        }
        
        if(indexPath.row ==  ((NSArray *)[data objectAtIndex:indexPath.section]).count)
        {
            cell.detailTextLabel.text = @"添加";
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"personalhomepage_my_addition"]];
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.accessoryView = nil;
            NSDictionary *timeDic = [((NSArray *) [data objectAtIndex:indexPath.section]) objectAtIndex:indexPath.row];
            cell.detailTextLabel.text = [CommonMethod formatDate:[timeDic objectForKey:@"remindtime"] inFormat:@"HH:mm:ss" outFormat:@"HH:mm"] ;
        }
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2 && indexPath.row != ((NSArray *)[data objectAtIndex:2]).count)
    {
        return YES;
    }
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = [[GlobalVar instance].messageSetting.homeworkTime objectAtIndex:indexPath.row];
    [[GlobalVar instance].messageSetting.homeworkTime removeObjectAtIndex:indexPath.row];
    [GlobalVar instance].messageSetting = [GlobalVar instance].messageSetting;
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationBottom];
    

    [AFNetClient GlobalGet:kUrlDelRemindTime parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key,@"id":[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        ;
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 2)
    {
        [self showDatePicker:indexPath.row];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)swichChange:(id)sender
{
    UISwitch *sw = (UISwitch *)sender;
    if(sw.tag == 0)
    {
        NSLog(@"%d",sw.on);
        [GlobalVar instance].messageSetting.wholeOn = sw.on;
        [GlobalVar instance].messageSetting = [GlobalVar instance].messageSetting;
        
        
        [AFNetClient GlobalGet:kUrlSetSystemSwitch parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key,@"type":@"remind_switch",@"switch":[NSString stringWithFormat:@"%d",sw.on]} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            ;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
    }
    else if(sw.tag == 1)
    {
        [GlobalVar instance].messageSetting.homeworkOn = sw.on;
        [GlobalVar instance].messageSetting = [GlobalVar instance].messageSetting;
        
        [AFNetClient GlobalGet:kUrlSetSystemSwitch parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key,@"type":@"msg_switch",@"switch":[NSString stringWithFormat:@"%d",sw.on]} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            ;
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
        
        if(sw.on)
        {
            [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
            [AFNetClient GlobalGet:kUrlGetRemindTimeList parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
                [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
                if(isUrlSuccess(dataDict))
                {
                    NSArray *list = [dataDict objectForKey:@"remindlist"];
                    NSMutableArray *t = [NSMutableArray array];
                    if(![list isKindOfClass:[NSNull class]])
                    {
                        for (NSDictionary *time in list) {
//                            NSString *remindtime = [time objectForKey:@"remindtime"];
                            [t addObject: time];
                        }
                    }
                    [GlobalVar instance].messageSetting.homeworkTime = t;
                    [GlobalVar instance].messageSetting = [GlobalVar instance].messageSetting;
                    
                    [self reloadData];
                    [table reloadData];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            }];
            
        }
    }
    [self reloadData];
    [table reloadData];
    
}

- (void)reloadData
{
    if([GlobalVar instance].messageSetting.wholeOn)
    {
        data = [NSMutableArray arrayWithArray:@[@[@"消息免打扰"]]];
    }
    else
    {
        if(![GlobalVar instance].messageSetting.homeworkOn)
        {
            data = [NSMutableArray arrayWithArray:@[@[@"消息免打扰"],
                                                    @[@"作业提醒"]]];
        }
        else
        {
            data = [NSMutableArray arrayWithArray:@[@[@"消息免打扰"],
                                                    @[@"作业提醒"],
                                                    [GlobalVar instance].messageSetting.homeworkTime
                                                    ]
                    ];
        }
    }
}


- (void)showDatePicker:(NSInteger)row
{
    if(pickerContainer == nil)
    {
        datePicker = [[UIPickerView alloc] init];
        datePicker.dataSource = self;
        datePicker.delegate = self;
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
        [btnComplete addTarget:self action:@selector(doSureTime:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
        [topView addSubview:btnCancel];
        btnCancel.frame = CGRectMake(10, 0, 100, 49);
        [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
        [btnCancel addTarget:self action:@selector(doCancelTime) forControlEvents:UIControlEventTouchUpInside];
        
    }
    pickerContainer.frame = CGRectMake(0, self.view.frame.size.height, SCREEN_WIDTH, datePicker.frame.size.height + 50);
    datePicker.frame = CGRectMake(0, 50, SCREEN_WIDTH, datePicker.frame.size.height);
    pickerContainer.tag = row;
    [LayerCustom showWithView:pickerContainer];
}

- (void)hideDatePicker
{
    [LayerCustom hide];
}


- (void)doSureTime:(id)sender
{

    NSInteger row = ((UIView *)sender).superview.superview.tag;
    
    NSString *time = [[pickerData objectAtIndex:0] objectAtIndex:[datePicker selectedRowInComponent:0]];
    
    [self hideDatePicker];

    BOOL isContaine = NO;
    for (NSDictionary *dic in [GlobalVar instance].messageSetting.homeworkTime) {
        if([time isEqualToString: [CommonMethod formatDate:[dic objectForKey:@"remindtime"] inFormat:@"HH:mm:ss" outFormat:@"HH:mm"] ])
        {
            isContaine = YES;
            break;
        }
        
    }

    
    if(row == [GlobalVar instance].messageSetting.homeworkTime.count)
    {
        if(!isContaine)
        {
            
            [AFNetClient GlobalGet:kUrlSetRemindTime parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key,@"remindtime":time} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
                if(isUrlSuccess(dataDict))
                {
                    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
                    [AFNetClient GlobalGet:kUrlGetRemindTimeList parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
                        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
                        if(isUrlSuccess(dataDict))
                        {
                            NSArray *list = [dataDict objectForKey:@"remindlist"];
                            NSMutableArray *t = [NSMutableArray array];
                            if(![list isKindOfClass:[NSNull class]])
                            {
                                for (NSDictionary *time in list) {
                                    //                            NSString *remindtime = [time objectForKey:@"remindtime"];
                                    [t addObject: time];
                                }
                            }
                            [GlobalVar instance].messageSetting.homeworkTime = t;
                            [GlobalVar instance].messageSetting = [GlobalVar instance].messageSetting;
                            
                            [self reloadData];
                            [table reloadData];
                        }
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
                    }];

                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
            }];
            
        }
        else
        {
            [CommonMethod showAlert:@"时间重复"];
            return;
        }
    }
    else
    {
        
        UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:2]];
        if([time isEqualToString:cell.detailTextLabel.text])
        {
//            [CommonMethod showAlert:@"时间重复"];
            return;
        }
        
        if(isContaine)
        {
            [CommonMethod showAlert:@"时间重复"];
            return;
        }
        
        NSDictionary *dic = [[GlobalVar instance].messageSetting.homeworkTime objectAtIndex:row];
        
        dic = @{@"id":[dic objectForKey:@"id"],@"remindtime":[NSString stringWithFormat:@"%@:00",time]};
        [[GlobalVar instance].messageSetting.homeworkTime replaceObjectAtIndex:row withObject:dic];
        
        [AFNetClient GlobalGet:kUrlUpdateRemindTime parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key,@"remindtime":time,@"id":[dic objectForKey:@"id"]} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
        
        
    }
    [GlobalVar instance].messageSetting = [GlobalVar instance].messageSetting;
    
    [self reloadData];
    [table reloadData];
}

- (void)doCancelTime
{
    [self hideDatePicker];
}

#pragma mark UIPickerViewDataSource,Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return pickerData.count;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return ((NSArray *) [pickerData objectAtIndex:component]).count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [[pickerData objectAtIndex:component] objectAtIndex:row];
}

@end
