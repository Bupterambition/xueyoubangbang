//
//  UIQustionAskViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIQuestionAskViewController.h"
#import "CameraViewController.h"
#import "UIContactViewController.h"
#import "MSubject.h"
#import "MContact.h"
#import "AudioRecorder.h"
@interface UIQuestionAskViewController ()<AVAudioRecorderDelegate>
{
    UIView *top;
    UIButton *topButton;
    
    UIView *operation;
    UIImageView *imageView;
    UIButton *addImageButton;
    UIButton *addVoiceButton;
    
    UITextView *input;
    UIView *inputContainer;
    
    AudioRecorder *recorder;
    
    UIButton *ask;
    
    
    UIDropListView *dropList;
    NSArray *dropListData;
    NSMutableArray *dropItemTitle;
    
    ChooseGetPictureView *activeView;
    
    NSInteger currentPictureViewTag;
    
    UIContactViewController *contactViewController;
    
}
@end

@implementation UIQuestionAskViewController


#define CONTENT_WIDTH (SCREEN_WIDTH - 20)
#define LEFT (self.view.frame.size.width / 2 - CONTENT_WIDTH / 2)
#define TOP_HEIGHT 50
#define OPERATION_HEIGHT 100
#define ASK_BUTTON_HEIGHT 50
#define INPUT_HEIGHT 80

#define image0Tag 10001
#define image1Tag 10002
#define image2Tag 10003
#define btnPictureTag 10004
#define btnAddTag 10005
- (id)init
{
    self = [super init];
    if (self)
    {
        [self setHidesBottomBarWhenPushed:YES];
        [self initial];
    }
    return self;
}

- (void)initial
{
    dropListData =[[ CommonMethod subjectDictionary] allValues];
    dropItemTitle  = [[NSMutableArray alloc] init];
    for (MSubject *subject in dropListData) {
        [dropItemTitle addObject:subject.subject_name];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadHomeworkItemImage];
}

- (void)loadHomeworkItemImage
{
    if(_homeworkItem)
    {
        NSMutableArray *buttonArray = [NSMutableArray array];
        for (UIView *sub in operation.subviews) {
            UIButton *picture =(UIButton *) [sub viewWithTag:btnPictureTag];
            [buttonArray addObject:picture];
        }
        
        NSInteger max = _homeworkItem.pictures.count >3?3:_homeworkItem.pictures.count;
        for (int i = 0; i< max; i++) {
            NSString *imageUrl = [_homeworkItem.pictures objectAtIndex:i];
            UIImageView *tempImageView = [[UIImageView alloc] init];
            [tempImageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(imageUrl)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                UIButton *btnPicture = [buttonArray objectAtIndex:i];
                if(btnPicture.hidden == YES)
                {
                    [btnPicture setBackgroundImage:image forState:UIControlStateNormal];
                    btnPicture.hidden = NO;
                    UIButton *btnAdd = (UIButton *)[btnPicture.superview viewWithTag:btnAddTag];
                    btnAdd.hidden = YES;
                }
            }];
            
        }
        input.text = _homeworkItem.desc;
    }

}


- (void)createView{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"发起提问";
    
    //隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapssss)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
//
    
    [self createTop];
    [self createOperation];
    [self createInput];
    [self createAudio];
    if(SCREEN_HEIGHT != SCREEN_IPHONE_4)
    {
        [self createAsk];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提问" style:UIBarButtonItemStylePlain target:self action:@selector(doAsk)];
    }
    
}

////////////////////////////////////////////////////////////
// UIGestureRecognizerDelegate methods

#pragma mark UIGestureRecognizerDelegate methods

//如果不写该段甘薯，则UITableView的点击回调不会执行
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:dropList.table]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    
    return YES;
}

