//
//  UIView+Hierarchy.h


#import <UIKit/UIView.h>

@class UIScrollView, UITableView, NSArray;

@interface UIView (Hierarchy)

/*!
    @method superScrollView:
 
    @return Returns the UIScrollView object if any found in view's upper hierarchy.
 */
- (UIScrollView*)superScrollView;

/*!
    @method superTableView:
 
    @return Returns the UITableView object if any found in view's upper hierarchy.
 */
- (UITableView*)superTableView;

/*!
    @method responderSiblings:
 
    @return returns all siblings of the receiver which canBecomeFirstResponder.
 */
- (NSArray*)responderSiblings;

/*!
    @method deepResponderViews:
 
    @return returns all deep subViews of the receiver which canBecomeFirstResponder.
 */
- (NSArray*)deepResponderViews;

-(BOOL)isInsideSearchBar;
//-(BOOL)isInsideAlertView;

@end
