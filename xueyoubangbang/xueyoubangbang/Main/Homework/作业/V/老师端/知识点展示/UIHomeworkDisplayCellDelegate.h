//
//  UIHomeworkDisplayCellDelegate.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol UIHomeworkDisplayCellDelegate <NSObject>
- (void)didTouchDeleteKnowledge:(NSIndexPath*)indexPath;
@end
