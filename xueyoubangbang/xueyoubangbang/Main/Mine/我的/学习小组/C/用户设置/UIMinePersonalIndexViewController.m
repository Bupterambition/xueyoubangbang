//
//  UIMinePersonalIndexViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMinePersonalIndexViewController.h"
#import "UIMineClassIndexViewController.h"
#import "ClassEditView.h"
#import "MClass.h"
#import "UIMineCell.h"
#import "UIMineModifyUsernameViewController.h"
#import "UIPhoneViewController.h"
#import "UIMineModifyQQ.h"
#import "UIModifyPassword.h"
#import "VPImageCropperViewController.h"
#import "UILoginViewController.h"
#import "MainTabViewController.h"
#import "PrivateClassEditView.h"
#import "UIAboutViewController.h"
#import "UISettingMessageViewController.h"
#import "MBProgressHUD+MJ.h"

@interface UIMinePersonalIndexViewController ()<VPImageCropperDelegate>
{
    UITableView *table;
    NSMutableArray *classArr;//公立学校
    NSMutableArray *classArr2;//辅导学校
    NSArray *section1Arr;
    NSArray *sectionForStudent;
    ChooseGetPictureView *activeView;
    ClassEditView *classEditView;
    PrivateClassEditView *privateClassEditView;
}
@end

@implementation UIMinePersonalIndexViewController

- (id)init
{
    self = [super init];
    if(self){
        self.hidesBottomBarWhenPushed = YES;
        section1Arr = @[@"修改昵称",@"我的学校",@"手机号",@"QQ",@"修改密码",@"关于学有帮帮",@"清除缓存"];
        sectionForStudent = @[@"修改昵称",@"我的学校",@"手机号",@"QQ",@"修改密码",@"关于学有帮帮",@"消息设置",@"清除缓存"];
        classArr = [NSMutableArray array];
        classArr2 = [NSMutableArray array];
    }
    return self;
}
#pragma mark - life Circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createViews];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - init Method

- (void)loadData{
    [AFNetClient GlobalGet:kUrlGetAllUserClass parameters:@{@"id":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict){
        NSLog(@"%@ = %@",kUrlGetUserClass,dataDict);
        NSArray *list = [dataDict objectForKey:@"list"];
         for (NSDictionary *dic in list) {
             MClass *m = [MClass objectWithDictionary:dic];
             [GlobalVar instance].myClass = m;
             [GlobalVar instance].user.schoolinfo = m.class_name;
         }
        [table reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error){
         [CommonMethod showAlert:@"服务异常"];
    }];
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"个人信息";
    table = CREATE_TABLE(UITableViewStylePlain);
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, 0,SCREEN_WIDTH,self.view.frame.size.height - kNavigateBarHight);
    table.sectionHeaderHeight = 20;
    [self.view addSubview:table];
}

#pragma mark - event Respont

- (void)doLogout
{
    [GlobalVar instance].user = nil;
    
    [self presentViewController:[[UICustomNavigationViewController alloc] initWithRootViewController:[[UILoginViewController alloc]init]] animated:YES completion:nil];
}

- (void)showEditView
{
    if(!classEditView)
    {
        classEditView = [[ClassEditView alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, CELL_HEIGHT * 3 + 80)];
        [classEditView.btnSure addTarget:self action:@selector(doSureClassEdit) forControlEvents:UIControlEventTouchUpInside];
        [classEditView.btnCancel addTarget:self action:@selector(hideEditView) forControlEvents:UIControlEventTouchUpInside];
        UIView *layer = [CommonMethod showWindowLayer];
        [layer addSubview:classEditView];
        //隐藏键盘
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap)];
        [layer addGestureRecognizer:tap];
        tap.delegate = self;
    }
    
}

- (void)showPrivateClassEditView
{
    if(!privateClassEditView)
    {
        privateClassEditView = [[PrivateClassEditView alloc]initWithFrame:CGRectMake(0, 130, SCREEN_WIDTH, CELL_HEIGHT * 3 + 80)];
        [privateClassEditView.btnSure addTarget:self action:@selector(doSurePrivateClassEdit) forControlEvents:UIControlEventTouchUpInside];
        [privateClassEditView.btnCancel addTarget:self action:@selector(hideEditView) forControlEvents:UIControlEventTouchUpInside];
        UIView *layer = [CommonMethod showWindowLayer];
        [layer addSubview:privateClassEditView];
        //隐藏键盘
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap)];
        [layer addGestureRecognizer:tap];
        tap.delegate = self;
    }
    
}