- (void)createTop{
    CGFloat const h = TOP_HEIGHT;
    top = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, h)];
    
    top.backgroundColor = [UIColor whiteColor];
    CGFloat const lableWidth = 100;
    UILabel *leftLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, lableWidth, h)];
    leftLable.textAlignment = NSTextAlignmentCenter;
    leftLable.text = @"选择科目";
    [top addSubview:leftLable];
    
    UIView *sep = [[UIView alloc] init];
    sep.frame = CGRectMake([leftLable rightX]- 10, 5, 1, h - 10);
    sep.backgroundColor = VIEW_BACKGROUND_COLOR;
    [top addSubview:sep];
    
    topButton = [UIButton buttonWithType:UIButtonTypeSystem];
    topButton.frame = CGRectMake(lableWidth, 0, CONTENT_WIDTH - lableWidth, h);
    topButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    topButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    topButton.titleLabel.textAlignment = NSTextAlignmentLeft;
    [topButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if(_homeworkItem)
    {
        [topButton setTitle:_homeworkItem.subject_name forState:UIControlStateNormal];
    }
    else
    {
        [topButton setTitle:@"语文" forState:UIControlStateNormal];
        [topButton addTarget:self action:@selector(doSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [top addSubview:topButton];
    [self.view addSubview:top];
}


- (void)createOperation
{
    operation = [[UIView alloc] initWithFrame:CGRectMake(0, top.frame.size.height + top.frame.origin.y + 20, SCREEN_WIDTH, OPERATION_HEIGHT)];
    operation.backgroundColor = [UIColor whiteColor];
//    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(LEFT, 0, CONTENT_WIDTH - LEFT * 2, 100)];
//    [operation addSubview:imageView];
    
    CGFloat viewWidth = (SCREEN_WIDTH - kPaddingLeft * 4) / 3;
    UIView *image0 = [self createImageViewWithFrame:CGRectMake(kPaddingLeft, 10, viewWidth, OPERATION_HEIGHT - 2 * 10)];
    [operation addSubview:image0];
    image0.tag = image0Tag;
    
//    UIView *image1 = [self createImageViewWithFrame:CGRectMake([image0 rightX] + kPaddingLeft, 10, viewWidth, OPERATION_HEIGHT - 2 * 10)];
//    [operation addSubview:image1];
//    image1.tag = image1Tag;
//    
//    UIView *image2 = [self createImageViewWithFrame:CGRectMake([image1 rightX] + kPaddingLeft, 10, viewWidth, OPERATION_HEIGHT - 2 * 10)];
//    [operation addSubview:image2];
//    image2.tag = image2Tag;
    
    [operation addSubview:addImageButton];
//    [operation addSubview:addVoiceButton];
    [self.view addSubview:operation];
}

- (UIView *)createImageViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    
    UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAdd.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
    btnAdd.tag = btnAddTag;
    [btnAdd setBackgroundImage:[UIImage imageNamed:@"homewoek_addpic"] forState:UIControlStateNormal];
    [view addSubview:btnAdd];
    [btnAdd addTarget:self action:@selector(doAddPicture:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *btnPicture = [UIButton buttonWithType:UIButtonTypeCustom];
    btnPicture.tag = btnPictureTag;
    [view addSubview:btnPicture];
    btnPicture.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
//    [btnPicture addTarget:self action:@selector(doDeletePicture:) forControlEvents:UIControlEventTouchUpInside];
    btnPicture.hidden = YES;
    
    
    UIImage *deleteIcon = [UIImage imageNamed:@"question_delete"];
    UIImageView *iconView = [[UIImageView alloc] initWithImage:deleteIcon];
    iconView.frame = CGRectMake(btnPicture.frame.size.width - deleteIcon.size.width / 2, 0 - deleteIcon.size.height / 2, deleteIcon.size.width, deleteIcon.size.height);
    [btnPicture addSubview:iconView];
    
    
    UIButton *btnDeleteIcon = [UIButton buttonWithType:UIButtonTypeCustom];
//    [btnDeleteIcon setBackgroundImage:deleteIcon forState:UIControlStateNormal];
    [btnDeleteIcon addTarget:self action:@selector(doDeletePicture:) forControlEvents:UIControlEventTouchUpInside];
//    btnDeleteIcon.backgroundColor = [UIColor redColor];
    btnDeleteIcon.frame = CGRectMake(btnPicture.frame.size.width / 2 ,0, btnPicture.frame.size.width / 2, btnPicture.frame.size.height / 2);
    
    
    [btnPicture addSubview:btnDeleteIcon];
    
    return view;
}

- (void)createInput
{
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 120)];
    container.backgroundColor = [UIColor whiteColor];
    input = [[UITextView alloc] initWithFrame:CGRectMake(kPaddingLeft, 0, container.frame.size.width - kPaddingLeft * 2, 120) ];
    input.backgroundColor = [UIColor whiteColor];
    input.font = FONT_CUSTOM(16);
    [container addSubview:input];
    [self.view addSubview:container];
    inputContainer = container;
}

- (void)createAudio
{
    recorder = [[AudioRecorder alloc] init];
    recorder.frame = CGRectMake(0, [inputContainer bottomY] + 10, SCREEN_WIDTH, 50);
    recorder.delegate = self;
    [self.view addSubview:recorder];
}

- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    
}

- (void)createAsk
{
    ask = BUTTON_CUSTOM(0);
    ask.frame = CGRectMake(ask.frame.origin.x,self.view.frame.size.height - kNavigateBarHight - ask.frame.size.height - 10,ask.frame.size.width,ask.frame.size.height);
    [ask setTitle:@"提问" forState:UIControlStateNormal];
    [self.view addSubview:ask];
    [ask addTarget:self action:@selector(doAsk) forControlEvents:UIControlEventTouchUpInside];
}

-(void)keyboardWillShow:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    //keyboardWasShown = YES;
    if(keyboardSize.height != 0)
    {
        [UIImageView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(0, self.view.frame.size.height - inputContainer.frame.origin.y - inputContainer.frame.size.height - keyboardSize.height - 20, self.view.frame.size.width, self.view.frame.size.height);
        } completion:^(BOOL finished) {
        
        }];
    }
}

