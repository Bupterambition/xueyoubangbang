//
//  UIMineAddNoteViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMineAddNoteViewController.h"
#import "StudentGroupViewModel.h"
#import "BRPlaceholderTextView.h"
#import "UIHomeworkEditCell.h"
#import "AudioRecorder.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "DWBubbleMenuButton.h"
@interface UIMineAddNoteViewController ()
<UICollectionViewDataSource,UICollectionViewDelegate,UIHomeworkEditDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *homeworkDisplayView;
@property (weak, nonatomic) IBOutlet BRPlaceholderTextView *homeworkInfo;
@property (strong, nonatomic) NSData *audioData;
@end

@implementation UIMineAddNoteViewController{
    NSMutableArray *picArray;
    NSMutableArray *audioArray;
    ChooseGetPictureView *activeView;
    AudioRecorder *recorder;
    UIImageView *audioView ;
    UILabel *label;
    DWBubbleMenuButton *downButton ;
    UILabel *subjectLabel;
    NSString *subjectid;
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
}
- (void)initNav{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(doSubmit)];
}
- (void)initView{
    self.title = @"笔记本-语文";
    //初始化图片展现
    [self.homeworkDisplayView registerNib:[UINib nibWithNibName:@"UIHomeworkEditCell" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkEditCell"];
    //初始化文字描述
    self.homeworkInfo.placeholder = @"请填写笔记，也可使用图片、录音等方式";
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
    
    downButton =[[DWBubbleMenuButton alloc] initWithFrame:CGRectMake(SCREEN_WIDTH -40, 100, subjectLabel.frame.size.width, subjectLabel.frame.size.height)
                                       expansionDirection:DirectionLeft];
    downButton.homeButtonView = subjectLabel;
    downButton.buttonSpacing = 1.0f;
    [downButton addButtons:[self createButtonArray]];
    [self.view addSubview:downButton];
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
    if (picArray.count == 5) {
        [picArray replaceObjectAtIndex:4 withObject:UIImageJPEGRepresentation(image,0.000001)];
    }
    else{
        [picArray addObject:UIImageJPEGRepresentation(image,0.000001)];
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
        if (picArray.count == 5) {
            [picArray replaceObjectAtIndex:4 withObject:UIImageJPEGRepresentation(image,0.000001)];
        }
        else{
            [picArray addObject:UIImageJPEGRepresentation(image,0.000001)];
        }
    }];
    [self.homeworkDisplayView reloadData];
    [imagePickerController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - event response

- (void)didSelectSubject:(UIButton*)sender{
    subjectid = NSIntTOString(sender.tag);
    subjectLabel.text = [self getSubject:sender.tag];
    self.title = [NSString stringWithFormat:@"笔记本-%@",[self getSubjectForTitle:sender.tag]];
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
- (void)doSubmit{
    [StudentGroupViewModel addNoteWithParams:[self testGetPara] withFileDataArr:[self testGetData] withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"成功添加"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}


#pragma mark - private Method

- (NSArray *)testGetData{
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
        NSDictionary *audio = @{@"name": [NSString stringWithFormat:@"item_audio"],@"fileName":@"audio.amr",@"fileData":self.audioData,@"mimeType":@"audio/amr"};
        [dataArr addObject:audio];
    }
    return dataArr;
}
- (NSDictionary *)testGetPara{
    NSDictionary *otherPara = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":[GlobalVar instance].user.userid,@"subjectid":subjectid?subjectid:@0,@"item_info":_homeworkInfo.text?_homeworkInfo.text:@"",@"item_imgscnt":@(picArray.count)}];
    return otherPara;
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

@end
