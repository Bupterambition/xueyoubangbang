//
//  UIMineClassIndexViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineCheckViewController.h"
#import "StudentGroupViewModel.h"
#import "UIMineClassIndexViewController.h"
#import "MStudent.h"
#import "UIMineCell.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import "UIMineStudentGroupSetting.h"
#import "UIMineKnowledageViewController.h"
#import "NSDate+Format.h"
#import "UIMineUserDetailViewController.h"
#import "MBProgressHUD+MJ.h"
@interface UIMineClassIndexViewController ()<BMKLocationServiceDelegate,UIActionSheetDelegate>
{
    UITableView *table;
    NSMutableArray *sortHeaders;
    NSMutableArray *sortedArray;
    NSMutableArray *resultArray;
    NSMutableArray *allMemberList;
    BOOL hasLoadData;
    BOOL hasGotTheLocation;
    AFNetClient *messageManager;
    
}
@property (nonatomic, strong) UILabel *location;
@end

@implementation UIMineClassIndexViewController{
    UIView *top;
}
#pragma mark - life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self initTableView];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if ([rolesUser isEqualToString:roleStudent]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateLocation:)  name:@"GETLOCATIONS" object:nil];
    }
    if(!hasLoadData)
    {
        hasLoadData = YES;
        [table.legendHeader beginRefreshing];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    if ([rolesUser isEqualToString:roleStudent]) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"GETLOCATIONS" object:nil];
    }
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
    [self.view addSubview:top];
    
    UILabel *className = [[UILabel alloc] init];
    className.frame = CGRectMake(100, 0, SCREEN_WIDTH-150, 44);
    className.text = _classinfo==nil?_groupinfo.groupname: _classinfo.class_name;
    [top addSubview:className];
    
    self.location = [[UILabel alloc] init];
    self.location.frame = CGRectMake(100, 30, SCREEN_WIDTH-150, 50);
    self.location.textColor = [UIColor grayColor];
    self.location.font = [UIFont systemFontOfSize:14];
    self.location.numberOfLines = 0;
    self.location.text = [NSString stringWithFormat:@"ID:%ld",self.groupinfo.groupid];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 80, SCREEN_WIDTH, 4)];
    line.backgroundColor = VIEW_BACKGROUND_COLOR;
    
    UIImageView *groupImage = [[UIImageView alloc] initWithImage:IMAGE([self.groupinfo getSubject])];
    groupImage.center = CGPointMake(25, 25);
    UIView *imageBack = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    imageBack.backgroundColor = VIEW_BACKGROUND_COLOR;
    imageBack.layer.masksToBounds = YES;
    imageBack.layer.cornerRadius = 25;
    imageBack.center = CGPointMake(50, 42);
    [imageBack addSubview:groupImage];
    
    [top addSubview:imageBack];
    [top addSubview:line];
    [top addSubview:self.location];
    
    if (_classinfo != nil) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"退出班级" style:UIBarButtonItemStylePlain target:self action:@selector(doExit)];
    }
    else{
        if (ifRoleTeacher) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"分享小组" style:UIBarButtonItemStylePlain target:self action:@selector(doShare)];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doSettingGroup)];
            [top addGestureRecognizer:tap];
        }
        else {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(didOperateGroup)];
        }
        
    }
    
}

- (void)initTableView{
    table = CREATE_TABLE(UITableViewStylePlain);
    table.frame = CGRectMake(0,  5, SCREEN_WIDTH, SCREEN_HEIGHT - kNavigateBarHight);
    table.sectionIndexBackgroundColor = [UIColor clearColor];
    [table registerClass:NSClassFromString(@"UIMineCell") forCellReuseIdentifier:@"MineCell"];
    table.rowHeight = 50;
    [self.view addSubview:table];
    [table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(reload)];
}

