//
//  UIHomeworkEditViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/10.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkEditViewController.h"
#import "BRPlaceholderTextView.h"
#import "UIHomeworkEditCell.h"
#import "AudioRecorder.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "VPImageCropperViewController.h"
#import "UIHomeworkAddHomeworkViewController.h"
@interface UIHomeworkEditViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UIHomeworkEditDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *homeworkDisplayView;
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *homeworkInfo;
@property (strong, nonatomic) NSData *audioData;
@end

@implementation UIHomeworkEditViewController{
    NSMutableArray *picArray;
    NSMutableArray *audioArray;
    ChooseGetPictureView *activeView;
    AudioRecorder *recorder;
    UIImageView *audioView ;
    UILabel *label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initIvar];
    [self initView];
    [self initInputView];
    [self initNav];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.homeworkInfo becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [audioView removeFromSuperview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init Method
- (void)initIvar{
    picArray = [NSMutableArray array];
    audioArray = [NSMutableArray array];
    recorder = [[AudioRecorder alloc] init];
}
- (void)initNav{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(doneEdit)];
}
- (void)initView{
    //初始化图片展现
    [self.homeworkDisplayView registerNib:[UINib nibWithNibName:@"UIHomeworkEditCell" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkEditCell"];
    //初始化文字描述
    self.homeworkInfo.placeholder = @"请填写作业描述，也可使用图片、录音等方式";
    //初始化照片组建
    activeView = [[ChooseGetPictureView alloc] initWithViewContrller:self cameraDelegate:self photoDelegate:self];
    activeView.photoAllowsMultipleSelection = YES;
    activeView.photoMaximumNumberOfSelection = 5;//最大选取个数
    
    //录音显示
    audioView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 150)];
    audioView.center = CGPointMake(SCREEN_WIDTH/2, 200);
//    audioView.backgroundColor = RGBA(0, 0, 0, 0.3);
    audioView.animationImages = @[IMAGE(@"record_1"),IMAGE(@"record_2"),IMAGE(@"record_3"),IMAGE(@"record_4"),IMAGE(@"record_5"),IMAGE(@"record_6"),IMAGE(@"record_7")];

    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 25)];
    label.center = CGPointMake(125/2, 25);
    label.text = @"松开手指,结束录音";
    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [audioView addSubview:label];
    audioView.tag = 1009;
    [[UIApplication sharedApplication].keyWindow addSubview:audioView];
    audioView.hidden = YES;
}
- (void)initInputView{
    UIView *accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    accessoryView.backgroundColor = VIEW_BACKGROUND_COLOR;
    
    UIButton *picBtn = CREATE_BUTTON(64, 5, 40, 35, nil, nil, @selector(doAddPicture:));
    [picBtn setImage:IMAGE(@"add_pic") forState:UIControlStateNormal];
    [accessoryView addSubview:picBtn];
    
    UIButton *audioBtn = CREATE_BUTTON(SCREEN_WIDTH-104, 5, 40, 35, nil, nil, nil);
    [audioBtn setImage:IMAGE(@"question_say") forState:UIControlStateNormal];
    [audioBtn addTarget:self action:@selector(startAudio) forControlEvents:UIControlEventTouchDown];//
    [audioBtn addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchDragOutside];
    [audioBtn addTarget:self action:@selector(test_) forControlEvents:UIControlEventTouchDragInside];
    [audioBtn addTarget:self action:@selector(test_0) forControlEvents:UIControlEventTouchUpOutside];
    [audioBtn addTarget:self action:@selector(stopRecord) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:audioBtn];
    self.homeworkInfo.inputAccessoryView = accessoryView;
}
- (void)test{
    label.text = @"松开手指,取消录音";
    
}
- (void)test_{
    label.text = @"松开上滑,取消录音";
}
- (void)test_0{
    label.text = @"松开上滑,取消录音";
    [audioView stopAnimating];
    audioView.hidden = YES;
}
#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return picArray.count + audioArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIHomeworkEditCell *cell = (UIHomeworkEditCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UIHomeworkEditCell" forIndexPath:indexPath];
    cell.homeworkEditDelegate = self;
    if (audioArray.count != 0 && indexPath.row == picArray.count + audioArray.count -1) {
        cell.homeworkImage.image = audioArray[0];
        return cell;
    }
    cell.homeworkImage.image = [UIImage imageWithData:picArray[indexPath.row]];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (audioArray.count != 0 && indexPath.row == picArray.count + audioArray.count -1) {
        [self playAudio];
    }
}

