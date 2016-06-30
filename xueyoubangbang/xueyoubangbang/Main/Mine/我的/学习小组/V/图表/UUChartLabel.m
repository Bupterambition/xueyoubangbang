//
//  PNChartLabel.m
//  PNChart
//
//  Created by shake on 14-7-24.
//  Copyright (c) 2014年 uyiuyao. All rights reserved.
//

#import "UUChartLabel.h"
#import "UUColor.h"

@implementation UUChartLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setLineBreakMode:NSLineBreakByTruncatingMiddle];
        [self setMinimumScaleFactor:5.0f];
        [self setNumberOfLines:2];
        [self setFont:[UIFont boldSystemFontOfSize:9.0f]];
        [self setTextColor: UUDeepGrey];
        self.backgroundColor = [UIColor clearColor];
        [self setTextAlignment:NSTextAlignmentCenter];
        self.adjustsFontSizeToFitWidth = YES;
        self.userInteractionEnabled = YES;
    }
    return self;
}


@end
