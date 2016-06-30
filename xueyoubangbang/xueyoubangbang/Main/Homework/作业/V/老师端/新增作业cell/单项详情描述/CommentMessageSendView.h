
#import <UIKit/UIKit.h>

static const CGFloat kToolbarHeight = 98 / 2.f;

@protocol CommentMsgSendViewDelegate <NSObject>
@optional
- (void)msgChangeHeight:(CGFloat)height;
- (void)onClickMessageSendButton:(BOOL)isAnony text:(NSString*)text;

@end

@interface CommentMessageSendView : UIView
@property(nonatomic, assign) id <CommentMsgSendViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;
- (void)showMessageSendView;
- (void)hideMessageSendView;
- (void)setPlaceHolder:(NSString*)placeHolder;
- (void)sendFailure:(NSString*)content isAnony:(BOOL)isAnony;
- (void)setAllowAnonymous:(BOOL)anonymous;
- (void)resetInputContent;
- (void)setReplySomeone:(NSString*)text;
- (NSString*)inputText;

@end
