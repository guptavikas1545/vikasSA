//
//  UIWindow+Hierarchy.h

#import <UIKit/UIWindow.h>

@class UIViewController;

@interface UIWindow (Hierarchy)

/*!
    @method topMostController
 
    @return Returns the current Top Most ViewController in hierarchy.
 */
- (UIViewController*) topMostController;

/*!
    @method currentViewController
 
    @return Returns the topViewController in stack of topMostController.
 */
- (UIViewController*)currentViewController;


@end
