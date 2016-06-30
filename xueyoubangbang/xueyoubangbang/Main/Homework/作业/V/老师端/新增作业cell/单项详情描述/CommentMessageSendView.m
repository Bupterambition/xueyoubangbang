#import "CommentMessageSendView.h"
#import "HPGrowingTextView.h"
#import "ViewUtils.h"

static const CGFloat kSubviewMargin = 10.f;
static const CGFloat kActionButtonWidth = kToolbarHeight - 2 * kSubviewMargin;
static const CGFloat kInputViewHeight = 35.f;
static const CGFloat kSendTextButtonWidth = 32.;

@interface CommentMessageSendView() <HPGrowingTextViewDelegate> {
    HPGrowingTextView *growingTextView_;
    UIButton *sendButton_;
    NSString *replySomeone_;
    BOOL allowAnonymous_;
    CGPoint beginPoint;
}

@end

@implementation CommentMessageSendView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        replySomeone_ = @"";
        allowAnonymous_ = YES;
        
        self.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:239/255. green:239/255. blue:244/255. alpha:1.];
        self.layer.borderColor = STYLE_COLOR.CGColor;
        self.layer.borderWidth = 1.5f;
        self.layer.cornerRadius = 1.0;
        CGFloat originX = kSubviewMargin;
        const CGFloat sendBtnX = self.frame.size.width - kSendTextButtonWidth - kSubviewMargin;
        growingTextView_ = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(originX, 0, sendBtnX - originX - kSubviewMargin + 20, kInputViewHeight)];
        growingTextView_.backgroundColor = [UIColor clearColor];
        growingTextView_.layer.cornerRadius = 5.0f;
        growingTextView_.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        growingTextView_.clipsToBounds = YES;
        growingTextView_.returnKeyType = UIReturnKeySend;
        growingTextView_.delegate = self;
        growingTextView_.maxNumberOfLines = 5;
        growingTextView_.internalTextView.showsVerticalScrollIndicator = NO;
        [self addSubview:growingTextView_];
        [ViewUtils alignViewCenterInParent:growingTextView_];
        
        sendButton_ = [[UIButton alloc] initWithFrame:CGRectMake(sendBtnX-10, 0, kSendTextButtonWidth+20, kActionButtonWidth+20)];
        sendButton_.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
        sendButton_.titleLabel.textColor = [UIColor whiteColor];
        sendButton_.tintColor = [UIColor whiteColor];
        [sendButton_ setTitle:NSLocalizedString(@"确定", nil) forState:UIControlStateNormal];
        [sendButton_ setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [sendButton_ setBackgroundColor:STYLE_COLOR];
        [sendButton_ addTarget:self action:@selector(clickStateButton) forControlEvents:UIControlEventTouchUpInside];
       // [self addSubview:sendButton_];
        [ViewUtils alignViewCenterInParent:sendButton_];
        
        [self resetInputContent];
    }
    
    return self;
}

- (void)showMessageSendView {
    [super becomeFirstResponder];
    if (![growingTextView_ isFirstResponder]) {
        [growingTextView_ becomeFirstResponder];
    }
}

- (void)hideMessageSendView {
    [super resignFirstResponder];
    if ([growingTextView_ isFirstResponder]) {
        [growingTextView_ resignFirstResponder];
    }
}

- (void)setPlaceHolder:(NSString *)placeHolder {
    [growingTextView_ setPlaceholder:placeHolder];
}

- (void)sendFailure:(NSString *)content isAnony:(BOOL)isAnony {
    growingTextView_.text = [NSString stringWithFormat:@"%@", content];
    [growingTextView_ becomeFirstResponder];
}

- (void)setAllowAnonymous:(BOOL)anonymous {
    allowAnonymous_ = anonymous;
}

#pragma mark --
#pragma mark KeyboardNotification
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillShowNotification
                                                      object:nil];
        
        [[NSNotificationCenter defaultCenter] removeObserver:self
                                                        name:UIKeyboardWillHideNotification
                                                      object:nil];
        
    }
    [super willMoveToWindow:newWindow];
}


