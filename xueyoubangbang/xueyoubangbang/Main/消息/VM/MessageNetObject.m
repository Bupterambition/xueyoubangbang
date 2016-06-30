//
//  MessageNetObject.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "MessageNetObject.h"
#import "MBProgressHUD+MJ.h"
#import "UCZProgressView.h"
@implementation MessageNetObject

#pragma mark - public Method
static AFHTTPRequestOperationManager* Netmanage;
+ (void)cancelRequest{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    Netmanage = ({
        AFHTTPRequestOperationManager* manage = [AFHTTPRequestOperationManager manager];
        manage.securityPolicy = securityPolicy;
        manage.securityPolicy.allowInvalidCertificates = YES;
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        manage;
    });
    [Netmanage.operationQueue cancelAllOperations];
}
static BOOL notNetStatus;
+ (void)testNetStatusWithCallBack:(void(^)(NSDictionary * rawData))callBack
{
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
//                callBack(nil);
                [MBProgressHUD showError:@"网络错误"];
                notNetStatus = YES;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                //NSLog(@"连接wifi");
                notNetStatus = NO;
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                //NSLog(@"网络通过移动网络连接：");
                notNetStatus = NO;
                break;
            }
            default:
                break;
        }
        //NSLog(@"网络状态返回: %@", AFStringFromNetworkReachabilityStatus(status));
    }];
}

+ (void) MessageGlobalPostHeader:(NSString *)urlStr
                      parameters:(NSDictionary *)parameters
                    withCallBack:(void(^)(NSDictionary * rawData))callBack{
    [self testNetStatusWithCallBack:callBack];
    if (notNetStatus == YES){
        callBack(nil);
        return;
    }
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    Netmanage = ({
        AFHTTPRequestOperationManager* manage = [AFHTTPRequestOperationManager manager];
        manage.securityPolicy = securityPolicy;
        manage.securityPolicy.allowInvalidCertificates = YES;
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        manage;
    });
    [Netmanage POST:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        @try {
            NSLog(@"获取到的数据为：%@",[NSString stringWithCString:[[dict description] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]);
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        @finally {
            
        }
        callBack(dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        callBack(nil);
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showError:@"网络错误"];
    }];
}


@end
