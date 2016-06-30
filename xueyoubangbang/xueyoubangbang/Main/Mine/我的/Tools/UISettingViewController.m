//
//  UISettingViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/3.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UISettingViewController.h"
#import "UILoginViewController.h"
#import "UIAboutViewController.h"
#import "UISettingMessageViewController.h"
#import "UIWebViewController.h"
@interface UISettingViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    
    NSArray *cellData;
}

@end
@implementation UISettingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cellData = @[@"消息设置",@"关于学有帮帮"];
    
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"系统设置";
    table = CREATE_TABLE(UITableViewStylePlain);
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    UIButton *btnLogout = BUTTON_CUSTOM(44 * 3 + 20 + 50);
    [btnLogout setTitle:@"退出登录" forState:UIControlStateNormal];
    [btnLogout addTarget:self action:@selector(doLogout) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnLogout];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellData.count-1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [cellData objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        [self.navigationController pushViewController:[[UISettingMessageViewController alloc] init] animated:YES];
    }
    else if(indexPath.row == 1)
    {
        [self.navigationController pushViewController:[[UIAboutViewController alloc] init] animated:YES];
    }
//    else if (indexPath.row == 2)
//    {
//        [self doVersion];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)doLogout
{
    [GlobalVar instance].user = nil;
    [GlobalVar instance].header = nil;
    [self presentViewController:[[UICustomNavigationViewController alloc] initWithRootViewController:[[UILoginViewController alloc]init]] animated:YES completion:nil];
}

//- (void)doVersion
//{
//    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
//    [AFNetClient GlobalGet:kUrlVersion parameters:[CommonMethod getParaWithOther:nil] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
//        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
////        if(isUrlSuccess(dataDict))
////        {
////            
////        }
//        NSDictionary *version = [dataDict objectForKey:@"version"];
//        NSString *latestVerstionname = [version objectForKey:@"iosversioncode"];
//
//        NSString *localVersionname = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
//        NSInteger compareResult = [self compareFirstVersion:latestVerstionname secondVersion:localVersionname];
//        if(compareResult > 0)
//        {
//            [BlockAlertView alertWithTitle:nil message:@"发现新版本,是否立即升级？" cancelButtonWithTitle:@"取消" cancelBlock:^{
//                ;
//            } confirmButtonWithTitle:@"去升级" confrimBlock:^{
//                UIWebViewController *ctrl = [[UIWebViewController alloc] init];
//                ctrl.urlString = [version objectForKey:@"iosdownloadurl"];
//                ctrl.title = @"更新";
//                [self.navigationController pushViewController:ctrl animated:YES];
//                
//            }];
//        }
//        else
//        {
//            [CommonMethod showAlert:@"已经是最新版本"];
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
//    }];
//}

- (NSInteger)compareFirstVersion:(NSString *)firstVersion secondVersion:(NSString *)secondVersion
{
    NSArray *firstVersionArr = [firstVersion componentsSeparatedByString:@"."];
    NSArray *secondVersionArr = [secondVersion componentsSeparatedByString:@"."];
    
    for (int i = 0; i<firstVersionArr.count; i++) {
        NSString *first = [firstVersionArr objectAtIndex:i];
        NSString *second = [secondVersionArr objectAtIndex:i];
        if(first.integerValue > second.integerValue )
        {
            return 1;
        }
        if(first.integerValue < second.integerValue)
        {
            return -1;
        }
        
    }
    return 0;
}


@end
