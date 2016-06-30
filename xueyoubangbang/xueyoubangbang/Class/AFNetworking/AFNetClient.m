//
//  AFNetClient.m
//  EnglishWeekly
//
//  Created by richardhxy on 14-4-29.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import "AFNetClient.h"
#import "UCZProgressView.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "LocationDescription.h"
@interface AFNetClient()
@property AFHTTPRequestOperationManager* Netmanage;
@end

@implementation AFNetClient
static AFNetClient *manager = nil;
+ (void)GlobalPostHeader:(NSString *)urlStr
              parameters:(NSString *)parameters
                 success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDcit))sucess
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObject:@"text/html"]];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:urlStr parameters:parameters error:nil];
    [request addValue:parameters forHTTPHeaderField:@"data"];
    request.timeoutInterval = 10;
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         if (sucess) {
                                             //                                             NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
                                             //                                             //系统自带JSON解析
                                             //                                             NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                                             sucess(operation,responseObject);
                                         }
                                         
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (failure) {
                                             failure(operation,error);
                                         }
                                     }
     ];
    [manager.operationQueue addOperation:operation];
}


+ (void)GlobalPost:(NSString *)urlStr
        parameters:(NSDictionary *)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDcit))sucess
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"%@ para = %@",urlStr,parameters);
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"application/json",nil]];
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"POST" URLString:urlStr parameters:parameters error:nil];
    request.timeoutInterval = 10;
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         if (sucess) {
                                             //                                             NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
                                             //                                             //系统自带JSON解析
                                             //                                             NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                                             sucess(operation,responseObject);
                                             NSLog(@"%@ = %@",urlStr, responseObject);
                                         }
                                         
                                     }
                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (failure) {
                                             failure(operation,error);
                                         }
                                         NSLog(@"error = %@ , responseString = %@ ",[error description],operation.responseString);
                                     }
     ];
    [manager.operationQueue addOperation:operation];
    //    [manager POST:urlStr
    //       parameters:parameters
    //          success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //              if (sucess) {
    //                  NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
    //                  //系统自带JSON解析
    //                  NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    //                  sucess(operation,resultDic);
    //              }
    //          }
    //          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //              if (failure) {
    //                  failure(operation,error);
    //              }
    //          }];
}

+ (void)GlobalGet:(NSString *)urlStr
       parameters:(NSDictionary *)parameters
          success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDcit))sucess
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"%@ para = %@",urlStr,parameters);
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:urlStr parameters:parameters error:nil];
    //request.timeoutInterval = 10;
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"text/plain",@"application/json",nil]];
    
    AFHTTPRequestOperation *operation =
    [manager HTTPRequestOperationWithRequest:request
                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                         NSLog(@"success!!!!");
                                         if (sucess) {
                                             
                                             //                                             NSLog(@"%@",(NSArray *) [((NSDictionary *)operation.responseObject) objectForKey:@"A"]);
                                             //                                             NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
                                             //                                             //系统自带JSON解析
                                             //                                             NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
                                             sucess(operation,responseObject);
                                             NSLog(@"%@ = %@",urlStr, responseObject);
                                         }
                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                         if (failure) {
                                             failure(operation,error);
                                         }
                                         NSLog(@"error = %@ , responseString = %@ ",[error description],operation.responseString);
                                     }
     ];
    [manager.operationQueue addOperation:operation];
    //    [manager HTTPRequestOperationWithRequest:request
    //                                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //                                         NSLog(@"success!!!!");
    //                                         if (sucess) {
    //                                             NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
    //                                             //系统自带JSON解析
    //                                             NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    //                                             sucess(operation,resultDic);
    //                                         }
    //                                     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //                                         NSLog(@"failure!!!!");
    //                                         if (failure) {
    //                                             failure(operation,error);
    //                                         }
    //                                     }
    //     ];
    
    
    //    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"text/plain",nil]];
    //    [manager GET:urlStr
    //      parameters:parameters
    //         success:^(AFHTTPRequestOperation *operation, id responseObject) {
    //             //              NSLog(@"operation %@",operation.responseString);
    //             //              NSLog(@"operation %@",[responseObject description]);
    //             //              NSLog(@"1111");
    //             if (sucess) {
    //                 NSData *resData = [[NSData alloc] initWithData:[operation.responseString dataUsingEncoding:NSUTF8StringEncoding]];
    //                 //系统自带JSON解析
    //                 NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:resData options:NSJSONReadingMutableLeaves error:nil];
    //                 sucess(operation,resultDic);
    //             }
    //         }
    //         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //             //              NSLog(@"operation %@",operation.responseString);
    //             //              NSLog(@"%@",[error description]);
    //             //              NSLog(@"2222");
    //             if (failure) {
    //                 failure(operation,error);
    //             }
    //         }];
}

