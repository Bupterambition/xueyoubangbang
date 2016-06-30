//
//  CheckViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/8/30.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "StudentGroupViewModel.h"
#import "UIMineCheckViewController.h"
#import "MStudent.h"
#import "UIMineSignCell.h"
#import "UIMineLocationPickerViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
@interface UIMineCheckViewController()<BMKLocationServiceDelegate>
{
    UITableView *table;
    NSMutableArray *sortHeaders;
    NSMutableArray *sortedArray;
    NSMutableArray *resultArray;
    BOOL hasLoadData;
    
}
@property (nonatomic, strong) UILabel *location;

@end

@implementation UIMineCheckViewController{
    UIView *top;
}

#pragma mark - life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self initTableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.location.text = [GlobalVar instance].currentAddress;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation:)  name:@"GETLOCATIONS" object:nil];
    if(!hasLoadData)
    {
        hasLoadData = YES;
        [table.legendHeader beginRefreshing];
    }
}
- (void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GETLOCATIONS" object:nil];
    [super viewDidDisappear:animated];
}
#pragma mark - init Method
- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"作业小组";
    
    top = [[UIView alloc] init];
    top.frame = CGRectMake(0, 0, SCREEN_WIDTH, 84);
    top.backgroundColor = [UIColor whiteColor];
    
    UILabel *className = [[UILabel alloc] init];
    className.frame = CGRectMake(100, 0, SCREEN_WIDTH-10, 44);
    className.text = _classinfo==nil?_groupinfo.groupname: _classinfo.class_name;
    [top addSubview:className];
    
    self.location = [[UILabel alloc] init];
    self.location.frame = CGRectMake(100, 40, SCREEN_WIDTH-150, 16);
    self.location.textColor = [UIColor grayColor];
    self.location.font = [UIFont systemFontOfSize:14];
    self.location.numberOfLines = 0;
    
    UIImageView *groupImage = [[UIImageView alloc] initWithImage:IMAGE([self.groupinfo getSubject])];
    groupImage.center = CGPointMake(30, 30);
    UIView *imageBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 60)];
    imageBack.backgroundColor = VIEW_BACKGROUND_COLOR;
    imageBack.layer.masksToBounds = YES;
    imageBack.layer.cornerRadius = 30;
    imageBack.center = CGPointMake(50, 42);
    [imageBack addSubview:groupImage];
    
    [top addSubview:imageBack];
    [top addSubview:self.location];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"签到位置" style:UIBarButtonItemStylePlain target:self action:@selector(singUp)];
}

- (void)initTableView{
    table = CREATE_TABLE(UITableViewStylePlain);
    table.frame = CGRectMake(0, 5, SCREEN_WIDTH, self.view.bounds.size.height - [top bottomY] - kNavigateBarHight);
    table.sectionIndexBackgroundColor = [UIColor clearColor];
    [table registerNib:[UINib nibWithNibName:@"UIMineSignCell" bundle:nil] forCellReuseIdentifier:@"UIMineSignCell"];
    [self.view addSubview:table];
    [table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(reload)];
    table.tableHeaderView = top;
}


