//
//  UIHomeworkAddGroupViewModel.h
//  xueyoubangbang
//
//  Created by Bob on 16/1/14.
//  Copyright (c) 2016年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
@interface UIHomeworkAddGroupViewModel : NSObject<UICollectionViewDataSource>
@property (nonatomic, strong) RACCommand *loadCommond;
@property (nonatomic, strong) NSMutableArray *subjectGroups;
@end