+ (void)GlobalDownloadURL:(NSString *)urlStr
             saveFilePath:(NSString *)path
             saveFileName:(NSString *)name
                  success:(void (^)(NSURLResponse *response, NSString *filePath))sucess
                  failure:(void (^)(NSURLResponse *response, NSError *error))failure
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *rq = [serializer requestWithMethod:@"GET" URLString:urlStr parameters:nil error:nil];
    rq.timeoutInterval = 10;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:rq];
    
    NSString *pathStr = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path];
    BOOL isDir = YES;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:pathStr isDirectory:&isDir];
    if (!exist) {
        [[NSFileManager defaultManager]createDirectoryAtPath:pathStr withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *absolutePath = [pathStr stringByAppendingPathComponent:name];
    NSString *tmpPath = [absolutePath stringByAppendingString:@".tmp"];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:tmpPath append:NO];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        NSError *moveError = nil;
        [[NSFileManager defaultManager] removeItemAtPath:absolutePath error:nil];
        [[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:absolutePath error:&moveError];
        if (sucess && !moveError) {
            sucess(operation.response,absolutePath);
        }else{
            sucess?sucess(operation.response,nil):nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
        NSLog(@"error = %@ , responseString = %@ ",[error description],operation.responseString);
        if (failure) {
            failure(operation.response, error);
        }
    }];
    [operation start];
    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    //
    //    NSString *pathStr = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path];
    //    BOOL isDir = YES;
    //    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:pathStr isDirectory:&isDir];
    //    if (!exist) {
    //        [[NSFileManager defaultManager]createDirectoryAtPath:pathStr withIntermediateDirectories:YES attributes:nil error:nil];
    //    }
    //    NSURL *URL = [NSURL URLWithString:urlStr];
    //    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    //
    //    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
    //        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
    //        return [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@/%@",path,name]];
    //    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
    //        if (nil == error) {
    //            if (nil != sucess) {
    //                sucess(response,filePath);
    //            }
    //        }else{
    //            if (nil != failure) {
    //                failure(response,error);
    //            }
    //        }
    //        NSLog(@"File downloaded to: %@", filePath);
    //    }];
    //    [downloadTask resume];
}


+ (void)GlobalMultiPartPost:(NSString *)urlStr
                   fileData:(NSData *)fileData
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDcit))sucess
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"%@ para = %@",urlStr,parameters);
    if (nil == fileData) {
        [AFNetClient GlobalPost:urlStr
                     parameters:parameters
                        success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDcit) {
                            if (sucess) {
                                sucess(operation,dataDcit);
                            }
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            if (failure) {
                                failure(operation,error);
                            }
                            NSLog(@"%@ failure : %@",urlStr,[error description]);
                        }];
    }else {
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"image/png",@"image/jpg",@"image/jpeg",@"image/gif",@"image/pjpeg",@"image/jpge",nil]];
        [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:fileData name:@"file" fileName:@"headimage" mimeType:@"image/jpg"];
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if (sucess) {
                sucess(operation,responseObject);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error = %@ , responseString = %@ ",[error description],operation.responseString);
            if (failure) {
                failure(operation,error);
            }
            
        }];
    }
}

+ (void)GlobalMultiPartPost:(NSString *)urlStr
                fileDataArr:(NSArray *)fileDataArr
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDcit))sucess
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSLog(@"%@ para = %@",urlStr,parameters);
    if (nil == fileDataArr || fileDataArr.count == 0) {
        [AFNetClient GlobalPost:urlStr
                     parameters:parameters
                        success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDcit) {
                            NSLog(@"%@ = %@",urlStr, dataDcit);
                            if (sucess) {
                                sucess(operation,dataDcit);
                            }
                        }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                            NSLog(@"error = %@ , responseString = %@ ",[error description],operation.responseString);
                            if (failure) {
                                failure(operation,error);
                            }
                            
                        }];
    }else {
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
                if (sucess) {
                    progressView.progress = 1.0;
                    [bgView removeFromSuperview];
                    NSDictionary *test = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    sucess(operation,test);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"error = %@ , responseString = %@ ",[error description],operation.responseString);
                if (failure) {
                    failure(operation,error);
                }
            }];
            [operation start];
            
        }
        //        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        //        [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"text/html",@"image/png",@"image/jpg",@"image/jpeg",@"image/gif",@"image/pjpeg",@"image/jpge",@"application/json",nil]];
        //        [manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //            for (NSDictionary *dic in fileDataArr) {
        //                NSString *name = [dic objectForKey:@"name"];
        //                NSString *mimeType = [dic objectForKey:@"mimeType"];
        //                NSData *fileData = [dic objectForKey:@"fileData"];
        //                NSString *fileName = [dic objectForKey:@"fileName"];
        //                NSLog(@"%@ fileData => name = %@ ,mimeType = %@ , fileName = %@",urlStr,name,mimeType,fileName );
        //                [formData appendPartWithFileData:[dic objectForKey:@"fileData"] name:[dic objectForKey:@"name"] fileName: [dic objectForKey:@"fileName"] mimeType:[dic objectForKey:@"mimeType"]];
        //            }
        //
        //        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //            NSLog(@"%@ = %@",urlStr, responseObject);
        //            if (sucess) {
        //                sucess(operation,responseObject);
        //            }
        //        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //            NSLog(@"error = %@ , responseString = %@ ",[error description],operation.responseString);
        //            if (failure) {
        //                failure(operation,error);
        //            }
        //        }];
    }
}


