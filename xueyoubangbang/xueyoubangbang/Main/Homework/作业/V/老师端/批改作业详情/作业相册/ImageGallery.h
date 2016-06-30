//
//  ImageGallery.h
//  CLPlus
//
//  Created by Stephen Derico on 12/10/11.
//  Copyright (c) 2011 Bixby Apps. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ImageGalleryDelegate <NSObject>
- (void)didTouchToDetail:(NSInteger)index;
@end

@interface ImageGallery : UIView <UIScrollViewDelegate>
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;
@property (nonatomic, weak) id<ImageGalleryDelegate> delegate;
- (void)loadUrlData:(NSArray*)urlData;
- (void)loadUrlData:(NSArray*)urlData withAnswerPic:(NSMutableArray *)picArray;
@end
