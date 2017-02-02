//
//  UIWindow+Hierarchy.m


#import "UIWindow+Hierarchy.h"

#import <UIKit/UINavigationController.h>

#import "IQKeyboardManagerConstantsInternal.h"
IQ_LoadCategory(IQUIWindowHierarchy)


@implementation UIWindow (Hierarchy)

//  Function to get topMost ViewController object.
- (UIViewController*) topMostController
{
    UIViewController *topController = [self rootViewController];
    
    //  Getting topMost ViewController
    while ([topController presentedViewController])	topController = [topController presentedViewController];
	
    //  Returning topMost ViewController
    return topController;
}

- (UIViewController*)currentViewController;
{
    UIViewController *currentViewController = [self topMostController];
    
    while ([currentViewController isKindOfClass:[UINavigationController class]] && [(UINavigationController*)currentViewController topViewController])
        currentViewController = [(UINavigationController*)currentViewController topViewController];
    
    return currentViewController;
}


@end
