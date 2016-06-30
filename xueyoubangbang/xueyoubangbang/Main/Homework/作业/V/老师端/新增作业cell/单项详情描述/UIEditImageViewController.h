//
//  UIEditImageViewController.h
//  xueyoubangbang
//
//  Created by Bob on 15/12/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SingleStudentHomeworkAnswer.h"

@protocol UIEditImageDelegate <NSObject>
/**
 *  图片修复后回调
 */
- (void)didChangeImage;

@end


@interface UIEditImageViewController : UIViewController
@property (nonatomic, weak) id<UIEditImageDelegate> editImageDelegate;
- (instancetype)initWithPicArray:(NSArray*)picArray andCurrentDisplayIndex:(NSUInteger)currentIndex;
- (instancetype)initWithCheckPicArray:(NSArray*)picArray andCurrentDisplayIndex:(NSUInteger)currentIndex;
- (instancetype)initWithCheckPicArray:(NSArray*)picArray andCurrentDisplayIndex:(NSUInteger)currentIndex withAnswer:(SingleStudentHomeworkAnswer *)answer;
@end
