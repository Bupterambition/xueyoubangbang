//
//  ClockView.m
//  xueyoubangbang
//
//  Created by Bob on 16/1/1.
//  Copyright (c) 2016年 sdzhu. All rights reserved.
//

#import "ClockView.h"
#import "NewHomeWork.h"
#import "NSString+Stackoverflow.h"
#import "UIHomeworkListViewModel.h"
@interface ClockView ()<UIScrollViewDelegate>
@property (nonatomic, copy) NSArray *homeworks;
@property (nonatomic, weak) UIView *mainView;
@property (nonatomic, strong) UIHomeworkListViewModel *viewModel;
@end
@implementation ClockView{
    UIImageView *_bgView;
    CGFloat curBgViewHeight;
}

- (void)creatWithMainView:(UIView *)mainView andScrollView:(UIScrollView *)scrollView andDataSource:(UIHomeworkListViewModel *)viewModel{
    self.mainView = mainView;
    scrollView.delegate = self;
    weak(weakself);
    self.viewModel = viewModel;
    [RACObserve(self.viewModel, finishUpdate) subscribeNext:^(id x) {
        if ([x boolValue]) {
            weakself.homeworks = weakself.viewModel.homeworks;
        }
    }];
    [self createInfoPanelView];
}
#pragma mark - 创建表盘
- (void)createInfoPanelView{
    
    UIImage *image = [UIImage imageNamed:@"clock_handler"];
    UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 110.f, 150.f, 62.f)];
    bgView.image = [image stretchableImageWithLeftCapWidth:image.size.width/2.0 topCapHeight:image.size.height/2.0];
    bgView.userInteractionEnabled = YES;
    bgView.alpha = 0.f;
    _bgView = bgView;
    [self.mainView addSubview:bgView];
    
    UIImageView *clockImage = [[UIImageView alloc]initWithFrame:CGRectMake(6.f, 6.f, 50.f, 50.f)];
    clockImage.image = [UIImage imageNamed:@"表盘图标"];
    clockImage.tag = 10010;
    [_bgView addSubview:clockImage];
    
    UIImageView *minImage = [[UIImageView alloc]initWithFrame:CGRectMake(5.f, 5.f, 40.f, 40.f)];
    minImage.image = [UIImage imageNamed:@"分钟"];
    minImage.tag = 10011;
    [clockImage addSubview:minImage];
    
    UIImageView *hourImage = [[UIImageView alloc]initWithFrame:CGRectMake(25.f/2, 25.f/2, 25.f, 25.f)];
    hourImage.image = [UIImage imageNamed:@"时钟"];
    hourImage.tag = 10012;
    [clockImage addSubview:hourImage];
    
    for (int i = 0; i < 2; i++) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(66.f, 10.f + i*28.f, 90.f, 15.f)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = (i == 0) ? [UIColor whiteColor] : [UIColor colorWithRed:192/255.f green:190/255.f blue:191/255.f alpha:1.0];
        titleLabel.font = (i == 0) ? [UIFont boldSystemFontOfSize:15.f] : [UIFont systemFontOfSize:13.f];
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.tag = 10020 + i;
        [_bgView addSubview:titleLabel];
    }
}

#pragma mark - 表盘时间控制
- (void)changeTime:(float)hour min:(float)min{
    
    UIImageView *clockImage = (UIImageView *)[_bgView viewWithTag:10010];
    UIImageView *minImage = (UIImageView *)[clockImage viewWithTag:10011];
    UIImageView *hourImage = (UIImageView *)[clockImage viewWithTag:10012];
    
    CGAffineTransform hourTransform = CGAffineTransformMakeRotation((hour + min/60.f) *(M_PI / 6.0f));
    
    CGAffineTransform minTransform = CGAffineTransformMakeRotation(min *(M_PI / 30.0f));
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        
        hourImage.transform = hourTransform;
        minImage.transform = minTransform;
    } completion:nil];
}
#pragma mark - 滑动回调代理

