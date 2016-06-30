//
//  UIHomeworkDetailQuestionViewController.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkDetailQuestionViewController.h"
#import "UIQuestionAskViewController.h"
#import "AudioPlayer.h"
@interface UIHomeworkDetailQuestionViewController ()
{
    UIScrollView *scrollView;
    UIView *top;
    UIView *imageContainer;
    UIView *voiceContainer;
    UIView *textContainer;
    
    UIView *container;
    
    UIView *seperate1;
    UIView *seperate2;
    UIView *seperate3;
    
    NSArray *images;
    NSString *text;
    NSMutableArray *_imageViews;
}
@end

@implementation UIHomeworkDetailQuestionViewController

-(id)init
{
    self = [super init];
    if(self){
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadData];
    [self createViews];
}

- (void)loadData
{
    images = _homeworkItem.pictures;
    text = _homeworkItem.desc;
}

- (void)createViews
{
    self.view.backgroundColor = VIEW_BACKGROUND_COLOR;
    self.navigationItem.title = @"作业详情";
    
    scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - kNavigateBarHight);
    
    [self.view addSubview:scrollView];
    
    [self createContainer];
    
    [self createTop];
    seperate1 = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft,top.frame.origin.y + top.frame.size.height, top.frame.size.width - kPaddingLeft * 2, 1)];
    seperate1.backgroundColor = VIEW_BACKGROUND_COLOR;
    [container addSubview:seperate1];
    
     [self createTextContainer];
    
    if(textContainer != nil)
    {
        seperate2 = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft,textContainer.frame.origin.y + textContainer.frame.size.height, textContainer.frame.size.width - kPaddingLeft * 2, 1)];
        seperate2.backgroundColor = VIEW_BACKGROUND_COLOR;
        [container addSubview:seperate2];
    }
    else
    {
        seperate2 = seperate1;
    }
    
    [self createVoiceContainer];
    
    if(voiceContainer != nil)
    {
        seperate3 = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft,voiceContainer.frame.origin.y + voiceContainer.frame.size.height, voiceContainer.frame.size.width - kPaddingLeft * 2, 1)];
        seperate3.backgroundColor = VIEW_BACKGROUND_COLOR;
        [container addSubview:seperate3];
    }
    else
    {
        seperate3 = seperate2;
    }

    
    [self createImageContainer];
    
//    seperate3 = [[UIView alloc] initWithFrame:CGRectMake(kPaddingLeft,imageContainer.frame.origin.y + imageContainer.frame.size.height, imageContainer.frame.size.width - kPaddingLeft * 2, 1)];
//    seperate3.backgroundColor = VIEW_BACKGROUND_COLOR;
//    [container addSubview:seperate3];
    
    container.frame = CGRectMake(0, kPaddingTop, SCREEN_WIDTH,top.frame.size.height + imageContainer.frame.size.height + voiceContainer.frame.size.height + textContainer.frame.size.height + 3 );
    
    scrollView.contentSize = CGSizeMake(container.frame.size.width, container.frame.origin.y + container.frame.size.height + 50);
}

- (void)createContainer
{
    container = [[UIView alloc] init];
    container.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:container];
}

- (void)createTop
{
    CGFloat topH = 30;
    top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, topH)];
    [self.view addSubview:top];
    
    //左上角
    
    UIImageView *leftIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_message_remind"]];
    leftIcon.frame = CGRectMake(10, topH / 2 - leftIcon.frame.size.height / 2, leftIcon.frame.size.width, leftIcon.frame.size.height);
    [top addSubview:leftIcon];
    
    UILabel *lbTitle = [[UILabel alloc]init];
    lbTitle.font = FONT_CUSTOM(14);
    lbTitle.frame = CGRectMake([leftIcon rightX] + 10, 0, 100, topH);
    lbTitle.text =_homeworkItem.title;
    [top addSubview:lbTitle];
    
    if([rolesUser isEqualToString:roleStudent])
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"问一下" forState:UIControlStateNormal];
        btn.titleLabel.font = FONT_CUSTOM(14);
        btn.frame = CGRectMake(SCREEN_WIDTH - 50 - 10, 0, 50, topH);
        [btn addTarget:self action:@selector(doAsk) forControlEvents:UIControlEventTouchUpInside];
        [top addSubview:btn];
        UIImageView *rigthIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"homework_question"]];
        rigthIcon.frame = CGRectMake(btn.frame.origin.x - rigthIcon.frame.size.width, topH / 2 - rigthIcon.frame.size.height / 2, rigthIcon.frame.size.width, rigthIcon.frame.size.height);
        [top addSubview:rigthIcon];

    }
    
    [container addSubview:top];
}

- (void)createImageContainer
{
    CGFloat containerH = 0;
    imageContainer = [[UIView alloc]init];
    [container addSubview:imageContainer];
    _imageViews = [NSMutableArray array];
    for (int i = 0 ; i< images.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.frame = CGRectMake(kPaddingLeft, containerH + 10, SCREEN_WIDTH - 2 *kPaddingLeft, 200);
        [imageContainer addSubview:imageView];
        containerH += imageView.frame.size.height + 10;
        
        [_imageViews addObject:imageView];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandle:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:gesture];
        
        [imageView setDefaultLoadingView];
        [imageView sd_setImageWithURL:[NSURL URLWithString:UrlResString( [_homeworkItem.pictures objectAtIndex:i])]];
    }
    containerH += 10;
    imageContainer.frame = CGRectMake(0, seperate3.frame.origin.y + seperate3.frame.size.height, SCREEN_WIDTH ,containerH);
}

- (void)tapHandle:(UITapGestureRecognizer *)tap {
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    //    imageViewer.delegate = self;
    [imageViewer showWithImageViews:_imageViews selectedView:(UIImageView *)tap.view];
}

- (void)createVoiceContainer
{
    
    
    if(![CommonMethod isBlankString:_homeworkItem.audio] || _homeworkItem.audioData != nil)
    {
        voiceContainer = [[UIView alloc]init];
        AudioPlayer *audio = [[AudioPlayer alloc] init];
        audio.frame = CGRectMake(kPaddingLeft, 10, 0, 0);
        audio.audioUrl = _homeworkItem.audio;
        audio.amrAudio = _homeworkItem.audioData;
        [voiceContainer addSubview:audio];
        [container addSubview:voiceContainer];
        voiceContainer.frame = CGRectMake(0, [seperate2 bottomY], SCREEN_WIDTH, audio.frame.size.height + 20);
    }
    
}

- (void)createTextContainer
{
    
    if([CommonMethod isBlankString:text])
    {
        return;
    }
    textContainer = [[UIView alloc]init];
    [container addSubview:textContainer];
    
    UILabel *label = [[UILabel alloc] init];
    label.numberOfLines = 0;
    label.font = [UIFont systemFontOfSize:16];
    CGSize size = [CommonMethod sizeWithString:text font:label.font maxSize:CGSizeMake(SCREEN_WIDTH - 20, MAXFLOAT)];
    label.frame = CGRectMake(10, kPaddingTop, size.width, size.height);
    label.text = text;
    textContainer.frame = CGRectMake(0, seperate1.frame.origin.y + seperate1.frame.size.height, SCREEN_WIDTH, label.frame.size.height + kPaddingTop * 2);
    [textContainer addSubview:label];
}

- (void)doAsk
{
    UIQuestionAskViewController *ctrl = [[UIQuestionAskViewController alloc]init];
    ctrl.homeworkItem = _homeworkItem;
    [self.navigationController pushViewController:ctrl animated:YES];
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
