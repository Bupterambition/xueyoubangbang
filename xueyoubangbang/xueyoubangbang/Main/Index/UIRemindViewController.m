//
//  UIRemindViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/12.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIRemindViewController.h"
#import "MJRefresh.h"
#import "UIRemindDetailViewController.h"
#import "UIRemindEditViewController.h"
@interface UIRemindViewController ()
{
    UITableView *table;
    int cellCount;
}
@end

@implementation UIRemindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.hidesBottomBarWhenPushed = YES;
    self.navigationItem.title = @"提醒";
    cellCount = 20;
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    table = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    table.backgroundView = nil;
    table.backgroundColor = [UIColor clearColor];
    table.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    table.separatorColor = RGB(190, 196, 210);
    
    if (IOS_VERSION_7_OR_ABOVE) {
        table.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    
    
    [table addLegendHeader ];
    table.legendHeader.refreshingBlock = ^{
        NSLog(@"loadNew");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [table reloadData];
            
            // 拿到当前的上拉刷新控件，结束刷新状态
            [table.header endRefreshing];
        });
    };
    [table addLegendFooter];
    table.legendFooter.refreshingBlock = ^{
        NSLog(@"loadMore");
        // 刷新表格
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [table reloadData];
            
            // 拿到当前的上拉刷新控件，结束刷新状态
            [table.footer endRefreshing];
        });

    };

    [self.view addSubview:table];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return cellCount;
}

#define LEFT_LABLE 10001
#define CELL_HEIGHT 70.0f
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        //        cell.backgroundView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"bg_setup_nor"] stretchableImageWithLeftCapWidth:6 topCapHeight:6]];
        //        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:[[UIImage imageNamed:@"bg_setup_pre"] stretchableImageWithLeftCapWidth:6 topCapHeight:6]];
        UILabel *left = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, CELL_HEIGHT)];
        left.textAlignment = NSTextAlignmentCenter;
        left.backgroundColor = [UIColor clearColor];
        left.tag = LEFT_LABLE;
        cell.imageView.image = [CommonMethod createImageWithColor:[UIColor clearColor] size:CGSizeMake(80, CELL_HEIGHT)];
        [cell.contentView addSubview:left];
        cell.editingAccessoryView = [self createEditingAccessoryView];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    //    cell.textLabel.textColor = RGB(100, 100, 100);
    
    cell.textLabel.text = @"textLable";
    cell.detailTextLabel.font = [UIFont systemFontOfSize:11];
    cell.detailTextLabel.textColor = RGB(100, 100, 100);
    cell.detailTextLabel.text = @"detailText";
    UILabel *leftLable = (UILabel *) [cell.contentView viewWithTag:LEFT_LABLE];
    leftLable.text = @"20:00";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewCellEditingStyleDelete;
//}

/*改变删除按钮的title*/
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return @"删除";
//}


//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *) indexPath
//
//{
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete)
//        
//    {
//        
//        NSLog(@"Deleted section %d, cell %d", indexPath.section, indexPath.row);
//        
//        NSMutableArray *array = [ [ NSMutableArray alloc ] init ];
//        
//        [ array addObject: indexPath ];
//        cellCount--;
//        [ tableView deleteRowsAtIndexPaths: array withRowAnimation: UITableViewRowAnimationBottom];
//        
//    }
//}

#pragma UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIRemindDetailViewController *detail = [[UIRemindDetailViewController alloc] init];
    detail.title = @"提醒";
    [self.navigationController pushViewController:detail animated:YES];
    
//    UIRemindEditViewController *edit = [[UIRemindEditViewController alloc] init];
//    edit.title = @"提醒";
//    [self.navigationController pushViewController:edit animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark private
- (UIView *)createEditingAccessoryView
{
    UIView *accessoryView = [[UIView alloc] init];
    UIButton *btnEdit = [UIButton buttonWithType:UIButtonTypeSystem];
    btnEdit.frame = CGRectMake(0, 0, 50, CELL_HEIGHT);
    btnEdit.titleLabel.text = @"编辑";
    
    UIButton *btnDelete = [UIButton buttonWithType:UIButtonTypeSystem];
    btnDelete.frame = CGRectMake(50, 0, 50, CELL_HEIGHT);
    btnDelete.titleLabel.text = @"删除";
    [accessoryView addSubview:btnEdit];
//    [accessoryView addSubview:btnDelete];
    return accessoryView;
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
