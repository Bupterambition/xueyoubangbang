//
//  CrabCrashReport.h
//  CrabCrashReport
//
//  Created by crab on 15-3-23.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  @protocol CrashSignalCallBackDelegate:
 *  @brief  Crash发生时候可以设置代理，开发者可以完成一些自己的记录工作(保存现场数据等)
 *  @example    在AppDelegate.h中添加CrashSignalCallBackDelegate接口，并在AppDelegate.m中实现crashCallBack函数即可
                @interface AppDelegate : UIResponder <UIApplicationDelegate,CrashSignalCallBackDelegate>
 *  @param  无
 *  @return int
 */
@protocol CrashSignalCallBackDelegate<NSObject>

@required

/**
 *  @protocol crashCallBack:
 *  @brief   必须覆写此函数，Crash发生时候可以回调，开发者可以在此函数中完成一些自己的记录工作(保存现场数据等)
 *  @example    在Crash发生时候会自动调用crashCallBack函数
        - (void)crashCallBack{
            [[CrabCrashReport sharedInstance] addCrashAttachLog:@"value1" forKey:@"key1"];
            [[CrabCrashReport sharedInstance] addCrashAttachLog:@"value2" forKey:@"key2"];
            [[CrabCrashReport sharedInstance] addCrashAttachLog:@"value3" forKey:@"key3"];
        }
 *  @param  无
 *  @return void.
 */
- (void)crashCallBack;

@end

@interface CrabCrashReport : NSObject

#pragma mark structure - Singleton
/**
 *  @method sharedInstance:
 *  @brief  获取CrabCrashReport单例
 *  @param  无
 *  @return id 返回CrabCrashReport单例
 */
+ (id)sharedInstance;

#pragma mark required - init
/**
 *  @method  initCrashReporterWithAppKey:
 *  @brief   初始化crash收集环境,在配置完所有参数(set开头的函数)后调用。
 *  @warning SDK最少只需要这一行代码即可收集Crash信息，其它配置信息可选择使用或者不用
 *  @param   appKey 在Crab平台（http://crab.baidu.com）注册产品线后自动生成的用于唯一标识产品线的ID
 *  @param   channel 发布App的渠道号，默认为`AppStore`
 *  @return  void.
 */
- (void)initCrashReporterWithAppKey:(NSString *)appKey AndVersion:(NSString *)version AndChannel:(NSString *)channel ;

#pragma mark optional - Configure
/**
 *  @method setCrashReportEnabled:
 *  @brief  设置SDK收集Crash的开关,默认打开,在initCrashReporterWithAppKey之前调用
 *  @param  value   默认为:YES
 *  @return void.
 */
- (void)setCrashReportEnabled:(BOOL)value;

/**
 *  @method setDebugEnabled:
 *  @brief  设置SDK的调试日志的开关,默认关闭
 *  @param  value   默认为:NO
 *  @return void.
 */
- (void)setDebugEnabled:(BOOL)value;

/**
 *  @method setStackSymbolsEnabled:
 *  @brief  设置SDK堆栈信息符号化的开关，默认关闭,在initCrashReporterWithAppKey之前调用
 *          不上传dsym文件也能够把Crash信息符号化，但是不能定位到代码具体行
 *  @param  value   默认为:NO
 *  @return void.
 */
- (void)setStackSymbolsEnabled:(BOOL)value;

/**
 *  @method setAppUsername:
 *  @brief  设置app的用户名,可以在任何地方调用，一般在用户登录之后调用
 *          用于确定是哪个用户产生了Crash
 *  @param  appUsername App的用户名，例如设置成`xxxx@gmail.com`.
 *  @return void.
 */
- (void)setAppUsername:(NSString *)appUsername;

/**
 *  @method setBuildnumber:
 *  @brief  设置App的构建号 ,在initCrashReporterWithAppKey之前调用
 *          并不是Version、Build，默认为0(必须为整数，后续会取消这个限制)
 *  @param  buildnumber:Crab平台提出的用于区别同一个版本存在多次构建发版的情况，同jenkins构建号一致
 *          必须为整数，默认为:0，如果同一个版本不存在多次构建发版，可以忽略该项设置
 *  @return void.
 */
- (void)setBuildnumber:(NSString *)buildnumber;

#pragma mark optional - other operate

/**
 *  @method setCrashCallBackDelegate:
 *  @brief  设置发生CrashSignalCallBackDelegate代理对象,在initCrashReporterWithAppKey之前调用
 *  @example 
            [[CrabCrashReport sharedInstance] setCrashCallBackDelegate:self];
 *  @param  delegate  代理对象
 *  @return void.
 */
- (void)setCrashCallBackDelegate:(id<CrashSignalCallBackDelegate>) delegate;

/**
 *  @method addCrashAttachLog:
 *  @brief  在发生奔溃时可以附加日志信息上传，注意：请在你的crashCallBack中调用，目前最多允许上传10个附加信息
 *  @param  attachLog   附加信息内容-Value
 *  @param  defaultName   附加信息-Key
 *  @return void.
 */
- (void)addCrashAttachLog:(NSString *)attachLog forKey:(NSString *)defaultName;



@end
