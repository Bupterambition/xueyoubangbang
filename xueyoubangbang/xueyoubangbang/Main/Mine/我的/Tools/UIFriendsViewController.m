//
//  UIFriendsViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIFriendsViewController.h"
#import "MContact.h"
#import "UIContactTableViewCell.h"
#import "UIFriendNewViewController.h"
#import "UIFriendAddViewController.h"
#import "UIMineUserDetailViewController.h"
@interface UIFriendsViewController ()
{
    UITableView *table;
    NSMutableArray *dataArr ;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    
    NSMutableArray *searchResult;
    NSMutableArray *userList;
    
    BOOL hasLoadData ;
    NSInteger currentPageIndex;
    
    NSDictionary *_groupWithSortLetters;
    NSArray *_sortLetters;
    NSArray *teachers;
}
@end

@implementation UIFriendsViewController

- (id)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
        [self initial];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通讯录";
    [self createViews];
    
    if ([table respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [table setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([table respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [table setLayoutMargins:UIEdgeInsetsZero];
        
    }
}

- (void)initial
{
    currentPageIndex = 0;
    hasLoadData = NO;
    
    dataArr = [NSMutableArray array];
    searchResult = [NSMutableArray array];
    teachers = [NSArray array];
    
    _sortLetters = @[];
    _groupWithSortLetters = @{};
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!hasLoadData){
        hasLoadData = YES;
        // 马上进入刷新状态
        [table.legendHeader beginRefreshing];
    }
}

- (void)reload
{
    NSLog(@"kUrlQuestionList reload");
    [self hideLegendFooter];
    currentPageIndex = 1;
    NSDictionary *para = [self getPara:currentPageIndex];
    NSLog(@"kUrlContactList para = %@",para);
    [AFNetClient GlobalPost:kUrlContactList parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        NSLog(@"kUrlContactList = %@",dataDict);
        [table.legendHeader endRefreshing];
        
        [dataArr removeAllObjects];
        if(isUrlSuccess(dataDict))
        {
            NSMutableArray *objList = [NSMutableArray array];
            if (dataDict[@"data"][@"friendlist"]!= nil) {
                [objList addObjectsFromArray:dataDict[@"data"][@"friendlist"]];
            }
            if (dataDict[@"data"][@"teacherlist"] != nil) {
//                [objList addObjectsFromArray:dataDict[@"data"][@"teacherlist"]];
                teachers = [MContact objectArrayWithKeyValuesArray:dataDict[@"data"][@"teacherlist"]];
            }
            if (dataDict[@"data"][@"classmatelist"] != nil) {
                [objList addObjectsFromArray:dataDict[@"data"][@"classmatelist"]];
            }
            dataArr = [MContact objectArrayWithKeyValuesArray:objList];
            userList = dataArr;
            
            _groupWithSortLetters = [self group:dataArr];
            
            if(dataArr.count > 0){
                [table reloadData];
            }
            else{
                [table.legendFooter noticeNoMoreData];
            }
        }
        else{
            [table.legendFooter noticeNoMoreData];
        }
        [self showLegendFooter];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [table.legendHeader endRefreshing];
        [self showLegendFooter];
    }];
}

- (void)loadMore
{
    NSDictionary *para = [self getPara:currentPageIndex + 1];
    NSLog(@"kUrlContactList para = %@",para);
    [AFNetClient GlobalPost:kUrlContactList parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        NSLog(@"kUrlContactList = %@",dataDict);
        if(isUrlSuccess(dataDict))
        {
            NSMutableArray *objList = [NSMutableArray array];
            if ([dataDict objectForKey:@"friendlist"] != nil) {
                [objList addObjectsFromArray:[dataDict objectForKey:@"friendlist"]];
            }
            if ([dataDict objectForKey:@"teacherlist"] != nil) {
//                [objList addObjectsFromArray:[dataDict objectForKey:@"teacherlist"]];
                teachers = [MContact objectArrayWithKeyValuesArray:[dataDict objectForKey:@"teacherlist"]];
            }
            if ([dataDict objectForKey:@"classmatelist"] != nil) {
                [objList addObjectsFromArray:[dataDict objectForKey:@"classmatelist"]];
            }
            
            [dataArr addObjectsFromArray:[MContact objectArrayWithKeyValuesArray:objList]];
            if(objList.count > 0){
                currentPageIndex ++;
                [table.legendFooter endRefreshing];
                [table reloadData];
            }
            else
            {
                [table.legendFooter noticeNoMoreData];
            }
        }
        else
        {
            [table.legendFooter noticeNoMoreData];
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [table.legendFooter endRefreshing];
    }];
    
}

- (NSDictionary *)group:(NSArray *)data
{
    NSMutableArray *sortLettes = [NSMutableArray array];
    NSMutableDictionary *groupWithSortLetters = [NSMutableDictionary dictionary];
    for (MContact *m in data) {
        if(![sortLettes containsObject:m.sortLetters])
        {
            [sortLettes addObject:m.sortLetters];
           
            [groupWithSortLetters setObject: [NSMutableArray arrayWithArray:@[]] forKey:m.sortLetters];
        }
        
        [[groupWithSortLetters objectForKey:m.sortLetters] addObject:m];
    }
    _sortLetters = sortLettes;
    return groupWithSortLetters;
}

-(void)showLegendFooter
{
    table.legendFooter.hidden = NO;
}

-(void)hideLegendFooter
{
    table.legendFooter.hidden = YES;
}

- (NSDictionary *)getPara:(NSInteger)pageIndex
{
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid};
    
    return para;
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    
    table = CREATE_TABLE(UITableViewStylePlain);
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - kNavigateBarHight);
    [self.view addSubview:table];
    [self createSearchBar];
    
    [self createLegend];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doAdd)];
}

