#import "ViewUtils.h"

//#import "colors.h"

@implementation ViewUtils

+ (void)alignViewCenterInParent:(UIView *) view {
    CGPoint center = view.center;
    center.y = CGRectGetMidY(view.superview.bounds);
    view.center = center;
}

@end