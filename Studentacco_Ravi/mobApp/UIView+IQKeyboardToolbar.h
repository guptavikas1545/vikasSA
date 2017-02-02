//
//  UIView+IQToolbar.h



#import <UIKit/UIView.h>

@class UIBarButtonItem;

/*!
    @category UIView (Toolbar)
 
    @since iOS (5.0 and later), ARC Required
 
    @abstract UIView category methods to add IQToolbar on UIKeyboard.
 */
@interface UIView (Toolbar)

/*!
    @method addDoneOnKeyboardWithTarget:action:
 
    @abstract Helper functions to add Done button on keyboard.
 
    @param target: Target object for selector. Usually 'self'.
 
    @param action: Done button action name. Usually 'doneAction:(IQBarButtonItem*)item'.
 
    @param shouldShowPlaceholder: A boolean to indicate whether to show textField placeholder on IQToolbar'.
 
    @param titleText: text to show as title in IQToolbar'.
 */
- (void)addRightButtonOnKeyboardWithText:(NSString*)text target:(id)target action:(SEL)action;
- (void)addRightButtonOnKeyboardWithText:(NSString*)text target:(id)target action:(SEL)action shouldShowPlaceholder:(BOOL)showPlaceholder;
- (void)addRightButtonOnKeyboardWithText:(NSString*)text target:(id)target action:(SEL)action titleText:(NSString*)titleText;
- (void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action;
- (void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action shouldShowPlaceholder:(BOOL)showPlaceholder;
- (void)addDoneOnKeyboardWithTarget:(id)target action:(SEL)action titleText:(NSString*)titleText;


/*!
    @method addCancelDoneOnKeyboardWithTarget:cancelAction:doneAction:
 
    @abstract Helper function to add Cancel and Done button on keyboard.
 
    @param target: Target object for selector. Usually 'self'.
 
    @param cancelAction: Crevious button action name. Usually 'cancelAction:(IQBarButtonItem*)item'.
 
    @param doneAction: Done button action name. Usually 'doneAction:(IQBarButtonItem*)item'.
 
    @param shouldShowPlaceholder: A boolean to indicate whether to show textField placeholder on IQToolbar'.
 
    @param titleText: text to show as title in IQToolbar'.
 */
- (void)addRightLeftOnKeyboardWithTarget:(id)target leftButtonTitle:(NSString*)leftTitle rightButtonTitle:(NSString*)rightTitle rightButtonAction:(SEL)rightAction leftButtonAction:(SEL)leftAction;
- (void)addRightLeftOnKeyboardWithTarget:(id)target leftButtonTitle:(NSString*)leftTitle rightButtonTitle:(NSString*)rightTitle rightButtonAction:(SEL)rightAction leftButtonAction:(SEL)leftAction shouldShowPlaceholder:(BOOL)showPlaceholder;
- (void)addRightLeftOnKeyboardWithTarget:(id)target leftButtonTitle:(NSString*)leftTitle rightButtonTitle:(NSString*)rightTitle rightButtonAction:(SEL)rightAction leftButtonAction:(SEL)leftAction titleText:(NSString*)titleText;
- (void)addCancelDoneOnKeyboardWithTarget:(id)target cancelAction:(SEL)cancelAction doneAction:(SEL)doneAction;
- (void)addCancelDoneOnKeyboardWithTarget:(id)target cancelAction:(SEL)cancelAction doneAction:(SEL)doneAction shouldShowPlaceholder:(BOOL)showPlaceholder;
- (void)addCancelDoneOnKeyboardWithTarget:(id)target cancelAction:(SEL)cancelAction doneAction:(SEL)doneAction titleText:(NSString*)titleText;

/*!
    @method addPreviousNextDoneOnKeyboardWithTarget:previousAction:nextAction:doneAction
 
    @abstract Helper function to add SegmentedNextPrevious and Done button on keyboard.
 
    @param target: Target object for selector. Usually 'self'.
 
    @param previousAction: Previous button action name. Usually 'previousAction:(IQSegmentedNextPrevious*)segmentedControl'.
 
    @param nextAction: Next button action name. Usually 'nextAction:(IQSegmentedNextPrevious*)segmentedControl'.
 
    @param doneAction: Done button action name. Usually 'doneAction:(IQBarButtonItem*)item'.
 
    @param shouldShowPlaceholder: A boolean to indicate whether to show textField placeholder on IQToolbar'.
 
    @param titleText: text to show as title in IQToolbar'.
 */
- (void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction;
- (void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction shouldShowPlaceholder:(BOOL)showPlaceholder;
- (void)addPreviousNextDoneOnKeyboardWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction doneAction:(SEL)doneAction titleText:(NSString*)titleText;

/*!
    @method setEnablePrevious:next:
 
    @abstract Helper function to enable and disable previous next buttons.
 
    @param isPreviousEnabled: BOOL to enable/disable previous button on keyboard.
 
    @param isNextEnabled:  BOOL to enable/disable next button on keyboard..
 */
- (void)setEnablePrevious:(BOOL)isPreviousEnabled next:(BOOL)isNextEnabled;

@end


