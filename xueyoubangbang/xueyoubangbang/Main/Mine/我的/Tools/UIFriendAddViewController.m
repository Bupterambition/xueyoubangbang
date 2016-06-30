//
//  UIFriendAddViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/4/4.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIFriendAddViewController.h"
#import "UIMineCell.h"
#import "UIFriendInfoViewController.h"
#import "QRCodeGenerator.h"
#import "RootViewController.h"
#import "ZBarReaderViewController.h"
@interface UIFriendAddViewController()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZBarReaderDelegate>
{
    UITableView *table;
    
    UISearchBar *searchBar;
    UISearchDisplayController *searchDisplayController;
    NSArray *searchResult;
    
    int num;
    BOOL upOrdown;
    NSTimer * timer;
    
    UIImageView *_line;
}
@end

@implementation UIFriendAddViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];
}

- (void)createView
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"添加好友";
    
    table = CREATE_TABLE(UITableViewStylePlain);
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
    [self createSearchBar];
    
    table.tableHeaderView = searchBar;
    
     self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(doCancel)];
}

- (void)createSearchBar
{
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) ];
    searchBar.placeholder = @"输入手机号/帮帮号";
    searchBar.delegate = self;
    searchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
    searchDisplayController.searchResultsTableView.editing = YES;
    searchDisplayController.searchResultsTableView.allowsMultipleSelectionDuringEditing = YES;
    // searchResultsDataSource 就是 UITableViewDataSource
    searchDisplayController.searchResultsDataSource = self;
    // searchResultsDelegate 就是 UITableViewDelegate
    searchDisplayController.searchResultsDelegate = self;
    searchDisplayController.searchResultsTableView.editing = NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == table)
    {
        return 2;
    }
    return searchResult.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(table == tableView)
    {
        NSString *cellId = @"cellID0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        if(indexPath.row == 0)
        {
            cell.textLabel.text = @"我的二维码";
        }
        else
        {
            cell.textLabel.text = @"扫一扫";
            cell.detailTextLabel.text = @"扫描二维码名片";
        }
        return cell;

    }
    else
    {
    NSString *cellId = @"cellID";
    UIMineCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell == nil)
    {
        cell = [[UIMineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    MUser *m = [searchResult objectAtIndex:indexPath.row];
    cell.textLabel.text = m.username;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(m.header_photo) ] placeholderImage:DEFAULT_HEADER];
    
    return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == table)
    {
        if(indexPath.row == 0)
        {
            [self doMyQR];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
        else
        {
            [self doCapture];
            [tableView deselectRowAtIndexPath:indexPath animated:YES];
        }
    }
    else
    {
        UIFriendInfoViewController *ctrl = [[UIFriendInfoViewController alloc] init];
        ctrl.user = [searchResult objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}

//- (void)searchBar:(UISearchBar *)SearchBar textDidChange:(NSString *)searchText
//{
//    if(![CommonMethod isBlankString:searchText])
//    {
//        [self doSearch:searchText];
//    }
//}


- (void)searchBarSearchButtonClicked:(UISearchBar *)_searchBar
{
    [self doSearch:searchBar.text];
}


- (void)doSearch:(NSString *)searchText
{
//    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlGetUserInfo parameters:@{@"userid":searchText} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
//        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            MUser *user = [MUser objectWithDictionary:[dataDict objectForKey:@"user"]];
            searchResult = @[user];
            [searchDisplayController.searchResultsTableView reloadData];
        }
        else
        {
            searchResult = @[];
            [searchDisplayController.searchResultsTableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        searchResult = @[];
        [searchDisplayController.searchResultsTableView reloadData];
    }];

}

- (void)doSendAddFriendReq:(MUser *)user
{
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlAddFriendReq parameters:@{@"id":user.userid} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict))
        {
            [CommonMethod showAlert:@"发送成功"];
        }
        else
        {
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [CommonMethod showAlert:@"发送失败"];
    }];
}

- (void)doMyQR
{
    
    UIView *container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    container.frame = CGRectMake(40, 150, SCREEN_WIDTH - 80, 300);
    
    UIView *top = [[UIView alloc] init];
    [container addSubview:top];
    
    UIImageView *header = [[UIImageView alloc] init];
    header.frame = CGRectMake(20, 20, 40, 40);
    header.contentMode = UIViewContentModeScaleToFill;
    header.image = [GlobalVar instance].header?[GlobalVar instance].header:DEFAULT_HEADER;
    [top addSubview:header];
    
    UILabel *username = [[UILabel alloc] init];
    username.textAlignment = NSTextAlignmentLeft;
    username.frame = CGRectMake([header rightX] + 10, header.frame.origin.y , 160, 20);
    username.text = [GlobalVar instance].user.username;
    username.adjustsFontSizeToFitWidth = YES;
    [top addSubview:username];
    
    UILabel *schoolInfo = [[UILabel alloc] init];
    schoolInfo.textAlignment = NSTextAlignmentLeft;
    schoolInfo.frame = CGRectMake(username.frame.origin.x, [username bottomY] , 170, 20);
    schoolInfo.text = [GlobalVar instance].user.schoolinfo;
    schoolInfo.font = FONT_CUSTOM(14);
    schoolInfo.adjustsFontSizeToFitWidth = YES;
    [top addSubview:schoolInfo];
    
    
    UIImageView *qrView = [[UIImageView alloc] init];
    qrView.frame = CGRectMake(0, [header bottomY] - 10, container.frame.size.width, container.frame.size.width );
    qrView.contentMode = UIViewContentModeScaleToFill;
//    qrView.backgroundColor = [UIColor redColor];
    [container addSubview:qrView];
    UIImage *qrImage = [QRCodeGenerator qrImageForString: [NSString stringWithFormat:@"friendid:%@", [GlobalVar instance].user.userid] imageSize:qrView.frame.size.width];
    qrView.image = qrImage;
    
    UILabel *bottomLabel = [[UILabel alloc] init];
    bottomLabel.frame = CGRectMake(0, [qrView bottomY] - 15, container.frame.size.width, 20);
    bottomLabel.text = @"扫一扫二维码添加好友";
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.font = FONT_CUSTOM(14);
    bottomLabel.textColor = [UIColor blackColor];
    [container addSubview:bottomLabel];

    [LayerCustom showFadeInWithView:container];
    
}

