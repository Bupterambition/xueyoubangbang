//
//  ImageGallery.m
//  CLPlus
//
//  Created by Stephen Derico on 12/10/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import "ImageGallery.h"

static const NSInteger kGallatyViewHeight = 141;
@implementation ImageGallery

- (void)layoutSubviews{
 
    [super layoutSubviews];
    [self addSubview:self.scrollView];
    [self addSubview:self.spinner];
    [self addSubview:self.pageControl];
    [self handleImages];

}
- (void)loadUrlData:(NSArray*)urlData{
    self.scrollView.contentSize = CGSizeMake((SCREEN_WIDTH -10)*urlData.count, kGallatyViewHeight);
    [urlData enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        UIImageView *display = [[UIImageView alloc]initWithFrame:CGRectMake(idx*(SCREEN_WIDTH -10), 0, SCREEN_WIDTH -10, kGallatyViewHeight) ];
        display.userInteractionEnabled = YES;
        [self.scrollView addSubview:display];
        [display sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(obj)] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload];
        display.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToDetailPic)];
        [display addGestureRecognizer:tap];
        
    }];
    self.pageControl.numberOfPages = [urlData count];
    [self handleImages];
}
- (void)loadUrlData:(NSArray*)urlData withAnswerPic:(NSMutableArray *)picArray{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    self.scrollView.contentSize = CGSizeMake((SCREEN_WIDTH -10)*urlData.count, kGallatyViewHeight);
    if (picArray.count != 0) {
        [picArray enumerateObjectsUsingBlock:^(NSData *obj, NSUInteger idx, BOOL *stop) {
            UIImageView *display = [[UIImageView alloc]initWithFrame:CGRectMake(idx*(SCREEN_WIDTH -10), 0, SCREEN_WIDTH -10, kGallatyViewHeight) ];
            display.userInteractionEnabled = YES;
            [self.scrollView addSubview:display];
            display.image = [UIImage imageWithData:obj];
            display.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToDetailPic)];
            [display addGestureRecognizer:tap];
        }];
    }
    else{
        [urlData enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            UIImageView *display = [[UIImageView alloc]initWithFrame:CGRectMake(idx*(SCREEN_WIDTH -10), 0, SCREEN_WIDTH -10, kGallatyViewHeight) ];
            display.userInteractionEnabled = YES;
            [self.scrollView addSubview:display];
            [display sd_setImageWithURL:[NSURL URLWithString:UrlResStringForImg(obj)] placeholderImage:[UIImage imageNamed:@"loading"] options:SDWebImageProgressiveDownload completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [picArray addObject:UIImageJPEGRepresentation(image,0.000001)];
            }];
            display.contentMode = UIViewContentModeScaleAspectFit;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToDetailPic)];
            [display addGestureRecognizer:tap];
            
        }];
    }
    self.pageControl.numberOfPages = [urlData count];
    [self handleImages];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView {
    
    CGFloat pageWidth = self.scrollView.frame.size.width;
    NSInteger page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}
#pragma mark -private Method
- (void)handleImages{
    [self.spinner stopAnimating];
    [self.spinner hidesWhenStopped];
}
#pragma mark - event response
- (void)goToDetailPic{
    if ([self.delegate respondsToSelector:@selector(didTouchToDetail:)]) {
        [self.delegate didTouchToDetail:self.pageControl.currentPage];
    }
}

#pragma mark - setter and getter
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH -10, kGallatyViewHeight)];
        _scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        _scrollView.clipsToBounds = YES;
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        [_scrollView setBackgroundColor:[UIColor blackColor]];
        [_scrollView setCanCancelContentTouches:NO];
        _scrollView.delegate = self;
    }
    return _scrollView;
}
- (UIActivityIndicatorView *)spinner{
    if (_spinner == nil) {
        _spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kGallatyViewHeight/2, (SCREEN_WIDTH-10)/2, 25, 25)];
        [_spinner setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_spinner startAnimating];
    }
    return _spinner;
}
- (UIPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(50, kGallatyViewHeight - 30, (SCREEN_WIDTH-10) - 100, 25)];
        _pageControl.hidesForSinglePage = YES;
    }
    return _pageControl;
}

@end
