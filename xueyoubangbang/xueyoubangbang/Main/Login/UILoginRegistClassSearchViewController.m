//
//  UILoginRegistClassSearchViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UILoginRegistClassSearchViewController.h"

@interface UILoginRegistClassSearchViewController ()
{
    UISearchDisplayController *searchDisplayController;
    UISearchBar *searchBar;
    UITableView *table;
    NSArray *allItems;
    NSArray *searchResults;
}
@end

@implementation UILoginRegistClassSearchViewController

- (id)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createData];
    [self createViews];
}

- (void)createData
{
    
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"搜索";
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
    
    searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"请输入姓名";
    [searchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [searchBar sizeToFit];
    
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    
    [searchDisplayController setDelegate:self];
    [searchDisplayController setSearchResultsDataSource:self];
    [searchDisplayController setSearchResultsDelegate:self];
    table = CREATE_TABLE(UITableViewStylePlain);
    table.tableHeaderView = searchBar;
    table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height);
    [self.view addSubview:table];
}

#pragma mark

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",                                     searchText];
    
    searchResults = [[allItems valueForKey:@"RealName"] filteredArrayUsingPredicate:resultPredicate];
    NSLog(@"%@",searchResults);
    
}




#pragma mark - UISearchDisplayController delegate methods

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString  scope:[[self.searchDisplayController.searchBar scopeButtonTitles]  objectAtIndex:[self.searchDisplayController.searchBar                                                      selectedScopeButtonIndex]]];
    
    return YES;
    
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller  shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
    
}

#pragma mark UITableViewDataSource


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return searchResults.count;
    }
    else
    {
        return 10;
    }
}
//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
//section数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == searchDisplayController.searchResultsTableView)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

//section 的名字
//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (tableView == searchDisplayController.searchResultsTableView)
//    {
//        return nil;
//    }
//    else
//    {
//        return [ziMuArr objectAtIndex:section];
//    }
//    return nil;
//}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{    if (tableView == searchDisplayController.searchResultsTableView)
//    {
//        return nil;
//    }
////    else
////    {
////        return ziMuArr;
////    }
//    return nil;
//}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == searchDisplayController.searchResultsTableView){
        NSString *CellIdentifier = @"cellIdentifier0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = [searchResults objectAtIndex:indexPath.row];
        return cell;
    }
    else{
        NSString *CellIdentifier = @"cellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = @"aha";
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == searchDisplayController.searchResultsTableView){
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            //把选定内容带回上个界面;
        }];
    }
    else{
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self dismissViewControllerAnimated:YES completion:^{
            //把选定内容带回上个界面;
        }];
    }
}

- (void)doCancel
{
    [self dismissViewControllerAnimated:YES completion:^{
        ;
    }];
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
