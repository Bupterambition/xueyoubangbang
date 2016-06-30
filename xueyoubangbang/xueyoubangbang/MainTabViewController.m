//
//  MainTabViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/21.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MainTabViewController.h"
#import "UIIndexViewController.h"
#import "UIMineViewController.h"
#import "UIHomeworkListViewController.h"
#import "MJExtension.h"
//学生
#import "UIHomeworkAddGroupVCForS.h"
#import "UIMessageViewController.h"

#import <RDVTabBarController/RDVTabBarItem.h>
@interface MainTabViewController ()

@end

@implementation MainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
    [self initUserInfo];
}
- (void)createViews{
    UINavigationController *indexNav = [[UICustomNavigationViewController alloc] initWithRootViewController:[[UIMessageViewController alloc] init]];
    UINavigationController *homeworkNav;
    if([rolesUser isEqualToString:roleStudent]){
        homeworkNav = [[UICustomNavigationViewController alloc] initWithRootViewController:[[UIHomeworkAddGroupVCForS alloc] initWithNibName:@"UIHomeworkAddGroupVCForS" bundle:nil]];
    }
    else{
        homeworkNav = [[UICustomNavigationViewController alloc] initWithRootViewController:[[UIHomeworkListViewController alloc] init]];
    }
    UINavigationController *mineNav = [[UICustomNavigationViewController alloc] initWithRootViewController:[[UIMineViewController alloc] initWithNibName:@"UIMineViewController" bundle:nil]];
    [self setViewControllers:@[indexNav,homeworkNav,mineNav] ];
    self.tabBar.backgroundColor = [UIColor whiteColor];
    NSArray *selectImages;
    NSArray *unselectImages;
    NSArray *titles = @[@"消息",@"作业",@"我的"];
    if (ifRoleStudent) {
        selectImages = @[@"nav_message_active",@"nav_work_active",@"nav_my_active-1"];
        unselectImages = @[@"nav_message_normal",@"nav_work_normal",@"nav_my_normal-1"];
    }
    else{
        selectImages = @[@"nav_message_active",@"nav_work_active",@"nav_my_active"];
        unselectImages = @[@"nav_message_normal",@"nav_work_normal",@"nav_my_normal"]; 
    }
    
    for (NSUInteger i = 0; i<self.tabBar.items.count; i++) {
        RDVTabBarItem *item = [self.tabBar.items objectAtIndex:i];
        [item setTitle:[titles objectAtIndex:i]];
        [item setFinishedSelectedImage:[[UIImage imageNamed:[selectImages objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] withFinishedUnselectedImage:[[UIImage imageNamed:[unselectImages objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [item setImage:[[UIImage imageNamed:[unselectImages objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//        [item setSelectedImage:[[UIImage imageNamed:[selectImages objectAtIndex:i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    }
}
- (void)initUserInfo{
    if([GlobalVar instance].user != nil)
    {
        [AFNetClient GlobalGet:kUrlGetUserInfo parameters:[CommonMethod getParaWithOther:@{@"id":[GlobalVar instance].user.userid}] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            if(isUrlSuccess(dataDict))
            {
                MUser *user = [MUser objectWithKeyValues:[dataDict objectForKey:@"user"]];//[MUser objectWithDictionary:[dataDict objectForKey:@"user"]];
                MUser *userTemp = [GlobalVar instance].user;
                userTemp.userid = user.userid;
                userTemp.username = user.username;
                userTemp.roles = user.roles;
                userTemp.header_photo = user.header_photo;
                userTemp.phone = user.phone;
                userTemp.qq = user.qq;
                userTemp.schoolinfo = user.schoolinfo;
                [GlobalVar instance].user = userTemp;
                
                SDWebImageDownloader *downloader = [SDWebImageDownloader sharedDownloader];
                [downloader downloadImageWithURL:[NSURL URLWithString:UrlResString(userTemp.header_photo)]  options:SDWebImageDownloaderLowPriority progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                    [GlobalVar instance].header = image;
                }];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
        
        if(![CommonMethod isBlankString:[GlobalVar instance].deviceToken])
        {
            [AFNetClient GlobalGet:kUrlSetDeviceToken parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key,@"token":[GlobalVar instance].deviceToken} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
                ;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ;
            }];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
