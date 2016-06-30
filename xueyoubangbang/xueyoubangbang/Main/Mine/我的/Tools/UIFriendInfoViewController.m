//
//  UIFriendInfoViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/4.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIFriendInfoViewController.h"
#import "UIMineCell.h"
@interface UIFriendInfoViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSArray *section1Arr;
    
    UIButton *btnAdd;
}
@end

@implementation UIFriendInfoViewController
- (void)viewDidLoad
{
    [super viewDidLoad];

    section1Arr = @[@"昵称",@"帮帮号"];

    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"添加好友";
    
    table = CREATE_TABLE(UITableViewStyleGrouped);
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    
    btnAdd = BUTTON_CUSTOM(0 );
    btnAdd.frame = CGRectMake(btnAdd.frame.origin.x,self.view.frame.size.height - btnAdd.frame.size.height - 20 - kNavigateBarHight, btnAdd.frame.size.width, btnAdd.frame.size.height);
    [self.view addSubview:btnAdd];
    [btnAdd setTitle:@"加为好友" forState:UIControlStateNormal];
    [btnAdd addTarget:self action:@selector(doAdd) forControlEvents:UIControlEventTouchUpInside];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return section1Arr.count;
            break;
        case 1:
            return 1;
            break;
        
        default:
            break;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

#define ivTag 10000
#define lb1Tag 10001
#define lb2Tag 10002
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier ;
    UITableViewCell *cell;
//    if(indexPath.section == 0){
//        CellIdentifier = @"cellIdentifier0";
//        cell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (nil == cell) {
//            cell = [[UIMineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            UILabel *lb1 = [[UILabel alloc] init];
//            lb1.frame = CGRectMake(93, 20, 100, 20);
//            lb1.tag = lb1Tag;
//            [cell.contentView addSubview:lb1];
//            
//            UILabel *lb2 = [[UILabel alloc] init];
//            lb2.frame = CGRectMake(93, 40, 100, 20);
//            lb2.font = FONT_CUSTOM(14);
//            lb2.tag = lb2Tag;
//            [cell.contentView addSubview:lb2];
//        }
//        if(cell.imageView.image == nil)
//        {
//            UIImage *image = [GlobalVar instance].header == nil?DEFAULT_HEADER:[GlobalVar instance].header;
//            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString([GlobalVar instance].user.header_photo)] placeholderImage:image completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//                [GlobalVar instance].header = image;
//                cell.imageView.image = image;
//            }];
//        }
//        
//        UILabel *l1 = (UILabel *)[cell viewWithTag:lb1Tag];
//        l1.text = [GlobalVar instance].user.username;
//        
//        UILabel *l2 = (UILabel *)[cell viewWithTag:lb2Tag];
//        l2.text = [NSString stringWithFormat:@"帮帮号:%@",[GlobalVar instance].user.userid];
//        
//    }
//    else
      if(indexPath.section == 0){
        CellIdentifier = @"cellIdentifier1";
        cell  = [table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = [section1Arr objectAtIndex:indexPath.row];
        NSString *detail;
        switch (indexPath.row) {
            case 0:
                detail = _user.username;
                break;
            case 1:
                detail = _user.userid;
                cell.accessoryType = UITableViewCellAccessoryNone;
                break;
                
            default:
                break;
        }
        if([CommonMethod isBlankString:detail])
        {
            detail = @"去绑定";
        }
        cell.detailTextLabel.text = detail;
    }
    else if(indexPath.section == 1){
        CellIdentifier = @"cellIdentifier3";
        cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.detailTextLabel.text = _user.schoolinfo;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)doAdd
{
    if([[GlobalVar instance].user.userid isEqualToString:_user.userid])
    {
        [CommonMethod showAlert:@"不能添加自己为好友"];
        return;
    }
    
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlAddFriendReq parameters:[CommonMethod getParaWithOther: @{@"id":_user.userid}] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            [CommonMethod showAlert:@"好友申请已发送"];
        }
        else
        {
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
    }];
}

@end