#pragma mark - UIHomeworkEditDelegate
- (void)didTouchDelete:(NSIndexPath*)index{
    if (audioArray.count != 0 && index.row == picArray.count + audioArray.count -1) {
        self.audioData = nil;
        recorder.amrAudio = nil;
        [audioArray removeAllObjects];
    }else{
        [picArray removeObjectAtIndex:index.row];
    }
    [self.homeworkDisplayView reloadData];
}

#pragma mark cameraDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    VPImageCropperViewController *vpCtrl = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, SCREEN_HEIGHT / 2-SCREEN_WIDTH / 2, SCREEN_WIDTH, SCREEN_WIDTH) limitScaleRatio:3];
    vpCtrl.delegate = self;
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self presentViewController:vpCtrl animated:YES completion:nil];
}

// For responding to the user tapping Cancel.
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker  dismissViewControllerAnimated:YES completion:nil];
}


#pragma QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets{
    [assets enumerateObjectsUsingBlock:^(ALAsset *asset, NSUInteger idx, BOOL *stop) {
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        UIImage *image = [[UIImage alloc] initWithCGImage:iref];
        if (picArray.count == 5) {
            [picArray replaceObjectAtIndex:(idx +5)%5 withObject:UIImageJPEGRepresentation(image,0.000001)];
        }
        else{
            [picArray addObject:UIImageJPEGRepresentation(image,0.000001)];
        }
    }];
    [self.homeworkDisplayView reloadData];
    [imagePickerController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)image{
    if (picArray.count == 5) {
        [picArray replaceObjectAtIndex:4 withObject:UIImageJPEGRepresentation(image,0.000001)];
    }
    else{
        [picArray addObject:UIImageJPEGRepresentation(image,0.000001)];
    }
    [self.homeworkDisplayView reloadData];
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - event response
- (void)doneEdit{
    ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_imgscnt = [NSString stringWithFormat:@"%ld",picArray.count];
    [((NewHomeworkFileSend*)[self.baseHome.items lastObject]) transferArrayToString:picArray];
    [((NewHomeworkFileSend*)[self.baseHome.items lastObject]) transferDataTOString:self.audioData] ;
    ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_info = self.homeworkInfo.text;
//    [self.navigationController popToRootViewControllerAnimated:YES];
    NSArray *VCs = [self.navigationController viewControllers];
    UIViewController __block *vc;
    [VCs enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIHomeworkAddHomeworkViewController class]]) {
            vc = obj;
            *stop = YES;
        }
    }];
    [self.navigationController popToViewController:vc animated:YES];
}
- (void)startAudio{//recorder
    audioView.hidden = NO;
    [audioView startAnimating];
    ((void(*)(id,SEL, unsigned long))objc_msgSend)(recorder, @selector(btnDown),nil);
}
- (void)playAudio{
    ((void(*)(id,SEL, unsigned long))objc_msgSend)(recorder, @selector(doPlayOrStop),nil);
}
- (void)stopRecord{
    [audioView stopAnimating];
    audioView.hidden = YES;
    ((void(*)(id,SEL, unsigned long))objc_msgSend)(recorder, @selector(btnUp:),nil);
    if (recorder.deleteButton.hidden == NO) {
        self.audioData = recorder.amrAudio;
        [audioArray removeAllObjects];
        [audioArray addObject:IMAGE(@"voice_icon")];
        [self.homeworkDisplayView reloadData];
    }
    
    
}
- (void)doAddPicture:(UIButton *)btn{
    [self.homeworkInfo resignFirstResponder];
    [activeView showWithFinish:nil];
}

@end
