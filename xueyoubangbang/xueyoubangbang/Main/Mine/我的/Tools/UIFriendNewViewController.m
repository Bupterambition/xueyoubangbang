//
//  UIFriendNewViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/3.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIFriendNewViewController.h"
#import "MContact.h"
#import "UIMineCell.h"
#import "UIFriendAddViewController.h"
@interface UIFriendNewViewController()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table;
    NSArray *cellData;
}

@end
@implementation UIFriendNewViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    cellData = @[];
    
    [self createView];
    [table.legendHeader beginRefreshing];
}

- (void)reload
{
    [AFNetClient GlobalGet:kUrlFriendAddList parameters:[CommonMethod getParaWithOther:nil] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [table.legendHeader endRefreshing];
        if(isUrlSuccess(dataDict))
        {
            NSArray *list = [dataDict objectForKey:@"contact_list"];
            if([list isKindOfClass:[NSNull class]])
            {
                return ;
            }
            NSMutableArray *t = [NSMutableArray array];
            for (NSDictionary *dic in list) {
                MContact *m = [MContact objectWithDictionary:dic];
                [t addObject:m];
            }
            
            cellData = t;
            [table reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [table.legendHeader endRefreshing];
    }];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"新的朋友";
    
    table = CREATE_TABLE(UITableViewStylePlain);
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    [table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(reload)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doAdd)];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return cellData.count;
}

#define rightLabelTag 10002
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellID = @"cellID";
    UIMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(cell == nil)
    {
        cell = [[UIMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIButton *rightLabel = [[UIButton alloc] init];
        rightLabel.tag = rightLabelTag;
        rightLabel.frame = CGRectMake(SCREEN_WIDTH - 40 - 30, 12, 40, 20);
        [rightLabel addTarget:self action:@selector(doAccept:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:rightLabel];
        rightLabel.titleLabel.font = FONT_CUSTOM(10);
    }
    
    
    MContact *m = [cellData objectAtIndex:indexPath.row];
    cell.textLabel.text = m.username;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(m.header_photo)] placeholderImage:DEFAULT_HEADER];
    UIButton *rl = (UIButton *)[cell.contentView viewWithTag:rightLabelTag];
    if(m.isfriend == 0)
    {
        [rl setTitle:@"接受" forState:UIControlStateNormal];
        [rl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rl.backgroundColor = UIColorFromRGB(0x64c672);
        rl.enabled = YES;
    }
    else
    {
        [rl setTitle:@"已添加" forState:UIControlStateNormal];
        [rl setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        rl.backgroundColor = UIColorFromRGB(0xe5e5e5);
        rl.enabled = NO;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)doAccept:(id)sender
{
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    UIMineCell *cell = (UIMineCell *) ((UIView *)sender).superview.superview;
    NSIndexPath *indexPath = [table indexPathForCell:cell];
    MContact *m = [cellData objectAtIndex:indexPath.row];
    [AFNetClient GlobalGet:kUrlFriendAdd parameters:[CommonMethod getParaWithOther:@{@"id":m.userid}] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            [CommonMethod showAlert:@"添加成功"];
            [table.legendHeader beginRefreshing];
            
        }
        else{
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [CommonMethod showAlert:@"添加失败"];
    }];
}

- (void)doAdd
{
    UIFriendAddViewController *ctrl = [[UIFriendAddViewController alloc] init];
    UICustomNavigationViewController *nav = [[UICustomNavigationViewController alloc] initWithRootViewController:ctrl];
    [self presentViewController:nav animated:YES completion:nil];
    
}

@end
