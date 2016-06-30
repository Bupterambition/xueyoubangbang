//
//  MHomeworkItem.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/26.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MHomeworkItem : NSObject
@property (nonatomic,copy) NSString *item_id;
@property (nonatomic,copy) NSString *homework_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *inserttime;
@property (nonatomic,copy) NSString *imgs;
@property (nonatomic,copy) NSString *audio;
@property (nonatomic,retain) NSData *audioData;
@property (nonatomic,copy) NSString *firstimg;
@property (nonatomic,retain) NSArray *pictures;  //NSString (URL)
@property (nonatomic,retain) UIImage *firstUIImage;
@property (nonatomic,retain) NSArray *picturesUIImage;  //UIImage

@property (nonatomic,copy)  NSString    *subject_name;

+(MHomeworkItem *)objectWithDictionary:(NSDictionary *)dic;

@end
