//
//  UIQuestionMyAnswerViewContrller.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIQuestionMyAnswerViewContrller.h"
#import "AudioRecorder.h"
@interface UIQuestionMyAnswerViewContrller()
{
    UIView *operation;
    UIImageView *imageView;
    UIButton *addImageButton;
    UIButton *addVoiceButton;
    
    UITextView *input;
    UIView *inputContainer;
    UIButton *ask;
    
    NSArray *data;
    
    ChooseGetPictureView *activeView;
    
    NSInteger currentPictureViewTag;
    AudioRecorder *recorder;
}

@end
@implementation UIQuestionMyAnswerViewContrller

#define CONTENT_WIDTH (SCREEN_WIDTH - 20)
#define LEFT (self.view.frame.size.width / 2 - CONTENT_WIDTH / 2)
#define TOP_HEIGHT 50
#define OPERATION_HEIGHT 90
#define ASK_BUTTON_HEIGHT 50
#define INPUT_HEIGHT 80

#define image0Tag 10001
#define image1Tag 10002
#define image2Tag 10003
#define btnPictureTag 10004
#define btnAddTag 10005

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
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
    self.navigationItem.title = @"我来回答";
    
    //隐藏键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTapssss)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
    //
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doBack)];
    
    [self createOperation];
    [self createInput];
    [self createAudio];
    [self createAnswer];
}


- (void)createOperation
{
    operation = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, OPERATION_HEIGHT)];
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
    UIView *container = [[UIView alloc] initWithFrame:CGRectMake(0, operation.frame.origin.y + operation.frame.size.height + 1, SCREEN_WIDTH, 120)];
    container.backgroundColor = [UIColor whiteColor];
    input = [[UITextView alloc] initWithFrame:CGRectMake(kPaddingLeft, 0, container.frame.size.width - kPaddingLeft * 2, 120) ];
    input.backgroundColor = [UIColor whiteColor];
    input.font = FONT_CUSTOM(16);
    [container addSubview:input];
    [self.view addSubview:container];
    inputContainer = container;
}

- (void)createAnswer
{
    ask = BUTTON_CUSTOM(0);
    ask.frame = CGRectMake(ask.frame.origin.x, self.view.frame.size.height - kNavigateBarHight - ask.frame.size.height - 20, ask.frame.size.width , ask.frame.size.height);
    [ask setTitle:@"提交回答" forState:UIControlStateNormal];
    [self.view addSubview:ask];
    [ask addTarget:self action:@selector(doAnswer) forControlEvents:UIControlEventTouchUpInside];

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

- (void)createAudio
{
    recorder = [[AudioRecorder alloc] init];
    recorder.frame = CGRectMake(0, [inputContainer bottomY] + 10, SCREEN_WIDTH, 50);
//    recorder.delegate = self;
    [self.view addSubview:recorder];
}


- (void)doCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doTapssss
{
    [[self.view findFirstResponder] resignFirstResponder];
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
//    btn.hidden = YES;
//    UIButton *btnAdd =(UIButton *) [btn.superview viewWithTag:btnAddTag];
//    btnAdd.hidden = NO;
    [btn.superview.superview viewWithTag:btnPictureTag].hidden = YES;
    UIButton *btnAdd =(UIButton *) [btn.superview.superview viewWithTag:btnAddTag];
    btnAdd.hidden = NO;
}

- (void)doAnswer
{
    
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //子线程
        NSArray *fileData = [self getImageData];
        NSDictionary *para = [self getSendParaItem_imgscnt:fileData.count];

        
        // 主线程执行：
        dispatch_async(dispatch_get_main_queue(), ^{
            // 刷新UI
            [AFNetClient GlobalMultiPartPost:kUrlAddAnswer fileDataArr:fileData parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDcit) {
                [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
                if(isUrlSuccess(dataDcit))
                {
                    [CommonMethod showAlert:@"提交成功"];
                    [self dismissViewControllerAnimated:YES completion:nil];
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
//            if((UIImagePNGRepresentation(image) == nil))
//            {
//                mimeType = @"image/jpeg";
//                filename = [NSString stringWithFormat:@"%@%@",name,@".jpeg"];
//            }
//            else
//            {
//                mimeType = @"image/png";
//                filename = [NSString stringWithFormat:@"%@%@",name,@".png"];
//            }
//            NSData *fileData = [image toData];
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

- (NSDictionary *)getSendParaItem_imgscnt:(NSInteger)item_imgscnt
{
    NSDictionary *para = @{@"questionid":_question.question_id,
                           @"userid":[GlobalVar instance].user.userid,
                           @"txt":input.text,
                           @"item_imgscnt":[NSNumber numberWithInteger:item_imgscnt]        //图片数目
                           };
    NSLog(@"kUrlAddAnswer para = %@",para);
    return para;
}



- (void)doBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
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



@end
