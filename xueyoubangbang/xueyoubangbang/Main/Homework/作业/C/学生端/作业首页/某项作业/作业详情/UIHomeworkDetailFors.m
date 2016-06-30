//
//  UIHomeworkDetailFors.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkDetailFors.h"
#import "UIHomeworkAddCell.h"
#import "NSDate+Format.h"
#import "UIHomeworkBottomView.h"
#import "NewHomeWorkSend.h"
#import "NewHomeworkFileSend.h"
#import "UFOFeedImageViewController.h"
#import "UIHomeworkStudentDetailCell.h"
#import "MBProgressHUD+MJ.h"
#import "UIHomeworkViewModel.h"
#import "NewHomeworkItem.h"
#import "UIHomeworkDoHomeworkForS.h"
#import "StudentGroupViewModel.h"
#import "UIHomeworkModels.h"
#import "UIInterActAskViewController.h"
#import "UITableView+FDTemplateLayoutCell.h"
typedef NS_ENUM(NSInteger, ADDHOMEWORK){
    HOMEWORKTITLE,
    SUBMMITTIME,
    KNOWLEDGE
};
typedef NS_ENUM(NSInteger, BottomMethod){
    NoSelectorItem = 0,
    SelectorItem,
    Method_Cancel
};
typedef NS_ENUM(NSInteger, CELLHEIGHT){
    NOPICANDAUDIO = 80,
    ONELINEPIC = 189,
    TWOLINEPIC = 293
};

@interface UIHomeworkDetailFors ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIHomeworkStudentDetailDelegate>
@property (nonatomic, strong) UITableView *table;


@end

