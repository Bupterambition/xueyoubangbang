//
//  UIHomeworkDoHomeworkForS.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkDoHomeworkForS.h"
#import "UIHomeworkAddCell.h"
#import "UIHomeworkAnswerCell.h"
#import "UIHomeworkAnwser.h"
#import "UIHomeworkEditViewController.h"
#import "NewHomeWorkSend.h"
#import "NewHomeworkFileSend.h"
#import "NewHomeworkItem.h"
#import "NewHomeworkInfo.h"
#import "UIHomeworkAnwserFors.h"
#import "NoSelectorForsCell.h"
#import "UFOFeedImageViewController.h"
#import "UIHomeworkViewModel.h"
#import "NSDate+Format.h"
#import "MBProgressHUD+MJ.h"
#import "VPImageCropperViewController.h"

@interface UIHomeworkDoHomeworkForS ()<UITableViewDataSource,UITableViewDelegate,UIHomeworkAnswerDelegate,UIGestureRecognizerDelegate,NoSelectorForsCellDelegate,UIImagePickerControllerDelegate,QBImagePickerControllerDelegate,UINavigationControllerDelegate,VPImageCropperDelegate>
@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) NewHomeWorkSend *baseHome;
@property (nonatomic, strong) NewHomeworkFileSend *baseHomeInfo;
@property (nonatomic, copy) NSArray *homeworkDetail;
@end

@implementation UIHomeworkDoHomeworkForS{
    NSInteger questionNum;
    ChooseGetPictureView *activeView;
    NSIndexPath *noSelectorIndex;
    NSIndexPath *selectorIndex;
}
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initIvar];
    [self loadHomeworkItem];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init Method
