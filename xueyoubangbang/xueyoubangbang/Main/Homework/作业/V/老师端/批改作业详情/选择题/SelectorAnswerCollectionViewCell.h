//
//  SelectorAnswerCollectionViewCell.h
//  xueyoubangbang
//
//  Created by Bob on 15/9/14.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectorAnswerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *selectorItem;
/**
 *  hilighted 代表❌ normal代表✅
 */
@property (weak, nonatomic) IBOutlet UIImageView *answerImage;
- (void)displayAnswer:(NSString*)answer;
@end