@implementation UIHomeworkDetailFors{
    NSArray *cellTitles;
    NSString *homeworkTitles;
    NSMutableArray *homeworkData;
    NSString *homeworkTitle;
}
#pragma mark - life circle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initIvar];
    [self.view addSubview:self.table];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDetailHomeWork];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews{
    [self initTable];
}
#pragma mark - init Method
- (void)initView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"作业详情";
    
}
- (void)initIvar{
    cellTitles = @[@"作业题目",@"提交时间",@"知识点"];
    
}
- (void)initTable{
    self.table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT-64);
}
- (void)loadDetailHomeWork{
    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [UIHomeworkViewModel getHomeworkDetailWithParams:@{@"homeworkid":_home_work_id} withCallBack:^(NSArray *homeWorkDetail,BOOL noNet) {
        if (homeWorkDetail != nil) {
            [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
            homeworkData = [NSMutableArray arrayWithArray:homeWorkDetail];
            [self.table reloadData];
        }
        else{
            [MBProgressHUD hideAllHUDsForView:[UIApplication sharedApplication].keyWindow animated:YES];
        }
        
    }];
}
#pragma mark - UITableViewDelegate and UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 45;
    }
    else{
        CGFloat collectionHeight;
        NSInteger picNum = [(NewHomeworkItem*)(homeworkData[1][indexPath.section-1]) getPicArray].count;
        picNum +=  [CommonMethod isBlankString:((NewHomeworkItem*)(homeworkData[1][indexPath.section-1])).audio]?0:1;
        if (picNum == 0){
            collectionHeight = 0;
        }
        else if (picNum >3){
            collectionHeight = 190;
        }
        else{
            collectionHeight = 100;
        }
        
        return collectionHeight + [tableView fd_heightForCellWithIdentifier:@"UIHomeworkStudentDetailCell" cacheByIndexPath:indexPath configuration:^(UIHomeworkStudentDetailCell *cell) {
            [cell loadItemDataForCheck:homeworkData[1][indexPath.section -1]];
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1 + (homeworkData == nil?0:[homeworkData[1] count]);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return section == 0?3:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UIHomeworkAddCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkAddCell"];
        cell.title.text = cellTitles[indexPath.row];
        cell.editField.enabled = NO;
        if (indexPath.row ==2) {
            cell.editField.delegate = self;
        }
        [cell.editImageView removeFromSuperview];
        [cell loadHomeworkForStudent:homeworkData[0] withIndex:indexPath];
        homeworkTitle = cell.editField.text;
        return cell;
    }
    else{
        UIHomeworkStudentDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIHomeworkStudentDetailCell"];
        cell.itemNum.text = [NSString stringWithFormat:@"第%ld项",indexPath.section];
        cell.checkDetailDelegate = self;
        cell.currentIndex = indexPath;
        [cell loadItemDataForCheck:homeworkData[1][indexPath.section -1]];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UIHomeworkStudentDetailDelegate
- (void)didTouchHomeworkPic:(NSInteger)index withIndex:(NSIndexPath *)indexPath{
    UFOFeedImageViewController *vc = [[UFOFeedImageViewController alloc]initWithCheckPicArray:[(NewHomeworkItem*)(homeworkData[1][indexPath.section-1]) getPicArray] andCurrentDisplayIndex:index];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didTouchAddNote:(NSIndexPath *)indexPath{
    [StudentGroupViewModel addNoteWithParams:[self testGetPara:indexPath] withFileDataArr:nil withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"已添加到笔记本"];
        }
    }];
}

- (void)didTouchAskQuestion:(NSIndexPath *)indexPath{
    NewHomeworkItem *data = homeworkData[1][indexPath.section -1];
    
    UIInterActAskViewController *vc = [[UIInterActAskViewController alloc] initWithNibName:@"UIInterActAskViewController" bundle:nil];
    vc.audioUrl = data.audio;
    vc.picUrlArray = [NSMutableArray arrayWithArray:[data getPicArray]];
    vc.subject_id = [(NewHomeworkInfo*)homeworkData[0] subject_id];
    vc.itemInfo = data.desc;
    vc.ifFromHomework = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    [self.table reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    return YES;
}
#pragma mark - event respond
- (void)doHomework{
    if (_ifSubmit) {
        [self saveForWork];
        UIHomeworkDoHomeworkForS *vc = [[UIHomeworkDoHomeworkForS alloc] initWithHomeWork:homeworkData];
        vc.homeworkid = _home_work_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        UIHomeworkDoHomeworkForS *vc = [[UIHomeworkDoHomeworkForS alloc] initWithHomeWork:homeworkData];
        vc.homeworkid = _home_work_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}


#pragma mark - private Method

- (NSDictionary *)testGetPara:(NSIndexPath*)indexPath{
    NewHomeworkInfo *info = homeworkData[0];
    NewHomeworkItem *data = homeworkData[1][indexPath.section -1];
    NSMutableDictionary *otherPara = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":[GlobalVar instance].user.userid,@"subjectid":info.subject_id?info.subject_id:@0,@"item_info":data.desc?data.desc:@"",@"item_imgscnt":@([data getPicArray].count)}];
    if ([data getPicArray].count) {
        for (NSInteger j = 1; j<=[data getPicArray].count; j++) {
            NSString *name = [NSString stringWithFormat:@"item_img_%ld",j];
            [otherPara setObject:UrlResStringForImg([data getPicArray][j-1]) forKey:name];
        }
    }
    
    if(![CommonMethod isBlankString:data.audio]){
        [otherPara setObject:UrlResStringForImg(data.audio) forKey:@"item_audio"];
    }
    return otherPara;
}

- (NSArray *)getFileData:(NSIndexPath*)indexPath{
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    NSMutableArray *dataArr = [NSMutableArray array];
    NewHomeworkItem *data = homeworkData[1][indexPath.section -1];
    if ([data getPicArray].count) {
        for (NSInteger j = 1; j<=[data getPicArray].count; j++) {
            NSString *name = [NSString stringWithFormat:@"item_img_%ld",j];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",name];
            NSString *mimeType = @"image/jpeg";
            NSData *fileData =UIImagePNGRepresentation( [imageCache imageFromDiskCacheForKey:UrlResStringForImg([data getPicArray][j-1])]);
            NSDictionary *dic = @{ @"name":name,@"fileName":fileName,@"mimeType":mimeType,@"fileData":fileData };
            [dataArr addObject:dic];
        }
    }
    
//    if(![CommonMethod isBlankString:data.audio]){
//        NSDictionary *audio = @{@"name": @"item_audio",@"fileName":@"audio.amr",@"fileData":[NSURL],@"mimeType":@"audio/amr"};
//        [dataArr addObject:audio];
//    }
  
    return dataArr;
}
- (void)saveForWork{
    homeworkData[1] = [NSMutableArray arrayWithArray:[NewHomeworkItem readListModelForKey:_home_work_id]];
}

#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.delegate = self;
        _table.dataSource = self;
        _table.sectionHeaderHeight = 5;
        _table.sectionFooterHeight = 5;
        _table.showsVerticalScrollIndicator = NO;
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkAddCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkAddCell"];
        [_table registerNib:[UINib nibWithNibName:@"UIHomeworkStudentDetailCell" bundle:nil] forCellReuseIdentifier:@"UIHomeworkStudentDetailCell"];
        
        UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-10, 60)];
        UIButton *btnAddItem = [UIButton buttonWithType:UIButtonTypeCustom];
        btnAddItem.frame = CGRectMake(0, 0, SCREEN_WIDTH - 10, 55);
        btnAddItem.layer.masksToBounds = YES;
        btnAddItem.layer.cornerRadius = 5;
        if (_ifFinish) {
            btnAddItem.backgroundColor = [UIColor grayColor];
            [btnAddItem setTitle:@"做作业" forState:UIControlStateNormal];
            [btnAddItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else{
            if (_ifSubmit) {
                [btnAddItem setTitle:@"修改作业" forState:UIControlStateNormal];
            }
            else{
                [btnAddItem setTitle:@"做作业" forState:UIControlStateNormal];
            }
            btnAddItem.backgroundColor = STYLE_COLOR;
            [btnAddItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [btnAddItem addTarget:self action:@selector(doHomework) forControlEvents:UIControlEventTouchUpInside];
        }
        [bg addSubview:btnAddItem];
        _table.tableFooterView = bg;
    }
    return _table;
}@end