- (void)doCapture
{
    [self setupCamera];
}

-(void)setupCamera
{
    if(IOS_VERSION_7_OR_ABOVE)
    {
        RootViewController * rt = [[RootViewController alloc]init];
        rt.superViewController = self;
        [self presentViewController:rt animated:YES completion:nil];
        
    }
    else
    {
        [self scanBtnAction];
    }
}
-(void)scanBtnAction
{
    num = 0;
    upOrdown = NO;
    //初始话ZBar
    ZBarReaderViewController * reader = [ZBarReaderViewController new];
    //设置代理
    reader.readerDelegate = self;
    //支持界面旋转
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsHelpOnFail = NO;
    reader.scanCrop = CGRectMake(0.1, 0.2, 0.8, 0.8);//扫描的感应框
    ZBarImageScanner * scanner = reader.scanner;
    [scanner setSymbology:ZBAR_I25
                   config:ZBAR_CFG_ENABLE
                       to:0];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 420)];
    view.backgroundColor = [UIColor clearColor];
    reader.cameraOverlayView = view;
    
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 280, 40)];
    label.text = @"将二维码图像置于矩形方框内，离手机摄像头10CM左右，系统会自动识别。";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = 1;
    label.lineBreakMode = 0;
    label.numberOfLines = 2;
    label.backgroundColor = [UIColor clearColor];
    [view addSubview:label];
    
    UIImageView * image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    image.frame = CGRectMake(20, 80, 280, 280);
    [view addSubview:image];
    
    
    _line = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _line.image = [UIImage imageNamed:@"line.png"];
    [image addSubview:_line];
    //定时器，设定时间过1.5秒，
    timer = [NSTimer scheduledTimerWithTimeInterval:.02 target:self selector:@selector(animation1) userInfo:nil repeats:YES];
    
    [self presentViewController:reader animated:YES completion:nil];
}
-(void)animation1
{
    if (upOrdown == NO) {
        num ++;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (2*num == 260) {
            upOrdown = YES;
        }
    }
    else {
        num --;
        _line.frame = CGRectMake(30, 10+2*num, 220, 2);
        if (num == 0) {
            upOrdown = NO;
        }
    }
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
    }];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [timer invalidate];
    _line.frame = CGRectMake(30, 10, 220, 2);
    num = 0;
    upOrdown = NO;
    [picker dismissViewControllerAnimated:YES completion:^{
        [picker removeFromParentViewController];
        UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //初始化
        ZBarReaderController * read = [ZBarReaderController new];
        //设置代理
        read.readerDelegate = self;
        CGImageRef cgImageRef = image.CGImage;
        ZBarSymbol * symbol = nil;
        id <NSFastEnumeration> results = [read scanImage:cgImageRef];
        for (symbol in results)
        {
            break;
        }
        NSString * result;
        if ([symbol.data canBeConvertedToEncoding:NSShiftJISStringEncoding])
            
        {
            result = [NSString stringWithCString:[symbol.data cStringUsingEncoding: NSShiftJISStringEncoding] encoding:NSUTF8StringEncoding];
        }
        else
        {
            result = symbol.data;
        }
        
        
        NSLog(@"%@",result);
        if([CommonMethod isBlankString:result])
        {
            [CommonMethod showAlert:@"二维码有误"];
            return ;
        }
        
        NSArray *subs = [result componentsSeparatedByString:@":"];
        if(subs.count != 2)
        {
            [CommonMethod showAlert:@"二维码有误"];
            return;
        }
        
        if( [@"friendid" isEqualToString: [subs objectAtIndex:0]])
        {
            NSString *friendid = [subs objectAtIndex:1];
            [self friendInfo:friendid];
        }
        else
        {
            [CommonMethod showAlert:@"二维码有误"];
        }
        
    }];
}

- (void)friendInfo:(NSString *)userid
{
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlGetUserInfo parameters:[CommonMethod getParaWithOther:@{@"id":userid}] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];

        if(isUrlSuccess(dataDict))
        {
            MUser *m = [MUser objectWithDictionary:[dataDict objectForKey:@"user"]];
            if(m!=nil)
            {
                UIFriendInfoViewController *ctrl = [[UIFriendInfoViewController alloc] init];
                ctrl.user = m;
                [self.navigationController pushViewController:ctrl animated:YES];
            }else
            {
                [CommonMethod showAlert:@"未找到用户"];
            }
        }
        else
        {
            [CommonMethod showAlert:urlErrorMessage(dataDict)];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        [CommonMethod showAlert:@"网络异常"];
    }];
}


- (void)doCancel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
