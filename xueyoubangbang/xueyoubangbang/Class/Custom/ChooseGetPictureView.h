//
//  ChooseGetPictureView.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/22.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseGetPictureView : UIView
@property (nonatomic,weak) UIViewController *viewController;
@property (nonatomic,weak) id<UIImagePickerControllerDelegate,UINavigationControllerDelegate> cameraDelegate;
@property (nonatomic,weak) id<QBImagePickerControllerDelegate> photoDelegate;
@property (nonatomic) BOOL photoAllowsMultipleSelection ;
@property (nonatomic) NSInteger photoMaximumNumberOfSelection ;
- (id)initWithViewContrller:(UIViewController *)viewController cameraDelegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>) cameraDelegate photoDelegate:(id<QBImagePickerControllerDelegate>) photoDelegate;
- (void)showWithFinish:(void(^)(BOOL finished))finish;
- (void)hideWithFinish:(void(^)(BOOL finished))finish;

@end