#pragma mark - UITableViewDelegate and UITableviewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sortHeaders.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    NSArray *array = [sortedArray objectAtIndex:section-1];
    return array.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    return  [NSString stringWithFormat:@"   %@" ,[sortHeaders objectAtIndex:section-1]];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 84;
    }
    else{
        return 25;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return top;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MineCell";
    UIMineCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if ([rolesUser isEqualToString:roleStudent]) {
            cell.textLabel.text = @"签到";
        }
        else{
            cell.textLabel.text = @"查看签到";
        }
        cell.imageView.image = IMAGE(@"position_icon");
    }
    else{
        if (_groupinfo == nil) {
            NSArray *array = [sortedArray objectAtIndex:indexPath.section-1];
            MStudent *student = [array objectAtIndex:indexPath.row];
            cell.textLabel.text = student.username;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(student.header_photo)]  placeholderImage:DEFAULT_HEADER];
        }
        else{
            NSArray *array = [sortedArray objectAtIndex:indexPath.section-1];
            Member *student = [array objectAtIndex:indexPath.row];
            cell.textLabel.text = student.username;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(student.header_photo)]  placeholderImage:DEFAULT_HEADER];
        }
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [table deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (ifRoleStudent) {
            [self signUP];
        }
        else{
            [self checkSignUp];
        }
    }
    else {
        if (ifRoleStudent) {
            UIMineUserDetailViewController *vc = [[UIMineUserDetailViewController alloc] init];
            NSArray *array = [sortedArray objectAtIndex:indexPath.section-1];
            MStudent *student = [array objectAtIndex:indexPath.row];
            vc.userid = student.userid;
            [self.navigationController pushViewController:vc animated:YES];
        }
        else{
            UIMineKnowledageViewController *vc = [[UIMineKnowledageViewController alloc]initWithNibName:@"UIMineKnowledageViewController" bundle:nil];
            vc.groupid =NSIntTOString(_groupinfo.groupid) ;
            NSArray *array = [sortedArray objectAtIndex:indexPath.section-1];
            Member *student = [array objectAtIndex:indexPath.row];
            vc.studentid = student.userid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
#pragma mark - UIActionSheetDelegate
#pragma mark - UIActionSheetDelegate and its private methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0) {
        [self doShare];
    }
    else if (buttonIndex==1) {
        [self quiteGroup];
    }
}
#pragma mark - event respont
- (void)quiteGroup{
    [StudentGroupViewModel quiteGroup:@{@"groupid":[NSNumber numberWithInteger:_groupinfo.groupid],@"studentid":UserID} withCallBack:^(BOOL success) {
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}
/**
 *  分享
 */
- (void)doShare
{
    NSString *textToShare = [NSString stringWithFormat:@"安装注册学有帮帮，你的学习好帮手！下载学有帮帮，妈妈再也不担心我的作业~"];
    //    NSURL *urlToShare = [NSURL URLWithString:@"http://ew.changyan.com"];
    NSString *title = [NSString stringWithFormat:@"安装注册学有帮帮，你的学习好帮手！"];
    NSString *url = [NSString stringWithFormat:@"http://www.sharingpop.cn/joinGroup/index.html?groupid=%ld",self.groupinfo.groupid];
    UIImage *thumb = [UIImage imageNamed:@"icon-120"];
    NSString *text = @"下载学有帮帮，妈妈再也不担心我的作业~";
    NSArray *activityItems = @[textToShare,thumb,[NSURL URLWithString:url]];
    WeixinActivity *weixinSession =[[WeixinActivity alloc] init];
    weixinSession.title = title;
    weixinSession.thumb = thumb;
    weixinSession.text = text;
    weixinSession.url = url;
    weixinSession.scene = 0;
    
    WeixinActivity *weixinTimeLine =[[WeixinActivity alloc] init];
    weixinTimeLine.title = title;
    weixinTimeLine.thumb = thumb;
    weixinTimeLine.text = text;
    weixinTimeLine.url = url;
    weixinTimeLine.scene = 1;
    
    TencentActivity *tencent = [[TencentActivity alloc]init];
    tencent.title = title;
    tencent.thumb = thumb;
    tencent.text = text;
    tencent.url = url;
    
    NSArray *activities = @[tencent,weixinSession,weixinTimeLine];
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                     applicationActivities:activities];
    //不出现在活动项目
    if(IOS_VERSION_7_OR_ABOVE){
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeAirDrop,UIActivityTypeAddToReadingList];
    }
    else{
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeMessage,UIActivityTypeMail];
    }
    [self presentViewController:activityVC animated:TRUE completion:nil];
    UIActivityViewControllerCompletionHandler handler = ^(NSString *activityType, BOOL completed){
        if (nil != activityType) {
            if (completed) {
                
            }
            if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
                NSLog(@"新浪微博分享！");
            }else if ([activityType isEqualToString:@"com.apple.UIKit.activity.TencentWeibo"]) {
                NSLog(@"腾讯微博分享");
            }else {
                //do nothing
            }
        }
    };
    activityVC.completionHandler = handler;
    
}
/**
 *  点击右上角item
 */
