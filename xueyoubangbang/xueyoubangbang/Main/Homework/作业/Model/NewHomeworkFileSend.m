//
//  NewHomeworkFileSend.m
//  xueyoubangbang
//
//  Created by Bob on 15/9/8.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "NewHomeworkFileSend.h"

@implementation NewHomeworkFileSend
CoreArchiver_MODEL_M
- (NSInteger)picNum{
    return [self.item_imgscnt integerValue] + (self.item_audio == nil?0:1);
}

- (NSArray *)stringToArray{
    return [self.true_img toArray:NO];
}

- (void)transferArrayToString:(NSArray *)array{
    self.true_img = [array toString];
}

- (void)transferDataTOString:(NSData*)rawData{
    self.item_audio = [rawData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (NSData*)getAudioData{
    if (self.item_audio == nil) {
        return  nil;
    }
    return [[NSData alloc] initWithBase64EncodedString:self.item_audio options:NSDataBase64DecodingIgnoreUnknownCharacters];
}

- (NSString*)item_imgscnt{
    if (_item_imgscnt == nil) {
        _item_imgscnt = @"0";
    }
    return _item_imgscnt;
}

@end
