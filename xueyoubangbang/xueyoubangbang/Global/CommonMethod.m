//
//  CommonMethod.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/12.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "CommonMethod.h"
#import "UIImage+Scale.h"
#import "MSubject.h"
#import "AFNetClient.h"
@implementation CommonMethod

+ (UIImage *)createImageWithColor:(UIColor *)color size: (CGSize) size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

+ (UIImage *)getStrechableImageFromImage:(UIImage *)image size:(CGSize)size
{
    //    CGFloat originWidth = image.size.width;
    //    CGFloat originHeight = image.size.height;
    //    UIImage *newImage = [image stretchableImageWithLeftCapWidth:(int)originWidth/2 topCapHeight:(int)originHeight/2];
    //
    //    return newImage;
    //用以上方法拉伸的图片作为view的转为UIColor有问题，会变成repeat模式
    
    CGFloat originWidth = image.size.width;
    CGFloat originHeight = image.size.height;
    UIEdgeInsets sets = UIEdgeInsetsMake( (int)( originHeight / 2.0 - 1),(int)( originWidth / 2.0 - 1), (int)(originHeight / 2.0 -1),(int)( originWidth / 2.0 - 1));
    UIImage *newImage = [image stretchImageWithSets:sets toSize:size];
    return newImage;
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}

#define MASK_LAYER_TAG 100001
+ (UIView *)showWindowLayer
{
    UIView *layer =  [[[UIApplication sharedApplication] keyWindow] viewWithTag:MASK_LAYER_TAG];
    if(!layer)
    {
        layer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        layer.backgroundColor = UIColorFromRGBA(0x000000, 0.5);
        layer.tag = MASK_LAYER_TAG;
        [[[UIApplication sharedApplication] keyWindow] addSubview:layer];
    }
    return layer;
}

+ (void)hideWindowLayer
{
    UIView *layer =  [[[UIApplication sharedApplication] keyWindow] viewWithTag:MASK_LAYER_TAG];
    [layer removeFromSuperview];
}

+ (UIAlertView *)showAlert:(NSString *)text
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    return alert;
}

+ (BOOL)isBlankString:(NSString *)string{
    
    if (string == nil) {
     
     return YES;
     
     }
    
     if (string == NULL) {
     
      return YES;
     
      }
    
     if ([string isKindOfClass:[NSNull class]]) {
     
     return YES;
     
     }
    
     if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
      
      return YES;
      
      }
     
     return NO;
}

+ (NSString *)formatDate:(NSString *)dateString outFormat:(NSString *)outFormat
{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [df1 dateFromString:dateString];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:outFormat];
    NSString *formatDateString = [df2 stringFromDate:date ];
    return formatDateString;
}

+ (NSString *)formatDate:(NSString *)dateString inFormat:(NSString *)inFormat outFormat:(NSString *)outFormat
{
    NSDateFormatter *df1 = [[NSDateFormatter alloc] init];
    [df1 setDateFormat:inFormat];
    NSDate *date = [df1 dateFromString:dateString];
    
    NSDateFormatter *df2 = [[NSDateFormatter alloc] init];
    [df2 setDateFormat:outFormat];
    NSString *formatDateString = [df2 stringFromDate:date ];
    return formatDateString;
}

+ (NSString *)timeToNow:(NSString *)dateString
{
    return [CommonMethod formatDate:dateString outFormat:@"MM月dd日 HH:mm"];
}

+ (NSDictionary *)subjectDictionary
{
    static NSDictionary *subjectDictionary = nil ;
    
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        
        subjectDictionary = @{@"1":[MSubject objectWithId:@"1" name:@"语文" nickname:@"语" icon:@"homework_subject_chinese"],
                                  @"2":[MSubject objectWithId:@"2" name:@"数学" nickname:@"数" icon:@"homework_subject_math"],
                                  @"3":[MSubject objectWithId:@"3" name:@"英语" nickname:@"英" icon:@"homework_subject_english"],
                                  @"4":[MSubject objectWithId:@"4" name:@"物理" nickname:@"物" icon:@"homework_subject_physical"],
                                  @"5":[MSubject objectWithId:@"5" name:@"化学" nickname:@"化" icon:@"homework_subject_chemistry"],
                                  @"6":[MSubject objectWithId:@"6" name:@"生物" nickname:@"生" icon:@"homework_subject_biology"],
                                  @"7":[MSubject objectWithId:@"7" name:@"政治" nickname:@"政" icon:@"homework_subject_political"],
                                  @"8":[MSubject objectWithId:@"8" name:@"历史" nickname:@"历" icon:@"homework_subject_history"],
                                  @"9":[MSubject objectWithId:@"9" name:@"地理" nickname:@"地" icon:@"homework_subject_geograhy"]
                                  };
    });
    
    return subjectDictionary;
}

