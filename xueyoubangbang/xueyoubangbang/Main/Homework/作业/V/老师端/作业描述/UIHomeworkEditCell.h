//
//  UIHomeworkEditCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIHomeworkEditDelegate.h"
@interface UIHomeworkEditCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *homeworkImage;
@property (strong, nonatomic) NSIndexPath *currentPath;
@property (weak, nonatomic) id<UIHomeworkEditDelegate> homeworkEditDelegate;
@end
