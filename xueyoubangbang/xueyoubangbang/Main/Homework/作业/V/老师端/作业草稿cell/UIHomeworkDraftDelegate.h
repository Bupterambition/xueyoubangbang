//
//  UIHomeworkDraftDelegate.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIHomeworkDraftDelegate <NSObject>
- (void)didTouchDraftDelete:(NSIndexPath*)currentIndexPath;
@end
