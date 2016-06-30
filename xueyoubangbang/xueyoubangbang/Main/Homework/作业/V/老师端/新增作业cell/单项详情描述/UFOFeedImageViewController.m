//
//  UFOFeedImageViewController.m
//  newUfoSDK
//
//  Created by Bob on 15/8/21.
//  Copyright (c) 2015年 ___bidu___. All rights reserved.
//


#define UFOSCREENWIDTH  [UIScreen mainScreen].bounds.size.width
#define UFOSCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#import "ZoomScrollView.h"
#import "UFOFeedImageViewController.h"
@interface UFOFeedImageViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *imageDisplayView;
@property (nonatomic, strong) NSMutableArray *currentPicArray;
@end

@implementation UFOFeedImageViewController{
    NSArray *mutablePicArray;
    NSArray *checkPicArray;
    NSUInteger currentPicIndex;
    CGFloat scrollViewContentWidth;
    NSUInteger totalPic;
}
#pragma mark - life Method
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.imageDisplayView];
    [self initViewForInfinite];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - init Method
- (instancetype)initWithPicArray:(NSArray*)picArray andCurrentDisplayIndex:(NSUInteger)currentIndex{
    self = [super init];
    if (self) {
        mutablePicArray = picArray;
        currentPicIndex = currentIndex;
        totalPic = mutablePicArray.count;
    }
    return self;
}
- (instancetype)initWithCheckPicArray:(NSArray*)picArray andCurrentDisplayIndex:(NSUInteger)currentIndex{
    self = [super init];
    if (self) {
        checkPicArray = picArray;
        currentPicIndex = currentIndex;
        totalPic = picArray.count;
    }
    return self;
}
- (void)initView{
    if (mutablePicArray.count) {
        [mutablePicArray enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
            UIImageView *display = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
            ZoomScrollView *scrollview = [[ZoomScrollView alloc]initWithFrame:CGRectMake((idx) * UFOSCREENWIDTH, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
            [scrollview addSubview:display];
            display.image = [UIImage imageWithData:obj];
            display.contentMode = UIViewContentModeScaleAspectFit;
            display.tag = 10001;
            scrollview.tag = idx * UFOSCREENWIDTH +1;
            scrollview.delegate = self;
            scrollview.maximumZoomScale = 2.5f;
            [self.imageDisplayView addSubview:scrollview];
        }];
    }
    else{
        [checkPicArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            UIImageView *display = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
            ZoomScrollView *scrollview = [[ZoomScrollView alloc]initWithFrame:CGRectMake(( idx) * UFOSCREENWIDTH, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
            [scrollview addSubview:display];
            [display sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(obj)] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload];
            display.contentMode = UIViewContentModeScaleAspectFit;
            display.tag = 10001;
            scrollview.tag = idx * UFOSCREENWIDTH +1;
            scrollview.delegate = self;
            scrollview.maximumZoomScale = 2.5f;
            [self.imageDisplayView addSubview:scrollview];
        }];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToFeedDetails)];
    [self.imageDisplayView addGestureRecognizer:tap];
}
- (void)initViewForInfinite{
    if (mutablePicArray.count) {
        [self.imageDisplayView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self reloadCacheImg];
        [self.currentPicArray enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
            UIImageView *display = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
            ZoomScrollView *scrollview = [[ZoomScrollView alloc]initWithFrame:CGRectMake((idx) * UFOSCREENWIDTH, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
            [scrollview addSubview:display];
            display.image = [UIImage imageWithData:obj];
            display.contentMode = UIViewContentModeScaleAspectFit;
            display.tag = 10001;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:scrollview action:@selector(zoomImage:)];
            tap.numberOfTapsRequired = 2;
            [scrollview addGestureRecognizer:tap];
            scrollview.tag = idx * UFOSCREENWIDTH +1;
            scrollview.delegate = self;
            scrollview.maximumZoomScale = 2.f;
            [scrollview displayImage:nil];
            [self.imageDisplayView addSubview:scrollview];
        }];
    }
    else{
        [self.imageDisplayView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self reloadCacheImg];
        [self.currentPicArray enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            UIImageView *display = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
            ZoomScrollView *scrollview = [[ZoomScrollView alloc]initWithFrame:CGRectMake(( idx) * UFOSCREENWIDTH, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT) ];
            [scrollview addSubview:display];
            [display sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(obj)] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [scrollview displayImage:image];
            }];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:scrollview action:@selector(zoomImage:)];
            tap.numberOfTapsRequired = 2;
            [scrollview addGestureRecognizer:tap];
            display.contentMode = UIViewContentModeScaleAspectFit;
            display.tag = 10001;
            scrollview.tag = idx * UFOSCREENWIDTH +1;
            scrollview.delegate = self;
            scrollview.maximumZoomScale = 2.f;
            [scrollview displayImage:nil];
            [self.imageDisplayView addSubview:scrollview];
        }];
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backToFeedDetails)];
    tap.delegate = self;
    [self.imageDisplayView addGestureRecognizer:tap];
}
- (void)reloadCacheImg{
    if (mutablePicArray.count) {
        [self.currentPicArray removeAllObjects];
        NSLog(@"%ld,%ld,%ld",(currentPicIndex+mutablePicArray.count-1)%(mutablePicArray.count),currentPicIndex,(currentPicIndex+1)%(mutablePicArray.count));
        [self.currentPicArray addObject:mutablePicArray[(currentPicIndex+mutablePicArray.count-1)%(mutablePicArray.count)]];
        [self.currentPicArray addObject:mutablePicArray[currentPicIndex]];
        [self.currentPicArray addObject:mutablePicArray[(currentPicIndex+1)%(mutablePicArray.count)]];
    }
    else{
        NSLog(@"%ld,%ld,%ld",(currentPicIndex+checkPicArray.count-1)%(checkPicArray.count),currentPicIndex,(currentPicIndex+1)%(checkPicArray.count));
        [self.currentPicArray removeAllObjects];
        [self.currentPicArray addObject:checkPicArray[(currentPicIndex+checkPicArray.count-1)%(checkPicArray.count)]];
        [self.currentPicArray addObject:checkPicArray[currentPicIndex]];
        [self.currentPicArray addObject:checkPicArray[(currentPicIndex+1)%(checkPicArray.count)]];
    }
}
#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    if (scrollView.tag == 9999) {
        return nil;
    }
    else{
        return [scrollView viewWithTag:10001];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.tag != 9999) {
        return;
    }
    if (scrollView.contentOffset.x >= UFOSCREENWIDTH*2) {
        currentPicIndex = (currentPicIndex+1)%totalPic;
        [self initViewForInfinite];
        [scrollView setContentOffset:CGPointMake(UFOSCREENWIDTH, 0)];
    }
    else if (scrollView.contentOffset.x <= 0) {
        currentPicIndex = (currentPicIndex+totalPic-1)%totalPic;
        [self initViewForInfinite];
        [scrollView setContentOffset:CGPointMake(UFOSCREENWIDTH, 0)];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (scrollView.tag != 9999) {
        [(ZoomScrollView*)scrollView setNeedsLayout];
        [(ZoomScrollView*)scrollView layoutIfNeeded];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma mark - event Respond
- (void)backToFeedDetails{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setter and getter Method
- (UIScrollView*)imageDisplayView{
    if (_imageDisplayView == nil) {
        _imageDisplayView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, UFOSCREENWIDTH, UFOSCREENHEIGHT)];
        _imageDisplayView.alwaysBounceHorizontal = YES;
        _imageDisplayView.pagingEnabled = YES;
        _imageDisplayView.backgroundColor = [UIColor blackColor];
        _imageDisplayView.maximumZoomScale = 2;
        _imageDisplayView.minimumZoomScale = 1;
        _imageDisplayView.delegate = self;
        _imageDisplayView.tag = 9999;
        //        _imageDisplayView.contentSize = CGSizeMake(UFOSCREENWIDTH * (mutablePicArray.count + checkPicArray.count), UFOSCREENHEIGHT);
        _imageDisplayView.contentSize = CGSizeMake(UFOSCREENWIDTH * 3, UFOSCREENHEIGHT);
        scrollViewContentWidth = UFOSCREENWIDTH * (mutablePicArray.count + checkPicArray.count + 1);
        //        [_imageDisplayView setContentOffset:CGPointMake((currentPicIndex) * UFOSCREENWIDTH, 0)];
        [_imageDisplayView setContentOffset:CGPointMake( UFOSCREENWIDTH, 0)];
    }
    return _imageDisplayView;
}
- (NSMutableArray *)currentPicArray{
    if (_currentPicArray == nil) {
        _currentPicArray = [NSMutableArray array];
    }
    return _currentPicArray;
}
@end
