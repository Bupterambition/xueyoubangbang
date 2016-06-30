//
//  UIHomeworkAddDetailDelegate.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIHomeworkAddDetailDelegate <NSObject>
- (void)didTouchHomeworkPic:(NSInteger)index withIndex:(NSIndexPath *)indexPath;
@end
