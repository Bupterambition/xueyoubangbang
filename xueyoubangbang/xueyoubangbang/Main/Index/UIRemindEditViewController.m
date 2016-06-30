//
//  UIRemindEditViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/13.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIRemindEditViewController.h"

@interface UIRemindEditViewController ()
{
    UITableView *table;
    UIPickerView *picker;
    UIView *pickerContainer;
    UIButton *pickerButton;
}
@end

@implementation UIRemindEditViewController

#define LEFT_LABLE 10001
#define CELL_HEIGHT 50.0f
#define CELL_NUMBER 4


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor grayColor];
    
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
    
    [self createDatePicker];
}

- (void)createDatePicker
{
    
    pickerButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    pickerButton.layer.cornerRadius = 10;
    pickerButton.frame = CGRectMake(0, 0, self.view.frame.size.width, CELL_HEIGHT);
    [pickerButton setTitle:@"完成时间" forState:UIControlStateNormal];
    [pickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    pickerButton.backgroundColor = RGB(190, 196, 210);
    
    picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT, 0,0)];
    picker.showsSelectionIndicator = YES;
    picker.backgroundColor = [UIColor whiteColor];
    picker.delegate = self;
    picker.dataSource = self;
     NSLog(@"pickerFrame = %@ , pickerBounds = %@",NSStringFromCGRect(picker.frame),NSStringFromCGRect(picker.bounds));
    
    CGFloat pickerHeight = picker.bounds.size.height;
    pickerContainer = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - pickerHeight - CELL_HEIGHT, self.view.frame.size.width, pickerHeight + CELL_HEIGHT)];
    pickerContainer.backgroundColor = [UIColor blueColor];
    [pickerContainer addSubview:picker];
    [pickerContainer addSubview:pickerButton];
    [self.view addSubview:pickerContainer];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return CELL_NUMBER;
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
    
    UILabel *leftLable = (UILabel *) [cell.contentView viewWithTag:LEFT_LABLE];
    switch (indexPath.row) {
        case 0:
            leftLable.text = @"提醒日期";
            cell.textLabel.text = @"今天";
            break;
        case 1:
            leftLable.text = @"提醒时间";
            cell.textLabel.text = @"20:00";
            break;
        case 2:
            leftLable.text = @"提醒内容";
            cell.textLabel.text = @"数学作业";
            break;
        case 3:
            leftLable.text = @"备注";
            cell.textLabel.text = @"第一次提醒";
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}


#pragma mark pickerview function

/* return cor of pickerview*/
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
/*return row number*/
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
}

/*return component row str*/
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return   [NSString stringWithFormat:@"%d%d",component,row];
}

/*choose com is component,row's function*/
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    // NSLog(@"font %@ is selected.",row);
    NSLog(@"%d",component);
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
