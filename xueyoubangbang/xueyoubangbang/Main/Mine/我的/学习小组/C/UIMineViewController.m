//
//  UIMineViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//
#define rightLableTag 10000
#define CELL_HEIGTH 50

#import "UIMineViewController.h"
#import "StudentGroupViewModel.h"
#import "UIMineCreatStudentViewController.h"
#import "MClass.h"
#import "UIMineClassIndexViewController.h"
#import "UIFriendsViewController.h"
#import "UIMinePersonalIndexViewController.h"
#import "UIMineCell.h"
#import "UILoginViewController.h"
#import "MainTabViewController.h"
#import "UISettingViewController.h"
#import "UIMineNoteViewController.h"
#import "UIHomeworkApplyGroupsForsFirst.h"
#import "UIMineKnowledageViewControllerFors.h"
#import "UIHomeworkViewModel.h"
#import "UIMineNoteAllViewController.h"
#import "UIMineGroupViewController.h"
#import "UIMineSystemSettingViewController.h"

@interface UIMineViewController ()<UITableViewDataSource,UITableViewDelegate>{
    NSArray *itemTitle;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classLabel;
@property (weak, nonatomic) IBOutlet UIImageView *header;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightView;

@end
typedef NS_ENUM(NSInteger, TopTag){
    HEADER    = 10000,
    NAMELABEL = 10001,
    CLASSLABEL= 10002
};
@implementation UIMineViewController{
    NSMutableArray *classArr;//公立学校
    NSMutableArray *classArr2;//辅导学校
}
#pragma mark - life method
- (void)viewDidLoad {
    [super viewDidLoad];
    itemTitle = @[@"通讯录",@"邀请好友",@"系统设置"];
    [self createViews];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self loadData];
    [self updateUserInfo];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.translucent = NO;
    [super viewWillDisappear:animated];
}
#pragma mark - init Method
- (void)updateUserInfo{
    if([GlobalVar instance].header == nil)
    {
        if ([CommonMethod isBlankString:[GlobalVar instance].user.header_photo]) {
            if ([UserID integerValue] % 2 == 0) {
                if (ifRoleStudent) {
                    _header.image = DEFAULT_HEADER_Tf;
                }
                else{
                    _header.image = DEFAULT_HEADER_f;
                }
            }
            else{
                if (ifRoleStudent) {
                    _header.image = DEFAULT_HEADER_M;
                }
                else{
                    _header.image = DEFAULT_HEADER_TM;
                };
            }
        }
        else{
            [_header sd_setImageWithURL:[NSURL URLWithString:UrlResString([GlobalVar instance].user.header_photo)] placeholderImage:DEFAULT_HEADER_M completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [GlobalVar instance].header = image;
                _header.image = image;
            }];
        }
    }
    else {
        _header.image = [GlobalVar instance].header;
    }
    _nameLabel.text = [GlobalVar instance].user.username;
    _classLabel.text = [GlobalVar instance].user.schoolinfo == nil?@"未进入任何班级":[GlobalVar instance].user.schoolinfo;
    if ([_classLabel.text hasSuffix:@"0班"]) {
        NSInteger length = [GlobalVar instance].user.schoolinfo.length;
        _classLabel.text = [[GlobalVar instance].user.schoolinfo substringToIndex:length-2];
    }
}
- (void)createViews{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:IMAGE(@"personalset_icon") style:UIBarButtonItemStylePlain target:self action:@selector(doDetail)];
    // 给导航条的背景图片传递一个空图片的UIImage对象
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    // 隐藏底部阴影条，传递一个空图片的UIImage对象
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    self.tableView.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.topView.backgroundColor = STYLE_COLOR;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationController.view.backgroundColor = STYLE_COLOR;
    self.tableView.contentInset = UIEdgeInsetsMake(254, 0, 0, 0);
    self.header.layer.borderWidth = 4;
    self.header.layer.borderColor = RGBA(249,166,158,0.8).CGColor;
}

