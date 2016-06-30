//
//  UIHomeworkAddDetailDisplayCell.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAddDetailDisplayCell.h"

@implementation UIHomeworkAddDetailDisplayCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)modifyImageModeForVoice{
    self.picView.contentMode = UIViewContentModeScaleAspectFit;
}
- (void)modifyImageModeForImage{
    self.picView.contentMode = UIViewContentModeScaleAspectFill;
}
@end
