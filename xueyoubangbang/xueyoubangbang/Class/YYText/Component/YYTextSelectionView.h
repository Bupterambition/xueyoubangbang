//
//  YYTextSelectionView.h
//  YYText <https://github.com/ibireme/YYText>
//
//  Created by ibireme on 15/2/25.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYText/YYText.h>)
#import <YYText/YYTextAttribute.h>
#import <YYText/YYTextInput.h>
#else
#import "YYTextAttribute.h"
#import "YYTextInput.h"
#endif

/**
 A single dot view. The frame should be foursquare.
 Change the background color for display.
 
 @discussion Typically, you should not use this class directly.
 */
@interface YYSelectionGrabberDot : UIView
/// Dont't access this property. It was used by `YYTextEffectWindow`.
@property (nonatomic, strong) UIView *mirror;
@end


/**
 A grabber (stick with a dot).
 
 @discussion Typically, you should not use this class directly.
 */
@interface YYSelectionGrabber : UIView

@property (nonatomic, readonly) YYSelectionGrabberDot *dot; ///< the dot view
@property (nonatomic, assign) YYTextDirection dotDirection; ///< don't support composite direction
@property (nonatomic, strong) UIColor *color; ///< tint color, default is nil

@end


/**
 The selection view for text edit and select.
 
 @discussion Typically, you should not use this class directly.
 */
@interface YYTextSelectionView : UIView

@property (nonatomic, weak) UIView *hostView; ///< the holder view
@property (nonatomic, strong) UIColor *color; ///< the tint color
@property (nonatomic, assign, getter = isCaretBlinks) BOOL caretBlinks; ///< whether the caret is blinks
@property (nonatomic, assign, getter = isCaretVisible) BOOL caretVisible; ///< whether the caret is visible
@property (nonatomic, assign, getter = isVerticalForm) BOOL verticalForm; ///< weather the text view is vertical form

@property (nonatomic, assign) CGRect caretRect; ///< caret rect (width==0 or height==0)
@property (nonatomic, copy) NSArray *selectionRects; ///<  array of YYTextSelectionRect, default is nil

@property (nonatomic, readonly) UIView *caretView;
@property (nonatomic, readonly) YYSelectionGrabber *startGrabber;
@property (nonatomic, readonly) YYSelectionGrabber *endGrabber;

- (BOOL)isGrabberContainsPoint:(CGPoint)point;
- (BOOL)isStartGrabberContainsPoint:(CGPoint)point;
- (BOOL)isEndGrabberContainsPoint:(CGPoint)point;
- (BOOL)isCaretContainsPoint:(CGPoint)point;
- (BOOL)isSelectionRectsContainsPoint:(CGPoint)point;

@end
