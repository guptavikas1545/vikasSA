//
//  IQBarButtonItem.m


#import "IQBarButtonItem.h"
#import "IQToolbar.h"
#import "IQKeyboardManagerConstantsInternal.h"

@implementation IQBarButtonItem

- (id)init
{
    self = [super init];
    if (self)
    {
        if (IQ_IS_IOS7_OR_GREATER)
        {
            [self setTintColor:[UIColor blackColor]];
        }
    }
    return self;
}

@end


