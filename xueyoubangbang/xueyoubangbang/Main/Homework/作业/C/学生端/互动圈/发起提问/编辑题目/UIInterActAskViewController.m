//
//  UIMineAddNoteViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIInterActAskViewController.h"
#import "UIHomeworkViewModel.h"
#import "BRPlaceholderTextView.h"
#import "UIHomeworkEditCell.h"
#import "AudioRecorder.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "MBProgressHUD+MJ.h"
#import "DWBubbleMenuButton.h"
#import "UIInterActMemberViewController.h"
#import "UFOFeedImageViewController.h"
#import "AudioPlayer.h"
@interface UIInterActAskViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UIHomeworkEditDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *homeworkDisplayView;
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *homeworkInfo;
@property (strong, nonatomic) NSData *audioData;
@end

@implementation UIInterActAskViewController{
    NSMutableArray *picArray;
    NSMutableArray *audioArray;
    ChooseGetPictureView *activeView;
    AudioRecorder *recorder;
    UIImageView *audioView ;
    UILabel *label;
    DWBubbleMenuButton *downButton ;
    UILabel *subjectLabel;
    NSString *subjectid;
    AudioPlayer *audioPlayer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initIvar];
    [self initView];
    [self initInputView];
    [self initNav];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.homeworkInfo becomeFirstResponder];
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
    if (self.ifFromHomework && self.audioUrl.length > 0) {
        [audioArray addObject:IMAGE(@"voice_icon")];
        audioPlayer = [[AudioPlayer alloc] init];
        audioPlayer.audioUrl = self.audioUrl;
    }
   
}
- (void)initNav{
    if (self.ifFromMyAnswer) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(doSubmit)];
    }
    else{
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"问TA" style:UIBarButtonItemStylePlain target:self action:@selector(askMember)];
    }
}
- (void)initView{
    self.title = @"发起提问";
    //初始化图片展现
    [self.homeworkDisplayView registerNib:[UINib nibWithNibName:@"UIHomeworkEditCell" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkEditCell"];
    //初始化文字描述
    self.homeworkInfo.placeholder = @"请填写文字表述，也可使用图片、录音等方式";
    if (self.ifFromHomework) {
        self.homeworkInfo.text = [NSString stringWithFormat:@"#%@#%@",[self getSubjectForTitle:[_subject_id integerValue]],_itemInfo];
        self.homeworkInfo.editable = NO;
    }
    //初始化照片组建
    activeView = [[ChooseGetPictureView alloc] initWithViewContrller:self cameraDelegate:self photoDelegate:self];
    activeView.photoAllowsMultipleSelection = YES;
    activeView.photoMaximumNumberOfSelection = 1;//最大选取个数
    
    //录音显示
    audioView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 150)];
    audioView.center = CGPointMake(SCREEN_WIDTH/2, 200);
    //    audioView.backgroundColor = RGBA(0, 0, 0, 0.3);
    audioView.animationImages = @[IMAGE(@"record_1"),IMAGE(@"record_2"),IMAGE(@"record_3"),IMAGE(@"record_4"),IMAGE(@"record_5"),IMAGE(@"record_6"),IMAGE(@"record_7")];
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 125, 30)];
    label.center = CGPointMake(125/2, 50);
    label.text = @"松开手指,结束录音";
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [audioView addSubview:label];
    [[UIApplication sharedApplication].keyWindow addSubview:audioView];
    audioView.hidden = YES;
    
    subjectLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
    subjectLabel.text = @"语";
    subjectLabel.textColor = [UIColor whiteColor];
    subjectLabel.textAlignment = NSTextAlignmentCenter;
    subjectLabel.layer.masksToBounds = YES;
    subjectLabel.layer.cornerRadius = 17.5;
    subjectLabel.backgroundColor = STYLE_COLOR;
    
    if (self.ifFromHomework || self.ifFromMyAnswer) {
        return;
    }
    downButton =[[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -40, 70, subjectLabel.frame.size.width, subjectLabel.frame.size.height)
                                       expansionDirection:DirectionLeft];
    downButton.homeButtonView = subjectLabel;
    downButton.buttonSpacing = 1.0f;
    [downButton addButtons:[self createButtonArray]];
    [self.view addSubview:downButton];
}
- (void)initInputView{
    if (self.ifFromHomework) {
        return;
    }
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
    return (self.ifFromHomework?self.picUrlArray.count: picArray.count) + audioArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIHomeworkEditCell *cell = (UIHomeworkEditCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UIHomeworkEditCell" forIndexPath:indexPath];
    cell.homeworkEditDelegate = self;
    if (audioArray.count != 0 && indexPath.row == (self.ifFromHomework?self.picUrlArray.count: picArray.count) + audioArray.count -1) {
        cell.homeworkImage.image = audioArray[0];
        return cell;
    }
    if (self.ifFromHomework) {
        [cell.homeworkImage sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(self.picUrlArray[indexPath.row])] placeholderImage:DEFAULT_PIC];
    }
    else{
        cell.homeworkImage.image = [UIImage imageWithData:picArray[indexPath.row]];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    if (audioArray.count != 0 && indexPath.row == picArray.count + audioArray.count -1) {
        if (self.ifFromHomework) {
            [self playAudioByUrl];
        }
        else{
            [self playAudio];
        }
        
    }
    else{
        if (self.ifFromHomework) {
            UFOFeedImageViewController *vc =[[UFOFeedImageViewController alloc] initWithCheckPicArray:self.picUrlArray andCurrentDisplayIndex:indexPath.row];
            [self presentViewController:vc animated:YES completion:nil];
        }
        else{
            UFOFeedImageViewController *vc =[[UFOFeedImageViewController alloc] initWithPicArray:picArray andCurrentDisplayIndex:indexPath.row];
            [self presentViewController:vc animated:YES completion:nil];
        }
        
    }
}

#pragma mark - UIHomeworkEditDelegate
- (void)didTouchDelete:(NSIndexPath*)index{
    if (audioArray.count != 0 && index.row == picArray.count + audioArray.count -1) {
        self.audioData = nil;
        recorder.amrAudio = nil;
        [audioArray removeAllObjects];
    }else{
        if (self.ifFromHomework) {
            [self.picUrlArray removeObjectAtIndex:index.row];
        }
        else{
            [picArray removeObjectAtIndex:index.row];
        }
    }
    [self.homeworkDisplayView reloadData];
}

#pragma mark cameraDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    image = [self fixOrientation:image];
    if (self.ifFromMyAnswer) {
        if (picArray.count == 1) {
            [picArray replaceObjectAtIndex:0 withObject:UIImageJPEGRepresentation(image,0.000001)];
        }
        else{
            [picArray addObject:UIImageJPEGRepresentation(image,0.000001)];
        }
    }
    else{
        if (picArray.count == 5) {
            [picArray replaceObjectAtIndex:4 withObject:UIImageJPEGRepresentation(image,0.000001)];
        }
        else{
            [picArray addObject:UIImageJPEGRepresentation(image,0.000001)];
        }
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.homeworkDisplayView reloadData];
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
        if (self.ifFromMyAnswer) {
            if (picArray.count == 1) {
                [picArray replaceObjectAtIndex:0 withObject:UIImageJPEGRepresentation(image,0.000001)];
            }
            else{
                [picArray addObject:UIImageJPEGRepresentation(image,0.000001)];
            }
        }
        else{
            if (picArray.count == 5) {
                [picArray replaceObjectAtIndex:4 withObject:UIImageJPEGRepresentation(image,0.000001)];
            }
            else{
                [picArray addObject:UIImageJPEGRepresentation(image,0.000001)];
            }
        }
        
    }];
    [self.homeworkDisplayView reloadData];
    [imagePickerController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - event response
- (void)doSubmit{
    [UIHomeworkViewModel addAnswerWithParams:[self testGetPara] withFileDataArr:[self testGetData] withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"发送成功"];
            [self.navigationController popViewControllerAnimated: YES];
        }
    }];
}

