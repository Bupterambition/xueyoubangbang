//
//  UIQuestionDetailViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/16.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIQuestionDetailViewController.h"
#import "UIQuestionTableViewCell.h"
#import "UIQuestionAnswerTableViewCell.h"

#import "MQuestion.h"
#import "MAnswer.h"
#import "UIQuestionMyAnswerViewContrller.h"
#import "AudioPlayer.h"
@interface UIQuestionDetailViewController()<XHImageViewerDelegate>
{
    UITableView *table;
    CGFloat questionHeight;
    
    NSMutableArray *answerArr;
    
    NSMutableArray *_imageViews;
}

@end
@implementation UIQuestionDetailViewController

- (id)init
{
    self = [super init];
    if(self)
    {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    
    answerArr = [[NSMutableArray alloc] init];
    [self createViews];
}

- (void)createViews
{
//    UIView *question = [self createQuestion];
//    [self.view addSubview:question];
//    UIView *table = [self createTable];
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"问题详情";
    [self createTable];
//    [self loadData];
}

- (void)loadData
{
    NSDictionary *para = @{@"userid":[GlobalVar instance].user.userid,@"userkey":[GlobalVar instance].user.key,@"id":_question.question_id};
    [AFNetClient GlobalGet:kUrlGetQuestion parameters:para success:^(AFHTTPRequestOperation *operation, NSDictionary *dataDict)
     {
         [answerArr removeAllObjects];
         NSArray *dataArray = dataDict[@"question"][@"answerlist"];
         for (int i=0; i< dataArray.count; i++)
         {
             [answerArr addObject:[MAnswer objectWithDictionary:dataArray[i]]];
         }
         [table reloadData];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [CommonMethod showAlert:@"加载失败"];
     }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

- (UIView *)createQuestion
{
    CGFloat h = 0;
    //题面
    UIView *question = [[UIView alloc] init];
    
    //题面内容文字
    UIView *content = [[UIView alloc] init];
    UILabel *textLable = [[UILabel alloc] init];
    CGFloat const textWidth = SCREEN_WIDTH - kPaddingLeft * 2;
    textLable.numberOfLines = 0;
    textLable.text = _question.desc;
    CGSize textLableSize = [CommonMethod sizeWithString:textLable.text font:textLable.font maxSize:CGSizeMake(textWidth, MAXFLOAT)];
    textLable.frame = CGRectMake(10, 10, textWidth, textLableSize.height);
    [content addSubview:textLable];
    h = [textLable bottomY] + 10;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    if(![CommonMethod isBlankString:_question.firstimg])
    {
        _imageViews = [NSMutableArray array];
        imageView.frame = CGRectMake(10, [textLable bottomY] + 10, SCREEN_WIDTH - 20, 200);

        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [content addSubview:imageView];
        
        [_imageViews addObject:imageView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:gesture];
        
        [imageView setDefaultLoadingView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString( _question.firstimg)] placeholderImage:[CommonMethod createImageWithColor:[UIColor grayColor] size:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)]];
        
        h += imageView.frame.size.height + 10;
    }
    else
    {
        imageView.frame = CGRectMake(10, [textLable bottomY], 0, 0);
    }
    
    if(![CommonMethod isBlankString:_question.audio])
    {
        AudioPlayer  *audio = [[AudioPlayer alloc] init];
        audio.frame = CGRectMake(10, [imageView bottomY] + 10, 0, 0);
        audio.audioUrl = _question.audio;
        [content addSubview:audio];
        
        h += audio.frame.size.height + 10;
    }

    content.frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
    [question addSubview:content];
    
    question.frame = CGRectMake(0,0, SCREEN_WIDTH, content.frame.size.height + content.frame.origin.y + 10);
    questionHeight = question.frame.size.height;
    return question;

}

- (UIView *)createQuestion2
{
    
    //题面
    UIView *question = [[UIView alloc] init];
    
    //题面内容文字
    UIView *content = [[UIView alloc] init];
    UILabel *textLable = [[UILabel alloc] init];
    CGFloat const textWidth = SCREEN_WIDTH - kPaddingLeft * 2;
    textLable.numberOfLines = 0;
    textLable.text = _question.desc;
    CGSize textLableSize = [CommonMethod sizeWithString:textLable.text font:textLable.font maxSize:CGSizeMake(textWidth, MAXFLOAT)];
    textLable.frame = CGRectMake(10, 10, textWidth, textLableSize.height);
    [content addSubview:textLable];
    
    
    CGFloat voiceViewY = [textLable bottomY] + 10;
    AudioPlayer *audio;
    if(![CommonMethod isBlankString:_question.audio])
    {
        audio = [[AudioPlayer alloc] init];
        audio.frame = CGRectMake(10, voiceViewY, 0, 0);
        audio.audioUrl = _question.audio;
        [content addSubview:audio];
    }
    CGFloat imageViewStartY;
    if(audio)
    {
        imageViewStartY = [audio bottomY] + 10;
    }
    else
    {
        imageViewStartY = [textLable bottomY] + 10;
    }

    //图片
    CGFloat imageViewY =  10 + [audio bottomY];
    CGFloat imageWidth = (SCREEN_WIDTH - 10 * 4) / 3;
    CGFloat imageHeight = imageWidth;
    CGFloat imageX = 10;
    _imageViews = [NSMutableArray array];
//    _question.pictures = @[@"/Question/2015-03-29/5516e2b26d72a.png",@"/Question/2015-03-29/5516e2b26f1e4.png",@"/Question/2015-03-29/5516e2b26f1e4.png",@"/Question/2015-03-29/5516e2b26f1e4.png",@"/Question/2015-03-29/5516e2b26f1e4.png",@"/Question/2015-03-29/5516e2b26f1e4.png",@"/Question/2015-03-29/5516e2b26f1e4.png"];
    for (int i = 0;i<_question.pictures.count ;i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        if(fmodf(i,3) == 0)
        {
            imageX = 10;
            if(i == 0)
            {
                imageViewY = imageViewStartY;
            }
            else
            {
                imageViewY += imageHeight + 10;
            }
        }
        else
        {
            imageX += imageWidth + 10;
        }
        
        imageView.frame = CGRectMake(imageX, imageViewY, imageWidth, imageHeight);
        
        
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [content addSubview:imageView];
        
        [_imageViews addObject:imageView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:gesture];
        
        [imageView setDefaultLoadingView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString( [_question.pictures objectAtIndex:i])] placeholderImage:[CommonMethod createImageWithColor:[UIColor grayColor] size:CGSizeMake(imageView.frame.size.width, imageView.frame.size.height)]];
        
    }
    if(_question.pictures.count > 0)
    {
        imageViewY += imageWidth ;
    }
    
    
    content.frame = CGRectMake(0, 0, SCREEN_WIDTH, imageViewY);
    [question addSubview:content];
    
    question.frame = CGRectMake(0,0, SCREEN_WIDTH, content.frame.size.height + content.frame.origin.y + 10);
//    question.backgroundColor = [UIColor redColor];
    
    
    questionHeight = question.frame.size.height;
    return question;
    
}