#pragma mark - UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        if ([rolesUser isEqualToString:roleStudent]) {
            return 4;
        }
        else{
            return 3;
        }
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return section == 1?0:5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0){
        if ([rolesUser isEqualToString:roleStudent]) {
            if (indexPath.row == 0) {
                NSString *CellIdentifier = @"cellIdentifier2";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                }
                cell.imageView.image = [UIImage imageNamed:@"my_data"];
                cell.textLabel.text = @"学习记录";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                return cell;
            }
            else if (indexPath.row == 1){
                NSString *CellIdentifier = @"cellIdentifier2";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                cell.imageView.image = [UIImage imageNamed:@"my_note"];
                cell.textLabel.text = @" 笔记本";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                return cell;
            }
            else if (indexPath.row == 2){
                NSString *CellIdentifier = @"cellIdentifier2";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                cell.imageView.image = [UIImage imageNamed:@"homework_team_icon"];
                cell.textLabel.text = @"作业小组";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                return cell;
            }
            else{
                NSString *CellIdentifier = @"cellIdentifier2";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                cell.imageView.image = [UIImage imageNamed:@"contact_icon"];
                cell.textLabel.text = @"通讯录";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                return cell;
            }
        }
        else{
            if (indexPath.row == 0) {
                NSString *CellIdentifier = @"cellIdentifier2";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                cell.imageView.image = [UIImage imageNamed:@"homework_team_icon"];
                cell.textLabel.text = @"作业小组";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                return cell;
            }
            else if (indexPath.row == 1) {
                NSString *CellIdentifier = @"cellIdentifier2";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                cell.imageView.image = [UIImage imageNamed:@"my_note"];
                cell.textLabel.text = @" 笔记本";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                return cell;
            }
            else{
                NSString *CellIdentifier = @"cellIdentifier2";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
                if (nil == cell) {
                    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                    
                    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    
                }
                cell.imageView.image = [UIImage imageNamed:@"my_contact2"];
                cell.textLabel.text = @"通讯录";
                cell.textLabel.textAlignment = NSTextAlignmentLeft;
                return cell;
            }
        }
        
    }
    else{
        NSString *CellIdentifier = @"cellIdentifier2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.imageView.image = [UIImage imageNamed:@"systemset_icon"];
        cell.textLabel.text = @"设置";
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if ([rolesUser isEqualToString:roleTeacher]) {
            switch (indexPath.row) {
                case 0:{
                    UIMineGroupViewController *vc = [[UIMineGroupViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 1:{
                    UIMineNoteAllViewController *vc = [[UIMineNoteAllViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                    
                case 2:{
                    UIFriendsViewController* ctrl ;
                    ctrl = [[UIFriendsViewController alloc] init];
                    [self.navigationController pushViewController:ctrl animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
        else{
            switch (indexPath.row) {
                case 0:{
                    UIMineKnowledageViewControllerFors *vc = [[UIMineKnowledageViewControllerFors alloc] initWithNibName:@"UIMineKnowledageViewControllerFors" bundle:nil];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    
                    break;
                    
                case 1:{
                    UIMineNoteViewController *vc = [[UIMineNoteViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    
                    break;
                case 2:{
                    UIMineGroupViewController *vc = [[UIMineGroupViewController alloc] init];
                    [self.navigationController pushViewController:vc animated:YES];
                }
                    break;
                case 3:{
                    UIFriendsViewController* ctrl ;
                    ctrl = [[UIFriendsViewController alloc] init];
                    [self.navigationController pushViewController:ctrl animated:YES];
                }
                    break;
                    
                default:
                    break;
            }
        }
        
    }
    else {
        [self gotoSetting];
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat delta = offsetY + 254;
    // 往上拖动，高度减少。
    CGFloat height = 254 - delta;
    if (delta < 0) {
        self.heightView.constant = 124 + (-delta)/2;
        self.widthView.constant  = 124 + (-delta)/2;
        self.header.layer.cornerRadius = self.widthView.constant/2;
    }
    if (offsetY > -254 && delta >0) {
        self.heightView.constant = 124 + (-delta)/2;
        self.widthView.constant  = 124 + (-delta)/2;
        self.header.layer.cornerRadius = self.widthView.constant/2;
    }
    if (height < 64) {
        height = 64;
    }
    _topHeight.constant = height;
}
#pragma mark - event respont
/**
 *  加入学习小组
 */
- (void)joinStudentGroup{
    UIHomeworkApplyGroupsForsFirst *vc = [[UIHomeworkApplyGroupsForsFirst alloc] initWithNibName:@"UIHomeworkApplyGroupsForsFirst" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 *  创建学习小组
 */
- (void)creatStudentGroup{
    UIMineCreatStudentViewController *vc = [[UIMineCreatStudentViewController alloc]initWithNibName:@"UIMineCreatStudentViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  请求数据(第一版。后续版本没有再维护)
 */
- (void)loadData
{
    //测试
    [AFNetClient GlobalGet:kUrlGetAllUserClass parameters:@{@"id":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict)
     {
         NSLog(@"%@ = %@",kUrlGetUserClass,dataDict);
         NSArray *list = [dataDict objectForKey:@"list"];
         NSMutableArray *l = [NSMutableArray array];
         for (NSDictionary *dic in list) {
             MClass *m = [MClass objectWithDictionary:dic];
             if ([m.class_type isEqualToString:@"0"] && l.count==0)
             {
                 [l addObject:m];
                 [GlobalVar instance].myClass = m;
             }
         }
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         [CommonMethod showAlert:@"服务异常"];
     }];
    //V2
    if ([rolesUser isEqualToString:roleStudent]) {
        [self getAddedGroups];
    }
    else{
        [StudentGroupViewModel GetStudentGroupListWithCallBack:^(NSArray *groups) {
            if (groups != nil) {
                classArr2 = [NSMutableArray arrayWithArray:groups];
                [_tableView reloadData];
            }
        }];
    }
    
}
- (void)getAddedGroups{
    [UIHomeworkViewModel getstudentGroupListWithParams:@{@"studentid":[GlobalVar instance].user.userid} withCallBack:^(NSArray *Students) {
        if (Students != nil) {
            classArr2 = [NSMutableArray arrayWithArray:Students];
            [_tableView reloadData];
        }
        else{
            [classArr2 removeAllObjects];
            [_tableView reloadData];
        }
    }];
}


/**
 *  进入个人信息
 */
- (void)doDetail{
    UIMinePersonalIndexViewController *ctrl = [[UIMinePersonalIndexViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}
/**
 *  进入系统设置
 */
- (void)gotoSetting{
    UIMineSystemSettingViewController *ctrl = [[UIMineSystemSettingViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
