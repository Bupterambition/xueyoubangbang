//
//  UIMineDelegateStudentViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/5.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineDeleteStudentViewController.h"
#import "UIMineDelegateCell.h"
#import "StudentGroupViewModel.h"
@interface UIMineDeleteStudentViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation UIMineDeleteStudentViewController{
    UITableView *table;
    NSMutableArray *selectedIndex;
    NSMutableArray *sortHeaders;
    NSMutableArray *sortedArray;
    NSMutableArray *resultArray;
    NSMutableArray *allMemberList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initBaseView];
    [self loadData];
    [self initIvar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init method
- (void)initIvar{
    selectedIndex = [NSMutableArray array];
}
- (void)initBaseView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    table = CREATE_TABLE(UITableViewStylePlain);
    [table registerClass:NSClassFromString(@"UIMineDelegateCell") forCellReuseIdentifier:@"UIMineDelegateCell"];
    [table setEditing:YES];
    [self.view addSubview:table];
    UIButton *button = CREATE_BUTTON(0, 0, 40, 30, @"移除", @"确定", @selector(didDelete))
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)loadData{
    [StudentGroupViewModel GetGroupMemberListwithparameters:@{@"groupid":[NSNumber numberWithInteger:_groupinfo.groupid],@"accept":@1} withCallBack:^(NSArray *memberlist) {
        [allMemberList removeAllObjects];
        [sortedArray removeAllObjects];
        allMemberList = [NSMutableArray arrayWithArray:memberlist];
        sortedArray = [self getChineseArrayForSign:[NSMutableArray arrayWithArray:memberlist]];
        [table reloadData];
    }];
}

#pragma mark - UITableViewDelegate and UITableviewDatasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return sortHeaders.count;
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
    return  [NSString stringWithFormat:@"   %@" ,[sortHeaders objectAtIndex:section-1]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UIMineDelegateCell";
    UIMineDelegateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSArray *array = [sortedArray objectAtIndex:indexPath.section];
    Member *student = [array objectAtIndex:indexPath.row];
    cell.textLabel.text = student.username;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(student.header_photo)]  placeholderImage:DEFAULT_HEADER];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [selectedIndex removeObject:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [selectedIndex addObject:indexPath];
}


#pragma mark - UITableViewDelegate
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
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
#pragma mark - event respond
- (void)didDelete{
    NSMutableArray *delMembers = [NSMutableArray array];
    [selectedIndex enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL *stop) {
        Member *student = sortedArray[obj.section][obj.row];
        [delMembers addObject:student.userid];
    }];
    weak(weakself);
    [StudentGroupViewModel operateGroupMember:@{@"studentid":[delMembers componentsJoinedByString:@","],@"accept":@1,@"groupid":NSIntToNumber(_groupinfo.groupid),@"operate":@0} withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"已移除学生"];
            [weakself loadData];
            [selectedIndex removeAllObjects];
            
        }
        else{
            [MBProgressHUD showError:@"移除失败"];
        }
    }];
    
    
}

@end