+ (void)GlobalDownloadURL:(NSString *)urlStr
             saveFilePath:(NSString *)path
             saveFileName:(NSString *)name
                  process:(void (^)(long long readBytes, long long totalBytes))process
                  success:(void (^)(NSURLResponse *response, NSString *filePath))sucess
                  failure:(void (^)(NSURLResponse *response, NSError *error))failure
{
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *rq = [serializer requestWithMethod:@"GET" URLString:urlStr parameters:nil error:nil];
    rq.timeoutInterval = 10;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:rq];
    
    NSString *pathStr = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),path];
    BOOL isDir = YES;
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:pathStr isDirectory:&isDir];
    if (!exist) {
        [[NSFileManager defaultManager]createDirectoryAtPath:pathStr withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSString *absolutePath = [pathStr stringByAppendingPathComponent:name];
    NSString *tmpPath = [absolutePath stringByAppendingString:@".tmp"];
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:tmpPath append:NO];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"success");
        NSError *moveError = nil;
        [[NSFileManager defaultManager] removeItemAtPath:absolutePath error:nil];
        [[NSFileManager defaultManager] moveItemAtPath:tmpPath toPath:absolutePath error:&moveError];
        if (sucess && !moveError) {
            sucess(operation.response,absolutePath);
        }else{
            sucess?sucess(operation.response,nil):nil;
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[NSFileManager defaultManager] removeItemAtPath:tmpPath error:nil];
        NSLog(@"error = %@ , responseString = %@ ",[error description],operation.responseString);
        if (failure) {
            failure(operation.response, error);
        }
        
    }];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        if (process) {
            process(totalBytesRead,totalBytesExpectedToRead);
        }
    }];
    [operation start];
}

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[self alloc]init];
    });
    
    return manager;
}

//初始化
- (instancetype)init{
    self = [super init];
    if (self) {
        [self inithttps];
    }
    return self;
}
- (id)initWithDelegate:(id)theDelegate {
    self = [super init];
    if (self) {
        [self inithttps];
    }
    return self;
}
- (void)inithttps{
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    self.Netmanage =[AFHTTPRequestOperationManager manager];
    self.Netmanage.securityPolicy = securityPolicy;
    self.Netmanage.securityPolicy.allowInvalidCertificates = YES;
    self.Netmanage.responseSerializer = [AFHTTPResponseSerializer serializer];
}
- (void)AppPostRegistwithPhone:(NSString*)urlStr
                 andparameters:(NSDictionary *)parameters
                       success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDcit))sucess
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    //URL：IP:PORT/Regist
    
    [self.Netmanage GET:urlStr parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"获取到的数据为：%@",[NSString stringWithCString:[[dict description] cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding]);
        // sucess(operation,dict);
        //这里需要写个回调给APPMessageManager，因为APPMessageManager需要通过- (id)initWithDelegate:(id)theDelegate 实现这个AppHttpdelegate协议
        //然后在协议中抛出广播
        /*User *user = [[User alloc]initWithJsonDictionary:userInfo];
         if ([AppHttpdelegate respondsToSelector:@selector(didGetUserInfo:)]) {
         [AppHttpdelegate didGetUserInfo:user];
         }*/
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        
        failure(operation,error);
    }];
    sucess(nil,@{@"result":@{@"ret":@"suc"}});
    
}
- (void)GetCurrentLocationWithLatitude:(CGFloat)latitude
                                     longitude:(CGFloat)longitude
                           withCompletionBlock:(void(^)(NSArray * CurrentLocation))callBack{
    NSString *urlStr = [NSString stringWithFormat:@"http://api.map.baidu.com/geosearch/v3/nearby?ak=A0aMq185YVPawRdEWK1rDSdK&geotable_id=106190&location=%f,%f&coord_type=3&radius=5000&page_index=0&page_size=20",longitude,latitude];
    [self.Netmanage GET:urlStr parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSArray *locations = [LocationDescription objectArrayWithKeyValuesArray:[dict objectForKey:@"contents"]];
        callBack(locations);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        callBack(nil);
    }];
}

@end