- (instancetype)initWithHomeWork:(NSArray*)homeDetail{
    self = [super init];
    if (self) {
        self.homeworkDetail = homeDetail;
    }
    return self;
}
- (void)initView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"答题卡";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"提交" style:UIBarButtonItemStylePlain target:self action:@selector(doSubmit)];
    [self.view addSubview:self.table];
}
- (void)initIvar{
    activeView = [[ChooseGetPictureView alloc] initWithViewContrller:self cameraDelegate:self photoDelegate:self];
    activeView.photoAllowsMultipleSelection = YES;
    activeView.photoMaximumNumberOfSelection = 5;//最大选取个数
}
- (void)loadHomeworkItem{
    
}
#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.homeworkDetail[1] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{//选择题
    if ([((NewHomeworkItem*)(self.homeworkDetail[1][section])).type isEqualToString:@"1"]) {
        return [((NewHomeworkItem*)(self.homeworkDetail[1][section])).selectnum integerValue];
    }
    else{
        return 1;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([((NewHomeworkItem*)(self.homeworkDetail[1][section])).type isEqualToString:@"1"]) {
        return 53;
    }
    else{
        return 50;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NewHomeworkItem *item ;
    item =self.homeworkDetail[1][indexPath.section];
    if ([item.type isEqualToString:@"0"]) {//非选择题
        if (item.testPics.count >2) {
            return 199;
        }
        else{
            return 107;
        }
    }
    else{
        if (item.choicenum >4) {
            return 90;
        }
        return 45;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIHomeworkAnwserFors *view = [[NSBundle mainBundle]loadNibNamed:@"UIHomeworkAnwserFors" owner:self options:nil][0];
    view.itemNum.text = [NSString stringWithFormat:@"第%ld项",section+1];
    static NewHomeworkItem *item ;
    item =self.homeworkDetail[1][section];
    if ([item.type isEqualToString:@"0"]) {//非选择题
        [view changeTitleToNoselector];
        [view disappear];
    }
    else if ([item.type isEqualToString:@"1"]){
        if ([item.desc hasPrefix:@"#单项选择题#"])
            [view changeTitleToSelector];
        else
            [view changeTitleToMutilSelector];
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewHomeworkItem *data = self.homeworkDetail[1][indexPath.section];
    if ([data.type isEqualToString:@"1"]) {//单选题
        UIHomeworkAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkAnswerCell"];
        cell.currentPath = indexPath;
        [cell hideExcessButton:data.choicenum];
        cell.answerItem.text = [NSString stringWithFormat:@"%ld",(indexPath.row + 1)];
        cell.answerDelegate = self;
        if ([data.desc hasPrefix:@"#单项选择题#"])
            [cell loadSelector:data.testAnswer[indexPath.row]];
        else
            [cell loadMutilSelector:data.testMutilAnswer[indexPath.row]];
        return cell;
    }
    else{
        NoSelectorForsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoSelectorForsCell"];
        cell.index = indexPath;
        cell.noSelectorForsCellDelegate =self;
        [cell loadPic:data.testPics];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - NoSelectorForsCellDelegate
- (void)didTouchDelete:(NSInteger)index withIndex:(NSIndexPath*)currentIndex{
    [((NewHomeworkItem *)(self.homeworkDetail[1][currentIndex.section])).testPics removeObjectAtIndex:index];
    [self.table reloadRowsAtIndexPaths:@[currentIndex] withRowAnimation:UITableViewRowAnimationNone];
}
- (void)didTouchHomeworkPic:(NSInteger)index withIndex:(NSIndexPath*)currentIndex{
    UFOFeedImageViewController *vc = [[UFOFeedImageViewController alloc]initWithPicArray:((NewHomeworkItem *)(self.homeworkDetail[1][currentIndex.section])).testPics andCurrentDisplayIndex:index];
    [self presentViewController:vc animated:YES completion:nil];
}
- (void)didTouchPicWithIndex:(NSIndexPath*)currentIndex{
    noSelectorIndex = currentIndex;
    [activeView showWithFinish:nil];
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
    if (((NewHomeworkItem *)(self.homeworkDetail[1][noSelectorIndex.section])).testPics.count == 5) {
        [((NewHomeworkItem *)(self.homeworkDetail[1][noSelectorIndex.section])).testPics replaceObjectAtIndex:4 withObject:UIImageJPEGRepresentation(image,0.000001)];
    }
    else{
        [((NewHomeworkItem *)(self.homeworkDetail[1][noSelectorIndex.section])).testPics addObject:UIImageJPEGRepresentation(image,0.000001)];
    }
    [self.table reloadRowsAtIndexPaths:@[noSelectorIndex] withRowAnimation:UITableViewRowAnimationNone];
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
        if (((NewHomeworkItem *)(self.homeworkDetail[1][noSelectorIndex.section])).testPics.count == 5) {
            [((NewHomeworkItem *)(self.homeworkDetail[1][noSelectorIndex.section])).testPics replaceObjectAtIndex:(idx + 5)%5 withObject:UIImageJPEGRepresentation(image,0.000001)];
        }
        else{
            [((NewHomeworkItem *)(self.homeworkDetail[1][noSelectorIndex.section])).testPics addObject:UIImageJPEGRepresentation(image,0.000001)];
        }
    }];
    weak(weakself);
    [imagePickerController.parentViewController dismissViewControllerAnimated:YES completion:^{
        [weakself.table reloadRowsAtIndexPaths:@[noSelectorIndex] withRowAnimation:UITableViewRowAnimationNone];
    }];
}
#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)image{
    if (((NewHomeworkItem *)(self.homeworkDetail[1][noSelectorIndex.section])).testPics.count == 5) {
        [((NewHomeworkItem *)(self.homeworkDetail[1][noSelectorIndex.section])).testPics replaceObjectAtIndex:4 withObject:UIImageJPEGRepresentation(image,0.000001)];
    }
    else{
        [((NewHomeworkItem *)(self.homeworkDetail[1][noSelectorIndex.section])).testPics addObject:UIImageJPEGRepresentation(image,0.000001)];
    }
    weak(weakself);
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        [weakself.table reloadRowsAtIndexPaths:@[noSelectorIndex] withRowAnimation:UITableViewRowAnimationNone];
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIHomeworkAnswerDelegate
- (void)didTouchAnswerWithIndex:(NSIndexPath *)index andCurrentIndex:(NSIndexPath*)currentindex{
    [((NewHomeworkItem *)(self.homeworkDetail[1][currentindex.section])).testAnswer replaceObjectAtIndex:index.section withObject:NSIntToNumber(index.row)];
}
- (void)didTouchMutilAnswerWithIndex:(NSIndexPath *)index andCurrentIndex:(NSIndexPath*)currentindex{
    NSMutableArray *currentMutilAnswer = ((NewHomeworkItem *)(self.homeworkDetail[1][currentindex.section])).testMutilAnswer[currentindex.row];
    if ([currentMutilAnswer containsObject:NSIntToNumber(index.row)]) {
        [currentMutilAnswer removeObject:NSIntToNumber(index.row)];
    }
    else{
        [currentMutilAnswer addObject:NSIntToNumber(index.row)];
    }
}

#pragma mark -event respond
- (void)disappearEdit{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
- (void)doSubmit{
    [UIHomeworkViewModel finishHomeworkWithParams:[self testGetPara] withFileDataArr:[self testGetData] withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"提交成功"];
            [NewHomeworkItem saveListModel:self.homeworkDetail[1] forKey:_homeworkid];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}

- (NSArray *)testGetData{
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSInteger i = 1; i <= [self.homeworkDetail[1] count]; i++) {
        NewHomeworkItem *item = [self.homeworkDetail[1] objectAtIndex:i-1];
        NSArray *imgArray = item.testPics;
        for (NSInteger j = 1; j<=imgArray.count; j++) {
            NSString *name = [NSString stringWithFormat:@"item_%ld_img_%ld",i,j];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",name];
            NSString *mimeType = @"image/jpeg";
            NSData *fileData = [imgArray objectAtIndex:j-1];
            NSDictionary *dic = @{ @"name":name,@"fileName":fileName,@"mimeType":mimeType,@"fileData":fileData };
            [dataArr addObject:dic];
        }
    }
    return dataArr;
}
- (NSDictionary *)testGetPara{
    NSMutableDictionary *otherPara = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":[GlobalVar instance].user.userid,@"itemnum":@([self.homeworkDetail[1] count])}];

    for (NSInteger i = 1; i <= [self.homeworkDetail[1] count]; i++){
        NewHomeworkItem *item = [self.homeworkDetail[1] objectAtIndex:i-1];

        NSString *keyItemInfo = [NSString stringWithFormat:@"item_%ld_id",i];
        NSString *valueItemInfo = item.item_id?item.item_id:@"";
        [otherPara setObject:valueItemInfo forKey:keyItemInfo];
        
        NSString *keyItemType = [NSString stringWithFormat:@"item_%ld_type",i];
        [otherPara setObject:item.type forKey:keyItemType];
        if ([item.type isEqualToString:@"1"]) {
            if ([item.desc hasPrefix:@"#单项选择题#"]){
                NSString *keyItemAnswer = [NSString stringWithFormat:@"item_%ld_selectanswer",i];
                [otherPara setObject:[item.testAnswer componentsJoinedByString:@","] forKey:keyItemAnswer];
            }
            else{
                NSString *keyItemAnswer = [NSString stringWithFormat:@"item_%ld_selectanswer",i];
                [item.testMutilAnswer enumerateObjectsUsingBlock:^(NSMutableArray *obj, NSUInteger idx, BOOL *stop) {
                    if (obj.count == 1) {
                        NSString *mutilAnswer = obj[0];
                        [item.testMutilAnswer replaceObjectAtIndex:idx withObject:mutilAnswer];
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
                        [item.testMutilAnswer replaceObjectAtIndex:idx withObject:mutilAnswer];
                    }
                    
                }];
                [otherPara setObject:[item.testMutilAnswer componentsJoinedByString:@","] forKey:keyItemAnswer];
            }
            
        }
        
        NSString *keyItemPicCount = [NSString stringWithFormat:@"item_%ld_imgscnt",i];
        [otherPara setObject:@(item.testPics.count) forKey:keyItemPicCount];

    };
    return otherPara;
}

#pragma private Method
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
#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT - 64);
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkAnswerCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkAnswerCell"];
        [_table registerNib:[UINib nibWithNibName:@"NoSelectorForsCell" bundle:nil] forCellReuseIdentifier:@"NoSelectorForsCell"];
    }
    return _table;
}
@end
