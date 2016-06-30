//
//  UIEditImageViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/12/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIEditImageViewController.h"
#import "UIRealImageView.h"
#import "CommentMessageSendView.h"
#import "SingleStudentHomeworkAnswer.h"
#import "UIHomeworkViewModel.h"
#import "MBProgressHUD+MJ.h"
#define UFOSCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define UFOSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@interface UIEditImageViewController ()<UIScrollViewDelegate,CommentMsgSendViewDelegate>
@property (nonatomic, strong) UIScrollView *imageDisplayView;
@property (weak, nonatomic) IBOutlet UIView *upTools;
@property (weak, nonatomic) IBOutlet UIView *downTools;
@property (weak, nonatomic) IBOutlet UIButton *checkLineButton;
@property (weak, nonatomic) IBOutlet UIButton *editCheckButton;

@end

@implementation UIEditImageViewController{
    NSArray *mutablePicArray;
    NSArray *checkPicArray;
    NSUInteger currentPicIndex;
    CommentMessageSendView *editLabel;
    CGRect editLabelFrame;
    SingleStudentHomeworkAnswer *currentAnswer;
}
#pragma mark - life Method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageDisplayView];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init Method
- (instancetype)initWithPicArray:(NSArray*)picArray andCurrentDisplayIndex:(NSUInteger)currentIndex{
    self = [self initWithNibName:@"UIEditImageViewController" bundle:nil];
    if (self) {
        mutablePicArray = picArray;
        currentPicIndex = currentIndex;
    }
    return self;
}
- (instancetype)initWithCheckPicArray:(NSArray*)picArray andCurrentDisplayIndex:(NSUInteger)currentIndex{
    self = [self initWithNibName:@"UIEditImageViewController" bundle:nil];
    if (self) {
        checkPicArray = picArray;
        currentPicIndex = currentIndex;
    }
    return self;
}

