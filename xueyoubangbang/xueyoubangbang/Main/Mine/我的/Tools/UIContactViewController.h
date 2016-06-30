//
//  UIContactViewController.h
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/18.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIContactViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchBarDelegate>
@property (nonatomic,retain) NSMutableArray *choosedItems; //MContact
@end
