//
//  UIHomeworkAddGroupForS.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/15.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAddGroupForS.h"
#import "StudentGroup.h"

@interface UIHomeworkAddGroupForS()
@property (weak, nonatomic) IBOutlet UIImageView *subjectImg;
@property (weak, nonatomic) IBOutlet UILabel *subjectName;
@property (weak, nonatomic) IBOutlet UILabel *className;

@end
@implementation UIHomeworkAddGroupForS{
    NSDictionary *subjects;
}

- (void)awakeFromNib {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    self.className.adjustsFontSizeToFitWidth = YES;
    subjects =  @{@"1":@"语文",
                  @"2":@"数学",
                  @"3":@"英语",
                  @"4":@"物理",
                  @"5":@"化学",
                  @"6":@"生物",
                  @"7":@"政治",
                  @"8":@"历史",
                  @"9":@"地理"
                  };
}
- (void)loadBaseData{
    self.subjectImg.image = IMAGE(@"workpage_addgroup");
    self.subjectName.text = @"添加班级";
    self.className.hidden = YES;
}
- (void)loadGroupData:(StudentGroup*)data{
    NSString *tets = subjects[[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld",data.subjectid]]];
    self.subjectImg.image = [UIImage imageNamed:tets];
    self.subjectName.text = subjects[[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"%ld",data.subjectid]]];
    self.className.hidden = NO;
    self.className.text = data.groupname;
}

@end