- (instancetype)initWithCheckPicArray:(NSArray*)picArray andCurrentDisplayIndex:(NSUInteger)currentIndex withAnswer:(SingleStudentHomeworkAnswer *)answer{
    self = [self initWithNibName:@"UIEditImageViewController" bundle:nil];
    if (self) {
        checkPicArray = picArray;
        currentPicIndex = currentIndex;
        currentAnswer = answer;
    }
    return self;
}
- (void)initView{
    if (mutablePicArray.count) {
        [mutablePicArray enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
            UIRealImageView *display = [[UIRealImageView alloc]initWithFrame:CGRectMake(0, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
            UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(idx * UFOSCREENWIDTH, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
            [scrollview addSubview:display];
            display.image = [UIImage imageWithData:obj];
            [display getFrameSizeForImage:display.image inImageView:display];
            display.contentMode = UIViewContentModeScaleAspectFit;
            display.tag = 10001;
            scrollview.tag = idx * UFOSCREENWIDTH +1;
            scrollview.delegate = self;
            scrollview.maximumZoomScale = 2.5f;
            [self.imageDisplayView addSubview:scrollview];
        }];
        
    }
    else{
        self.imageDisplayView.contentSize =  CGSizeMake(UFOSCREENWIDTH * checkPicArray.count, UFOSCREENHEIGHT);
        if (currentAnswer.checkPics.count != 0) {
            [currentAnswer.checkPics enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
                UIRealImageView *display = [[UIRealImageView alloc]initWithFrame:CGRectMake(0, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
                UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(idx * UFOSCREENWIDTH, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
                [scrollview addSubview:display];
                display.image = [UIImage imageWithData:obj];
                [display getFrameSizeForImage:display.image inImageView:display];
                display.contentMode = UIViewContentModeScaleAspectFit;
                display.tag = 10001;
                scrollview.tag = idx * UFOSCREENWIDTH +1;
                scrollview.delegate = self;
                scrollview.maximumZoomScale = 2.5f;
                [self.imageDisplayView addSubview:scrollview];
            }];
        }
        else{
            [checkPicArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                UIRealImageView *display = [[UIRealImageView alloc]initWithFrame:CGRectMake(0, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
                UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(idx * UFOSCREENWIDTH, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
                [scrollview addSubview:display];
                [display sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(obj)] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [display getFrameSizeForImage:image inImageView:display];
                }];
                display.contentMode = UIViewContentModeScaleAspectFit;
                display.tag = 10001;
                scrollview.tag = idx * UFOSCREENWIDTH +1;
                scrollview.delegate = self;
                scrollview.maximumZoomScale = 2.5f;
                [self.imageDisplayView addSubview:scrollview];
            }];
        }
    }
    [self.view bringSubviewToFront:self.upTools];
    [self.view bringSubviewToFront:self.downTools];
    [self makeMessageSendView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToFeedDetails)];
    [self.imageDisplayView addGestureRecognizer:tap];
}



- (void)makeMessageSendView {
    editLabel = [[CommentMessageSendView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 100, 200, kToolbarHeight)];
    editLabel.delegate = self;
    [editLabel setAllowAnonymous:YES];
    editLabel.hidden = YES;
    editLabelFrame = editLabel.frame;
    [self.view addSubview:editLabel];
    [self.view bringSubviewToFront:editLabel];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    currentPicIndex = scrollView.contentOffset.x/UFOSCREENWIDTH;
    NSLog(@"%ld",currentPicIndex);
}
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (scrollView.tag == 9999) {
        return nil;
    }
    else{
        NSLog(@"%@",NSStringFromCGSize(scrollView.contentSize));
        return [scrollView viewWithTag:10001];
    }
}


#pragma mark CommentMsgSendViewDelegate
- (void)onClickMessageSendButton:(BOOL)isAnony text:(NSString*)text {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSLog(@"%@",text);
}


#pragma mark - event Respond
- (void)backToFeedDetails{
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  画线
 *
 *  @param sender 当前button
 */
- (IBAction)addCheckLine:(UIButton *)sender {
    if (sender.selected == NO || self.imageDisplayView.scrollEnabled) {
        self.editCheckButton.selected = NO;
        sender.selected = YES;
        self.imageDisplayView.scrollEnabled = NO;
        UIScrollView *currentScrollView = (UIScrollView*)[self.imageDisplayView viewWithTag:currentPicIndex* UFOSCREENWIDTH +1];
        currentScrollView.scrollEnabled = NO;
        UIRealImageView *currentImg = (UIRealImageView*)[currentScrollView viewWithTag:10001];
        currentImg.userInteractionEnabled = YES;
        editLabel.hidden = YES;
        [editLabel resetInputContent];
        
    }
    else{
        sender.selected = NO;
        self.imageDisplayView.scrollEnabled = YES;
        UIScrollView *currentScrollView = (UIScrollView*)[self.imageDisplayView viewWithTag:currentPicIndex* UFOSCREENWIDTH +1];
        UIRealImageView *currentImg = (UIRealImageView*)[currentScrollView viewWithTag:10001];
        currentImg.userInteractionEnabled = NO;
    }
}
/**
 *  添加标签批注
 *
 *  @param sender 当前button
 */
- (IBAction)addCheckLabel:(UIButton *)sender {
    if (self.imageDisplayView.scrollEnabled || sender.selected == NO) {
        sender.selected = YES;
        self.checkLineButton.selected = NO;
        self.imageDisplayView.scrollEnabled = NO;
        UIScrollView *currentScrollView = (UIScrollView*)[self.imageDisplayView viewWithTag:currentPicIndex* UFOSCREENWIDTH +1];
        currentScrollView.scrollEnabled = NO;
        UIRealImageView *currentImg = (UIRealImageView*)[currentScrollView viewWithTag:10001];
        currentImg.userInteractionEnabled = NO;
        editLabel.hidden = NO;
    }
    else{
        editLabel.hidden = YES;
        [editLabel resetInputContent];
        sender.selected = NO;
        self.imageDisplayView.scrollEnabled = YES;
        UIScrollView *currentScrollView = (UIScrollView*)[self.imageDisplayView viewWithTag:currentPicIndex* UFOSCREENWIDTH +1];
        UIRealImageView *currentImg = (UIRealImageView*)[currentScrollView viewWithTag:10001];
        currentImg.userInteractionEnabled = NO;
    }
}
/**
 *  删除所有线
 *
 *  @param sender 当前button
 */
- (IBAction)deleteAllLine:(UIButton *)sender {
    UIScrollView *currentScrollView = (UIScrollView*)[self.imageDisplayView viewWithTag:currentPicIndex* UFOSCREENWIDTH +1];
    UIRealImageView *currentImg = (UIRealImageView*)[currentScrollView viewWithTag:10001];
    [currentImg clearAllCheckLine];
}
/**
 *  完成批注，画线完毕
 *
 *  @param sender 当前button
 */
- (IBAction)didCompleteCheck:(UIButton *)sender {
    self.imageDisplayView.scrollEnabled = YES;
    UIScrollView *currentScrollView = (UIScrollView*)[self.imageDisplayView viewWithTag:currentPicIndex* UFOSCREENWIDTH +1];
    [currentScrollView setZoomScale:1.0];
    UIRealImageView *currentImg = (UIRealImageView*)[currentScrollView viewWithTag:10001];
    currentImg.userInteractionEnabled = NO;
    self.upTools.hidden = YES;
    self.downTools.hidden = YES;
    currentImg.image = [self selectCurrentImageForLine:self.view withTheSize:currentImg.frame.size];
    if (currentAnswer.checkPics.count == 0) {
        [currentAnswer.checkPics addObject:UIImagePNGRepresentation(currentImg.image)];
    }
    else{
        @try {
            [currentAnswer.checkPics replaceObjectAtIndex:currentPicIndex withObject:UIImagePNGRepresentation(currentImg.image)];
        }
        @catch (NSException *exception) {
            
        }
        @finally {
            
        }
    }
    self.upTools.hidden = NO;
    self.downTools.hidden = NO;
    editLabel.hidden = YES;
    editLabel.frame = editLabelFrame;
    [editLabel resetInputContent];
    self.editCheckButton.selected = NO;
    self.checkLineButton.selected = NO;
    [self didUploadEditPic];
    if ([self.editImageDelegate respondsToSelector:@selector(didChangeImage)]) {
        [self.editImageDelegate didChangeImage];
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (IBAction)undoLastStep:(UIButton *)sender {
    UIScrollView *currentScrollView = (UIScrollView*)[self.imageDisplayView viewWithTag:currentPicIndex* UFOSCREENWIDTH +1];
    UIRealImageView *currentImg = (UIRealImageView*)[currentScrollView viewWithTag:10001];
    [currentImg undoLastAction];
}
#pragma mark - private Method
/**
 *  获取修改后的图片信息，整体截屏
 *
 *  @param currentView 需要截屏的view
 *  @param size        需要裁剪的屏幕
 *
 *  @return 返回修改后的Image
 */
- (UIImage *)selectCurrentImage:(UIView *)currentView withTheSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
/**
 *  获取修改后的图片信息，根据原始图片的合适位置进行截屏
 *
 *  @param currentView 需要截屏的view
 *  @param size        需要裁剪的屏幕大小，一般设置为待截屏的view的Size即可
 *
 *  @return 返回修改后的Image
 */
- (UIImage *)selectCurrentImageForLine:(UIView *)currentView withTheSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    [currentView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIScrollView *currentScrollView = (UIScrollView*)[self.imageDisplayView viewWithTag:currentPicIndex* UFOSCREENWIDTH +1];
    UIRealImageView *currentImg = (UIRealImageView*)[currentScrollView viewWithTag:10001];
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, [currentImg getFrameSizeForImage:currentImg.image inImageView:currentImg]);
    UIImage *imag = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    return imag;
}

- (void)didUploadEditPic{
    [UIHomeworkViewModel uploadCorrectingPicWithParams:[self getParas] withFileDataArr:[self getUploadData] withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"批改成功,学生可以查看您的批改"];
        }
    }];
}


- (NSDictionary *)getParas{
    NSMutableDictionary *otherPara = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":currentAnswer.userid,@"homeworkitemid":currentAnswer.homeworkitemid,@"picture_order":@(currentPicIndex)}];
    return otherPara;
}


- (NSArray *)getUploadData{
    NSString *name = @"picture";
    NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",name];
    NSString *mimeType = @"image/jpeg";
    NSDictionary *dic = @{ @"name":name,@"fileName":fileName,@"mimeType":mimeType,@"fileData":currentAnswer.checkPics[currentPicIndex] !=nil?currentAnswer.checkPics[currentPicIndex]:@"" };
    return @[dic];
}


#pragma mark - setter and getter Method
- (UIScrollView*)imageDisplayView{
    if (_imageDisplayView == nil) {
        _imageDisplayView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT)];
        _imageDisplayView.alwaysBounceHorizontal = YES;
        _imageDisplayView.pagingEnabled = YES;
        _imageDisplayView.backgroundColor = [UIColor blackColor];
        _imageDisplayView.maximumZoomScale = 2;
        _imageDisplayView.minimumZoomScale = 1;
        _imageDisplayView.delegate = self;
        _imageDisplayView.tag = 9999;
        _imageDisplayView.contentSize = CGSizeMake(UFOSCREENWIDTH * mutablePicArray.count, UFOSCREENHEIGHT);
        [_imageDisplayView setContentOffset:CGPointMake(currentPicIndex * UFOSCREENWIDTH, 0)];
    }
    return _imageDisplayView;
}

@end
