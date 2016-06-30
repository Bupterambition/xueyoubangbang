//
//  UILoginRegistDoneViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/17.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UILoginRegisterInfoDoneViewController.h"
#import "MainTabViewController.h"
@interface UILoginRegisterInfoDoneViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *collection;
    NSArray *cellData;
}
@end

@implementation UILoginRegisterInfoDoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    cellData = @[];
    [self createViews];
    [self reload];
}

- (void)reload
{
    [AFNetClient GlobalGet:kUrlGetStudents parameters:@{@"pageSize":@"6"} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
        if(isUrlSuccess(dataDict))
        {
            NSArray *list = [dataDict objectForKey:@"studentlist"];
            if([list isKindOfClass:[NSNull class]])
            {
                return ;
            }
            
            NSMutableArray *t = [NSMutableArray array];
            for (NSDictionary *dic in list) {
                MUser *m = [MUser objectWithDictionary:dic];
                [t addObject:m];
            }
            
            cellData = t;
            [collection reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"资料填写完成";
    
    UIView *topContainer = [[UIView alloc] init];
    [self.view addSubview:topContainer];
    topContainer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_registeredsuccessfully"]];
    icon.frame = CGRectMake(40, 30, icon.frame.size.width, icon.frame.size.height);
    [topContainer addSubview:icon];
    
    UILabel *l1 = [[UILabel alloc] init];
    l1.frame = CGRectMake([icon rightX], icon.frame.origin.y, 180, 30);
    l1.text = @"资料填写完成";
    l1.font = FONT_CUSTOM(20);
    l1.textColor = UIColorFromRGB(0x60a5a5);
    [topContainer addSubview:l1];
    
    UILabel *l2 = [[UILabel alloc] init];
    l2.frame = CGRectMake([icon rightX], [l1 bottomY], 200, 20);
    l2.font = FONT_CUSTOM(12);
    l2.textColor = UIColorFromRGB(0x60a5a5);
    l2.text = @"填写更多资料，享受完整服务";
    [topContainer addSubview:l2];
    
    
    collection = [[UICollectionView alloc] initWithFrame: CGRectMake(40, [topContainer bottomY] + 10, SCREEN_WIDTH - 80, 200) collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    [collection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"GradientCell"];
    //    collection.frame = CGRectMake(30, 100, SCREEN_WIDTH - 60, 200);
    [self.view addSubview:collection];
    collection.backgroundColor = [UIColor clearColor];
    collection.dataSource = self;
    collection.delegate = self;
    
    //按钮
    UIButton *btnNext = BUTTON_CUSTOM([collection bottomY] + 10);
    [btnNext setTitle:@"添加他们为好友" forState:UIControlStateNormal];
    [btnNext addTarget:self action:@selector(doNext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNext];
    
    UIButton *btnSkip = BUTTON_CUSTOM(btnNext.frame.origin.y + btnNext.frame.size.height + 20);
    btnSkip.backgroundColor = [UIColor whiteColor];
    [btnSkip setTitle:@"直接进入" forState:UIControlStateNormal];
    [btnSkip addTarget:self action:@selector(doSkip) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSkip];
}

//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return cellData.count;
}
//定义展示的Section的个数
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"GradientCell";
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    MUser *user = [cellData objectAtIndex:indexPath.row];
    UIImageView *header = [[UIImageView alloc] init];
    header.frame = CGRectMake(0, 0, 60, 60);
    header.contentMode = UIViewContentModeScaleToFill;
    [cell.contentView addSubview:header];
    [header sd_setImageWithURL:[NSURL URLWithString:UrlResString(user.header_photo)] placeholderImage:DEFAULT_HEADER];
    
    UILabel *username = [[UILabel alloc] init];
    username.frame = CGRectMake(0, [header bottomY] + 5, 60, 20);
    username.font = FONT_CUSTOM(14);
    username.text = user.username;
    [cell.contentView addSubview:username];
    
    return cell;
}
#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(60, 100);
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //    cell.backgroundColor = [UIColor whiteColor];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)doNext
{
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    __block BOOL flag = YES;
    for (MUser *user in cellData) {
        [AFNetClient GlobalGet:kUrlAddFriendReq parameters:[CommonMethod getParaWithOther:@{@"id":user.userid}] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            if(isUrlSuccess(dataDict))
            {
                if(flag)
                {
                    [CommonMethod showAlert:@"好友请求发送成功"];
                    flag = NO;
                    [self doSkip];
                }
            }
            else
            {
                if(flag)
                {
                    [CommonMethod showAlert:urlErrorMessage(dataDict)];
                    flag = NO;
                }
                
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
            if(flag)
            {
                [CommonMethod showAlert:@"服务器异常"];
                flag = NO;
            }
        }];
    }
    
}

- (void)doSkip
{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    mainWindow.rootViewController = [[MainTabViewController alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
