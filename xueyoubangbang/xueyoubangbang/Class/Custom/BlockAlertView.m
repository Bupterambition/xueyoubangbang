//
//  BlockAlertView.m
//  BlockAlertViewDemo
//
//  Created by fanpyi on 14-7-27.
//  Copyright (c) 2014年 fanpyi. All rights reserved.
//

#import "BlockAlertView.h"
@interface BlockAlertView()

@property(copy,nonatomic)void (^cancelClicked)();

@property(copy,nonatomic)void (^confirmClicked)();

@end
@implementation BlockAlertView

-(id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)())confirmBlock{
    self=[super initWithTitle:title message:message delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:confirmTitle, nil];
    if (self) {
        _cancelClicked=[cancelblock copy];
        _confirmClicked=[confirmBlock copy];
    }
    return self;
}
+(void)alertWithTitle:(NSString *)title message:(NSString *)message cancelButtonWithTitle:(NSString *)cancelTitle cancelBlock:(void (^)())cancelblock confirmButtonWithTitle:(NSString *)confirmTitle confrimBlock:(void (^)())confirmBlock{
    BlockAlertView *alert=[[BlockAlertView alloc]initWithTitle:title message:message cancelButtonWithTitle:cancelTitle cancelBlock:cancelblock confirmButtonWithTitle:confirmTitle confrimBlock:confirmBlock];
    [alert show];
}
#pragma -mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        if (self.cancelClicked) {
            self.cancelClicked();
        }
    }else if (buttonIndex==1){
        if (self.confirmClicked) {
            self.confirmClicked();
        }
    }
}
@end
