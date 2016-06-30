//
//  UFOFeedImageViewController.h
//  newUfoSDK
//
//  Created by Bob on 15/8/21.
//  Copyright (c) 2015年 ___bidu___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UFOFeedImageViewController : UIViewController
- (instancetype)initWithPicArray:(NSArray*)picArray andCurrentDisplayIndex:(NSUInteger)currentIndex;
- (instancetype)initWithCheckPicArray:(NSArray*)picArray andCurrentDisplayIndex:(NSUInteger)currentIndex;
@end
