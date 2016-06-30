//
//  UIHomeworkAddDetailDisplayCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIHomeworkAddDetailDisplayCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picView;
- (void)modifyImageModeForVoice;
- (void)modifyImageModeForImage;
@end