- (void)didOperateGroup{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"分享小组" otherButtonTitles:@"退出小组", nil];
    [actionSheet showInView:self.view];
}
- (void)signUP{
    if (hasGotTheLocation) {
        [StudentGroupViewModel getSignInAddress:@{@"groupid":self.groupinfo.getGroupID} withCallBack:^(BOOL success, SignUpAdress *location) {
            if (success) {
                BOOL suceessSignUp = BMKCircleContainsCoordinate([GlobalVar instance].current2DLocation,location.signupLocation,500);
                if (suceessSignUp) {
                    [StudentGroupViewModel SignupInGroup:@{@"groupid":[NSNumber numberWithInteger:_groupinfo.groupid],@"date":[[NSDate date] format:@"YYYY-MM-dd HH:mm:ss"],@"userid":UserID,@"username":[GlobalVar instance].user.username,@"type":@0} withCallBack:^(BOOL success) {
                        if (success) {
                            [MBProgressHUD showSuccess:@"签到成功"];
                        }
                    }];
                }
                else{
                    [MBProgressHUD showError:@"⚠️您的位置不符合签到要求，快去上课吧"];
                }
            }
        }];
    }
    else{
        [CommonMethod showAlert:@"未获取到定位，请打开定位"];
    }
}
- (void)checkSignUp{
    UIMineCheckViewController *vc = [[UIMineCheckViewController alloc]init];
    vc.groupinfo = _groupinfo;
    vc.classinfo = _classinfo;
    vc.unsignupMembers = allMemberList;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)reload
{
    if (_classinfo != nil) {
        NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"classid":_classinfo.class_info_id};
        [AFNetClient GlobalGet:kUrlGetClassMates parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            
            [table.legendHeader endRefreshing];
            
            if(isUrlSuccess(dataDict))
            {
                NSArray *list = [dataDict objectForKey:@"studentlist"];
                NSMutableArray *l = [NSMutableArray array];
                for (int i = 0 ; i < list.count; i++) {
                    MStudent *m = [MStudent objectWithDictionary:[list objectAtIndex:i]];
                    [l addObject:m];
                }
                resultArray = l;
                sortedArray = [NSMutableArray arrayWithArray:[self getChinesArray:resultArray]];
                [table reloadData];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [table.legendHeader endRefreshing];
        }];
    }
    else{
        [StudentGroupViewModel GetGroupMemberListwithparameters:@{@"groupid":[NSNumber numberWithInteger:_groupinfo.groupid],@"accept":@1} withCallBack:^(NSArray *memberlist) {
            if (memberlist != nil) {
                [table.legendHeader endRefreshing];
                allMemberList = [NSMutableArray arrayWithArray:memberlist];
                sortedArray = [NSMutableArray arrayWithArray:[self getChineseArrayForSign:[NSMutableArray arrayWithArray:memberlist]]];
                [table reloadData];
            }
            else{
                [table.legendHeader endRefreshing];
            }
        }];
    }
    
}

- (void)doSettingGroup{
    UIMineStudentGroupSetting *vc = [[UIMineStudentGroupSetting alloc]init];
    vc.groupinfo = _groupinfo;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  退出班级
 */
- (void)doExit
{
    [BlockAlertView alertWithTitle:@"确定要退出班级？" message:@"退出后将无法收到班级内老师布置的作业和各类提醒哦" cancelButtonWithTitle:@"取消" cancelBlock:nil confirmButtonWithTitle:@"确定" confrimBlock:^{
        [MBProgressHUD showHUDAddedTo:mainWindow animated:YES ];
        [AFNetClient GlobalGet:kUrlQuitClass parameters:[CommonMethod getParaWithOther:@{@"id":_classinfo.class_info_id}] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            if(isUrlSuccess(dataDict))
            {
                [CommonMethod showAlert:@"退出成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [CommonMethod showAlert:urlErrorMessage(dataDict)];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            [CommonMethod showAlert:@"退出失败"];
        }];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - public Method

- (void)updateLocation:(NSNotification*)sender{
    hasGotTheLocation = YES;
}
#pragma mark - private Method

- (NSString *)province:(NSString *)proviceid city:(NSString *)cityid{
    return [NSString stringWithFormat:@"%@%@",proviceid,cityid];
}

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

-(NSMutableArray*)getChinesArray:(NSMutableArray*)arrToSort
{
    //创建一个临时的变动数组
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i =0; i < arrToSort.count; i++)
    {
        MStudent *chineseString = [arrToSort objectAtIndex:i];
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
            chineseString.pinYin =chineseString.userid;;
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
