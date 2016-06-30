//
//  OldHomeworkItem.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OldHomeworkItem : NSObject
@property (nonatomic,copy) NSString *item_id;
@property (nonatomic,copy) NSString *homework_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *inserttime;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSString *audio;
@property (nonatomic,strong) NSData *audioData;
@property (nonatomic,copy) NSString *firstimg;
@property (nonatomic,copy) NSArray *pictures;  //NSString (URL)
@property (nonatomic,strong) UIImage *firstUIImage;
@property (nonatomic,copy) NSArray *picturesUIImage;  //UIImage

@property (nonatomic,copy)  NSString    *subject_name;
@end
