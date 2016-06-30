//
//  ClockView.h
//  xueyoubangbang
//  使用了RAC库，因此tableview的delegate使用的是racsubject来代替，这样就可以极大的给VC进行减负
//  Created by Bob on 16/1/1.
//  Copyright (c) 2016年 sdzhu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveCocoa/RACSubject.h>
@class UIHomeworkListViewModel;
@interface ClockView : UIView
- (void)creatWithMainView:(UIView *)mainView andScrollView:(UIScrollView *)scrollView andDataSource:(UIHomeworkListViewModel *)viewModel;
@end