- (void)doAdd
{
    UIFriendAddViewController *ctrl = [[UIFriendAddViewController alloc] init];
    UICustomNavigationViewController *nav = [[UICustomNavigationViewController alloc] initWithRootViewController:ctrl];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)createLegend{
    [table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(reload)];
}


- (void)createSearchBar
{
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) ];
    table.tableHeaderView = searchBar;
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    
    table.tableHeaderView = searchBar;
    
    // 用 searchbar 初始化 SearchDisplayController
    // 并把 searchDisplayController 和当前 controller 关联起来
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
}

- (void)search:(NSString *)searchText
{
    
    [searchResult removeAllObjects];
    for (int i=0; i < userList.count; i++) {
        MContact *user = [userList objectAtIndex:i];
        if([user.username rangeOfString:searchText].location != NSNotFound)
        {
            [searchResult addObject:user];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBars{
    // 谓词搜索
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.userid = %@",searchBars.text];
    NSArray *tempSearchArray = [userList filteredArrayUsingPredicate:predicate];
    if (tempSearchArray.count == 0) {
        return;
    }
    searchResult =  [[NSMutableArray alloc] initWithArray:tempSearchArray];
    [searchDisplayController.searchResultsTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self search:searchText];
    [searchDisplayController.searchResultsTableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(table == tableView)
        return 2 + _groupWithSortLetters.count;
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section > 1)
    {
        if(_sortLetters.count == 0)
            return nil;
        return  [NSString stringWithFormat:@"    %@", [_sortLetters objectAtIndex:section - 2]];
    }
    else if(section == 1){
        if (teachers.count) {
            return @"    我的老师";
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section > 0)
    {
        return 20;
    }
    return 0;
}

- (NSArray *)contactInSection:(NSInteger)section
{
    if(_sortLetters.count == 0)
    {
        return @[];
    }
    return  (NSArray *)[_groupWithSortLetters objectForKey:[_sortLetters objectAtIndex:section -1]];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(table == tableView)
    {
        if(section == 0)
        {
            return 1;
        }
        else if (section == 1){
            return teachers.count;
        }
        return  [self contactInSection:section-1].count;
    }
    return searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(table == tableView){
        
        if(indexPath.section == 0)
        {
            NSString *CellIdentifier = @"cellIdentifier0";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if(cell == nil)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.imageView.image = [UIImage imageNamed:@"my_addressbook_portrait"];
                cell.textLabel.text = @"新的朋友";
            }
            return cell;
        }
        else if (indexPath.section == 1){
            NSString *CellIdentifier = @"cellIdentifier";
            UIContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (nil == cell) {
                cell = [[UIContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.imageView.contentMode = UIViewContentModeScaleToFill;
            }
            NSLog(@"dataArr count = %lud indexPath.row = %ld(unsigned long)",dataArr.count,indexPath.row);
            MContact *user = teachers[indexPath.row];
            cell.textLabel.text = user.username;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString: UrlResString(user.header_photo]) placeholderImage:DEFAULT_HEADER];
             return cell;
        }
        else
        {
            NSString *CellIdentifier = @"cellIdentifier";
            UIContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (nil == cell) {
                cell = [[UIContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                cell.imageView.contentMode = UIViewContentModeScaleToFill;
            }
            NSLog(@"dataArr count = %lud indexPath.row = %ld(unsigned long)",dataArr.count,indexPath.row);
            MContact *user = [[self contactInSection:indexPath.section-1] objectAtIndex:indexPath.row];
            cell.textLabel.text = user.username;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString: UrlResString(user.header_photo]) placeholderImage:DEFAULT_HEADER];
             return cell;
         }
    }
    else
    {
        NSString *CellIdentifier = @"cellIdentifierSearch";
        UIContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UIContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        MContact *user = [searchResult objectAtIndex:indexPath.row] ;
        cell.textLabel.text = user.username;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString: UrlResString(user.header_photo]) placeholderImage:DEFAULT_HEADER];
        return cell;
    }
         
}
             
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return _sortLetters;
//}
 
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(table == tableView){
        if(indexPath.section == 0)
        {
            [self.navigationController pushViewController:[[UIFriendNewViewController alloc] init] animated:YES];
        }
        if(indexPath.section == 1){
            MContact *user = teachers[indexPath.row];
            UIMineUserDetailViewController *vc = [[UIMineUserDetailViewController alloc] init];
            vc.userid = user.userid;
            [self.navigationController pushViewController:vc animated:YES];
        }
        if(indexPath.section > 1)
        {
            MContact *user = [[self contactInSection:indexPath.section-1] objectAtIndex:indexPath.row];
            UIMineUserDetailViewController *vc = [[UIMineUserDetailViewController alloc] init];
            vc.userid = user.userid;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else{
        MContact *user = [searchResult objectAtIndex:indexPath.row];
        UIMineUserDetailViewController *vc = [[UIMineUserDetailViewController alloc] init];
        vc.userid = user.userid;
        [self.navigationController pushViewController:vc animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
 



@end
