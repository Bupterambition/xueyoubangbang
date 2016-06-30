//
//  UIIndexViewController.m
//  xybb
//
//  Created by sdzhu on 15/3/11.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIIndexViewController.h"
#import "UIRankingViewController.h"
#import "UIRankingViewController.h"
#import "UIRemindViewController.h"
#import "UILoginViewController.h"
#import "UIQuestionAskViewController.h"
#import "UIQuestionListViewController.h"
#import "UITaskListViewController.h"
#import "UILoginViewController.h"
#import "MHomeinfo.h"
#import "UIQuestionAskViewController.h"
#import "MainTabViewController.h"
#import "UIHomeworkAddViewController.h"
#import "MCProgressBarView.h"
#import "MJExtension.h"
@interface UIIndexViewController ()
{
    UISegmentedControl *segment;
    UIRankingViewController *rankViewController;
    UIRemindViewController *remindViewController;
    //    UILetterListViewController *letterViewController;
    
    PICircularProgressView *processCenter;
    UILabel *centerLabel;
    UILabel *centerLabel2;
    
    CGFloat taskProgress;
    NSInteger rank;
    
    
    NSTimer *timer;
    
    //    LDProgressView *scoreProgress;
    UIView *progressView;
    UIView *progressContainer;
    UILabel *levelLabel;
    UILabel *rankLabel;
    
    UIButton *btnAsk;
    UIButton *btnFinish;
    
    BOOL hasUpdateUser;
    
    MCProgressBarView *myProgressView;
}
@end

@implementation UIIndexViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    hasUpdateUser = NO;
    [self initView];
    
    if([GlobalVar instance].user != nil)
    {
        [AFNetClient GlobalGet:kUrlGetUserInfo parameters:[CommonMethod getParaWithOther:@{@"id":[GlobalVar instance].user.userid}] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            hasUpdateUser = YES;
            if(isUrlSuccess(dataDict))
            {
                hasUpdateUser = YES;
                MUser *user = [MUser objectWithKeyValues:[dataDict objectForKey:@"user"]];//[MUser objectWithDictionary:[dataDict objectForKey:@"user"]];
                MUser *userTemp = [GlobalVar instance].user;
                userTemp.userid = user.userid;
                userTemp.username = user.username;
                userTemp.roles = user.roles;
                userTemp.header_photo = user.header_photo;
                userTemp.phone = user.phone;
                userTemp.qq = user.qq;
                userTemp.schoolinfo = user.schoolinfo;
                [GlobalVar instance].user = userTemp;
                
                UIImageView *tempImageView = [[UIImageView alloc] init];
                [tempImageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(user.header_photo)] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [GlobalVar instance].header = image;
                }];
                [self loadData];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            hasUpdateUser = YES;
        }];
        
        if(![CommonMethod isBlankString:[GlobalVar instance].deviceToken])
        {
            [AFNetClient GlobalGet:kUrlSetDeviceToken parameters:@{@"userid":[GlobalVar instance].user.userid,@"key":[GlobalVar instance].user.key,@"token":[GlobalVar instance].deviceToken} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
                ;
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                ;
            }];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([GlobalVar instance].user == nil)
    {
        UICustomNavigationViewController *nva = [[UICustomNavigationViewController alloc] initWithRootViewController:[[UILoginViewController alloc] init]];
        mainWindow.rootViewController = nva;
        //        UILoginViewController *loginCtrl = [[UILoginViewController alloc] init];
        //        UICustomNavigationViewController *nav = [[UICustomNavigationViewController alloc] initWithRootViewController:loginCtrl];
        //        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        [self loadData];
        NSLog(@"userid = %@,username = %@ ,userkey = %@", [GlobalVar instance].user.userid,[GlobalVar instance].user.username,[GlobalVar instance].user.key);
    }
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
}

