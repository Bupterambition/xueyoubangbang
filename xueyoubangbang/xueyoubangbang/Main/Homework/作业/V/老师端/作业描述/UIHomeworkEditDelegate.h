//
//  UIHomeworkEditDelegate.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIHomeworkEditDelegate <NSObject>
- (void)didTouchDelete:(NSIndexPath*)index;
@end
