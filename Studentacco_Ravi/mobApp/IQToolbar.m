//
//  IQToolbar.m


#import "IQToolbar.h"
#import "IQKeyboardManagerConstantsInternal.h"


@implementation IQToolbar

-(void)initialize
{
    [self sizeToFit];
    
    if (!IQ_IS_IOS7_OR_GREATER)
    {
        [self setBarStyle:UIBarStyleBlackTranslucent];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self initialize];
    }
    return self;
}

//To resize IQToolbar on device rotation.
- (void) layoutSubviews
{
    [super layoutSubviews];
    CGRect origFrame = self.frame;
    [self sizeToFit];
    CGRect newFrame = self.frame;
    newFrame.origin.y += origFrame.size.height - newFrame.size.height;
    self.frame = newFrame;
}

@end