-(void)keyboardWillHide:(NSNotification *)notification{
    NSDictionary *info = [notification userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    [UIImageView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, kNavigateBarHight, self.view.frame.size.width, self.view.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
}



- (void)doCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doSelect
{
    if(dropList == nil){
        CGFloat dropItemHeight = 40;
        CGFloat h = dropItemTitle.count >= 7 ? 7 * dropItemHeight:dropItemTitle.count * dropItemHeight;
        
        CGRect frame =  CGRectMake(100, top.frame.origin.y + top.frame.size.height, 200, h);
        dropList = [[UIDropListView alloc] initWithFrame:frame itemHeight:dropItemHeight data:dropItemTitle];
        dropList.layer.borderColor = VIEW_BACKGROUND_COLOR.CGColor;
        dropList.layer.borderWidth = 1;
        dropList.backgroundColor = [UIColor grayColor];
        dropList.delegate = self;
        [self.view addSubview:dropList];
    }
    else
    {
        [dropList removeFromSuperview];
        dropList = nil;
    }
    
}

- (void)doTapssss
{
    [[self.view findFirstResponder] resignFirstResponder];
}

- (void)onChooseItem:(NSInteger)row
{
    NSLog(@"onChooseItem = %ld",(long)row);
    MSubject *subject = [dropListData objectAtIndex:row];
    [topButton setTitle: subject.subject_name forState:UIControlStateNormal];
    [dropList removeFromSuperview];
    dropList = nil;
}
- (void)doAddPicture:(UIButton *)btn
{
    [[self.view findFirstResponder] resignFirstResponder];
    
    currentPictureViewTag = btn.superview.tag;
    if(!activeView){
        activeView = [[ChooseGetPictureView alloc] initWithViewContrller:self cameraDelegate:self photoDelegate:self];
        
        int i = 0;
        for (UIView *sub in operation.subviews) {
            UIButton *picture =(UIButton *) [sub viewWithTag:btnPictureTag];
            if(picture.hidden == YES)
            {
                i++;
            }
        }

        activeView.photoAllowsMultipleSelection = YES;
        activeView.photoMaximumNumberOfSelection = i;
        
    }
    
    [activeView showWithFinish:^(BOOL finished) {
        ;
    }];
}

- (void)doDeletePicture:(UIButton *)btn
{
    [btn.superview.superview viewWithTag:btnPictureTag].hidden = YES;
    UIButton *btnAdd =(UIButton *) [btn.superview.superview viewWithTag:btnAddTag];
    btnAdd.hidden = NO;
}

- (void)doAsk
{
    contactViewController = [[UIContactViewController alloc] init];
    contactViewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(doSend)];
    contactViewController.navigationItem.rightBarButtonItem.enabled = NO;
    contactViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancelSend)];
    
    UICustomNavigationViewController *nav = [[UICustomNavigationViewController alloc] initWithRootViewController:contactViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)doSend
{
 
    NSArray *users = contactViewController.choosedItems;
    [contactViewController dismissViewControllerAnimated:YES completion:nil];
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //子线程
        NSArray *data = [self getImageData];
        NSDictionary *para = [self getSendPara:users item_imgscnt:data.count];
        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新UI
            [AFNetClient GlobalMultiPartPost:kUrlAddQuestion fileDataArr:data parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDcit) {
                [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
                if(isUrlSuccess(dataDcit))
                {
                    [CommonMethod showAlert:@"提交成功"];
                    
                    [self.navigationController popViewControllerAnimated:YES];
                    if([self.popDelegate respondsToSelector:@selector(popFromViewController:WithUserinfo:)])
                    {
                        [self.popDelegate popFromViewController:self WithUserinfo:nil];
                    }
                }
                else
                {
                    [CommonMethod showAlert:urlErrorMessage(dataDcit)];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
                [CommonMethod showAlert:@"网络异常"];
            }];
            
        });
    });
}

