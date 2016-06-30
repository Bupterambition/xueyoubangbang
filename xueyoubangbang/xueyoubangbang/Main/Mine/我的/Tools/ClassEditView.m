//
//  ClassEditView.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/22.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "ClassEditView.h"
#import "MSchool.h"
@interface ClassEditView()
{
    
    NSArray *titles;
    
    NSInteger tableResultType;// 0学校 1年级 2班级
    
    NSMutableArray *schoolArray;
    NSArray *gradeArray;
    NSArray *classArray;
    
    NSMutableArray *gradeIdArray;
    NSMutableArray *classIdArray;
    
    NSDictionary *gradeDic;
    NSMutableDictionary *classDic;
}
@end
@implementation ClassEditView
@synthesize table,tableResult;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + 80)];
    if(self)
    {
        [self initial];
        [self createViews];
        
    }
    return self;
}

- (void)initial
{
    if([rolesUser isEqualToString:roleStudent])
    {
        titles = @[@"学校",@"年级",@"班级"];
    }
    else if([rolesUser isEqualToString:roleTeacher])
    {
        titles = @[@"所在学校",@"授课年级",@"授课班级"];
    }
    else
    {
        titles = @[@"学校",@"年级",@"班级"];
    }
    schoolArray = [NSMutableArray array];
    gradeDic = @{@"7":@"初一",@"8":@"初二",@"9":@"初三",@"10":@"高一",@"11":@"高二",@"12":@"高三"};
    
    gradeIdArray = [NSMutableArray array];
    for (int i = 6; i < 12; i++) {
        [gradeIdArray addObject:[NSString stringWithFormat:@"%d",i + 1]];
    }
    
    gradeArray = [gradeDic allValues];
    
    
    classDic = [NSMutableDictionary dictionary];
    for (int i = 0; i<20; i++) {
        [classDic setObject:[NSString stringWithFormat:@"%d班",i + 1] forKey:[NSString stringWithFormat:@"%d",i + 1]];
        [classIdArray addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    classArray = [classDic allValues];
    
    
    
}

- (NSString *)classIdByClassName:(NSString *)className
{
    for (NSString *key in classDic) {
        if([className isEqualToString:[classDic objectForKey:key]])
        {
            return key;
        }
    }
    return nil;
}

- (NSString *)gradeIdByGradeName:(NSString *)gradeName
{
    for (NSString *key in gradeDic) {
        if([gradeName isEqualToString:[gradeDic objectForKey:key]])
        {
            return key;
        }
    }
    return nil;
}

- (void)createViews
{
    self.backgroundColor = [UIColor clearColor];
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - 70) style:UITableViewStyleGrouped];
    [self addSubview:table];
    table.dataSource = self;
    table.delegate = self;
    table.scrollEnabled = NO;
    UIView *v = [[UIView alloc]init];
    v.backgroundColor = [UIColor clearColor];
    table.tableFooterView = v;
    table.backgroundColor = [UIColor whiteColor];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT * 3 + 10, SCREEN_WIDTH, 60)];
    footerView.backgroundColor = [UIColor clearColor];
    CGFloat w = ( SCREEN_WIDTH - kPaddingLeft * 4 ) / 2;
    _btnCancel = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnCancel.frame =CGRectMake(kPaddingLeft, kPaddingTop, w, 40);
    _btnCancel.layer.borderColor = STYLE_COLOR.CGColor;
    _btnCancel.layer.borderWidth = 1;
    [_btnCancel setTitleColor:STYLE_COLOR forState:UIControlStateNormal];
    [footerView addSubview:_btnCancel];
    //    footerView.backgroundColor= [UIColor greenColor];
    [_btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    
    
    _btnSure = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnSure.frame = CGRectMake(kPaddingLeft * 3 + w, kPaddingTop, w, 40);
    _btnSure.backgroundColor = STYLE_COLOR;
    [footerView addSubview:_btnSure];
    [_btnSure setTitle:@"确定" forState:UIControlStateNormal];
    
    [self addSubview:footerView];
    
}

