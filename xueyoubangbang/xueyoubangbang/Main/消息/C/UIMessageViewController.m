//
//  UIMessageViewController.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIMessageViewController.h"
#import "UIMessageCell.h"
#import "MessageViewModel.h"
#import "UIMessageModels.h"
#import "UIHomeworkDetailFors.h"
#import "UIMineNewStudentsJoinVC.h"
#import "UIHomeworkReviewCheck.h"
#import "UIMessageFriendAcceptViewController.h"
#import "UIHomeworkCheckViewController.h"
#import "UIHomeworkViewModel.h"
#import "UIHomeworkListFors.h"
#import "UIInterActAllViewController.h"
#import "UIInterActAskMeViewController.h"
@interface UIMessageViewController ()<UITableViewDataSource,UITableViewDelegate,UIMessageCellDelegate>
@property (nonatomic, strong) UITableView *table;

@end

typedef NS_ENUM(NSInteger, StudentMessageType){
    HomeWorkToDo,
    HomeWorkChecked,
    ApplyForFriend,
    InterAct
};
typedef NS_ENUM(NSInteger, TeachMessageType){
    HomeWorkFinished,
    ApplyGroup
};

@implementation UIMessageViewController{
    NSMutableArray *messageArray;
    MessageObject *messageObject;
    NSMutableArray *subjectGroups;
    NSMutableDictionary *mutableDicForToDo;
    NSMutableDictionary *mutableDicForCheck;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
    [self initIvar];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.table.header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - init Method
- (void)initView{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"消息";
    [self.view addSubview:self.table];
}
- (void)initIvar{
    messageArray = [NSMutableArray array];
    subjectGroups = [NSMutableArray array];
    mutableDicForToDo = [NSMutableDictionary dictionary];
    mutableDicForCheck = [NSMutableDictionary dictionary];
}
#pragma mark - UITableViewDataSource and UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //暂时不加互动圈
    if ([rolesUser isEqualToString:roleStudent]) {
        return 4;
    }
    else{
        return 4;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //暂时不加互动圈
    if ([rolesUser isEqualToString:roleStudent]) {
        switch (section) {
            case HomeWorkToDo:
                return messageObject.homeworkToDo.count;
                break;
            case HomeWorkChecked:
                return messageObject.homeworkChecked.count;
                break;
            case ApplyForFriend:
                return messageObject.applyForFriends.count;
                break;
            case InterAct:
                return messageObject.question.count;
                break;
            default:
                return 0;
                break;
        }
    }
    else{
        switch (section) {
            case HomeWorkFinished:
                return [messageObject.homeworkFinished count];
                break;
            case ApplyGroup:
                return [messageObject.applyForGroup count];
                break;
            case ApplyForFriend:
                return [messageObject.applyForFriends count];
                break;
            case InterAct:
                return messageObject.question.count;
            default:
                return 0;
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UIMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UIMessageCell"];
    if ([rolesUser isEqualToString:roleStudent]) {
//        if (indexPath.section == subjectGroups.count) {
//            [cell loadData:messageObject.applyForFriends[indexPath.row]];
//        }
//        else{
//            
//            StudentGroup *data = subjectGroups[indexPath.section];
//            if ([homeworktodo containsObject:[data getGroupID]] && [homeworkcheck containsObject:[data getGroupID]]) {
//                [cell loadData:subjectGroups[indexPath.section] withIndex:indexPath.row];
//            }
//            else if ([homeworktodo containsObject:[data getGroupID]]){
//                [cell loadData:subjectGroups[indexPath.section] withIndex:0];
//            }
//            else{
//                [cell loadData:subjectGroups[indexPath.section] withIndex:1];
//            }
//            
//        }
        switch (indexPath.section) {
            case 0:
                [cell loadData:messageObject.homeworkToDo[indexPath.row]];
                break;
            case 1:
                [cell loadData:messageObject.homeworkChecked[indexPath.row]];
                break;
            case 2:
                [cell loadData:messageObject.applyForFriends[indexPath.row]];
                break;
            case 3:
                [cell loadData:messageObject.question[indexPath.row]];
                break;
            default:
                break;
        }
    }
    else{
        switch (indexPath.section) {
            case HomeWorkFinished:
                [cell loadData:messageObject.homeworkFinished[indexPath.row]];
                break;
            case ApplyGroup:
                [cell loadData:messageObject.applyForGroup[indexPath.row]];
                break;
            case ApplyForFriend:
                [cell loadData:messageObject.applyForFriends[indexPath.row]];
                break;
            case InterAct:
                [cell loadData:messageObject.question[indexPath.row]];
            default:
                break;
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([rolesUser isEqualToString:roleStudent]) {
//        [self deleteMessage:[((ApplyForFriends*)messageObject.applyForFriends[indexPath.row]) remind_id]];
//        [messageObject.applyForFriends removeObjectAtIndex:indexPath.row];
//        return;
        switch (indexPath.section) {
            case HomeWorkToDo:
                [self deleteMessage:[((HomeworkToDo*)messageObject.homeworkToDo[indexPath.row]) remind_id]];
                [messageObject.homeworkToDo removeObjectAtIndex:indexPath.row];
                
                break;
            case HomeWorkChecked:
                [self deleteMessage:[((HomeworkChecked*)messageObject.homeworkChecked[indexPath.row]) remind_id]];
                [messageObject.homeworkChecked removeObjectAtIndex:indexPath.row];
                break;
            case ApplyForFriend:
                [self deleteMessage:[((ApplyForFriends*)messageObject.applyForFriends[indexPath.row]) remind_id]];
                [messageObject.applyForFriends removeObjectAtIndex:indexPath.row];
                break;
            case InterAct:
                [self deleteMessage:[((Question*)messageObject.question[indexPath.row]) remind_id]];
                [messageObject.question removeObjectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
    }
    else{
        switch (indexPath.section) {
            case HomeWorkFinished:
                [self deleteMessage:[((HomeworkFinished*)messageObject.homeworkFinished[indexPath.row]) remind_id]];
                [messageObject.homeworkFinished removeObjectAtIndex:indexPath.row];
                break;
            case ApplyGroup:
                [self deleteMessage:[((ApplyForGroup*)messageObject.applyForGroup[indexPath.row]) remind_id]];
                [messageObject.applyForGroup removeObjectAtIndex:indexPath.row];
                break;
            case ApplyForFriend:
                [self deleteMessage:[((ApplyForFriends*)messageObject.applyForFriends[indexPath.row]) remind_id]];
                [messageObject.applyForFriends removeObjectAtIndex:indexPath.row];
                break;
            case InterAct:
                [self deleteMessage:[((Question*)messageObject.question[indexPath.row]) remind_id]];
                [messageObject.question removeObjectAtIndex:indexPath.row];
                break;
            default:
                break;
        }
    }
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section]withRowAnimation:UITableViewRowAnimationAutomatic];
//    [tableView reloadData];
}
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([rolesUser isEqualToString:roleStudent]) {
//        if (indexPath.section == subjectGroups.count) {
//            return YES;
//        }
//        else{
//            return NO;
//        }
//    }
//    else{
//        return YES;
//    }
//}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([rolesUser isEqualToString:roleStudent]) {
//        if (indexPath.section == subjectGroups.count) {
//            UIMessageFriendAcceptViewController *vc = [[UIMessageFriendAcceptViewController alloc] init];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
//        else{
//            UIMessageCell *cell =(UIMessageCell*)[tableView cellForRowAtIndexPath:indexPath];
//            if (cell.leftDownLabel.hidden) {
//                NSArray * temp = mutableDicForToDo[[(StudentGroup*)subjectGroups[indexPath.section] getGroupID]];
//                [self deleteMessages:temp];
//            }
//            else{
//                NSArray * temp = mutableDicForCheck[[(StudentGroup*)subjectGroups[indexPath.section] getGroupID]];
//                [self deleteMessages:temp];
//            }
//            UIHomeworkListFors *vc =[[UIHomeworkListFors alloc] init];
//            vc.groupid = [(StudentGroup*)subjectGroups[indexPath.section] getGroupID];
//            vc.title = [(StudentGroup*)subjectGroups[0] getSubject];
//            [self.navigationController pushViewController:vc animated:YES];
//        }
        switch (indexPath.section) {
            case HomeWorkToDo:{
                //[self deleteMessage:[(HomeworkToDo*)(messageObject.homeworkToDo[indexPath.row]) remind_id]];
//                UIHomeworkDetailFors *vc = [[UIHomeworkDetailFors alloc] init];
                UIHomeworkListFors *vc =[[UIHomeworkListFors alloc] init];
//                vc.home_work_id = [(HomeworkToDo*)messageObject.homeworkToDo[indexPath.row] homework_id];
                vc.groupid = [(HomeworkToDo*)messageObject.homeworkToDo[indexPath.row] groupid];
                vc.title = [(HomeworkToDo*)subjectGroups[0] getSubject];
                [self.navigationController pushViewController:vc animated:YES];
            }
//                [messageObject.homeworkToDo removeObjectAtIndex:indexPath.row];
                break;
            case HomeWorkChecked:{
//                [self deleteMessage:[((HomeworkChecked*)messageObject.homeworkChecked[indexPath.row]) remind_id]];
                UIHomeworkListFors *vc =[[UIHomeworkListFors alloc] init];
                vc.groupid = [(HomeworkChecked*)messageObject.homeworkChecked[indexPath.row] groupid];
                vc.title = [(HomeworkChecked*)subjectGroups[0] getSubject];
                [self.navigationController pushViewController:vc animated:YES];
            }
//                [self didTouchReview:indexPath];
//                [self deleteMessage:[((HomeworkChecked*)messageObject.homeworkChecked[indexPath.row]) remind_id]];
                
//                [messageObject.homeworkChecked removeObjectAtIndex:indexPath.row];
                break;
            case ApplyForFriend:{
                UIMessageFriendAcceptViewController *vc = [[UIMessageFriendAcceptViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case InterAct:
                [self goToInterAct];
                break;
            default:
                break;
        }
    }
    else{
        switch (indexPath.section) {
            case HomeWorkFinished:{
                //UIHomeworkCheckViewController *vc = [[UIHomeworkCheckViewController alloc] init];
                //vc.homeworkid = [(HomeworkFinished*)messageObject.homeworkFinished[indexPath.row] homework_id];
//                vc.homeworkTitle = [(HomeworkFinished*)messageObject.homeworkFinished[indexPath.row] title];
//                vc.ifMessage = YES;
//                [self.navigationController pushViewController:vc animated:YES];
            }
            {
                UIHomeworkListFors *vc =[[UIHomeworkListFors alloc] init];
                vc.groupid = [(HomeworkFinished*)messageObject.homeworkFinished[indexPath.row] groupid];;
                vc.title = [(HomeworkFinished*)messageObject.homeworkFinished[indexPath.row] title];
                vc.ifMessage = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
//                [self deleteMessage:[((HomeworkFinished*)messageObject.homeworkFinished[indexPath.row]) remind_id]];
//                [messageObject.homeworkFinished removeObjectAtIndex:indexPath.row];
                break;
                
            case ApplyGroup:{
                UIMineNewStudentsJoinVC *vc = [[UIMineNewStudentsJoinVC alloc] init];
                vc.groupID = [((ApplyForGroup*)messageObject.applyForGroup[indexPath.row]) groupid];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case ApplyForFriend:{
                UIMessageFriendAcceptViewController *vc = [[UIMessageFriendAcceptViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
            }
                break;
            case InterAct:
                [self goToInterAct];
                break;
            default:
                break;
        }
    }
    
}

#pragma mark - UIMessageCellDelegate

- (void)didTouchReview:(NSIndexPath *)currentIndex{
    UIHomeworkReviewCheck *vc = [[UIHomeworkReviewCheck alloc] initWithHomework:@[[((HomeworkChecked*)messageObject.homeworkChecked[currentIndex.row]) homework_id],[((HomeworkChecked*)messageObject.homeworkChecked[currentIndex.row]) groupname]]];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - event response
- (void)goToInterAct{
    if (ifRoleTeacher) {
        UIInterActAskMeViewController *vc = [[UIInterActAskMeViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
        UIInterActAllViewController *vc = [[UIInterActAllViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}
- (void)loadGroups{
    if (ifRoleStudent) {
        weak(weakself);
        [UIHomeworkViewModel getstudentGroupListWithParams:@{@"studentid":[GlobalVar instance].user.userid} withCallBack:^(NSArray *Students) {
            if (Students) {
                [subjectGroups removeAllObjects];
                [subjectGroups addObjectsFromArray:Students];
                if (messageObject.homeworkToDo.count > 0) {
                    [weakself filtGroupForHomewokToDo:subjectGroups];
                }
                if (messageObject.homeworkChecked.count > 0) {
                    [weakself filtGroupForHomeworkCheck:subjectGroups];
                }
                [weakself.table reloadData];
            }
        }];
    }
}
- (void)loadMessage{
    weak(weakself);
//    [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    [MessageViewModel getMessageListWithParams:@{@"userid":UserID} withCallBack:^(id messageList) {
//        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if (messageList) {
            messageObject = messageList;
            if (messageObject.homeworkToDo || messageObject.homeworkChecked) {
                [weakself loadGroups];
            }
            [weakself.table reloadData];
        }
        [weakself.table.header endRefreshing];
    }];
}
- (void)deleteMessage:(NSString*)remind_id{
    [MessageViewModel deleteMessageListWithParams:@{@"remindid":remind_id} withCallBack:^(BOOL success) {
        
    }];
}
- (void)deleteMessages:(NSArray*)remind_ids{
    [MessageViewModel deleteMessageListWithParams:@{@"remindid":[remind_ids componentsJoinedByString:@","]} withCallBack:^(BOOL success) {
        
    }];
}
#pragma mark - private Method
- (void)filtGroupForHomewokToDo:(NSArray*)groups{
    [groups enumerateObjectsUsingBlock:^(StudentGroup* obj, NSUInteger idx, BOOL *stop) {
        NSPredicate *resultPredicateForCheck = [NSPredicate
                                                predicateWithFormat:@"SELF.groupid = %ld",
                                                obj.groupid];
        NSArray * tempMessage = [messageObject.homeworkToDo filteredArrayUsingPredicate:resultPredicateForCheck];
        NSMutableArray *tempRemind = [NSMutableArray array];
        [tempMessage enumerateObjectsUsingBlock:^(HomeworkToDo *data, NSUInteger idx, BOOL *stop) {
            [tempRemind addObject:data.remind_id];
        }];
        [mutableDicForToDo setObject:tempRemind forKey:NSIntTOString((long)obj.groupid)];
    }];
}
- (void)filtGroupForHomeworkCheck:(NSArray*)groups{
    [groups enumerateObjectsUsingBlock:^(StudentGroup* obj, NSUInteger idx, BOOL *stop) {
        NSPredicate *resultPredicateForCheck = [NSPredicate
                                                predicateWithFormat:@"SELF.groupid = %ld",
                                                obj.groupid];
        NSArray * tempMessage = [messageObject.homeworkChecked filteredArrayUsingPredicate:resultPredicateForCheck];
        NSMutableArray *tempRemind = [NSMutableArray array];
        [tempMessage enumerateObjectsUsingBlock:^(HomeworkChecked *data, NSUInteger idx, BOOL *stop) {
            [tempRemind addObject:data.remind_id];
        }];
        [mutableDicForCheck setObject:tempRemind forKey:NSIntTOString((long)obj.groupid)];
    }];
}
#pragma getter and setter
- (UITableView *)table{
    if (_table == nil) {
        _table = CREATE_TABLE(UITableViewStylePlain);
        _table.frame = CGRectMake(0, 5, SCREEN_WIDTH, SCREEN_HEIGHT - 64);
        _table.delegate = self;
        _table.dataSource = self;
        _table.rowHeight = 70;
        _table.sectionHeaderHeight = 3;
        [_table registerNib:[UINib nibWithNibName:@"UIMessageCell" bundle:nil] forCellReuseIdentifier:@"UIMessageCell"];
        [_table addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(loadMessage)];
    }
    return _table;
}

@end
