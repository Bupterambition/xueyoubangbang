//
//  UILoginRegistClassSearchViewController.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILoginRegistClassSearchViewController : UIViewController<UISearchBarDelegate,UISearchDisplayDelegate,UITableViewDataSource,UITableViewDelegate>
@property (nonatomic) NSInteger type;
@end
