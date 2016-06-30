//
//  PopListView.h
//  CodexPopupList
//
//  Created by huyang on 14-4-20.
//
//

#import <UIKit/UIKit.h>
@protocol PopListViewDelegate <NSObject>
- (void) onChooseItem:(NSInteger)row;

@end

@interface PopListView : UIView<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    //NSMutableArray *_data;
}
- (id)initWithFrame:(CGRect)frame data:(NSMutableArray *)data;
- (void)reloadData:(int)currentIndex;
@property (nonatomic) int currentIndex;
@property (nonatomic,weak) id<PopListViewDelegate> delegate;
@property (nonatomic,retain) NSMutableArray *data;
@end
