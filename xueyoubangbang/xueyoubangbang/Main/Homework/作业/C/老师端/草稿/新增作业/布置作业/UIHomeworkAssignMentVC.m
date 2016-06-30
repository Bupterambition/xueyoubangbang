//
//  UIHomeworkAssignMentVC.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/12.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAssignMentVC.h"
#import "StudentGroupViewModel.h"
#import "NewHomeworkFileSend.h"
#import "UIHomeworkViewModel.h"
@interface UIHomeworkAssignMentVC ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *table;
@end

@implementation UIHomeworkAssignMentVC{
    NSArray *myGroups;
    NSMutableArray *selectedGroups;
    NSMutableArray *selectedSubjects;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initIvar];
    [self initNav];
    [self getGroups];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillLayoutSubviews{
    self.table.frame = CGRectMake(5, 0, SCREEN_WIDTH-10, SCREEN_HEIGHT-64);
}
#pragma mark - init Method
- (void)initView{
    [self.view addSubview:self.table];
}
- (void)initIvar{
    myGroups = [NSArray array];
    selectedGroups = [NSMutableArray array];
    selectedSubjects = [NSMutableArray array];
}
- (void)initNav{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStylePlain target:self action:@selector(assignMent)];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return myGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GROUPS"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"GROUPS"] ;
    }
    cell.textLabel.text = ((StudentGroup*)myGroups[indexPath.row]).groupname;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *oneCell = [tableView cellForRowAtIndexPath: indexPath];
    if (oneCell.accessoryType == UITableViewCellAccessoryNone) {
        oneCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedGroups addObject:NSIntTOString(((StudentGroup*)myGroups[indexPath.row]).groupid)];
        [selectedSubjects addObject:NSIntTOString(((StudentGroup*)myGroups[indexPath.row]).subjectid)];
    }
    else{
        [selectedGroups removeObject:NSIntTOString(((StudentGroup*)myGroups[indexPath.row]).groupid)];
        [selectedSubjects removeObject:NSIntTOString(((StudentGroup*)myGroups[indexPath.row]).subjectid)];
        oneCell.accessoryType = UITableViewCellAccessoryNone;
    }
}
#pragma mark - private Method
- (void)getGroups{
    weak(weakself);
    [StudentGroupViewModel GetStudentGroupListWithCallBack:^(NSArray *groups) {
        myGroups = groups;
        [weakself.table reloadData];
    }];
}
- (void)doPublish{
    if (selectedGroups.count == 0 || selectedSubjects.count == 0) {
        [CommonMethod showAlert:@"请选择要布置的小组"];
        return;
    }
    [UIHomeworkViewModel assignmentHomeworkWithParams:[self getPara] withFileDataArr:[self getData] withCallBack:^(BOOL success) {
        if (success) {
            [MBProgressHUD showSuccess:@"已布置到所选班"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else{
            [MBProgressHUD showError:@"网络错误请稍候再试"];
        }
    }];
}

- (NSDictionary *)getPara{
    NSMutableDictionary *otherPara = [NSMutableDictionary dictionaryWithDictionary:@{@"userid":[GlobalVar instance].user.userid,@"groupid":[selectedGroups componentsJoinedByString:@","],@"subjectid":[selectedSubjects componentsJoinedByString:@","],@"title":self.baseHome.title,@"submittime":self.baseHome.submittime,@"knowledgepoints":self.baseHome.knowledgepoints,@"itemcnt": [NSNumber numberWithInteger:self.baseHome.items.count]}];
    
    for (NSInteger i = 1; i <= self.baseHome.items.count; i++){
        NewHomeworkFileSend *item = [self.baseHome.items objectAtIndex:i-1];
        
        NSString *keyItemTitle = [NSString stringWithFormat:@"item_%ld_title",i];
        NSString *valueItemTitle = item.item_title?item.item_title:@"";
        [otherPara setObject:valueItemTitle forKey:keyItemTitle];
        
        NSString *keyItemInfo = [NSString stringWithFormat:@"item_%ld_info",i];
        NSString *valueItemInfo = item.item_info?item.item_info:@"";
        [otherPara setObject:valueItemInfo forKey:keyItemInfo];
        
        NSString *keyItemType = [NSString stringWithFormat:@"item_%ld_type",i];
        NSString *valueItemType = [item.item_type isEqualToString:@"2"]?@"1":item.item_type;
        [otherPara setObject:valueItemType forKey:keyItemType];
        
        if ([item.item_type isEqualToString:@"1"] || [item.item_type isEqualToString:@"2"] ) {
            NSString *keyItemAnswer = [NSString stringWithFormat:@"item_%ld_answer",i];
            NSString *valueItemAnswer = item.item_answer;
            [otherPara setObject:valueItemAnswer forKey:keyItemAnswer];
            
            NSString *keyItemChoicenum = [NSString stringWithFormat:@"item_%ld_choicenum",i];
            NSString *valueItemChoicenum = item.item_choicenum;
            [otherPara setObject:valueItemChoicenum forKey:keyItemChoicenum];
        }
        
        
        NSString *keyItemPicCount = [NSString stringWithFormat:@"item_%ld_imgscnt",i];
        NSString *valueItemPicCount = item.item_imgscnt;
        [otherPara setObject:valueItemPicCount forKey:keyItemPicCount];
        
    }
    
    return otherPara;//[CommonMethod getParaWithOther:otherPara];
}

- (NSArray *)getData{
    NSMutableArray *dataArr = [NSMutableArray array];
    for (NSInteger i = 1; i <= self.baseHome.items.count; i++) {
        NewHomeworkFileSend *item = [self.baseHome.items objectAtIndex:i-1];
        NSArray *imgArray = [item stringToArray];
        for (NSInteger j = 1; j<=[item.item_imgscnt integerValue]; j++) {
            NSString *name = [NSString stringWithFormat:@"item_%ld_img_%ld",i,j];
            NSString *fileName = [NSString stringWithFormat:@"%@.jpeg",name];
            NSString *mimeType = @"image/jpeg";
            NSData *fileData = [imgArray objectAtIndex:j-1];
            NSDictionary *dic = @{ @"name":name,@"fileName":fileName,@"mimeType":mimeType,@"fileData":fileData };
            [dataArr addObject:dic];
        }
        
        if(item.item_audio != nil){
            NSDictionary *audio = @{@"name": [NSString stringWithFormat:@"item_%ld_audio",i],@"fileName":@"audio.amr",@"fileData":[item getAudioData],@"mimeType":@"audio/amr"};
            [dataArr addObject:audio];
        }
    }
    return dataArr;
}

#pragma mark - event response
- (void)assignMent{
    [self doPublish];
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
    }
    return _table;
}
@end
