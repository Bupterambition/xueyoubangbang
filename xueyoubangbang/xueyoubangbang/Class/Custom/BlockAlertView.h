//
//  BlockAlertView.h
//  BlockAlertViewDemo
//
//  Created by fanpyi on 14-7-27.
//  Copyright (c) 2014年 fanpyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlockAlertView : UIAlertView<UIAlertViewDelegate>
+ (void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)())confirmBlock;
@end