- (void)loadData
{
    if([rolesUser isEqualToString:roleStudent])
    {
        [AFNetClient GlobalGet:kUrlGetHomeInfo parameters:@{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            NSLog(@"kUrlGetHomeInfo = %@",dataDict);
            if(isUrlSuccess(dataDict))
            {
                MHomeinfo *info = [MHomeinfo objectWithKeyValues:[dataDict objectForKey:@"homeinfo"]];//[MHomeinfo objectWithDictionary:[dataDict objectForKey:@"homeinfo"]];
                [GlobalVar instance].homeInfo = info;
                
                [processCenter setProgressValue:(CGFloat) info.progressValue / 100.00 animated:YES];
                //            [scoreProgress setProgressValue:(CGFloat) [self getProgressWithScore:info.scoring lvlevel:info.lvlevel] ];
                [self setProgressViewLenth:[self getProgressWithScore:info.scoring lvlevel:info.lvlevel]];
                levelLabel.text = [NSString stringWithFormat:@"等级：%ld",  info.lvlevel];
                rankLabel.text = [NSString stringWithFormat:@"%ld名",info.ranking];
//                [myProgressView setProgress:info.scoring%100/100.0 animated:NO];
                myProgressView.progress = info.scoring%100/100.0;
                if(info.taskcnt > 0)
                {
                    [btnFinish addRedPoint];
                }
                else
                {
                    [btnFinish removeRedPoint];
                }
                
                if(info.questioncnt > 0)
                {
                    [btnAsk addRedPointWithOffset:CGPointMake(btnAsk.frame.size.width * 3 / 4, btnAsk.frame.size.width  / 8)];
                }
                else
                {
                    [btnAsk removeRedPoint];
                }
            }
            else
            {
                [CommonMethod showAlert:urlErrorMessage(dataDict)];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
        
    }
    else
    {
        
        [AFNetClient GlobalGet:kUrlGetHomeInfo parameters:@{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key} success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
            NSLog(@"kUrlGetHomeInfo = %@",dataDict);
            if(isUrlSuccess(dataDict))
            {
                MHomeinfo *info = [MHomeinfo objectWithKeyValues:[dataDict objectForKey:@"homeinfo"]];
                [GlobalVar instance].homeInfo = info;
                centerLabel.text = [NSString stringWithFormat:@"%ld", (long)info.unfinishcnt];
                
                [processCenter setProgressValue:(CGFloat) info.progressValue / 100.00 animated:YES];
                //            [scoreProgress setProgressValue:(CGFloat) [self getProgressWithScore:info.scoring lvlevel:info.lvlevel] ];
                //                [self setProgressViewLenth:[self getProgressWithScore:info.scoring lvlevel:info.lvlevel]];
                levelLabel.text = [NSString stringWithFormat:@"等级：%ld",  (long)info.lvlevel];
                myProgressView.progress = info.scoring%100/100.0;
//                [myProgressView setProgress:info.scoring%100/100.0 animated:NO];
                //                rankLabel.text = [NSString stringWithFormat:@"%d名",info.ranking];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            ;
        }];
        
    }
}

- (void)initView
{
    self.navigationItem.title = @"学有帮帮";
    
    self.navigationController.navigationBar.backgroundColor = [UIColor greenColor];
    
    [self createBackground];
    [self createCenterProgress];
    [self createAskIcon];
    [self createFinishButton];
    [self createScore];
    
    if([rolesUser isEqualToString:roleStudent])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_home_share"] style:UIBarButtonItemStylePlain target:self action:@selector(doShare)];
    }
    else if([rolesUser isEqualToString:roleTeacher])
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doTeacherAddHomework)];
    }
}

