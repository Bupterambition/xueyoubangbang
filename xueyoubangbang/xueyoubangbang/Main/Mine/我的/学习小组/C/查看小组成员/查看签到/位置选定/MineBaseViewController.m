//
//  MineBaseViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/8/31.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MineBaseViewController.h"
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
@interface MineBaseViewController ()<BMKGeoCodeSearchDelegate>

@end

@implementation MineBaseViewController{
    BMKLocationService* _locService;
    BMKUserLocation *currentLocation;
    AFNetClient *messageManager;
    BMKGeoCodeSearch *searcher;
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    messageManager = [AFNetClient sharedManager];
    [self initBaiduMap];
}

- (void)dealloc{
    searcher.delegate = nil;
    _locService.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initBaiduMap{
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:10.f];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    
    //地理位置反相编码检索//发起反向地理编码检索
    searcher =[[BMKGeoCodeSearch alloc]init];
    searcher.delegate = self;
    reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
}

//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f andPlacetitle:%@",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude,userLocation.subtitle);
    [GlobalVar instance].current2DLocation = userLocation.location.coordinate;
    reverseGeoCodeSearchOption.reverseGeoPoint = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    BOOL flag = [searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag)
    {
        NSLog(@"反geo检索发送成功");
    }
    else
    {
        NSLog(@"反geo检索发送失败");
    }
//    [messageManager GetCurrentLocationWithLatitude:userLocation.location.coordinate.latitude longitude:userLocation.location.coordinate.longitude withCompletionBlock:^(NSArray *CurrentLocation) {
//        BOOL signSuccess = BMKCircleContainsCoordinate(CurrentLocation)
//        BMKMapPoint point1 = BMKCircleContainsCoordinate(CLLocationCoordinate2DMake(39.915,116.404));
//        BMKMapPoint point2 = BMKMapPointForCoordinat(CLLocationCoordinate2DMake(38.915,115.404));
//        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
//        if (CurrentLocation && CurrentLocation.count) {
//            NSNotification *notification = [NSNotification notificationWithName:@"GETLOCATIONS" object:CurrentLocation[0]];
//            [[NSNotificationCenter defaultCenter] postNotification:notification];
//        }
//    }];
//    option.location = CLLocationCoordinate2DMake(userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
//    option.keyword = @" ";
//    BOOL flag = [searcher poiSearchNearBy:option];
//    if(flag)
//    {
//        NSLog(@"周边检索发送成功");
//    }
//    else
//    {
//        NSLog(@"周边检索发送失败");
//    }
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      if (result != nil && result.poiList.count != 0) {
          [GlobalVar instance].currentAddress = ((BMKPoiInfo*)result.poiList[0]).name;
          if ([rolesUser isEqualToString:roleStudent]) {
              [GlobalVar instance].current2DLocation = ((BMKPoiInfo*)result.poiList[0]).pt;
          }
          NSNotification *notification = [NSNotification notificationWithName:@"GETLOCATIONS" object:@[result.address,((BMKPoiInfo*)result.poiList[0]).name]];
          [[NSNotificationCenter defaultCenter] postNotification:notification];
      }
  }
  else {
      NSLog(@"抱歉，未找到结果");
  }
}


@end
