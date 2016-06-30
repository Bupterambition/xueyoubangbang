//
//  NoSelectorCollectionFors.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UICollectionViewCellDelegate <NSObject>
- (void)didTouchDelete:(NSIndexPath*)index;
@end
@interface NoSelectorCollectionFors : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *homeworkImage;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (strong, nonatomic) NSIndexPath *currentPath;
@property (weak, nonatomic) id<UICollectionViewCellDelegate> homeworkDeleteDelegate;
@end
