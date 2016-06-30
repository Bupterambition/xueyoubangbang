//
//  CommonMethod.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/12.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MUser.h"

typedef NS_ENUM(NSInteger, LoginType)  {
    LoginType_NotLogin = 0,
    LoginType_Bangbang = 1,
    LoginType_QQ = 2,
    LoginType_Weibo = 3,
    LoginType_Weixin = 4
};

@interface CommonMethod : NSObject


+ (UIImage *)createImageWithColor:(UIColor *)color size: (CGSize) size;
+ (UIImage *)getStrechableImageFromImage:(UIImage *)image size:(CGSize)size;
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;
+ (UIView *)showWindowLayer;
+ (void)hideWindowLayer;
+ (UIAlertView *)showAlert:(NSString *)text;
+ (BOOL)isBlankString:(NSString *)string;

+ (NSString *)formatDate:(NSString *)dateString outFormat:(NSString *)outFormat;
+ (NSString *)formatDate:(NSString *)dateString inFormat:(NSString *)inFormat outFormat:(NSString *)outFormat;
+ (NSString *)timeToNow:(NSString *)dateString;
+ (NSDictionary *)subjectDictionary;

+ (void)doBangbangLoginUsername:(NSString *)username pwd:(NSString *)pwd sucess:(void (^)(MUser *user))sucess fail :(void(^)(NSString *failMsg))fail;
+ (void)doQQLoginSucess:(void (^)(MUser *))sucess fail:(void (^)(NSString *failMsg))fail;
/**
 *  登陆第三方按钮
 *
 *  @param sucess         登陆成功后的回调
 *  @param fail           登录失败后的回调
 *  @param thirdOpenId    第三方传过来的userid
 *  @param thirdLoginType 使用何种第三方登陆
 */
+ (void)doThirdLoginSuccess:(void (^)(MUser *))sucess
                       fail:(void (^)(NSString *failMsg))fail
                thirdOpenId:(NSString *)thirdOpenId
                  thirdType:(LoginType)thirdLoginType;
+ (NSDictionary *)getParaWithOther:(NSDictionary *)otherPara;
+ (NSArray *)getUTCFormateDate:(NSString *)inDate inFormat:(NSString *)inFormat outFormat:(NSString *)outFormat;

@end