- (void)hideEditView
{
    [classEditView removeFromSuperview];
    classEditView = nil;
    [privateClassEditView removeFromSuperview];
    privateClassEditView = nil;
    [CommonMethod hideWindowLayer];
}

- (void)doTap
{
    [classEditView removeTableResult];
    [[classEditView findFirstResponder] resignFirstResponder];
    [privateClassEditView removeTableResult];
    [[privateClassEditView findFirstResponder] resignFirstResponder];
}
#pragma mark - UIGestureRecognizerDelegate
//如果不写该段甘薯，则UITableView的点击回调不会执行
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:classEditView.table] || [touch.view isDescendantOfView:classEditView.tableResult]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    if ([touch.view isDescendantOfView:privateClassEditView.table] || [touch.view isDescendantOfView:privateClassEditView.tableResult]) {
        
        // Don't let selections of auto-complete entries fire the
        // gesture recognizer
        return NO;
    }
    return YES;
}
#pragma mark - UITableviewDataSource and UITableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            if (ifRoleTeacher) {
                return 2;
            }
            else
                return 2;
        default:
            return 1;
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionPadding;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        return 90;
    }
    else{
        return 44;
    }
}

#define ivTag 10000
#define lb1Tag 10001
#define lb2Tag 10002
#define rightLable1Tag 10000
#define rightLable2Tag 10001
#define leftLabelTag 10002
#define middleLabelTag 10003
#define cell_h 44
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier ;
    UITableViewCell *cell;
    if(indexPath.section == 0){
        CellIdentifier = @"cellIdentifier0";
        cell  = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UIMineCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            cell.accessoryType = UITableViewCellAccessoryNone;
            UILabel *lb1 = [[UILabel alloc] init];
            lb1.frame = CGRectMake(93, 10, 200, 20);
            lb1.tag = lb1Tag;
            lb1.text = [GlobalVar instance].user.username;
            [cell.contentView addSubview:lb1];
            
            UILabel *lb2 = [[UILabel alloc] init];
            lb2.frame = CGRectMake(93, 50, 200, 20);
            lb2.font = FONT_CUSTOM(14);
            lb2.tag = lb2Tag;
            lb2.text = [NSString stringWithFormat:@"帮帮号:%@",[GlobalVar instance].user.userid];
            [cell.contentView addSubview:lb2];
        }
        if([GlobalVar instance].header == nil)
        {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString([GlobalVar instance].user.header_photo)] placeholderImage:DEFAULT_HEADER completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [GlobalVar instance].header = image;
                cell.imageView.image = image;
            }];
        }
        else {
            cell.imageView.image = [GlobalVar instance].header;
        }
        
    }
    else if(indexPath.section == 1){
        CellIdentifier = @"cellIdentifier1";
        cell  = [table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        if (ifRoleTeacher) {
            cell.textLabel.text = [section1Arr objectAtIndex:indexPath.row];
            NSString *detail;
            switch (indexPath.row) {
                case 0:
                    detail = [GlobalVar instance].user.username;
                    break;
                case 1:
                    detail = [GlobalVar instance].user.schoolinfo == nil?[GlobalVar instance].myClass.class_name:[GlobalVar instance].user.schoolinfo;
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    break;
                case 2:
                    detail = [GlobalVar instance].user.phone;
                    break;
                case 3:
                    detail = [GlobalVar instance].user.qq;
                    break;
                case 4:
                    detail = nil;
                    break;
                case 5:
                    detail = nil;
                    break;
                case 6:
                    if (ifRoleTeacher){
                        detail = [NSString stringWithFormat:@"%0.1f",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
                    }
                    break;
                case 7:
                    detail = [NSString stringWithFormat:@"%0.1f",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
                    break;
                default:
                    break;
            }
            if([CommonMethod isBlankString:detail])
            {
                if(indexPath.row !=4 && indexPath.row !=5&&indexPath.row != 6 && indexPath.row != 7)
                {
                    detail = @"去绑定";
                }
            }
            cell.detailTextLabel.text = detail;
        }
        else{
            cell.textLabel.text = [sectionForStudent objectAtIndex:indexPath.row];
            NSString *detail;
            switch (indexPath.row) {
                case 0:
                    detail = [GlobalVar instance].user.username;
                    break;
                case 1:
                    detail = [GlobalVar instance].user.schoolinfo == nil?[GlobalVar instance].myClass.class_name:[GlobalVar instance].user.schoolinfo;
                    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    break;
                case 2:
                    detail = [GlobalVar instance].user.phone;
                    break;
                case 3:
                    detail = [GlobalVar instance].user.qq;
                    break;
                case 4:
                    detail = nil;
                    break;
                case 5:
                    detail = nil;
                    break;
                case 6:
                    if (ifRoleTeacher){
                        detail = [NSString stringWithFormat:@"%0.1f",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
                    }
                    break;
                case 7:
                    detail = [NSString stringWithFormat:@"%0.1f",[[SDImageCache sharedImageCache] getSize]/1024.0/1024.0];
                    break;
                default:
                    break;
            }
            if([CommonMethod isBlankString:detail])
            {
                if(indexPath.row !=4 && indexPath.row !=5&&indexPath.row != 6 && indexPath.row != 7)
                {
                    detail = @"去绑定";
                }
            }
            cell.detailTextLabel.text = detail;
        }
    }
   
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0){
        if(!activeView){
            activeView = [[ChooseGetPictureView alloc] initWithViewContrller:self cameraDelegate:self photoDelegate:self];
        }
        [activeView showWithFinish:^(BOOL finished) {
            
        }];
    }
    else if(indexPath.section == 1){
        UIViewController *ctrl ;
        switch (indexPath.row) {
            case 0:
                ctrl = [[UIMineModifyUsernameViewController alloc] init];
                [self.navigationController pushViewController:ctrl animated:YES];
                break;
            case 1:
                [self showEditView];
                break;
            case 2:
                ctrl = [[UIPhoneViewController alloc] init];
                [self.navigationController pushViewController:ctrl animated:YES];
                break;
            case 3:
                ctrl = [[UIMineModifyQQ alloc] init];
                [self.navigationController pushViewController:ctrl animated:YES];
                break;
            case 4:
                ctrl = [[UIModifyPassword alloc] init];
                [self.navigationController pushViewController:ctrl animated:YES];
                break;
            case 5:
                ctrl = [[UIAboutViewController alloc] init];
                [self.navigationController pushViewController:ctrl animated:YES];
                break;
            case 6:
                if (ifRoleStudent) {
                    [self.navigationController pushViewController:[[UISettingMessageViewController alloc] init] animated:YES];
                }
                else{
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                        [MBProgressHUD showSuccess:@"清理完毕"];
                        [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:6 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                    }];
                }
                break;
            case 7:{
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                    [MBProgressHUD showSuccess:@"清理完毕"];
                    [table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:7 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }
                break;
            default:
                break;
        }
    }
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - private Method
- (UIImageView *)headerImageView
{
    UITableViewCell *cell = [table cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UIImageView *imageView = cell.imageView;
    return imageView;
}

#pragma mark cameraDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //得到图片
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    //图片存入相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [picker dismissViewControllerAnimated:YES completion:nil];
    VPImageCropperViewController *vpCtrl = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, SCREEN_HEIGHT / 2-SCREEN_WIDTH / 2, SCREEN_WIDTH, SCREEN_WIDTH) limitScaleRatio:3];
    vpCtrl.delegate = self;
    [self presentViewController:vpCtrl animated:YES completion:nil];
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
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
        // 以下为调整图片角度的部分
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        // 调整图片角度完毕
    }
    [imagePickerController.parentViewController dismissViewControllerAnimated:YES completion:nil];
    
    VPImageCropperViewController *vpCtrl = [[VPImageCropperViewController alloc] initWithImage:image cropFrame:CGRectMake(0, SCREEN_HEIGHT / 2-SCREEN_WIDTH / 2, SCREEN_WIDTH, SCREEN_WIDTH) limitScaleRatio:3];
    vpCtrl.delegate = self;
    [self presentViewController:vpCtrl animated:YES completion:nil];
    
    
    
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    [self headerImageView].image = editedImage;
    [self doUploadHeader:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}


- (void)doUploadHeader:(UIImage *)image
{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        //子线程
        NSString *mimeType = @"image/jpeg";
        NSString *name = @"item_image";
        NSString *filename = [NSString stringWithFormat:@"%@%@",name,@".jpeg"];
        NSData *fileData = UIImageJPEGRepresentation(image, 0.5);
        
        [GlobalVar instance].header = [UIImage imageWithData:fileData];
        
        // 主线程执行：
        //        dispatch_async(dispatch_get_main_queue(), ^{
        // 刷新UI
        [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
        [AFNetClient GlobalMultiPartPost:kUrlUploadHeader fileDataArr:@[@{@"name":name,@"fileName":filename,@"mimeType":mimeType,@"fileData":fileData }] parameters:@{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDcit) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            if(isUrlSuccess(dataDcit))
            {
                [GlobalVar instance].user.header_photo = [[dataDcit objectForKey:@"user"] objectForKey:@"header_photo"];
                [GlobalVar instance].user = [GlobalVar instance].user;
                [CommonMethod showAlert:@"修改成功"];
            }
            else
            {
                [CommonMethod showAlert:urlErrorMessage(dataDcit)];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            [CommonMethod showAlert:@"修改失败"];
        }];
        //        });
    });
    
}