- (void)infoPanelDidScroll:(UITableView *)messageBaseTableView atPoint:(CGPoint)point {
    NSIndexPath * indexPath = [messageBaseTableView indexPathForRowAtPoint:point];
    NSString *dataString =[((NewHomeWork *)self.homeworks[indexPath.section]).finishtime transTimeWithOriginFormat:@"yyyy-MM-dd HH:mm:ss" toFormat:@"yyyy-MM-dd HH:mm"] ;
    UILabel *timeLabel = (UILabel *)[_bgView viewWithTag:10020];
    UILabel *dateLabel = (UILabel *)[_bgView viewWithTag:10021];
    if (dataString && dataString.length == 16) {
        NSString *dateString = [dataString substringToIndex:10];
        NSString *timeString = [dataString substringFromIndex:11];
        
        CGFloat hour = [[timeString substringToIndex:2] floatValue];
        CGFloat min = [[timeString substringFromIndex:3] floatValue];
        
        if (hour > 12.f) {
            hour = hour - 12.f;
            NSString *tureTime = (hour < 10) ? [timeString stringByReplacingCharactersInRange:NSMakeRange(0,2) withString:[NSString stringWithFormat:@"0%.f",hour]] : [timeString stringByReplacingCharactersInRange:NSMakeRange(0,2) withString:[NSString stringWithFormat:@"%.f",hour]];
            timeLabel.text = [NSString stringWithFormat:@"下午 %@",tureTime];
        }else{
            
            timeLabel.text = [NSString stringWithFormat:@"上午 %@",timeString];
        }
        
        dateLabel.text = dateString;
        [self changeTime:hour min:min];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UITableView *)messageBaseTableView{
    if (self.homeworks.count == 0) {
        return;
    }
    CGFloat heightScale = 0.f;
    if (messageBaseTableView.contentOffset.y <= 0 || messageBaseTableView.contentOffset.y >= messageBaseTableView.contentSize.height - messageBaseTableView.frame.size.height) {
        
        heightScale = (messageBaseTableView.contentOffset.y > 0) ? 0.99999f : 0.f;
    }else{
        
        heightScale = messageBaseTableView.contentOffset.y/(messageBaseTableView.contentSize.height - messageBaseTableView.frame.size.height);
    }
    
    curBgViewHeight = heightScale * (messageBaseTableView.frame.size.height-49);
    
    CGRect newFrame = _bgView.frame;
    newFrame.origin.y = curBgViewHeight - 62.f*heightScale  ;
    _bgView.frame = newFrame;
    
    _bgView.hidden = (messageBaseTableView.contentSize.height < messageBaseTableView.frame.size.height) ? YES : NO;
    CGFloat indexHeight = heightScale*messageBaseTableView.contentSize.height + (0.5 - heightScale)*62.f;
    
    [self infoPanelDidScroll:messageBaseTableView atPoint:CGPointMake(20.f, indexHeight)];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.alpha = 1.f;
        CGRect newFrame = _bgView.frame;
        if (newFrame.origin.x == self.mainView.frame.size.width) {
            
            newFrame.origin.x = self.mainView.frame.size.width - 150.f;
            _bgView.frame = newFrame;
        }
    }completion:nil];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.alpha = 0.f;
        CGRect newFrame = _bgView.frame;
        if (newFrame.origin.x != self.mainView.frame.size.width) {
            newFrame.origin.x = self.mainView.frame.size.width;
            _bgView.frame = newFrame;
        }
    }completion:nil];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate) {
        [UIView animateWithDuration:0.2 animations:^{
            _bgView.alpha = 0.f;
            CGRect newFrame = _bgView.frame;
            if (newFrame.origin.x != self.mainView.frame.size.width) {
                newFrame.origin.x = self.mainView.frame.size.width;
                _bgView.frame = newFrame;
            }
        }completion:nil];
    }
}
#pragma mark -  UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [self.viewModel.tableSubject sendNext:indexPath];
}
@end
