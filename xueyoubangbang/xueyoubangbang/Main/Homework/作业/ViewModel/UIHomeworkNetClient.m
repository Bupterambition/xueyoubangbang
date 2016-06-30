//
//  UIHomeworkNetClient.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/7.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkNetClient.h"
#import "UCZProgressView.h"
#import "MJExtension.h"
#import "MBProgressHUD+MJ.h"
#import "UCZProgressView.h"
#import "CustomURLCache.h"
@implementation UIHomeworkNetClient

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

BOOL notNetStatus;
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

+ (void)HomeWorkGlobalPostHeader:(NSString *)urlStr
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
    CustomURLCache __block *URLCache = [CustomURLCache standardURLCache];
//    cachedResponseForRequest
    AFHTTPRequestSerializer *urlOperation = [AFHTTPRequestSerializer serializer];
    NSURLRequest *urlRequest = [urlOperation requestWithMethod:@"POST" URLString:urlStr parameters:parameters error:nil];
    NSCachedURLResponse *  CacheResponse = [URLCache cachedResponseForRequest:urlRequest];
    if (CacheResponse) {
        NSLog(@"%@",[NSJSONSerialization JSONObjectWithData:CacheResponse.data options:0 error:nil]);
    }
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

+ (void)HomeWorkGlobalGetHeader:(NSString *)urlStr
                      parameters:(NSDictionary *)parameters
                    withCallBack:(void(^)(NSDictionary * rawData))callBack{
    [self testNetStatusWithCallBack:callBack];
    if (notNetStatus == YES){
        callBack(nil);
        return;
    }
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    AFHTTPRequestOperationManager* Netmanage = ({
        AFHTTPRequestOperationManager* manage = [AFHTTPRequestOperationManager manager];
        manage.securityPolicy = securityPolicy;
        manage.securityPolicy.allowInvalidCertificates = YES;
        manage.responseSerializer = [AFHTTPResponseSerializer serializer];
        manage;
    });
    [Netmanage GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"获取到的数据为：%@",[NSString stringWithCString:[[dict description] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]);
        callBack(dict);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        callBack(nil);
        [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [MBProgressHUD showError:@"网络错误"];
    }];
}
+ (void)HomeWorkGlobalMultiPartPost:(NSString *)urlStr
                fileDataArr:(NSArray *)fileDataArr
                 parameters:(NSDictionary *)parameters
               withCallBack:(void(^)(NSDictionary * rawData))callBack{
    [self testNetStatusWithCallBack:callBack];
    if (notNetStatus == YES){
        callBack(nil);
        return;
    }
    __block UCZProgressView *progressView = [[UCZProgressView alloc] init];
    progressView.indeterminate = NO;
    progressView.showsText = YES;
    progressView.radius = 74;
    progressView.textSize = 46;
    progressView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    __block UIView *bgView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    bgView.backgroundColor = [UIColor clearColor];
    [bgView addSubview:progressView];
    [[UIApplication sharedApplication].keyWindow addSubview:bgView];
    {
        AFHTTPRequestSerializer *httpClient = [[AFHTTPRequestSerializer alloc] init];
        NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" URLString:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            for (NSDictionary *dic in fileDataArr) {
                [formData appendPartWithFileData:[dic objectForKey:@"fileData"] name:[dic objectForKey:@"name"] fileName: [dic objectForKey:@"fileName"] mimeType:[dic objectForKey:@"mimeType"]];
            }
        } error:nil];
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
            NSLog(@"Sent %lld of %lld bytes and %f ％", totalBytesWritten, totalBytesExpectedToWrite,(double)((double)totalBytesWritten/totalBytesExpectedToWrite)*100);
            double progress = (double)((double)totalBytesWritten/totalBytesExpectedToWrite);
            if (progress > 0.99) {
                progressView.progress = 0.99;
            }
            else
                progressView.progress = progress;
        }];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@ = %@",urlStr, responseObject);
            if (callBack) {
                progressView.progress = 1.0;
                [bgView removeFromSuperview];
                NSDictionary *test = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                callBack(test);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@ , responseString = %@ ",[error description],operation.responseString);
            progressView.progress = 1.0;
            [bgView removeFromSuperview];
            if (callBack) {
                callBack(nil);
            }
        }];
        [operation start];
        
    }
}
@end
