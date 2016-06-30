//
//  PopListView.m
//  CodexPopupList
//
//  Created by huyang on 14-4-20.
//
//

#import "PopListView.h"

@implementation PopListView

- (id)initWithFrame:(CGRect)frame data:(NSMutableArray *)data
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        //初始化tableview
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height )];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.backgroundColor = [UIColor clearColor];
        //[_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        if (IOS_VERSION_7_OR_ABOVE)
        {
            [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        UIColor *sepratorLineColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"di_box"]];
        _tableView.separatorColor = sepratorLineColor;
        //[self setClipsToBounds:YES];
        self.backgroundColor = [UIColor clearColor];
        
        //初始化箭头
        UIImage *arrowImage = [UIImage imageNamed:@"bg_box2"];
        CGFloat arrowHeight = arrowImage.size.height;
        CGRect arrowRect = CGRectMake(234, - arrowHeight, arrowImage.size.width, arrowHeight);
        UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:arrowImage];
        [arrowImageView setFrame:arrowRect];
        
        
        self.data = data;
        
        [self addSubview:_tableView];
        [self addSubview:arrowImageView];
    }
    return self;
}

- (void)show:(BOOL)animated
{
    self.hidden = NO;
    if(animated)
    {
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            
        }];
    }
    else{
        self.alpha = 1;
    }
    
}

- (void)hide:(BOOL)animated
{
    if(animated){
        [UIView animateWithDuration:0.3 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
    else{
        self.alpha = 0;
        self.hidden = YES;
    }
}


- (void)drawRect:(CGRect)rect
{
    NSLog(@"popList drawRect = %@",NSStringFromCGRect(rect));
    NSLog(@"self.frame = %@",NSStringFromCGRect(self.frame));
    UIImage *originimage = [UIImage imageNamed:@"bg_box1"];
    UIImage *newImage = [originimage stretchableImageWithLeftCapWidth:originimage.size.width / 2.0 topCapHeight:originimage.size.height / 2.0];
    //CGRect bgRect = CGRectMake(-10, -20, rect.size.width + 10, rect.size.height + 20);
    [newImage drawInRect:rect blendMode:kCGBlendModeNormal alpha:1.0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 42.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.data.count;
    return self.data.count ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //UILabel *lb;
    if(!cell)
    {
        //cell = [[UITableViewCell alloc] init];
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.width - 10, cell.frame.size.height)];
//        view.backgroundColor = [UIColor blueColor];
//        cell.selectedBackgroundView = view;
        cell.backgroundColor = [UIColor clearColor];
       
        NSLog(@"cell.frame = %@",NSStringFromCGRect(cell.frame));
//        lb = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, cell.frame.size.width - 13, cell.frame.size.height)];
//        lb.tag = 100001;
//        //[btn.titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
//        lb.textAlignment = UITextAlignmentLeft;
//        lb.lineBreakMode = NSLineBreakByTruncatingTail;
//        //[btn setBackgroundColor:[UIColor redColor]];
//        [cell addSubview:lb];
    }
    //lb = [cell viewWithTag:100001];
    cell.textLabel.text = [_data objectAtIndex:indexPath.row];
    UIFont *font = FONT_CUSTOM(14);
    [cell.textLabel setFont:font];
    if (indexPath.row == self.currentIndex)
    {
        cell.textLabel.textColor = [UIColor colorWithRed:0xfa/255.0f green:0xf0/255.0f blue:0xaf/255.0f alpha:1.0];
    }
    else
    {
        cell.textLabel.textColor = [UIColor colorWithRed:0xe9/255.0f green:0xed/255.0f blue:0xf3/255.0f alpha:1.0];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selected = NO;
   
    cell.textLabel.textColor = [UIColor whiteColor];
    
    if([self.delegate respondsToSelector:@selector(onChooseItem:)])
    {
        [self.delegate onChooseItem:indexPath.row];
    }
}

- (void)reloadData:(int) currentIndex
{
    if (_tableView)
    {
        self.currentIndex = currentIndex;
        [_tableView reloadData];
//        if (![self isVisible:currentIndex])
//        {
            NSIndexPath *path = [NSIndexPath indexPathForRow:currentIndex inSection:0];
            [_tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//        }
    }
}

- (BOOL)isVisible:(int)index
{
    NSArray *visibleRows = [_tableView indexPathsForVisibleRows];
    for(NSIndexPath *path in visibleRows)
    {
        if (path.row == index)
        {
            return YES;
        }
    }
    return NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