- (NSArray *)testGetData{
    if (self.ifFromHomework) {
        return nil;
    }
    NSMutableArray *dataArr = [NSMutableArray array];
    if (picArray.count) {
        for (NSInteger j = 1; j<=[picArray count]; j++) {
            NSString *name = [NSString stringWithFormat:@"item_img_%ld",j];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",name];
            NSString *mimeType = @"image/jpeg";
            NSData *fileData = [picArray objectAtIndex:j-1];
            NSDictionary *dic = @{ @"name":name,@"fileName":fileName,@"mimeType":mimeType,@"fileData":fileData };
            [dataArr addObject:dic];
        }
    }
    if(self.audioData != nil){
        NSDictionary *audio = @{@"name": [NSString stringWithFormat:@"audio"],@"fileName":@"audio.amr",@"fileData":self.audioData,@"mimeType":@"audio/amr"};
        [dataArr addObject:audio];
    }
    return dataArr;
}
- (NSDictionary *)testGetPara{
    NSDictionary *otherPara = @{@"userid":[GlobalVar instance].user.userid,@"questionid":_questionid?_questionid:@0,@"txt":self.homeworkInfo.text?self.homeworkInfo.text:@""};
    return otherPara;
    
}

- (void)askMember{
    if (_ifFromHomework) {
        UIInterActMemberViewController *vc = [[UIInterActMemberViewController alloc] init];
        vc.audioUrl = self.audioUrl;
        vc.picUrlArray = self.picUrlArray;
        vc.subjectid = self.subject_id;
        vc.item_info = self.homeworkInfo.text;
        vc.ifFromHomework = self.ifFromHomework;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        UIInterActMemberViewController *vc = [[UIInterActMemberViewController alloc] init];
        vc.audioData = self.audioData;
        vc.picArray = picArray;
        vc.subjectid = subjectid;
        vc.item_info = self.homeworkInfo.text;
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)didSelectSubject:(UIButton*)sender{
    subjectid = NSIntTOString(sender.tag);
    subjectLabel.text = [self getSubject:sender.tag];
    self.homeworkInfo.text = [NSString stringWithFormat:@"#%@#%@",[self getSubjectForTitle:sender.tag],self.homeworkInfo.text];
}

- (void)playAudioByUrl{
    ((void(*)(id,SEL, unsigned long))objc_msgSend)(recorder, @selector(doPlayOrStop:),nil);
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
    audioView.hidden = YES;
    [audioView stopAnimating];
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


- (NSMutableArray*)createButtonArray{
    NSMutableArray *btns = [NSMutableArray array];
    [@[@"语",@"数",@"英",@"物",@"化",@"生",@"政",@"历",@"地"] enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIButton *btn = CREATE_BUTTON(0, 0, 25, 25, obj, nil, @selector(didSelectSubject:));
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 12.5;
        btn.tag = idx+1;
        btn.layer.borderColor = [UIColor blackColor].CGColor;
        btn.backgroundColor = STYLE_COLOR;
        btn.titleLabel.textColor = [UIColor blackColor];
        [btns addObject:btn];
    }];
    return btns;
}
- (NSString*)getSubject:(NSInteger)subjectId{
    NSDictionary* subjects =  @{@"1":@"语",
                                @"2":@"数",
                                @"3":@"英",
                                @"4":@"物",
                                @"5":@"化",
                                @"6":@"生",
                                @"7":@"政",
                                @"8":@"历",
                                @"9":@"地"
                                };
    return subjects[[NSString stringWithFormat:@"%ld",subjectId]];
}
- (NSString*)getSubjectForTitle:(NSInteger)subjectId{
    NSDictionary* subjects =  @{@"1":@"语文",
                                @"2":@"数学",
                                @"3":@"英语",
                                @"4":@"物理",
                                @"5":@"化学",
                                @"6":@"生物",
                                @"7":@"政治",
                                @"8":@"历史",
                                @"9":@"地理"
                                };
    return subjects[[NSString stringWithFormat:@"%ld",subjectId]];
}
- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}
@end
