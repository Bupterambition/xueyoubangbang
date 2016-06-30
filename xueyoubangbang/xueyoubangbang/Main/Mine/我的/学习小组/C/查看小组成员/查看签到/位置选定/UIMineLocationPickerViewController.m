//
//  LocationPickerViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/1.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineLocationPickerViewController.h"
#import "StudentGroupViewModel.h"
#import <CoreLocation/CoreLocation.h>
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件

#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件

#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件

#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
@interface UIMineLocationPickerViewController ()<BMKGeoCodeSearchDelegate>

@end

@implementation UIMineLocationPickerViewController{
    BMKGeoCodeSearch *searcher;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
    NSIndexPath *lastIndex;
    UITableViewCell *lastIndexCell;
    NSArray *datasource;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    datasource = [NSArray array];
    [self initTableView];
    [self initBaiduMap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)initTableView{
    self.tableView.rowHeight = 55;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(singUp)];
    lastIndex = [NSIndexPath indexPathForRow:0 inSection:0];
}
- (void)initBaiduMap{
    //周边检索
    //地理位置反相编码检索//发起反向地理编码检索
    searcher =[[BMKGeoCodeSearch alloc]init];
    searcher.delegate = self;
    reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
    reverseGeoCodeSearchOption.reverseGeoPoint = [GlobalVar instance].current2DLocation;
    BOOL flag = [searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
}
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        if (result != nil && result.poiList.count != 0) {
            [GlobalVar instance].currentAddress = ((BMKPoiInfo*)result.poiList[0]).name;
            datasource = result.poiList;
            [self.tableView reloadData];
        }
    }
    else {
        NSLog(@"抱歉，未找到结果");
    }
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LOCATION"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"LOCATION"] ;
    }
    if (indexPath.row == lastIndex.row) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        lastIndexCell = cell;
    }
    BMKPoiInfo *data = datasource[indexPath.row];
    cell.textLabel.text = data.name;
    cell.detailTextLabel.text = data.address;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *oneCell = [tableView cellForRowAtIndexPath: indexPath];
    if (oneCell.accessoryType == UITableViewCellAccessoryNone) {
        oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else
        oneCell.accessoryType = UITableViewCellAccessoryNone;
    if (lastIndex.row != indexPath.row) {
        lastIndexCell.accessoryType = UITableViewCellAccessoryNone;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    lastIndex = indexPath;
    lastIndexCell = oneCell;
    [GlobalVar instance].currentAddress = ((BMKPoiInfo *)datasource[indexPath.row]).name;
    [GlobalVar instance].current2DLocation = ((BMKPoiInfo *)datasource[indexPath.row]).pt;
}
#pragma mark - event Respond
- (void)singUp{
    [StudentGroupViewModel setSignInAddress:@{@"groupid":[NSNumber numberWithInteger:_groupinfo.groupid],@"teacherid":[GlobalVar instance].user.userid,@"latitude":@([GlobalVar instance].current2DLocation.latitude),@"atitude":@([GlobalVar instance].current2DLocation.longitude),@"address":[GlobalVar instance].currentAddress}withCallBack:^(BOOL success) {
        if (success) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    
}

@end
