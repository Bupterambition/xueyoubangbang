//
//  ChooseGetPictureView.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/22.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "ChooseGetPictureView.h"

@implementation ChooseGetPictureView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithViewContrller:(UIViewController *)viewController cameraDelegate:(id<UIImagePickerControllerDelegate,UINavigationControllerDelegate>) cameraDelegate photoDelegate:(id<QBImagePickerControllerDelegate>) photoDelegate
{
    self = [super initWithFrame:CGRectMake(0, viewController.view.frame.size.height, SCREEN_WIDTH, 3 * 50 +  + 10)];
    if(self)
    {
        self.viewController = viewController;
        self.cameraDelegate = cameraDelegate;
        self.photoDelegate = photoDelegate;
        self.photoAllowsMultipleSelection = NO;
        self.photoMaximumNumberOfSelection = 1;
        [self createView];
    }
    return self;
}

- (void)createView
{
//    self.backgroundColor = UIColorFromRGBA(0x000000, 0.8);
//    
//    [[ UIApplication sharedApplication].keyWindow addSubview:self];
    
    static CGFloat btnH = 50;
    
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    container.backgroundColor = VIEW_BACKGROUND_COLOR;
    [self addSubview:container];
    
    UIButton *btnCamera = [UIButton buttonWithType:UIButtonTypeSystem];
    [container addSubview:btnCamera];
    [btnCamera setTitle:@"拍摄" forState:UIControlStateNormal];
    [btnCamera setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnCamera.backgroundColor = [UIColor whiteColor];
    [btnCamera addTarget:self action:@selector(doCamera) forControlEvents:UIControlEventTouchUpInside];
    btnCamera.frame = CGRectMake(0,0, btnCamera.superview.frame.size.width, btnH);
    
    UIView *seperate = [[UIView alloc] initWithFrame:CGRectMake(0, btnH , SCREEN_WIDTH, 1)];
    seperate.backgroundColor = VIEW_BACKGROUND_COLOR;
    [container addSubview:seperate];
    
    UIButton *btnAblum = [UIButton buttonWithType:UIButtonTypeSystem];
    [container addSubview:btnAblum];
    [btnAblum setTitle:@"从相册选取" forState:UIControlStateNormal];
    [btnAblum setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btnAblum.backgroundColor = [UIColor whiteColor];
    [btnAblum addTarget:self action:@selector(doAblum) forControlEvents:UIControlEventTouchUpInside];
    btnAblum.frame = CGRectMake(0, btnH + 1, btnAblum.superview.frame.size.width, 50);
    
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [container addSubview:btnCancel];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    btnCancel.backgroundColor = [UIColor whiteColor];
    [btnCancel addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    btnCancel.frame = CGRectMake(0, btnH * 2 + 1 + 10, btnAblum.superview.frame.size.width, 50);

}

- (void)doCamera{
    NSLog(@"doCamera");
    [self hide];
    [self startCameraControllerFromViewController:self.viewController usingDelegate:self.cameraDelegate];
}

- (void)doAblum
{
    NSLog(@"doAblum");
    [self hide];
    [self startPhotoWithViewController:self.viewController delegate:self.photoDelegate];
}

- (void)show
{
//    [UIView animateWithDuration:0.2 animations:^{
//        self.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
//    } completion:^(BOOL finished) {
//        
//    }];
    [LayerCustom showWithView:self];
}

- (void)hide
{
    [LayerCustom hide];
}

- (void)showWithFinish:(void (^)(BOOL finished))finish
{
    [LayerCustom showWithView:self];
}

- (void)hideWithFinish:(void (^)(BOOL finished))finish
{
//    [UIView animateWithDuration:0.2 animations:^{
//        self.frame = CGRectMake(0, SCREEN_HEIGHT, self.frame.size.width, self.frame.size.height);
//    } completion:^(BOOL finished) {
//        if(finish){
//            finish(finished);
//        }
//    }];
    [LayerCustom hide];
}


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate
{
    
    if (IOS_VERSION_7_OR_ABOVE) {
        AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (cameraStatus == AVAuthorizationStatusDenied) {
            NSLog(@"Denied(被拒绝了，不能打开)");
            [Toast showWithText:@"无法使用相机，请在iPhone的“设置-隐私-相机”中允许访问相机" duration:3];
            return NO;
        } else if (cameraStatus == AVAuthorizationStatusAuthorized) {
            NSLog(@"Authorized(已经获得了许可)");
            //            return YES;
        } else if (cameraStatus == AVAuthorizationStatusNotDetermined) {
            NSLog(@"Not Determined(没有决定获得了许可)第一次安装打开");
            //                    [Toast showWithText:@"无法使用相机，请在iPhone的“设置-隐私-相机”中允许访问相机" duration:3];
            //            return NO;
        } else if (cameraStatus == AVAuthorizationStatusRestricted) {
            NSLog(@"Restricted(受限制：已经询问过是否获得许可但被拒绝)");
            [Toast showWithText:@"无法使用相机，请在iPhone的“设置-隐私-相机”中允许访问相机" duration:3];
            return NO;
        }
    }
    
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentViewController:cameraUI animated:YES completion:^{}];
    return YES;
}


- (BOOL)startPhotoWithViewController:(UIViewController *)viewController delegate:(id<QBImagePickerControllerDelegate>)delegate
{
    
    if (IOS_VERSION_7_OR_ABOVE) {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == AVAuthorizationStatusDenied) {
            NSLog(@"Denied(被拒绝了，不能打开)");
            [Toast showWithText:@"无法使用相册，请在iPhone的“设置-隐私-相机”中允许访问相册" duration:3];
            return NO;
        } else if (status == AVAuthorizationStatusAuthorized) {
            NSLog(@"Authorized(已经获得了许可)");
            //            return YES;
        } else if (status == AVAuthorizationStatusNotDetermined) {
            NSLog(@"Not Determined(没有决定获得了许可)第一次安装打开");
            //                    [Toast showWithText:@"无法使用相机，请在iPhone的“设置-隐私-相机”中允许访问相机" duration:3];
            //            return NO;
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"Restricted(受限制：已经询问过是否获得许可但被拒绝)");
            [Toast showWithText:@"无法使用相册，请在iPhone的“设置-隐私-相机”中允许访问相册" duration:3];
            return NO;
        }
    }
    
    
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = delegate;
    imagePickerController.allowsMultipleSelection = self.photoAllowsMultipleSelection;
    imagePickerController.maximumNumberOfSelection = self.photoMaximumNumberOfSelection;
    imagePickerController.title = @"选取照片";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [viewController presentViewController:navigationController animated:YES completion:nil];
    return YES;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    if([self.cameraDelegate respondsToSelector:@selector(imagePickerController:didFinishPickingMediaWithInfo:)])
    {
        [self.cameraDelegate imagePickerController:picker didFinishPickingMediaWithInfo:info];
    }
}


// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [picker  dismissViewControllerAnimated:YES completion:^{}];
}


#pragma QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    
    [imagePickerController.parentViewController dismissViewControllerAnimated:YES completion:nil];
    if([self.photoDelegate respondsToSelector:@selector(imagePickerController:didSelectAsset:)]){
        [self.photoDelegate imagePickerController:imagePickerController didSelectAsset:asset];
    }
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    [imagePickerController.parentViewController dismissViewControllerAnimated:YES completion:nil];
    if([self.photoDelegate respondsToSelector:@selector(imagePickerController:didSelectAsset:)]){
        [self.photoDelegate imagePickerController:imagePickerController didSelectAssets:assets];
    }
}



@end