- (void)createCenterProgress
{
    UIImage *centerOutImage = [UIImage imageNamed:@"home_precent_bac"];
    UIImageView *centerOutView = [[UIImageView alloc] initWithImage:centerOutImage];
    centerOutView.frame = CGRectMake(SCREEN_WIDTH / 2 - centerOutView.frame.size.width / 2, 190 - centerOutView.frame.size.height / 2, centerOutView.frame.size.width, centerOutView.frame.size.height);
    [self.view addSubview:centerOutView];
    
    CGFloat padding = 36;
    processCenter = [[PICircularProgressView alloc] init];
    CGFloat h = centerOutView.frame.size.height - padding;
    processCenter.frame = CGRectMake(SCREEN_WIDTH / 2 - h / 2, centerOutView.frame.origin.y + padding / 2 - 2, h, h);
    processCenter.innerBackgroundColor = [UIColor clearColor];
    processCenter.outerBackgroundColor = [UIColor clearColor];
    processCenter.progressFillColor = UIColorFromRGB(0xeb6100);
    processCenter.thicknessRatio = 0.05;
    processCenter.showText = NO;
    processCenter.delegate = self;
    processCenter.showShadow = 0;
    
    if([rolesUser isEqualToString:roleStudent])
    {
        UILabel *topLabel = [[UILabel alloc] init];
        CGFloat topLabelW = 100;
        topLabel.frame = CGRectMake(processCenter.frame.size.width / 2 - topLabelW / 2, 40, topLabelW, 25);
        topLabel.font = FONT_CUSTOM(12);
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.textColor = UIColorFromRGB(0x3c3c3c);
        topLabel.text= @"今日进度完成";
        [processCenter addSubview:topLabel];
        
        UIImageView *rankView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_rank"]];
        rankView.frame = CGRectMake(60, 140, rankView.frame.size.width, rankView.frame.size.height);
        [processCenter addSubview:rankView];
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.frame = CGRectMake([rankView rightX], rankView.frame.origin.y, 50, 20);
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.font = FONT_CUSTOM(15);
        bottomLabel.textColor = UIColorFromRGB(0xeb6100);
        bottomLabel.text = @"0 名";
        rankLabel = bottomLabel;
        [processCenter addSubview:bottomLabel];
        
        UILabel *centerLabel1 = [[UILabel alloc] init];
        centerLabel1.frame = CGRectMake(0, [topLabel bottomY], 130, 80);
        centerLabel1.textAlignment = NSTextAlignmentCenter;
        centerLabel1.font = FONT_CUSTOM(75);
        centerLabel1.textColor = [UIColor blackColor];
        centerLabel1.text = @"0";
        [processCenter addSubview:centerLabel1];
        centerLabel = centerLabel1;
        
        
        centerLabel2 = [[UILabel alloc] init];
        
        centerLabel2.frame = CGRectMake([centerLabel1 rightX], centerLabel1.frame.origin.y + centerLabel1.frame.size.height -  75, 50, 75);
        centerLabel2.textAlignment = NSTextAlignmentLeft;
        centerLabel2.font = FONT_CUSTOM(50);
        centerLabel2.textColor = [UIColor blackColor];
        centerLabel2.text = @"%";
        [processCenter addSubview:centerLabel2];
        
        CGSize size = [CommonMethod sizeWithString:centerLabel.text font:FONT_CUSTOM(75) maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        centerLabel.frame = CGRectMake(70 - size.width / 2, centerLabel.frame.origin.y, size.width, centerLabel.frame.size.height);
        centerLabel2.frame = CGRectMake(centerLabel.frame.origin.x + centerLabel.frame.size.width, centerLabel2.frame.origin.y, centerLabel2.frame.size.width, centerLabel2.frame.size.height);
        
    }
    else if([rolesUser isEqualToString:roleTeacher])
    {
        UILabel *centerLabel1 = [[UILabel alloc] init];
        centerLabel1.frame = CGRectMake(0, 0, processCenter.frame.size.width, processCenter.frame.size.height);
        centerLabel1.textAlignment = NSTextAlignmentCenter;
        centerLabel1.font = FONT_CUSTOM(75);
        centerLabel1.textColor = [UIColor blackColor];
        centerLabel1.text = @"0";
        [processCenter addSubview:centerLabel1];
        centerLabel = centerLabel1;
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.frame = CGRectMake(0, [centerLabel1 bottomY] - 50, processCenter.frame.size.width, 20);
        bottomLabel.textAlignment = NSTextAlignmentCenter;
        bottomLabel.font = FONT_CUSTOM(15);
        bottomLabel.textColor = UIColorFromRGB(0xeb6100);
        bottomLabel.text = @"尚未完成作业人数";
        rankLabel = bottomLabel;
        [processCenter addSubview:bottomLabel];
        
    }
    
    
    [self.view addSubview:processCenter];
}

- (void)createBackground
{
    UIImageView *back_up = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_down_bac"]];
    back_up.frame = CGRectMake(0, - kNavigateBarHight, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:back_up];
}

- (void)createAskIcon
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"home_ask_normal"];
    
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"home_ask_active"] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(SCREEN_WIDTH - 12 - image.size.width , 12, image.size.width, image.size.height);
    
    //    [btn addRedPointWithOffset:CGPointMake(btn.frame.size.width - 10, 0)];
    
    [self.view addSubview:btn];
    [btn addTarget:self action:@selector(doAsk) forControlEvents:UIControlEventTouchUpInside];
    btnAsk = btn;
}

