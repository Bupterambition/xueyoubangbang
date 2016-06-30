//
//  UIHomeworkAnwser.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIHomeworkAnwserFors : UIView
@property (weak, nonatomic) IBOutlet UILabel *itemNum;
- (void)changeTitleToSelector;
- (void)changeTitleToNoselector;
- (void)changeTitleToMutilSelector;
- (void)disappear;
@end
