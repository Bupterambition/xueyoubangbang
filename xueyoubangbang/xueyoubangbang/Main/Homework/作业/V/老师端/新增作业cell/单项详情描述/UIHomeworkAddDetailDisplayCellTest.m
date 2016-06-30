//
//  UIHomeworkAddDetailDisplayCellTest.m
//  xueyoubangbang
//
//  Created by Bob on 15/12/27.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIHomeworkAddDetailDisplayCellTest.h"
#import "SDWebImageDecoder.h"
#import "SDImageCache.h"
@interface UIHomeworkAddDetailDisplayCellTest()
@property (nonatomic, strong) SDImageCache* imageCache;
@end
@implementation UIHomeworkAddDetailDisplayCellTest

- (void)awakeFromNib {
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, 82, 82);
    self.imageCache = [SDImageCache sharedImageCache];
}
- (void)loadImg:(UIImage *)img withKey:(NSString *)key{
    self.contentView.contentMode = UIViewContentModeScaleAspectFill;
    weak(weakself);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        strong(strongself);
        UIImage *imgRef = [self.imageCache imageFromMemoryCacheForKey:key];
        if (!imgRef) {
            imgRef = [UIImage decodedImageWithImage:img];
            [strongself.imageCache storeImage:imgRef recalculateFromImage:NO imageData:nil forKey:key toDisk:NO];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            strongself.contentView.layer.contents = (id)imgRef.CGImage;
        });
    });
}
- (void)loadVoice:(UIImage *)img{
    self.contentView.contentMode = UIViewContentModeScaleAspectFit;
    self.contentView.layer.contents = (id)img.CGImage;
}
@end
