//
//  UIHomeworkAddGroupForS.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/15.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class StudentGroup;
@interface UIHomeworkAddGroupForS : UICollectionViewCell
- (void)loadBaseData;
- (void)loadGroupData:(StudentGroup*)data;
@end