#define tableResultCellHeight 35
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == table){
        return 1;
    }
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == table)
        return titles.count;
    return [self tableResultData].count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == table)
        return CELL_HEIGHT;
    return tableResultCellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(table == tableView)
    {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId0"];
        cell.textLabel.text = [titles objectAtIndex:indexPath.row];
        cell.backgroundColor = [UIColor whiteColor];
        if(indexPath.row == 0){
            UITextField *f = [[UITextField alloc] initWithFrame:CGRectMake(95, 0, 180, CELL_HEIGHT)];
            
            _field1 = f;
            [cell.contentView addSubview:_field1];
            _field1.returnKeyType = UIReturnKeySearch;
            _field1.clearButtonMode = UITextFieldViewModeAlways;
            _field1.delegate = self;
            _field1.placeholder = @"请输入你的学校";
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_classinformation_find"]];
            
            _field1.text = _currentSchoolId;
            
            
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:f];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:_field1];
        }
        else if(indexPath.row == 1)
        {
            _label2 = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 180, CELL_HEIGHT)];
            [cell.contentView addSubview:_label2];
            if(![CommonMethod isBlankString:_currentGrade])
            {
                _label2.text = [gradeDic objectForKey:_currentGrade];
            }
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_classinformation_pulldown"]];
        }
        else if(indexPath.row == 2)
        {
            _label3 = [[UILabel alloc] initWithFrame:CGRectMake(90, 0, 180, CELL_HEIGHT)];
            [cell.contentView addSubview:_label3];
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_classinformation_pulldown"]];
            if(![CommonMethod isBlankString:_currentClass])
            {
                _label3.text = [classDic objectForKey:_currentClass];
            }
        }
        
        return cell;
    }
    else
    {
        static NSString *cellId = @"cellId1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if(!cell){
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        
        cell.textLabel.text = [self tableResultDataText:indexPath.row];
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(table == tableView)
    {
        
        if(indexPath.row == 0)
        {
            if( ![CommonMethod isBlankString:_field1.text])
            {
                [self removeTableResult];
                tableResultType = indexPath.row;
                [self searchSchool:_field1.text];
            }
        }
        else
        {
            if(tableResultType != indexPath.row)
            {
                [self removeTableResult];
                tableResultType = indexPath.row;
            }
            [self createTableResult];
        }
        
    }
    else
    {
        [self removeTableResult];
        MSchool *m;
        switch (tableResultType) {
            case 0:
                _field1.text = [self tableResultDataText:indexPath.row];
                m = [schoolArray objectAtIndex:indexPath.row];
                _currentSchoolId = m.school_id;
                _currentScooolName = m.school_name;
                //这部分是我加上去的
                [self getGradeList];
                break;
            case 1:
                _label2.text = [self tableResultDataText:indexPath.row];
                _currentGrade = [self gradeIdByGradeName:_label2.text];
                break;
            case 2:
                _label3.text = [self tableResultDataText:indexPath.row];
                _currentClass = [self classIdByClassName:_label3.text];
            default:
                break;
        }
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [[self findFirstResponder] resignFirstResponder];
}

-(void)getGradeList
{
    
}

- (void)createTableResult
{
    if(tableResult)
    {
        [self removeTableResult];
    }
    
    CGFloat y = CELL_HEIGHT * ( tableResultType + 1);
    NSUInteger cellCount = [self tableResultData].count > 4 ? 4:[self tableResultData].count;
    tableResult = [[UITableView alloc] initWithFrame:CGRectMake(_label2.frame.origin.x, y, self.frame.size.width - _label2.frame.origin.x,  cellCount * tableResultCellHeight) style:UITableViewStyleGrouped];
    tableResult.layer.borderWidth = 1;
    tableResult.layer.borderColor = VIEW_BACKGROUND_COLOR.CGColor;
    tableResult.dataSource = self;
    tableResult.delegate = self;
    
    [self addSubview:tableResult];
    
}

- (void)removeTableResult
{
    [tableResult removeFromSuperview];
    tableResult = nil;
}

- (NSArray *)tableResultData
{
    switch (tableResultType) {
        case 0:
            return schoolArray;
            break;
        case 1:
            return gradeArray;
        case 2:
            return classArray;
        default:
            return @[];
    }
}

- (NSString *)tableResultDataText:(NSInteger)row
{
    switch (tableResultType) {
        case 0:
            return ((MSchool*) [schoolArray objectAtIndex:row]).school_name;
            break;
        case 1:
            return [gradeDic objectForKey:[NSString stringWithFormat:@"%ld",row + 7]];
        case 2:
            return [classDic objectForKey:[NSString stringWithFormat:@"%ld",row + 1]];
        default:
            return nil;
    }
}

- (void)searchSchool:(NSString *)text
{
    
    //[MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    [AFNetClient GlobalGet:kUrlGetSchoolList parameters:@{@"input":text} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        [schoolArray removeAllObjects];
        //[MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDict)){
            NSLog(@"schoolList = %@",dataDict);
            NSArray *list = [dataDict objectForKey:@"list"];
            if([list isKindOfClass:[NSNull class]])
            {
                [self removeTableResult];
                return ;
            }
            for (int i = 0; i< list.count; i++) {
                NSLog(@"list%d = %@",i,[list objectAtIndex:i]);
                MSchool *school = [MSchool objectWithDictionary:[list objectAtIndex:i]];
                [schoolArray addObject:school];
            }
            [self createTableResult];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
    }];
}

-(void)getGradeList:(NSInteger)school_id
{
    [AFNetClient GlobalGet:kUrlgetGradeList parameters:@{@"school_id":_currentSchoolId} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict)
     {
         [schoolArray removeAllObjects];
         [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
         if(isUrlSuccess(dataDict)){
             NSLog(@"schoolList = %@",dataDict);
             NSArray *list = [dataDict objectForKey:@"list"];
             if([list isKindOfClass:[NSNull class]])
             {
                 [self removeTableResult];
                 return ;
             }
             for (int i = 0; i< list.count; i++) {
                 NSLog(@"list%d = %@",i,[list objectAtIndex:i]);
                 MSchool *school = [MSchool objectWithDictionary:[list objectAtIndex:i]];
                 [schoolArray addObject:school];
             }
             [self createTableResult];
         }
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [ MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
     }];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if( ![CommonMethod isBlankString:textField.text])
    {
        [self removeTableResult];
        tableResultType = 0;
        [self searchSchool:textField.text];
    }
    return YES;
}

- (void)textFieldChanged:(id)sender
{
    tableResultType = 0;
    [self searchSchool:_field1.text];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:_field1];
    
}



/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
