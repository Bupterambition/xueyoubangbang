//
//  AFNetClient.h
//  EnglishWeekly
//
//  Created by richardhxy on 14-4-29.
//  Copyright (c) 2014年 iflytek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
@interface AFNetClient : NSObject


/**
 *  全局POST请求接口
 *
 *  @param urlStr     URL链接
 *  @param parameters 参数（字典格式）
 *  @param sucess     success代码块
 *  @param failure    failure代码块
 */
+ (void)GlobalPostHeader:(NSString *)urlStr
              parameters:(NSString *)parameters
                 success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDict))sucess
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  全局POST请求接口
 *
 *  @param urlStr     URL链接
 *  @param parameters 参数（字典格式）
 *  @param sucess     success代码块
 *  @param failure    failure代码块
 */
+ (void)GlobalPost:(NSString *)urlStr
        parameters:(NSDictionary *)parameters
           success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDict))sucess
           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  全局GET请求接口
 *
 *  @param urlStr     URL String
 *  @param parameters 参数（字典格式）
 *  @param sucess     sucess代码块
 *  @param failure    failure代码块
 */
+ (void)GlobalGet:(NSString *)urlStr
       parameters:(NSDictionary *)parameters
          success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDict))sucess
          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/**
 *  全局Download接口，用于下载文件。
 *
 *  @param urlStr  URL String
 *  @param path    文件存放位置，相对与Documents的路径
 *  @param name    存放文件名称
 *  @param sucess  sucess代码块
 *  @param failure failure代码块
 */
+ (void)GlobalDownloadURL:(NSString *)urlStr
             saveFilePath:(NSString *)path
             saveFileName:(NSString *)name
                  success:(void (^)(NSURLResponse *response, NSString *filePath))sucess
                  failure:(void (^)(NSURLResponse *response, NSError *error))failure;

+ (void)GlobalMultiPartPost:(NSString *)urlStr
                   fileData:(NSData *)fileData
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDict))sucess
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  上传多个文件
 *  @param  urlStr          URL String
 *  @param  fileDataArr     上传文件数据及信息 @{@"name":@"headerimage",@"mimeType":"image/png",@"fileData":NSData }
 *  @param  parameters      其他文本数据
 *  @param  success
 *  @param  failure
 */
+ (void)GlobalMultiPartPost:(NSString *)urlStr
                fileDataArr:(NSArray *)fileDataArr
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDcit))sucess
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)GlobalDownloadURL:(NSString *)urlStr
             saveFilePath:(NSString *)path
             saveFileName:(NSString *)name
                  process:(void (^)(long long readBytes, long long totalBytes))process
                  success:(void (^)(NSURLResponse *response, NSString *filePath))sucess
                  failure:(void (^)(NSURLResponse *response, NSError *error))failure;

+ (instancetype)sharedManager;
- (void)AppPostRegistwithPhone:(NSString*)urlStr
                 andparameters:(NSDictionary *)parameters
                       success:(void (^)(AFHTTPRequestOperation *operation, NSDictionary *dataDcit))sucess
                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/**
 *  根据当前的经纬度获取当前的地点信息
 *
 *  @param latitude  纬度
 *  @param longitude 经度
 */
- (void)GetCurrentLocationWithLatitude:(CGFloat)latitude
                             longitude:(CGFloat)longitude
                   withCompletionBlock:(void(^)(NSArray * CurrentLocation))callBack;
/**
 *  学生签到
 *
 *  @param classid      班级id
 *  @param address      当前地点
 *  @param geotable_id  上一个接口参数中的geotable_id
 *  @param geotable_uid 上一个接口中返回的uid
 *  @param sign_number  上一个接口中返回的sign_number加1
 *  @param callback     status 返回0代码签到成功否则失败
 */
- (void)studentSignUpWithClassid:(NSUInteger)classid
                   andWithAdress:(NSString *)address
                 withGeotable_id:(NSUInteger)geotable_id
                withGeotable_uid:(NSUInteger)geotable_uid
                 withSign_number:(NSUInteger)sign_number withCompletionBlock:(void(^)(BOOL status))callback;

@end
