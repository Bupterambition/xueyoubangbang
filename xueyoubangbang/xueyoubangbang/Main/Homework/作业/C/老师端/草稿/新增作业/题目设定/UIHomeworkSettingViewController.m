//
//  UIHomeworkSettingViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/23.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkSettingViewController.h"
#import "UIHomeworkAddCell.h"
#import "UIHomeworkAnswerCell.h"
#import "UIHomeworkAnwser.h"
#import "NSMutableArray+Capacity.h"
#import "UIHomeworkEditViewController.h"
#import "NewHomeWorkSend.h"
#import "NewHomeworkFileSend.h"
#import "BRPlaceholderTextView.h"
#import "UIHomeworkEditCell.h"
#import "AudioRecorder.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "VPImageCropperViewController.h"
#import "UIHomeworkAddHomeworkViewController.h"
#import "QuestionAnswerNumCell.h"
#import "QuestionAnswersNum.h"
#import "QuestionTypeCell.h"
@interface UIHomeworkSettingViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,UIHomeworkAnswerDelegate,UIGestureRecognizerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UIHomeworkEditDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate,QuestionTypeDelegate,QuestionAnswerNumCellDelegate,SelectiorAnswerItemNumCellDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NewHomeworkFileSend *baseHomeInfo;
@property (strong, nonatomic) IBOutlet UICollectionView *homeworkDisplayView;
@property (strong, nonatomic) IBOutlet BRPlaceholderTextView *homeworkInfo;
@property (strong, nonatomic) NSData *audioData;

@property (weak, nonatomic) IBOutlet UILabel *fontSizes;
@end

@implementation UIHomeworkSettingViewController{
    NSMutableArray *mutilAnswers;
    
    NSMutableArray *answers;
    NSInteger questionNum;
    NSInteger questionAnswerNum;
    NSInteger questionType;
    
    NSMutableArray *picArray;
    NSMutableArray *audioArray;
    ChooseGetPictureView *activeView;
    AudioRecorder *recorder;
    UIImageView *audioView ;
    UILabel *label;
}
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initBaseView];
    [self.view addSubview:self.table];
    [self initIvar];
    [self initInputView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [audioView removeFromSuperview];
    NSLog(@"%@",self.navigationController.viewControllers);
    @try {
        [self.navigationController.viewControllers[0] setUpdateTable:YES];
    }
    @catch (NSException *exception) {
        [self.navigationController.viewControllers[1] setUpdateTable:YES];
    }
    @finally {
        
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init Method

- (void)initView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"编辑作业";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(doneEdit)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(disappearEdit)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
}
- (void)initBaseView{
    //初始化图片展现
    [self.homeworkDisplayView registerNib:[UINib nibWithNibName:@"UIHomeworkEditCell" bundle:nil] forCellWithReuseIdentifier:@"UIHomeworkEditCell"];
    //初始化文字描述
    self.homeworkInfo.placeholder = @"请填写作业描述，也可使用图片、录音等方式";
    self.homeworkInfo.maxTextLength = 199;
    self.homeworkInfo.delegate = self;
    //初始化照片组建
    activeView = [[ChooseGetPictureView alloc] initWithViewContrller:self cameraDelegate:self photoDelegate:self];
    activeView.photoAllowsMultipleSelection = YES;
    activeView.photoMaximumNumberOfSelection = 5;//最大选取个数
    
    //录音显示
    audioView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 125, 150)];
    audioView.center = CGPointMake(SCREEN_WIDTH/2, 200);
    //    audioView.backgroundColor = RGBA(0, 0, 0, 0.3);
    audioView.animationImages = @[IMAGE(@"record_4"),IMAGE(@"record_5"),IMAGE(@"record_6"),IMAGE(@"record_7")];
    audioView.animationDuration = 0.5;
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    label.center = CGPointMake(125/2, 15);
    label.numberOfLines = 2;
    label.font = [UIFont systemFontOfSize:13];
    label.text = @"松开手指,完成录音,滑动手指,取消录音";