- (void)tapHandle:(UITapGestureRecognizer *)tap {
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    imageViewer.delegate = self;
    [imageViewer showWithImageViews:_imageViews selectedView:(UIImageView *)tap.view];
}

- (void)createTable
{
    table = CREATE_TABLE(UITableViewStyleGrouped);
    table.delegate = self;
    table.dataSource = self;
    table.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - kNavigateBarHight );
    [self.view addSubview:table];
    
//    UIButton *btnFinish = BUTTON_CUSTOM(0);
//    btnFinish.frame = CGRectMake(btnFinish.frame.origin.x, self.view.frame.size.height - kNavigateBarHight - btnFinish.frame.size.height - kPaddingTop, btnFinish.frame.size.width , btnFinish.frame.size.height );
//    [btnFinish setTitle:@"我来回答" forState:UIControlStateNormal];
//    [btnFinish addTarget:self action:@selector(doMyAnswer) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:btnFinish];
//    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50 + kPaddingTop * 2)];
//    [footer addSubview:btnFinish];
//    table.tableFooterView = footer;
    if(_questionType == 2)
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"我来回答" style:UIBarButtonItemStylePlain target:self action:@selector(doMyAnswer)];
    }
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return answerArr.count + 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        NSString *CellIdentifier = @"cellIdentifier0";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.imageView.contentMode = UIViewContentModeScaleToFill;
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString(_question.header_photo)] placeholderImage:DEFAULT_HEADER];
            cell.textLabel.text = _question.username;
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   %@", _question.subject_name,[CommonMethod timeToNow:_question.inserttime]];
        }
        
        return cell;
    }
    else if(indexPath.section == 1){
        NSString *CellIdentifier = @"cellIdentifier1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIView *quesitonView = [self createQuestion];
            [cell.contentView addSubview:quesitonView];
            
        }
        return cell;
    }
    else{
        NSString *CellIdentifier = @"cellIdentifier2";

        UIQuestionAnswerTableViewCell *cell = [[UIQuestionAnswerTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        MAnswer *answer = [answerArr objectAtIndex:indexPath.section  - 2];
        [cell settingData:answer];
        
        return cell;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        return 44;
    }
    else if(indexPath.section == 1){
        return questionHeight;
        
    }
    else {
        MAnswer *answer = [answerArr objectAtIndex:indexPath.section - 2];
        UIQuestionAnswerTableViewCellFrame *frame = [[UIQuestionAnswerTableViewCellFrame alloc] initWithAnswer:answer];
        CGFloat h = frame.cellHeight;
        return h;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kSectionPadding;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)doMyAnswer
{
    UIQuestionMyAnswerViewContrller *ctrl = [[UIQuestionMyAnswerViewContrller alloc] init];
    ctrl.question = _question;
    UICustomNavigationViewController *nav = [[UICustomNavigationViewController alloc] initWithRootViewController:ctrl];
    [self presentViewController:nav animated:YES completion:nil];
}


@end
