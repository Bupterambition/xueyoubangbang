//
//  UITaskListViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UITaskListViewController.h"
#import "MTask.h"
#import "MSubject.h"
#import "UIHomeworkDetailViewController.h"
#import "UIMinePersonalIndexViewController.h"
#import "AFNetClient.h"
@interface UITaskListViewController ()
{
    UITableView *table;
    NSArray *dataArr; //MTask
    BOOL hasLoadData;
}
@end

@implementation UITaskListViewController

- (id)init
{
    self = [super init];
    if(self){
        self.hidesBottomBarWhenPushed = YES;
        dataArr = @[];
        hasLoadData = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!hasLoadData)
    {
        hasLoadData = YES;
        [table.legendHeader beginRefreshing];
    }
    
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"任务列表";
    table = CREATE_TABLE(UITableViewStylePlain);
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - kNavigateBarHight);
    [table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(reload)];
    
    [self.view addSubview:table];
}

- (void)reload
{
    
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key};
    [AFNetClient GlobalGet:kUrlGetTastList parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        NSLog(@"%@ = %@",kUrlGetTastList,dataDict);
        [table.legendHeader endRefreshing];
        
        if(isUrlSuccess(dataDict))
        {
            NSArray *list = [dataDict objectForKey:@"list"];
            
            NSMutableArray *l = [NSMutableArray array];
            if(![list isKindOfClass:[NSNull class]])
            {
                for (int i = 0 ; i < list.count; i++) {
                    MTask *m = [MTask objectWithDictionary:[list objectAtIndex:i]];
                    [l addObject:m];
                }
                dataArr = l;
                if(list.count > 0){
                    [table reloadData];
                }
            }
            
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [table.legendHeader endRefreshing];
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

#define rightLableTag 10000
#define CELL_HEIGTH 60
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        
        NSLog(@"textLable.frame:%@",NSStringFromCGRect(cell.textLabel.frame));
        
        UILabel *rightLable = [[UILabel alloc] init];
        rightLable.tag = rightLableTag;
        rightLable.textAlignment = NSTextAlignmentRight;
        rightLable.frame = CGRectMake(SCREEN_WIDTH - 100 -10, 0, 100, CELL_HEIGTH);
        [cell.contentView addSubview:rightLable];
    }
    MTask *m = [dataArr objectAtIndex:indexPath.row];
    MSubject *s = [[CommonMethod subjectDictionary] objectForKey:m.subject_id];
    cell.imageView.image = [UIImage imageNamed:s.icon];
    cell.textLabel.text = m.taskname;
    cell.detailTextLabel.text = [CommonMethod formatDate:m.needtime outFormat:@"MM月dd日"];
    UILabel *rl = (UILabel *) [cell viewWithTag:rightLableTag];
    rl.text = @"+2积分";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGTH;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MTask *m = [dataArr objectAtIndex:indexPath.row];
    
    if([@"完善个人资料" isEqualToString:m.taskname])
    {
        UIMinePersonalIndexViewController *ctrl = [[UIMinePersonalIndexViewController alloc] init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    else
    {
        UIHomeworkDetailViewController *ctrl = [[UIHomeworkDetailViewController alloc] init];
        ctrl.homeworkid = m.homeworkid;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