#pragma mark --
#pragma mark KeyBoradNotification Method
-(void)keyboardWillShow:(NSNotification *)note {
    CGRect keyboardBounds = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    
    keyboardBounds = [[self superview] convertRect:keyboardBounds toView:nil];
    CGRect containerFrame = self.frame;
    CGFloat oldOrigin = containerFrame.origin.y;
    containerFrame.origin.y = keyboardBounds.origin.y - CGRectGetHeight(self.frame);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.frame = containerFrame;
    
    if ([self.delegate respondsToSelector:@selector(msgChangeHeight:)]) {
        [self.delegate msgChangeHeight:containerFrame.origin.y - oldOrigin];
    }
    [UIView commitAnimations];
    NSLog(@"keyboard show");
}

- (void)keyboardWillHide:(NSNotification *)note {
    NSNumber *duration = [note.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSNumber *curve = [note.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];
    CGRect keyboardBounds = [[note.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGRect containerFrame = self.frame;
    CGFloat oldOrigin = containerFrame.origin.y;
    containerFrame.origin.y = [self superview].bounds.size.height - CGRectGetHeight(self.frame) - CGRectGetHeight(keyboardBounds);
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:[duration doubleValue]];
    [UIView setAnimationCurve:[curve intValue]];
    
    self.frame = containerFrame;
    if ([self.delegate respondsToSelector:@selector(msgChangeHeight:)]) {
        [self.delegate msgChangeHeight:containerFrame.origin.y - oldOrigin];
    }
    [UIView commitAnimations];
    NSLog(@"keyboard hide");
}

#pragma mark --
#pragma mark Click Action

- (void)clickStateButton {
    NSString *text = growingTextView_.text;
    if (text.length > 0) {
        if ([self.delegate respondsToSelector:@selector(onClickMessageSendButton:text:)]) {
            [self.delegate onClickMessageSendButton:sendButton_.selected text:text];
        }
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

#pragma mark --
#pragma mark HPGrowingTextViewDelegate
- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height {
    float diff = (growingTextView.frame.size.height - height);
    
    [self changeViewHeight:self diff:diff];
    [self changeViewYOffset:self diff:-diff];
    
    
    if ([self.delegate respondsToSelector:@selector(msgChangeHeight:)]) {
        [self.delegate msgChangeHeight:diff];
    }
}

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self clickStateButton];
        return NO;
    } else {
        return YES;
    }
}

- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView {
    if (growingTextView.text.length > 0) {
        [sendButton_ setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    } else {//初始化状态
        [sendButton_ setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
}

- (void)changeViewHeight:(UIView*)view diff:(CGFloat)diff {
    CGRect r = view.frame;
    r.size.height -= diff;
    view.frame = r;
}

- (void)changeViewYOffset:(UIView*)view diff:(CGFloat)diff {
    CGRect r = view.frame;
    r.origin.y -= diff;
    view.frame = r;
}

- (void)resetInputContent {
    [growingTextView_ setPlaceholder:NSLocalizedString(@"输入标注,可随意拖动", )];
    growingTextView_.text = @"";
    replySomeone_ = @"";
}

- (void)setReplySomeone:(NSString*)text {
    if (text.length > 0) {
        [growingTextView_ setPlaceholder:text];
        replySomeone_ = text;
    } else if (replySomeone_.length > 0 && growingTextView_.text.length == 0) {
        [growingTextView_ setPlaceholder:NSLocalizedString(@"$$$Statement", )];
        replySomeone_ = text;
    }
}

- (NSString*)inputText {
    return growingTextView_.text;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    beginPoint = [touch locationInView:self];
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint nowPoint = [touch locationInView:self];
    
    float offsetX = nowPoint.x - beginPoint.x;
    float offsetY = nowPoint.y - beginPoint.y;
    
    self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
}

@end