- (void)createFinishButton
{
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"btn_finsh_normal"];
    [btn setBackgroundImage:image forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"btn_finsh_active"] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(SCREEN_WIDTH / 2 - image.size.width / 2, self.view.frame.size.height - kNavigateBarHight - image.size.height  - kTabBarHeight - (SCREEN_HEIGHT == SCREEN_IPHONE_4 ? 10 : 40), image.size.width, image.size.height);
    
    
    
    if([rolesUser isEqualToString:roleStudent])
    {
        //        [btn addRedPoint];
        [btn setTitle:@"完成任务" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doFinishTask) forControlEvents:UIControlEventTouchUpInside];
        
    }
    else if ([rolesUser isEqualToString:roleTeacher])
    {
        [btn setTitle:@"一键催作业" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(doHurryHomework) forControlEvents:UIControlEventTouchUpInside];
        
    }
    [self.view addSubview:btn];
    btnFinish = btn;
}

- (void)createScore
{
    UIImageView *back = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_credit_1"]];
    back.frame = CGRectMake(5, 12, back.frame.size.width, back.frame.size.height);
    [self.view addSubview:back];
    UIImage * foregroundImage = [[UIImage imageNamed:@"home_credit_2"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    myProgressView = [[MCProgressBarView alloc]initWithFrame:CGRectMake(25, 28, 100, 6) backgroundImage:nil foregroundImage:foregroundImage];
    myProgressView.progress = 0.45;
    myProgressView.layer.borderColor = [RGB(255, 255, 255) CGColor];
    myProgressView.layer.borderWidth = 1;
    [self.view addSubview:myProgressView];
    
    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 120, 15)];
    lb.font = FONT_CUSTOM(12);
    lb.textColor = [UIColor whiteColor];
    
    [self.view addSubview:lb];
    levelLabel = lb;
}

- (void)setProgressViewLenth:(CGFloat)progress
{
    if(progress > 1)
    {
        progress = 1;
    }
    if(progress < 0)
    {
        progress = 0;
    }
    progressView.frame = CGRectMake(progressView.frame.origin.x, progressView.frame.origin.y, progress * progressContainer.frame.size.width, progressView.frame.size.height);
}


- (CGFloat)getProgressWithScore:(NSInteger)score lvlevel:(NSInteger)lvlevel
{
    if(lvlevel == 1){
        return (CGFloat) score / (powf(2, lvlevel - 1) *100);
    }
    else
    {
        return (CGFloat) (score - (powf(2, lvlevel - 2) *100) ) /( powf(2, lvlevel-1)*100 - powf(2, lvlevel - 2)*100);
    }
    
}