#pragma mark - UITableViewDelegate and UITableviewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sortHeaders.count ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *array = [sortedArray objectAtIndex:section];
    return array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    return  [NSString stringWithFormat:@"   %@" ,[sortHeaders objectAtIndex:section]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UIMineSignCell";
    UIMineSignCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [sortedArray objectAtIndex:indexPath.section];
    Member *student = [array objectAtIndex:indexPath.row];
    if (!student.Signup) {
        cell.signupLabel.text = @"未签到";
        cell.signupLabel.center = CGPointMake(cell.signupLabel.center.x, 25);
        cell.timeLabel.hidden = YES;
        cell.signupLabel.textColor = [UIColor redColor];
        cell.placeHoldTime.hidden = YES;
    }
    else{
        cell.timeLabel.hidden = NO;
        cell.placeHoldTime.hidden = NO;
        cell.timeLabel.text = student.accuratesigntime;
        cell.signupLabel.center = CGPointMake(cell.signupLabel.center.x, 13.5);
        cell.signupLabel.text = @"已签到";
        cell.signupLabel.textColor = [UIColor greenColor];
    }
    cell.textLabel.text = student.username;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(student.header_photo)]  placeholderImage:DEFAULT_HEADER];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [table deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIMineSignCell *cell = (UIMineSignCell*)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.signupLabel.text isEqualToString:@"未签到"]) {
        return @"签到有效";
    }
    else {
        return @"签到无效";
    }
    
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    NSArray *array = [sortedArray objectAtIndex:indexPath.section];
    Member *student = [array objectAtIndex:indexPath.row];
    UIMineSignCell *cell = (UIMineSignCell*)[tableView cellForRowAtIndexPath:indexPath];
    if ([cell.signupLabel.text isEqualToString:@"未签到"]) {
        [StudentGroupViewModel SignupInGroup:@{@"groupid":[NSNumber numberWithInteger:_groupinfo.groupid],@"date":[dateFormatter stringFromDate:[NSDate date]],@"userid":student.userid,@"username":student.username,@"type":@0} withCallBack:^(BOOL success) {
            if (success) {
                cell.signupLabel.text = @"已签到";
                ((Member*)[array objectAtIndex:indexPath.row]).Signup = YES;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    else {
        [StudentGroupViewModel SignupInGroup:@{@"groupid":[NSNumber numberWithInteger:_groupinfo.groupid],@"date":[dateFormatter stringFromDate:[NSDate date]],@"userid":student.userid,@"username":student.username,@"type":@1} withCallBack:^(BOOL success) {
            if (success) {
                cell.signupLabel.text = @"未签到";
                ((Member*)[array objectAtIndex:indexPath.row]).Signup = NO;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    
}

#pragma mark - public Method
- (void)updateLocation:(NSNotification*)sender{
    self.location.text = [NSString stringWithFormat:@"当前位置：%@",sender.object[1]];
}

#pragma mark - event respont
- (void)checkSignUp{
    
}
- (void)reload
{
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init] ;
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    [StudentGroupViewModel GetSignListwithparameters:@{@"groupid":[NSNumber numberWithInteger:_groupinfo.groupid],@"date":[dateFormatter stringFromDate:[NSDate date]]} withCallBack:^(NSArray *memberlist) {
        [table.legendHeader endRefreshing];
        //            [_unsignupMembers removeObjectsInArray:memberlist];
        [memberlist enumerateObjectsUsingBlock:^(Member *obj, NSUInteger idx, BOOL *stop) {
            [_unsignupMembers enumerateObjectsUsingBlock:^(Member *uobj, NSUInteger idx, BOOL *stop) {
                if ([uobj.userid isEqualToString:obj.userid]) {
                    ((Member*)_unsignupMembers[idx]).Signup = YES;
                    ((Member*)_unsignupMembers[idx]).accuratesigntime = obj.accuratesigntime;
                }
            }];
        }];
        //            [_unsignupMembers addObjectsFromArray:memberlist];
        sortedArray = [NSMutableArray arrayWithArray:[self getChineseArrayForSign:[NSMutableArray arrayWithArray:_unsignupMembers]]];
        [table reloadData];
    }];
}
- (void)singUp{
    UIMineLocationPickerViewController *vc = [[UIMineLocationPickerViewController alloc]init];
    vc.groupinfo = _groupinfo;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private Method
-(NSMutableArray*)getChineseArrayForSign:(NSMutableArray*)arrToSort
{
    //创建一个临时的变动数组
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i =0; i < arrToSort.count; i++)
    {
        Member *chineseString = [arrToSort objectAtIndex:i];
        if(chineseString.username==nil)
        {
            chineseString.username=@"";
        }
        if(![chineseString.username isEqualToString:@""])
        {
            //join(链接) the pinYin (letter字母) 链接到首字母
            NSString *pinYinResult = [NSString string];
            
            //按照数据模型中row的个数循环
            
            for(int j =0;j < chineseString.username.length; j++)
            {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.username characterAtIndex:j])]uppercaseString];
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
            
        } else {
            chineseString.pinYin =chineseString.userid;
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort(排序) the ChineseStringArr by pinYin(首字母)
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin"ascending:YES]];
    
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    
    BOOL checkValueAtIndex=NO; //flag to check
    
    NSMutableArray *TempArrForGrouping =nil;
    
    NSMutableArray *heads = [NSMutableArray array];
    
    for(int index =0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        //sr containing here the first character of each string  (这里包含的每个字符串的第一个字符)
        NSString *sr= [strchar substringToIndex:1];
        //here I'm checking whether the character already in the selection header keys or not  (检查字符是否已经选择头键)
        
        if(![heads containsObject:[sr uppercaseString]])
        {
            [heads addObject:[sr uppercaseString]];
            
            TempArrForGrouping = [[NSMutableArray alloc]initWithObjects:nil];
            
            checkValueAtIndex = NO;
        }
        
        if([heads containsObject:[sr uppercaseString]])
        {
            [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
        
    }
    
    sortHeaders = [NSMutableArray arrayWithArray:heads];
    return arrayForArrays;
}


@end