//    label.adjustsFontSizeToFitWidth = YES;
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [audioView addSubview:label];
    audioView.tag = 1009;
    [[UIApplication sharedApplication].keyWindow addSubview:audioView];
    audioView.hidden = YES;
}
- (void)initIvar{
    questionAnswerNum = 4;
    questionNum = 1;
    questionType = 0;
    answers = [NSMutableArray initAnswerWithCapacity:questionNum];;
    mutilAnswers = [NSMutableArray initMutilAnswerWithCapacity:questionNum];
    picArray = [NSMutableArray array];
    audioArray = [NSMutableArray array];
    recorder = [[AudioRecorder alloc] init];
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
    NSLog(@"11111111");
}
- (void)test_{
    label.text = @"松开手指,完成录音";
    NSLog(@"22222222");
}
- (void)test_0{
    NSLog(@"33333333");
    label.text = @"松开手指,完成录音,滑动手指,取消录音";
    [audioView stopAnimating];
    audioView.hidden = YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    self.fontSizes.text = [NSString stringWithFormat:@"%ld／200",textView.text.length];
}
#pragma mark - UITableViewDataSource and UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == questionNum) {
            return 45;
        }
        else if (questionAnswerNum <= 4){
            return 45;
        }
        else{
            return 90;
        }
    }
    return 45;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return questionType != 0?3:1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 1;
        case 2:
            return 1 + questionNum;
        default:
            return 0;
    };
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"选择题型";
        case 1:
            return @"设置选择题数量";
        case 2:
            return @"设置正确答案";
        default:
            return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        QuestionTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionTypeCell"];
        cell.questionTypeDelegate = self;
        return cell;
    }
    else if (indexPath.section == 1){
        QuestionAnswerNumCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionAnswerNumCell"];
        cell.questionAnswerNumDelegate = self;
        return cell;
    }
    else{
        if (indexPath.row == questionNum ) {
            QuestionAnswersNum *cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionAnswersNum"];
            cell.answerNumLabel.text = NSIntTOString(questionAnswerNum) ;
            cell.AnswerItemNumDelegate = self;
            return cell;
        }
        UIHomeworkAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkAnswerCell"];
        cell.currentPath = indexPath;
        [cell hideExcessButton:questionAnswerNum];
        if (questionType == 1) {
            [cell loadSelector:answers[indexPath.row]];
        }
        else{
            [cell loadMutilSelector:mutilAnswers[indexPath.row]];
        }
        
        cell.answerItem.text = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
        cell.answerDelegate = self;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    return YES;
}
#pragma mark - QuestionTypeDelegate
- (void)didTouchQuestionType:(NSInteger)num{
    ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_type = NSIntTOString(num);
    if (questionType != num) {
        questionType = num;
        if (questionType == 1) {
            answers = [NSMutableArray initAnswerWithCapacity:questionNum];
        }
        else if (questionType == 2){
            mutilAnswers = [NSMutableArray initMutilAnswerWithCapacity:questionNum];
        }
        [self.table reloadData];
    }
}
#pragma mark - QuestionAnswerNumCellDelegate
- (void)didChangeSelectorNum:(NSInteger)num{
    questionNum = num;
    if (questionType == 1) {
        answers = [NSMutableArray initAnswerWithCapacity:questionNum];
    }
    else if (questionType == 2){
        mutilAnswers = [NSMutableArray initMutilAnswerWithCapacity:questionNum];
    }
    
    [self.table reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}
#pragma mark - UIHomeworkAnswerDelegate
- (void)didTouchAnswerWithIndex:(NSIndexPath *)index andCurrentIndex:(NSIndexPath*)currentindex{
    [answers replaceObjectAtIndex:index.section withObject:NSIntToNumber(index.row)];
}
- (void)didTouchMutilAnswerWithIndex:(NSIndexPath *)index andCurrentIndex:(NSIndexPath*)currentindex{
    NSMutableArray *currentMutilAnswer = mutilAnswers[currentindex.row];
    if ([currentMutilAnswer containsObject:NSIntToNumber(index.row)]) {
        [currentMutilAnswer removeObject:NSIntToNumber(index.row)];
    }
    else{
        [currentMutilAnswer addObject:NSIntToNumber(index.row)];
    }
}
#pragma mark - SelectiorAnswerItemNumCellDelegate
- (void)didChangeSelectorAnswerItemNum:(NSInteger)num{
    questionAnswerNum = num;
    if (questionNum == 1) {
        answers = [NSMutableArray initAnswerWithCapacity:questionNum];
    }
    else if (questionNum == 2){
        mutilAnswers = [NSMutableArray initMutilAnswerWithCapacity:questionNum];
    }
    [self.table reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return picArray.count + audioArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UIHomeworkEditCell *cell = (UIHomeworkEditCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"UIHomeworkEditCell" forIndexPath:indexPath];
    cell.homeworkEditDelegate = self;
    cell.currentPath = indexPath;
    if (audioArray.count != 0 && indexPath.row == picArray.count + audioArray.count -1) {
        cell.homeworkImage.image = audioArray[0];
        cell.homeworkImage.contentMode = UIViewContentModeScaleAspectFit;
        return cell;
    }
    cell.homeworkImage.contentMode = UIViewContentModeScaleAspectFill;
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
    image = [self fixOrientation:image];
//    VPImageCropperViewController *vpCtrl = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, SCREEN_HEIGHT / 2-SCREEN_WIDTH / 2, SCREEN_WIDTH, SCREEN_WIDTH) limitScaleRatio:3];
//    vpCtrl.delegate = self;
    if (picArray.count == 5) {
        [picArray replaceObjectAtIndex:4 withObject:UIImageJPEGRepresentation(image,0.000001)];
    }
    else{
        [picArray addObject:UIImageJPEGRepresentation(image,0.000001)];
    }
    [self.homeworkDisplayView reloadData];
    [picker dismissViewControllerAnimated:NO completion:nil];
    
//    [self presentViewController:vpCtrl animated:YES completion:nil];
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
    [imagePickerController dismissViewControllerAnimated:YES completion:nil];
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


#pragma mark - event response
- (void)doneEdit{
    if ([((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_type integerValue] == 1) {
        if (answers.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先设置选择题答案" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        if ([answers containsObject:@0]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"有选择题未设置答案" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    else if ([((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_type integerValue] == 2){
        if (mutilAnswers.count == 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"请先设置选择题答案" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSInteger __block testFinal = 0;
        [mutilAnswers enumerateObjectsUsingBlock:^(NSMutableArray *obj, NSUInteger idx, BOOL *stop) {
            if (obj.count == 0) {
                testFinal =1 + idx;
            }
        }];
        if (testFinal !=0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"第%ld项选择题未设置选择题答案",testFinal] message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    
    ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_imgscnt = [NSString stringWithFormat:@"%ld",picArray.count];
    [((NewHomeworkFileSend*)[self.baseHome.items lastObject]) transferArrayToString:picArray];
    [((NewHomeworkFileSend*)[self.baseHome.items lastObject]) transferDataTOString:self.audioData] ;
    ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_info = [self getItemType:[((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_type integerValue]];
    if ([((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_type integerValue] == 1) {
        ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_answer =[answers componentsJoinedByString:@","];
        ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_choicenum = NSIntTOString(questionAnswerNum);
    }
    else if ([((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_type integerValue] == 2){
        [mutilAnswers enumerateObjectsUsingBlock:^(NSMutableArray *obj, NSUInteger idx, BOOL *stop) {
            if (obj.count == 1) {
                NSString *mutilAnswer = obj[0];
                [mutilAnswers replaceObjectAtIndex:idx withObject:mutilAnswer];
            }
            else{
                [obj sortUsingComparator: ^(id obj1, id obj2) {
                    if ([obj1 integerValue] > [obj2 integerValue]) {
                        return (NSComparisonResult)NSOrderedDescending;
                    }
                    if ([obj1 integerValue] < [obj2 integerValue]) {
                        return (NSComparisonResult)NSOrderedAscending;
                    }   
                    return (NSComparisonResult)NSOrderedSame;
                }];
                NSString *mutilAnswer = [obj componentsJoinedByString:@"-"];
                [mutilAnswers replaceObjectAtIndex:idx withObject:mutilAnswer];
            }
        }];
        ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_answer =[mutilAnswers componentsJoinedByString:@","];
        ((NewHomeworkFileSend*)[self.baseHome.items lastObject]).item_choicenum = NSIntTOString(questionAnswerNum);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)startAudio{
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

#pragma mark -event respond
- (void)disappearEdit{
//    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    if ([_homeworkInfo isFirstResponder]) {
        [_homeworkInfo resignFirstResponder];
    }
    else{
        [_homeworkInfo becomeFirstResponder];
    }
}


#pragma private Method
- (NSDictionary *)getPara:(NSInteger)pageIndex{
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"pageIndex":[NSNumber numberWithInteger:pageIndex],@"pageSize":kPageSize};
    NSLog(@"homelist para = %@",para);
    return para;
}

- (NSString *)getItemType:(NSInteger)type{
    switch (type) {
        case 0:
            return [NSString stringWithFormat:@"#解答题# %@",self.homeworkInfo.text];
        case 1:
            return [NSString stringWithFormat:@"#单项选择题# %@",self.homeworkInfo.text];
        case 2:
            return [NSString stringWithFormat:@"#不定项选择题# %@",self.homeworkInfo.text];
        default:
            return [NSString stringWithFormat:@"#未知题型# %@",self.homeworkInfo.text];
    }
    
}

#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.frame = CGRectMake(5, 64+158 +5, SCREEN_WIDTH-10, SCREEN_HEIGHT - 64 - CGRectGetMaxY(self.homeworkDisplayView.frame)-5);
        _table.delegate = self;
        _table.dataSource = self;
        _table.sectionFooterHeight = 20;
        _table.sectionIndexBackgroundColor = VIEW_BACKGROUND_COLOR;
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkAnswerCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkAnswerCell"];
        [_table registerNib:[UINib nibWithNibName:@"QuestionAnswerNumCell" bundle:nil] forCellReuseIdentifier:@"QuestionAnswerNumCell"];
        [_table registerNib:[UINib nibWithNibName:@"QuestionAnswersNum" bundle:nil] forCellReuseIdentifier:@"QuestionAnswersNum"];
        [_table registerNib:[UINib nibWithNibName:@"QuestionTypeCell" bundle:nil] forCellReuseIdentifier:@"QuestionTypeCell"];
    }
    return _table;
}
@end
