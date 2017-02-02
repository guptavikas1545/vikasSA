//
//  IQTitleBarButtonItem.m


#import "IQTitleBarButtonItem.h"
#import "IQKeyboardManagerConstants.h"

@implementation IQTitleBarButtonItem

-(id)initWithFrame:(CGRect)frame Title:(NSString *)title
{
    self = [super initWithTitle:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    if (self)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setText:title];
        [label setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
        [label setFont:[UIFont boldSystemFontOfSize:12.0]];

        self.customView = label;
        self.enabled = NO;
    }
    return self;
}

@end