- (void)doSureClassEdit
{
    if([CommonMethod isBlankString:classEditView.currentSchoolId])
    {
        [CommonMethod showAlert:@"请选择学校"];
        return;
    }
    
    if([CommonMethod isBlankString:classEditView.currentGrade] || [CommonMethod isBlankString:classEditView.currentClass] )
    {
        [CommonMethod showAlert:@"信息不完整"];
        return;
    }
    
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"schoolid":classEditView.currentSchoolId,@"schoolname":classEditView.currentScooolName,@"classid":classEditView.currentClass,@"gradeid":classEditView.currentGrade};
    NSLog(@"kUrlSetClassInfo para = %@",para);
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [self doExit];
    [AFNetClient GlobalGet:kUrlSetClassInfo parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict)
     {
         NSLog(@"%@",dataDict);
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            [self hideEditView];
            [self loadData];
        }
        else{
            [CommonMethod showAlert:@"添加失败"];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [CommonMethod showAlert:@"添加失败"];
    }];
    
}

- (void)doExit
{
    if ([GlobalVar instance].myClass == nil) {
        return;
    }
    [AFNetClient GlobalGet:kUrlQuitClass parameters:[CommonMethod getParaWithOther:@{@"id":[GlobalVar instance].myClass.class_info_id}] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        if(!isUrlSuccess(dataDict))
        {
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [CommonMethod showAlert:@"退出失败"];
    }];
}

-(void)doSurePrivateClassEdit
{
    if([CommonMethod isBlankString:privateClassEditView.currentSchoolId])
    {
        [CommonMethod showAlert:@"请选择学校"];
        return;
    }
    
    if([CommonMethod isBlankString:privateClassEditView.currentGrade] || [CommonMethod isBlankString:privateClassEditView.currentClass] )
    {
        [CommonMethod showAlert:@"信息不完整"];
        return;
    }
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"schoolid":privateClassEditView.currentSchoolId,@"schoolname":privateClassEditView.currentScooolName,@"classid":privateClassEditView.currentClass,@"gradeid":privateClassEditView.currentGrade};
    NSLog(@"kUrlSetClassInfo para = %@",para);
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlSetClassInfo parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict)
     {
         NSLog(@"%@",dataDict);
         [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
         if(isUrlSuccess(dataDict))
         {
             [self hideEditView];
             [self loadData];
         }
         else{
             [CommonMethod showAlert:@"添加失败"];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
         [CommonMethod showAlert:@"添加失败"];
     }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
