//
//  UIFriendsViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/24.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIInterActMemberViewController.h"
#import "MContact.h"
#import "MBProgressHUD+MJ.h"
#import "InterMenberCell.h"
#import "UIHomeworkViewModel.h"
@interface UIInterActMemberViewController()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@end
@implementation UIInterActMemberViewController{
    NSMutableArray *memberList;
    NSMutableArray *selectMember;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.title = @"互动圈";
    [self.view addSubview:self.table];
    [self initNav];
    [self initIvar];
    [self loadData];
}


#pragma mark - init Method
- (void)initNav{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"发送" style:UIBarButtonItemStylePlain target:self action:@selector(doSubmit)];
}
- (void)initIvar{
    memberList = [NSMutableArray array];
    selectMember = [NSMutableArray array];
}
#pragma mark - UITableViewDataSource And UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return memberList.count;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"名师";
            break;
        case 1:
            return @"朋友";
            break;
        case 2:
            return @"同学";
            break;
        default:
            return nil;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [memberList[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    InterMenberCell * cell = [tableView dequeueReusableCellWithIdentifier:@"InterMenberCell"];
    MContact *data = memberList[indexPath.section][indexPath.row];
    cell.nameLabel.text = data.username;
    [cell.headerImg sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(data.header_photo)] placeholderImage:DEFAULT_HEADER_f];
    if ([selectMember containsObject:data.userid]) {
        cell.selectImg.image = IMAGE(@"contacts_select");
    }
    else{
        cell.selectImg.image = IMAGE(@"select_contacts");
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    InterMenberCell * cell = (InterMenberCell*)[tableView cellForRowAtIndexPath:indexPath];
    MContact *data = memberList[indexPath.section][indexPath.row];
    if ([selectMember containsObject:data.userid]) {
        [selectMember removeObject:data.userid];
        cell.selectImg.image = IMAGE(@"select_contacts");
    }
    else{
        cell.selectImg.image = IMAGE(@"contacts_select");
        [selectMember addObject:data.userid];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - event response

- (void)loadData{
    weak(weakself);
    NSDictionary *para = [self getPara];
    [AFNetClient GlobalPost:kUrlContactList parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        NSLog(@"kUrlContactList = %@",dataDict);
        if(isUrlSuccess(dataDict))
        {
            dataDict = dataDict[@"data"];
            if ([dataDict objectForKey:@"teacherlist"] != nil&& [dataDict[@"teacherlist"] count]) {
                if ([dataDict[@"teacherlist"] isKindOfClass:[NSDictionary class]]) {
                    [memberList addObject:[MContact objectArrayWithKeyValuesArray: [dataDict[@"teacherlist"] allValues]]];
                }
                else{
                    [memberList addObject:[MContact objectArrayWithKeyValuesArray:dataDict[@"teacherlist"]]];
                }
            }
            if ([dataDict objectForKey:@"friendlist"] != nil&& [dataDict[@"friendlist"] count]) {
                [memberList addObject:[MContact objectArrayWithKeyValuesArray:[dataDict objectForKey:@"friendlist"]]];
            }
            if ([dataDict objectForKey:@"classmatelist"] != nil && [dataDict[@"classmatelist"] count]) {
                [memberList addObject:[MContact objectArrayWithKeyValuesArray:[dataDict objectForKey:@"classmatelist"]]];
            }
            [weakself.table reloadData];
        }} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD showError:@"网络异常😢"];
    }];
}



- (void)doSubmit{
    [UIHomeworkViewModel addquestionWithParams:[self testGetPara] withFileDataArr:[self testGetData] withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"发送成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
    }];
}


#pragma mark - private Method
- (NSDictionary *)getPara
{
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid};
    
    return para;
}

- (NSArray *)testGetData{
    if (self.ifFromHomework) {
        return nil;
    }
    NSMutableArray *dataArr = [NSMutableArray array];
    if (self.picArray.count) {
        for (NSInteger j = 1; j<=[self.picArray count]; j++) {
            NSString *name = [NSString stringWithFormat:@"item_img_%ld",j];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",name];
            NSString *mimeType = @"image/jpeg";
            NSData *fileData = [self.picArray objectAtIndex:j-1];
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
    if (self.ifFromHomework) {
        NSMutableDictionary __block *otherPara = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":[GlobalVar instance].user.userid,@"formgroupid":@0,@"subjectid":_subjectid?_subjectid:@0,@"item_info":_item_info?_item_info:@"",@"item_imgscnt":@(self.picUrlArray.count),@"toIds":[selectMember componentsJoinedByString:@","]}];
        if (self.picUrlArray.count && self.picUrlArray.count >0) {
            [self.picUrlArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
                NSString *name = [NSString stringWithFormat:@"item_img_%ld",idx+1];
                NSString *picFile = UrlResStringForImg(obj);
                [otherPara setObject:picFile forKey:name];
            }];
        }
        if (self.audioUrl.length >0) {
            [otherPara setObject:UrlResStringForImg(self.audioUrl) forKey:@"item_audio"];
        }
        
        return otherPara;
    }
    else{
        NSDictionary *otherPara = @{@"userid":[GlobalVar instance].user.userid,@"formgroupid":@0,@"subjectid":_subjectid?_subjectid:@0,@"item_info":_item_info?_item_info:@"",@"item_imgscnt":@(self.picArray.count),@"toIds":[selectMember componentsJoinedByString:@","]};
        return otherPara;
    }
    
}
#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT - 64);
        _table.showsVerticalScrollIndicator = NO;
        _table.delegate = self;
        _table.dataSource = self;
        [_table registerNib:[UINib nibWithNibName:@"InterMenberCell" bundle:nil] forCellReuseIdentifier:@"InterMenberCell"];
    }
    return _table;
}
@end
