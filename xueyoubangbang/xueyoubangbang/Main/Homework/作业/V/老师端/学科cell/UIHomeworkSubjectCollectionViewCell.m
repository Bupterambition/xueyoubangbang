//
//  UIHomeworkSubjectCollectionViewCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkSubjectCollectionViewCell.h"
#import "MSubject.h"
@implementation UIHomeworkSubjectCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)loadData:(MSubject*)data{
    self.subjectName.text = data.subject_name;
    self.subjectImage.image = [UIImage imageNamed:data.subject_name];
}
@end
