//
//  UIQuestionAnswerTableViewCellFrame.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIQuestionAnswerTableViewCellFrame.h"

@interface UIQuestionAnswerTableViewCellFrame()
{
}
@end

@implementation UIQuestionAnswerTableViewCellFrame
//@synthesize topContainerFrame,headerFrame,lable2Frame,lable1Frame,contentLableFrame,picutureFrame,contentContainerFrame,cellHeight;
-(id)initWithAnswer:( MAnswer*)answer
{
    self = [super init];
    if(self){
        [self setAnswer:answer];
    }
    return self;
}

-(void)setAnswer:(MAnswer *)answer
{
    _topContainerFrame = CGRectMake(0, 0, SCREEN_WIDTH, 48);
    
    _headerFrame = CGRectMake(4, 4, 40,40);
    
    _lable1Frame = CGRectMake(_headerFrame.origin.x + _headerFrame.size.width + 4, 4, 80, 20);
    
    
    _lable2Frame = CGRectMake(_lable1Frame.origin.x , _lable1Frame.origin.y + _lable1Frame.size.height + 4, 80, 20);
    
    CGSize mainTextSize = [CommonMethod sizeWithString:answer.txt font:[UIFont fontWithName:kChineseFontName size:28] maxSize:CGSizeMake(280, MAXFLOAT)];
    _contentLableFrame = CGRectMake(4, 4, mainTextSize.width, mainTextSize.height);
//    NSLog(@"contentLableFrame = %@",NSStringFromCGRect(contentLableFrame));
    _pictureH = 0;
    if(answer.pictures != nil && answer.pictures.count > 0){
        
        _pictureH = ( (answer.pictures.count - 1) / 3 +1 )
        
        UIImage *picture = [answer.pictures objectAtIndex:0];
        picutureFrame = CGRectMake(4, 4 + contentLableFrame.origin.y + contentLableFrame.size.height , picture.size.width , picture.size.height);
        pictureHeight = picture.size.height;
    }
    else{
        picutureFrame = CGRectMake(4, contentLableFrame.origin.y + contentLableFrame.size.height, 0, 0);
    }
    CGFloat pictureW =( SCREEN_WIDTH - 10 * 4) / 3;
     _picutureFrame = CGRectMake(4, 4 + _contentLableFrame.origin.y + _contentLableFrame.size.height , pictureW,pictureW);
    
    if(![ CommonMethod isBlankString:answer.audio]){
        _voiceFrame = CGRectMake(4, 4 + _picutureFrame.origin.y + _picutureFrame.size.height, 100, 40);
    }
    else
    {
        _voiceFrame = CGRectMake(4, _picutureFrame.origin.y + _picutureFrame.size.height, 0, 0);
    }
    
    _contentContainerFrame = CGRectMake(0, _topContainerFrame.origin.y + _topContainerFrame.size.height, SCREEN_WIDTH, _voiceFrame.origin.y + _voiceFrame.size.height + 4);
    
    
    _cellHeight = _contentContainerFrame.origin.y + _contentContainerFrame.size.height;

}
@end
