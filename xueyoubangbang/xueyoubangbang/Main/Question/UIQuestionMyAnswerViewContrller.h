//
//  UIQuestionMyAnswerViewContrller.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MQuestion.h"
@interface UIQuestionMyAnswerViewContrller : UIViewController<UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,QBImagePickerControllerDelegate>
@property (nonatomic,retain) MQuestion *question;
@end
