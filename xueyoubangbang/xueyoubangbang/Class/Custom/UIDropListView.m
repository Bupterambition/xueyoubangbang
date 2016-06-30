//
//  UIDropListView.m
//  xueyoubangbang
//
//  Created by sdzhu on 15/3/20.
//  Copyright (c) 2015年 sdzhu. All rights reserved.
//

#import "UIDropListView.h"
#import "MSubject.h"
@interface UIDropListView ()
{
    CGFloat _itemHeight;
}
@end

@implementation UIDropListView
@synthesize table;
- (id) initWithFrame:(CGRect)frame itemHeight:(CGFloat)itemHeight data:(NSArray *)data
{
    self = [super initWithFrame:frame];
    if(self)
    {
        _height = data.count * itemHeight;
        _itemHeight = itemHeight;
        _data = data;
        table = [[UITableView alloc] init];
        table.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        table.dataSource = self;
        table.delegate = self;
        table.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:table];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _data.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return _itemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * const cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(nil == cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.text = [_data objectAtIndex:indexPath.row];
//    cell.textLabel.text = subject.subject_name;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self removeFromSuperview]; 
    if([self.delegate respondsToSelector:@selector(onChooseItem:)])
    {
        [self.delegate onChooseItem:indexPath.row];
    }
}

@end
