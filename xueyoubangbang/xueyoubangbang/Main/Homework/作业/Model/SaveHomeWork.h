//
//  SaveHomeWork.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoreArchive.h"
@interface SaveHomeWork : NSObject
CoreArchiver_MODEL_H
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *submittime;
@property (nonatomic, copy) NSString *knowledgepoints;
@property (nonatomic, copy) NSString *unique;
@end