+(void)doBangbangLoginUsername:(NSString *)username pwd:(NSString *)pwd sucess:(void (^)(MUser *user))sucess fail :(void(^)(NSString *failMsg))fail
{
    [AFNetClient GlobalPost:kUrlLogin parameters:@{@"username":username,@"pwd":pwd,@"guid":[OpenUDID value]} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        
        NSLog(@"doLogin user :%@",dataDict);
        if(isUrlSuccess(dataDict)){
            NSDictionary *userDic = [dataDict objectForKey:@"user"];
            MUser *user = [MUser objectWithDictionary:userDic];
            if(user != nil && user.userid != nil)
            {
                [USER_DEFAULT setInteger:(NSInteger)LoginType_Bangbang forKey:UserDefaultsKey_LoginType];
                [GlobalVar instance].user = user;
                if(sucess)
                {
                    sucess(user);
                }
            }
            else
            {
                if(fail)
                {
                    fail(@"登录失败");
                }
            }
        }
        else{
            if(fail)
            {
                fail(urlErrorMessage(dataDict));
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(fail)
        {
            fail(@"服务异常");
        }
    }];

}

+ (void)doThirdLoginSuccess:(void (^)(MUser *user))sucess
                       fail:(void (^)(NSString *failMsg))fail
                thirdOpenId:(NSString *)thirdOpenId
                  thirdType:(LoginType)thirdLoginType
{
    //通过openId,获取用户信息
    NSDictionary *para = @{@"thirdid":thirdOpenId,@"guid":[OpenUDID value]};
    [AFNetClient GlobalPost:kUrlThirdLogin parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        NSLog(@"kUrlThirdLogin = %@",dataDict);
        if(isUrlSuccess(dataDict))
        {
            MUser *user = [MUser objectWithDictionary:[dataDict objectForKey:@"user"]];
            if(user != nil && user.userid != nil)
            {
                [USER_DEFAULT setInteger:(NSInteger)thirdLoginType forKey:UserDefaultsKey_LoginType];
                [GlobalVar instance].user = user;
                if(sucess)
                {
                    sucess(user);
                }
            }
            else
            {
                if(fail)
                {
                    fail(@"未绑定");
                }
            }
        }
        else
        {
            if(fail)
            {
                fail(@"未绑定");
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if(fail)
        {
            fail(@"服务异常");
        }
    }];

}

+(void)doQQLoginSucess:(void (^)(MUser *user))sucess fail:(void (^)(NSString *failMsg))fail
{
    //通过openId,获取用户信息
    NSDictionary *para = @{@"thirdid":[GlobalVar tencentOAuth].openId,@"guid":[OpenUDID value]};
    [AFNetClient GlobalPost:kUrlThirdLogin parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        NSLog(@"kUrlThirdLogin = %@",dataDict);
        if(isUrlSuccess(dataDict))
        {
            MUser *user = [MUser objectWithDictionary:[dataDict objectForKey:@"user"]];
            if(user != nil && user.userid != nil)
            {
                [USER_DEFAULT setInteger:(NSInteger)LoginType_QQ forKey:UserDefaultsKey_LoginType];
                [GlobalVar instance].user = user;
                if(sucess)
                {
                    sucess(user);
                }
            }
            else
            {
                if(fail)
                {
                    fail(@"未绑定");
                }
            }
        }
        else
        {
            if(fail)
            {
                fail(@"未绑定");
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fail)
            {
                fail(@"服务异常");
            }
    }];
    

}

+ (NSDictionary *)getParaWithOther:(NSDictionary *)otherPara
{
    NSLog(@"%@&&&%@",[GlobalVar instance].user.userid,[GlobalVar instance].user.key);
    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key}];
    if(otherPara != nil)
    {
        for (NSString *key in otherPara) {
            [para setObject:[otherPara objectForKey:key] forKey:key];
        }
    }
    return para;
}

+ (NSArray *)getUTCFormateDate:(NSString *)inDate inFormat:(NSString *)inFormat outFormat:(NSString *)outFormat
{
    //    newsDate = @"2013-08-09 17:01";
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:inFormat];
    
    NSLog(@"newsDate = %@",inDate);
    NSDate *newsDateFormatted = [dateFormatter dateFromString:inDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    
    NSDate* current_date = [[NSDate alloc] init];
    
    NSTimeInterval time=[newsDateFormatted timeIntervalSinceDate:current_date];//间隔的秒数
//    int month=((int)time)/(3600*24*30);
    int days=((int)time)/(3600*24);
    int hours=((int)time)%(3600*24)/3600;
//    int minute=((int)time)%(3600*24)/60;
//    NSLog(@"time=%d",(double)time);
    
    NSString *dateContent = @"剩余小时";
    
    
    int number = 0 ;
    if(days!=0){
        number = days;
        dateContent = @"剩余天数";
    }else if(hours!=0){
        number = hours;
        dateContent = @"剩余小时";
    }
    
    
    return @[[NSString stringWithFormat:@"%d",number],dateContent];

}

@end
