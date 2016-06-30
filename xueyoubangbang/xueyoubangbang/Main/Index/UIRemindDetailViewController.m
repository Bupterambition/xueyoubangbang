//
//  UIRemindDetailViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/12.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIRemindDetailViewController.h"

@interface UIRemindDetailViewController ()
{
    UITableView *table;
    BOOL isEdit ;
    
    UIDatePicker *picker;
    UIView *pickerContainer;
    UIButton *pickerButton;
    UILabel *pickerTitle;
    
    NSMutableArray *data;
}
@end

@implementation UIRemindDetailViewController


#define LEFT_LABLE 10001
#define CELL_HEIGHT 50.0f
#define CELL_NUMBER 4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    data = [[NSMutableArray alloc] initWithArray:@[@"今天",@"20:00",@"数学作业",@"第一次提醒"]];
    
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = RGB(190, 196, 210);
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.separatorColor = RGB(190, 196, 210);
    table.bounces = NO;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [table setTableFooterView:view];
    
    if (IOS_VERSION_7_OR_ABOVE) {
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    [self.view addSubview:table];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor blackColor]];
    isEdit = NO;
    
    [self createDatePicker];
}

- (void)createDatePicker
{
    pickerTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, CELL_HEIGHT)];
    pickerTitle.textAlignment = NSTextAlignmentCenter;
    pickerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //    pickerButton.layer.cornerRadius = 10;
    CGFloat pbWidth = 80;
    pickerButton.frame = CGRectMake(self.view.frame.size.width - pbWidth, 0, pbWidth, CELL_HEIGHT);
    [pickerButton setTitle:@"确定" forState:UIControlStateNormal];
//    [pickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    pickerButton.backgroundColor = RGB(190, 196, 210);
    [pickerButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT, 0,0)];
//    picker.showsSelectionIndicator = YES;
    picker.backgroundColor = [UIColor whiteColor];
//    picker.delegate = self;
//    picker.dataSource = self;
    NSLog(@"pickerFrame = %@ , pickerBounds = %@",NSStringFromCGRect(picker.frame),NSStringFromCGRect(picker.bounds));
    
    CGFloat pickerHeight = picker.bounds.size.height;
    pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, pickerHeight + CELL_HEIGHT)];
//    pickerContainer.backgroundColor = [UIColor blueColor];
    
    [pickerContainer addSubview:pickerTitle];
    [pickerContainer addSubview:picker];
    [pickerContainer addSubview:pickerButton];
    [self.view addSubview:pickerContainer];
}

- (void)showPicker:(int)mode
{
    if(mode == 0){
        picker.datePickerMode = UIDatePickerModeDate;
    }
    else if(mode == 1){
        picker.datePickerMode = UIDatePickerModeTime;
    }
    [UIView animateWithDuration:0.3
                     animations:^{
                         pickerContainer.frame = CGRectMake(0, self.view.frame.size.height - picker.bounds.size.height - CELL_HEIGHT, pickerContainer.frame.size.width, pickerContainer.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)hidePicker
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         pickerContainer.frame = CGRectMake(0, self.view.frame.size.height, pickerContainer.frame.size.width, pickerContainer.frame.size.height);
                     } completion:^(BOOL finished) {
                         
                     }];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //        cell.backgroundView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"bg_setup_nor"] stretchableImageWithLeftCapWidth:6 topCapHeight:6]];
        //        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"bg_setup_pre"] stretchableImageWithLeftCapWidth:6 topCapHeight:6]];
        UILabel *left = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 80, CELL_HEIGHT)];
        left.textAlignment = NSTextAlignmentLeft;
        left.backgroundColor = [UIColor clearColor];
        left.tag = LEFT_LABLE;
        cell.imageView.image = [CommonMethod createImageWithColor:[UIColor clearColor] size:CGSizeMake(80, CELL_HEIGHT)];
        [cell.contentView addSubview:left];
        
        NSLog(@"textLable.frame:%@",NSStringFromCGRect(cell.textLabel.frame));
        
    }
    
    if(isEdit){
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    UILabel *leftLable = (UILabel *) [cell.contentView viewWithTag:LEFT_LABLE];
    switch (indexPath.row) {
        case 0:
            leftLable.text = @"提醒日期";
            break;
        case 1:
            leftLable.text = @"提醒时间";
            break;
        case 2:
            leftLable.text = @"提醒内容";
            break;
        case 3:
            leftLable.text = @"备注";
        default:
            break;
    }
    cell.textLabel.text = [data objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isEdit){
        if(indexPath.row == 0){
            [self showPicker:0];
        }
        else if(indexPath.row ==1 ){
            [self showPicker:1];
        }
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        UILabel *leftLable = (UILabel *)[cell viewWithTag:LEFT_LABLE];
        pickerTitle.text = leftLable.text;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark pickerview function

///* return cor of pickerview*/
//-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
//{
//    return 2;
//}
///*return row number*/
//-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
//{
//    return 10;
//}
//
///*return component row str*/
//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
//{
//    
//    return   [NSString stringWithFormat:@"%d%d",component,row];
//}
//
///*choose com is component,row's function*/
//-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
//{
//    // NSLog(@"font %@ is selected.",row);
//    NSLog(@"%d",component);
//}



- (void)rightBarClick
{
    NSLog(@"rightBar click");
    if(isEdit){
        [self save];
    }
    else{
        [self enterEdit];
    }
    isEdit = !isEdit;
}

- (void)enterEdit
{
    NSLog(@"enterEdit");
//    self.navigationItem.rightBarButtonItem.style = UIBarButtonSystemItemDone;
    self.navigationItem.rightBarButtonItem.title = @"完成";
    [table reloadData];
}

- (void)save
{
    NSLog(@"save");
//    self.navigationItem.rightBarButtonItem.style = UIBarButtonSystemItemEdit;
    self.navigationItem.rightBarButtonItem.title = @"编辑";
    NSDate *select  = [picker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    int index;
    if(picker.datePickerMode == UIDatePickerModeDate){
        [dateFormatter setDateFormat:@"yyyy年MM月dd"];
        index = 0;
    }
    else if(picker.datePickerMode == UIDatePickerModeTime){
        index = 1;
         [dateFormatter setDateFormat:@"HH:mm"];
    }
    NSString *dateAndTime = [dateFormatter stringFromDate:select];
    [data replaceObjectAtIndex:index withObject:dateAndTime];
    [table reloadData];
    [self hidePicker];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
