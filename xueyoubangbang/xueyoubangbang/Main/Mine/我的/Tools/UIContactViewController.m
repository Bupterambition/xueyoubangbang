//
//  UIContactViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIContactViewController.h"
#import "MContact.h"
#import "UIContactTableViewCell.h"
@interface UIContactViewController ()
{
    UITableView *table;
    NSMutableArray *dataArr ;
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    
    NSMutableArray *searchResult;
    NSMutableArray *userList;
    
    BOOL hasLoadData ;
    NSInteger currentPageIndex;
}
@end

@implementation UIContactViewController

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
    _choosedItems = [NSMutableArray array];
    dataArr = [NSMutableArray array];
    searchResult = [NSMutableArray array];
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
    
    NSDictionary *para = [self getPara:0];
    NSLog(@"kUrlContactList para = %@",para);
    [AFNetClient GlobalGet:kUrlContactList parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        NSLog(@"kUrlContactList = %@",dataDict);
        [table.legendHeader endRefreshing];
        
        [dataArr removeAllObjects];
        if(isUrlSuccess(dataDict))
        {
            NSArray *list = [dataDict objectForKey:@"contact_list"];
            NSMutableArray *objList = [NSMutableArray array];
            for (int i = 0 ; i < list.count; i++) {
                MContact *m = [MContact objectWithDictionary:[list objectAtIndex:i]];
                [objList addObject:m];
            }
            dataArr = objList;
            userList = [NSMutableArray arrayWithArray:dataArr];
            searchResult = [NSMutableArray arrayWithArray:userList];
            if(list.count > 0){
                
                searchBar.text = @"";
                [self reloadData];
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
    [AFNetClient GlobalGet:kUrlContactList parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        NSLog(@"kUrlContactList = %@",dataDict);
        if(isUrlSuccess(dataDict))
        {
            NSArray *list = [dataDict objectForKey:@"contact_list"];
            
            for (int i = 0 ; i < list.count; i++) {
                MContact *m = [MContact objectWithDictionary:[list objectAtIndex:i]];
                [dataArr addObject:m];
            }
            if(list.count > 0){
                currentPageIndex ++;
                [table.legendFooter endRefreshing];
                [self reloadData];
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
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"pageIndex":[NSNumber numberWithInteger:pageIndex ],@"pageSize":[NSNumber numberWithInteger:10000] };
    
    return para;
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"联系人";
    
    table = CREATE_TABLE(UITableViewStylePlain);
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - kNavigateBarHight);
    table.editing = YES;
    table.allowsMultipleSelectionDuringEditing = YES;
    
    [self.view addSubview:table];
    [self createSearchBar];
    
    [self createLegend];
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
//    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    searchDisplayController.searchResultsTableView.editing = YES;
//    searchDisplayController.searchResultsTableView.allowsMultipleSelectionDuringEditing = YES;
//    // searchResultsDataSource 就是 UITableViewDataSource
//    searchDisplayController.searchResultsDataSource = self;
//    // searchResultsDelegate 就是 UITableViewDelegate
//    searchDisplayController.searchResultsDelegate = self;
}

- (void)search:(NSString *)searchText
{
    // 谓词搜索
    //    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"username Like [cd] '*%@*'",searchText];
    //    searchResult =  [[NSMutableArray alloc] initWithArray:[userList filteredArrayUsingPredicate:predicate]];
    if([CommonMethod isBlankString:searchText])
    {
        searchResult = [NSMutableArray arrayWithArray:userList];
        return;
    }
    [searchResult removeAllObjects];
    for (int i=0; i < userList.count; i++) {
        MContact *user = [userList objectAtIndex:i];
        if([user.username rangeOfString:searchText].location != NSNotFound)
        {
            [searchResult addObject:user];
        }
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self search:searchText];
//    [searchDisplayController.searchResultsTableView reloadData];
    
    [self reloadData];
}

- (void)reloadData
{
    _choosedItems = [NSMutableArray array];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    [table reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(table == tableView)
        return 1;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if(table == tableView)
//        return dataArr.count;
    return searchResult.count;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    if(table == tableView){
//        NSString *CellIdentifier = @"cellIdentifier";
//        UIContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (nil == cell) {
//            cell = [[UIContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            UIView *back = [[UIView alloc] init];
//            back.backgroundColor = [UIColor clearColor];
//            cell.selectedBackgroundView = back;
//        }
//        NSLog(@"dataArr count = %d indexPath.row = %d",dataArr.count,indexPath.row);
//        MContact *user = [dataArr objectAtIndex:indexPath.row];
//        cell.textLabel.text = user.username;
//        [cell.imageView sd_setImageWithURL:[NSURL URLWithString: UrlResString(user.header_photo])];
//        return cell;
//    }
//    else
//    {
        NSString *CellIdentifier = @"cellIdentifierSearch";
        UIContactTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UIContactTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            UIView *back = [[UIView alloc] init];
            back.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = back;
        }
        MContact *user = [searchResult objectAtIndex:indexPath.row] ;
        cell.textLabel.text = user.username;
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString: UrlResString(user.header_photo]) placeholderImage:[UIImage imageNamed:@"my_pic"]];
        return cell;
//    }
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MContact *user = [dataArr objectAtIndex:indexPath.row];
    [_choosedItems addObject:user];
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MContact *user = [dataArr objectAtIndex:indexPath.row];
    [_choosedItems removeObject:user];
    if(_choosedItems.count == 0)
    {
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    return [[dataArr objectAtIndex:section] objectAtIndex:0];
//}

//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    //用于设置sectionIndexTitle
//    //返回要为一个内容为NSString 的NSArray 里面存放section title;
//    //默认情况下 section Title根据顺序对应 section 【如果不写tableView: sectionForSectionIndexTitle: atIndex:的话】
//    
//    NSMutableArray *arr = [[NSMutableArray alloc] init];
//    for (int i = 0 ; i<dataArr.count; i++) {
//        [arr addObject:[[dataArr objectAtIndex:i] objectAtIndex:0]];
//    }
//    return <#expression#>
//}

//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    //传入 section title 和index 返回其应该对应的session序号。
//    //一般不需要写 默认section index 顺序与section对应。除非 你的section index数量或者序列与section不同才用修改
//    return index;
//}


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
