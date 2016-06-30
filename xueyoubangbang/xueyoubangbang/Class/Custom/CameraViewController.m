//
//  CameraViewController.m
//  sdzhu
//
//  Created by sdzhu on 15/3/9.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"相机" forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(20, 100, 100, 50)];
    [btn addTarget:self action:@selector(startCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *btnPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPhoto setTitle:@"相册" forState:UIControlStateNormal];
    [btnPhoto setFrame:CGRectMake(100, 100, 100, 50)];
    [btnPhoto addTarget:self action:@selector(startPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnPhoto];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate
{

    if (IOS_VERSION_7_OR_ABOVE) {
        AVAuthorizationStatus cameraStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (cameraStatus == AVAuthorizationStatusDenied) {
            NSLog(@"Denied(被拒绝了，不能打开)");
  //[Toast showWithText:@"无法使用相机，请在iPhone的“设置-隐私-相机”中允许访问相机" duration:3];
            return NO;
        } else if (cameraStatus == AVAuthorizationStatusAuthorized) {
            NSLog(@"Authorized(已经获得了许可)");
//            return YES;
        } else if (cameraStatus == AVAuthorizationStatusNotDetermined) {
            NSLog(@"Not Determined(没有决定获得了许可)第一次安装打开");
    //        [Toast showWithText:@"无法使用相机，请在iPhone的“设置-隐私-相机”中允许访问相机" duration:3];
//            return NO;
        } else if (cameraStatus == AVAuthorizationStatusRestricted) {
            NSLog(@"Restricted(受限制：已经询问过是否获得许可但被拒绝)");
//            [Toast showWithText:@"无法使用相机，请在iPhone的“设置-隐私-相机”中允许访问相机" duration:3];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [picker  dismissViewControllerAnimated:YES completion:^{}];
}

- (void)startCamera
{
    [self startCameraControllerFromViewController:self usingDelegate:self];
}

- (void)startPhoto
{
    QBImagePickerController *imagePickerController = [[QBImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsMultipleSelection = NO;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:imagePickerController];
    [self presentViewController:navigationController animated:YES completion:NULL];

}

#pragma QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];
    UIImage *image = [[UIImage alloc] initWithCGImage:iref];
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    [view setFrame:CGRectMake(10, 200, self.view.bounds.size.width, 300)];
    [self.view addSubview:view];
    [imagePickerController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
