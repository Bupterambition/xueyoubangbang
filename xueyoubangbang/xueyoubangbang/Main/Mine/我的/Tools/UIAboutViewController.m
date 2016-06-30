//
//  UIAboutViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/3.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIAboutViewController.h"
#import "UIFeedBackViewController.h"
#import "UIWebViewController.h"
#import "UIWelcomViewController.h"
@interface UIAboutViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSArray *cellData;
}
@end
@implementation UIAboutViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cellData = @[@"去评分",@"欢迎页",@"帮助与反馈"];
    
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"关于学有帮帮";
    
    UIImageView *logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@""]];
    logoView.frame = CGRectMake(SCREEN_WIDTH / 2 - logoView.frame.size.width / 2, 30, logoView.frame.size.width, logoView.frame.size.height);
    [self.view addSubview:logoView];
    
    table = CREATE_TABLE(UITableViewStylePlain);
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, [logoView bottomY] + 30, table.frame.size.width, table.frame.size.height);
    table.bounces = NO;
    [self.view addSubview:table];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellData.count;
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
        NSURL *url = [NSURL URLWithString:kUrlAppDownload];
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            [[UIApplication sharedApplication] openURL:url];
        }
        else
        {
            NSLog(@"can not open");
            UIWebViewController *ctrl = [[UIWebViewController alloc] init];
            ctrl.urlString = kUrlAppDownload;
            ctrl.title = @"评分";
            [self.navigationController pushViewController:ctrl animated:YES];
        }

        
        
    }
    else if(indexPath.row == 1)
    {
        UIWelcomViewController *ctrl = [[UIWelcomViewController alloc] init];
        ctrl.isStart = NO;
        [self presentViewController:ctrl animated:YES completion:nil];
    }
    else if (indexPath.row == 2)
    {
        [self.navigationController pushViewController:[[UIFeedBackViewController alloc] init] animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
