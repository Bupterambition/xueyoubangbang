//
//  UIHomeworkSubjectCollectionViewCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MSubject;
@interface UIHomeworkSubjectCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *subjectImage;
@property (weak, nonatomic) IBOutlet UILabel *subjectName;
- (void)loadData:(MSubject*)data;
@end