- (void)doAsk
{
    UIQuestionListViewController *ctrl = [[UIQuestionListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)doFinishTask
{
    UITaskListViewController *ctrl = [[UITaskListViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)doHurryHomework
{
    [MBProgressHUD showHUDAddedTo:mainWindow animated:YES];
    //    [AFNetClient GlobalGet:kUrlSetRemindInfo parameters:[CommonMethod getParaWithOther:nil] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict) {
    //        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
    //        if(isUrlSuccess(dataDict))
    //        {
    //            [CommonMethod showAlert:@"提醒成功"];
    //        }
    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    //        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
    //    }];
    [[AFNetClient sharedManager]AppPostRegistwithPhone:kUrlSetRemindInfo andparameters:[CommonMethod getParaWithOther:nil] success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDcit) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
        if(isUrlSuccess(dataDcit))
        {
            [CommonMethod showAlert:@"提醒成功"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:mainWindow animated:YES];
    }];
}

- (void)doAddQuestion
{
    UIQuestionAskViewController *ctrl = [[UIQuestionAskViewController alloc] init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

- (void)doShare
{
    NSString *textToShare = [NSString stringWithFormat:@"hi,我在学有帮帮的好友里任务排名第%ld哦,你是多少名呀?",[GlobalVar instance].homeInfo.ranking];
    //    NSURL *urlToShare = [NSURL URLWithString:@"http://ew.changyan.com"];
    NSString *title = @"学有帮帮";
    NSString *url = [NSString stringWithFormat:@"http://www.sharingpop.cn/bang/share.html?id=%@&from=groupmessage&isappinstalled=1",[GlobalVar instance].user.userid];
//    NSString *url = kUrlAppDownload;
    UIImage *thumb = [UIImage imageNamed:@"icon-120"];
    NSArray *activityItems = @[textToShare,thumb,[NSURL URLWithString:url]];
    WeixinActivity *weixinSession =[[WeixinActivity alloc] init];
    weixinSession.title = title;
    weixinSession.thumb = thumb;
    weixinSession.text = textToShare;
    weixinSession.url = url;
    weixinSession.scene = 0;
    
    WeixinActivity *weixinTimeLine =[[WeixinActivity alloc] init];
    weixinTimeLine.title = title;
    weixinTimeLine.thumb = thumb;
    weixinTimeLine.text = textToShare;
    weixinTimeLine.url = url;
    weixinTimeLine.scene = 1;
    
    TencentActivity *tencent = [[TencentActivity alloc]init];
    tencent.title = title;
    tencent.thumb = thumb;
    tencent.text = textToShare;
    tencent.url = url;
    
    NSArray *activities = @[tencent,weixinSession,weixinTimeLine];
    UIActivityViewController *activityVC =
    [[UIActivityViewController alloc]initWithActivityItems:activityItems
                                     applicationActivities:activities];
    //不出现在活动项目
    if(IOS_VERSION_7_OR_ABOVE){
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeAirDrop,UIActivityTypeAddToReadingList];
    }
    else{
        activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,
                                             UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll,UIActivityTypeMessage,UIActivityTypeMail];
    }
    [self presentViewController:activityVC animated:TRUE completion:nil];
    UIActivityViewControllerCompletionHandler handler = ^(NSString *activityType, BOOL completed){
        if (nil != activityType) {
            if (completed) {
                
            }
            if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
                NSLog(@"新浪微博分享！");
            }else if ([activityType isEqualToString:@"com.apple.UIKit.activity.TencentWeibo"]) {
                NSLog(@"腾讯微博分享");
            }else {
                //do nothing
            }
        }
    };
    activityVC.completionHandler = handler;
}

- (void)doTeacherAddHomework {
    //测试入口
    [self.navigationController pushViewController:[[UIHomeworkAddViewController alloc] init] animated:YES];
}



-(void)onRefresh:(CGFloat)progress
{
    if([[GlobalVar instance].homeInfo.roles isEqualToString:roleTeacher])
    {
        
        
        CGSize size = [CommonMethod sizeWithString:centerLabel.text font:FONT_CUSTOM(75) maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        centerLabel.frame = CGRectMake(90 - size.width / 2, centerLabel.frame.origin.y, size.width, centerLabel.frame.size.height);
        centerLabel2.frame = CGRectMake(centerLabel.frame.origin.x + centerLabel.frame.size.width, centerLabel2.frame.origin.y, centerLabel2.frame.size.width, centerLabel2.frame.size.height);
    }
    else
    {
        centerLabel.text = [NSString stringWithFormat:@"%d",(int) (progress * 100)];
        
        CGSize size = [CommonMethod sizeWithString:centerLabel.text font:FONT_CUSTOM(75) maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
        centerLabel.frame = CGRectMake(70 - size.width / 2, centerLabel.frame.origin.y, size.width, centerLabel.frame.size.height);
        centerLabel2.frame = CGRectMake(centerLabel.frame.origin.x + centerLabel.frame.size.width, centerLabel2.frame.origin.y, centerLabel2.frame.size.width, centerLabel2.frame.size.height);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
