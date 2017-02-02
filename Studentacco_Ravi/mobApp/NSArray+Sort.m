//
//  NSArray+Sort.m


#import "NSArray+Sort.h"

#import <UIKit/UIView.h>

#import "IQKeyboardManagerConstantsInternal.h"
IQ_LoadCategory(IQNSArraySort)

@implementation NSArray (Sort)

- (NSArray*)sortedArrayByTag
{
    return [self sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
        
        if ([obj1 respondsToSelector:@selector(tag)] && [obj2 respondsToSelector:@selector(tag)])
        {
            if ([obj1 tag] < [obj2 tag])	return NSOrderedAscending;
            
            else if ([obj1 tag] > [obj2 tag])	return NSOrderedDescending;
            
            else	return NSOrderedSame;
        }
        else
            return NSOrderedSame;
    }];
}

@end