- (void)doCancelSend
{
    [contactViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)getImageData
{
    NSInteger item_imgscnt = 0;
    NSMutableArray *arr = [NSMutableArray array];
    for (UIView *sub in operation.subviews) {
        UIButton *picture =(UIButton *) [sub viewWithTag:btnPictureTag];
        if(picture.hidden == NO)
        {
            UIImage *image = [[picture backgroundImageForState:UIControlStateNormal] scaleWithScale:0.5];
            
            NSString *mimeType;
            
            NSString *filename;
            NSString *name = [NSString stringWithFormat:@"item_img_%ld",item_imgscnt + 1];
            
            mimeType = @"image/jpeg";
            filename = [NSString stringWithFormat:@"%@%@",name,@".jpeg"];
            NSData *fileData = UIImageJPEGRepresentation(image, 0.5);

            NSDictionary *dic = @{@"name":name,@"fileName":filename,@"fileData":fileData,@"mimeType":mimeType};
            [arr addObject:dic];
            
            item_imgscnt ++;
        }
    }
    
    if(recorder.amrAudio != nil)
    {
        NSDictionary *audio = @{@"name":@"item_audio",@"fileName":@"audio.amr",@"fileData":recorder.amrAudio,@"mimeType":@"audio/amr"};
        [arr addObject:audio];
    }
    
    return arr;
}

- (NSDictionary *)getSendPara:(NSArray *)toUsers item_imgscnt:(NSInteger)item_imgscnt
{
    NSString *subjectid = [self subjectIdBySubjectName:[topButton titleForState:UIControlStateNormal]];
    
    
    NSString *toIds = @"";
    for (int i = 0 ; i< toUsers.count - 1; i++) {
        MContact *user = [toUsers objectAtIndex:i];
        toIds = [NSString stringWithFormat:@"%@%@,",toIds,user.userid];
    }
    if(toUsers.count > 0)
    {
        MContact *user = [toUsers objectAtIndex:toUsers.count - 1];
        toIds = [NSString stringWithFormat:@"%@%@",toIds,user.userid];
    }

    NSMutableDictionary *para = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":[GlobalVar instance].user.userid,
                                                                 @"userkey":[GlobalVar instance].user.key,
                                                                 @"subjectid":subjectid,
                                                                 @"toIds":toIds,          //向谁提问的userid,','分割
                                                                 @"item_info":input.text, //文字内容
                                                                 @"title":@"",            //作业标题
                                                                 @"itemcnt":[NSNumber numberWithInteger:1],            //作业项数目
                                                                 @"item_title":@"",       //问题标题
                                                                 @"item_imgscnt":[NSNumber numberWithInteger:item_imgscnt]        //图片数目
                                                                 }];
    if(_homeworkItem != nil)
    {
        if([CommonMethod isBlankString:_homeworkItem.title] )
        {
            [para setObject:_homeworkItem.title forKey:@"title"];
        }
    }
    
    NSLog(@"kUrlAddQuestion para = %@",para);
    return para;

}

- (NSString *)subjectIdBySubjectName:(NSString *)subjectName
{
    for (int i = 0; i < dropListData.count; i++) {
        MSubject *m = [dropListData objectAtIndex:i];
        if([subjectName isEqualToString:m.subject_name])
        {
            return m.subject_id;
        }
    }
    return @"1";
}

- (void)showOnImageView:(UIImage *)image
{
    //显示在控件上
    UIView *v = [operation viewWithTag:currentPictureViewTag];
    UIButton *btnPicture = (UIButton *) [v viewWithTag:btnPictureTag];
    [btnPicture setBackgroundImage:image forState:UIControlStateNormal];
    btnPicture.hidden = NO;
    UIButton *btnAdd = (UIButton *)[v viewWithTag:btnAddTag];
    btnAdd.hidden = YES;
}

#pragma mark cameraDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self showOnImageView:image];
    
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [picker  dismissViewControllerAnimated:YES completion:^{}];
}


#pragma QBImagePickerControllerDelegate
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAsset:(ALAsset *)asset
{
    ALAssetRepresentation *rep = [asset defaultRepresentation];
    CGImageRef iref = [rep fullResolutionImage];
    UIImage *image = [[UIImage alloc] initWithCGImage:iref];
    [self showOnImageView:image];
    [imagePickerController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(QBImagePickerController *)imagePickerController didSelectAssets:(NSArray *)assets
{
    
    NSMutableArray *buttonArray = [NSMutableArray array];
    for (UIView *sub in operation.subviews) {
        UIButton *picture =(UIButton *) [sub viewWithTag:btnPictureTag];
        if(picture.hidden == YES)
        {
            [buttonArray addObject:picture];
        }
    }


    for (int i = 0; i<assets.count; i++) {
        ALAsset *asset = [assets objectAtIndex:i];
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        UIImage *image = [[UIImage alloc] initWithCGImage:iref];
        UIButton *btnPicture = [buttonArray objectAtIndex:i];
        [btnPicture setBackgroundImage:image forState:UIControlStateNormal];
        btnPicture.hidden = NO;
        UIButton *btnAdd = (UIButton *)[btnPicture.superview viewWithTag:btnAddTag];
        btnAdd.hidden = YES;
    }
    
//    [view setFrame:CGRectMake(10, 200, self.view.bounds.size.width, 300)];
//    [self.view addSubview:view];
    [imagePickerController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
