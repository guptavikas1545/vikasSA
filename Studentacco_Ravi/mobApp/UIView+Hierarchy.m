//
//  UIView+Hierarchy.m


#import "UIView+Hierarchy.h"

#import <UIKit/UITableView.h>
#import <UIKit/UITextView.h>
#import <UIKit/UITextField.h>
#import <UIKit/UISearchBar.h>

#import "IQKeyboardManagerConstantsInternal.h"
IQ_LoadCategory(IQUIViewHierarchy)


@implementation UIView (Hierarchy)


- (UITableView*)superTableView
{
    UIView *superview = self.superview;
    
    while (superview)
    {
        if ([superview isKindOfClass:[UITableView class]])
        {
            return (UITableView*)superview;
        }
        else    superview = superview.superview;
    }
    
    return nil;
}

- (UIScrollView*)superScrollView
{
    UIView *superview = self.superview;
    
    while (superview)
    {
        if ([superview isKindOfClass:[UIScrollView class]])
        {
            return (UIScrollView*)superview;
        }
        else    superview = superview.superview;
    }
    
    return nil;
}

- (NSArray*)responderSiblings
{
    //	Getting all siblings
    NSArray *siblings = self.superview.subviews;
    
    //Array of (UITextField/UITextView's).
    NSMutableArray *tempTextFields = [[NSMutableArray alloc] init];
    
    for (UITextField *textField in siblings)
        if ([textField canBecomeFirstResponder] /*&& ![textField isInsideAlertView]*/  && ![textField isInsideSearchBar])
            [tempTextFields addObject:textField];
    
    return tempTextFields;
}

- (NSArray*)deepResponderViews
{
    NSMutableArray *textFields = [[NSMutableArray alloc] init];
    
    //subviews are returning in opposite order. So I sorted it according the frames 'y'.
    NSArray *subViews = [self.subviews sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        
        if (obj1.frame.origin.y < obj2.frame.origin.y)	return NSOrderedAscending;
        
        else if (obj1.frame.origin.y > obj2.frame.origin.y)	return NSOrderedDescending;
        
        else	return NSOrderedSame;
    }];

    
    for (UITextField *textField in subViews)
    {
        if ([textField canBecomeFirstResponder])
        {
            [textFields addObject:textField];
        }
        else if (textField.subviews.count)
        {
            [textFields addObjectsFromArray:[textField deepResponderViews]];
        }
    }

    return textFields;
}

-(BOOL)isInsideSearchBar
{
    UIView *superview = self.superview;
    
    while (superview)
    {
        if ([superview isKindOfClass:[UISearchBar class]])
        {
            return YES;
        }
        else    superview = superview.superview;
    }
    
    return NO;
}

//-(BOOL)isInsideAlertView
//{
//    UIView *superview = self.superview;
//    
//    while (superview)
//    {
//        if ([superview isKindOfClass:[UIAlertView class]])
//        {
//            return YES;
//        }
//        else    superview = superview.superview;
//    }
//    
//    return NO;
//}

@end
