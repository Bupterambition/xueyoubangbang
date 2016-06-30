//
//  UIHomeworkListViewModel.h
//  xueyoubangbang
//
//  Created by Bob on 15/12/31.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface UIHomeworkListViewModel : NSObject<UITableViewDataSource>
@property (nonatomic, strong) RACCommand *loadCommand;
@property (nonatomic, strong) RACCommand *moreLoadCommand;
@property (nonatomic, strong) NSMutableArray *homeworks;
@property (nonatomic, strong) RACSignal *cellDelegateSignal;
@property (nonatomic, strong) RACSubject *tableSubject;
@property (nonatomic, assign) BOOL finishUpdate;
@end
