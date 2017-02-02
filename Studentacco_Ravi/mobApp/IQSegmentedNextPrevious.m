//
//  IQSegmentedNextPrevious.m


#import "IQSegmentedNextPrevious.h"

#import <Foundation/NSArray.h>

@interface IQSegmentedNextPrevious ()

//  UISegmentedControl selector for value change.
- (void)segmentedControlHandler:(IQSegmentedNextPrevious*)sender;

@end


@implementation IQSegmentedNextPrevious
{
    id buttonTarget;
    SEL previousSelector;
    SEL nextSelector;
}

//  Initialize method
-(id)initWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction
{
    //  Creating it with two items, Previous/Next.
    self = [super initWithItems:[NSArray arrayWithObjects:@"Previous",@"Next",nil]];
    
    if (self)
    {
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
        {
            [self setSegmentedControlStyle:UISegmentedControlStyleBar];
        }
        
		[self setMomentary:YES];
		[self setTintColor:[UIColor blackColor]];
		//  Adding self as it's valueChange selector.
        [self addTarget:self action:@selector(segmentedControlHandler:) forControlEvents:UIControlEventValueChanged];
        
        //  Setting target and selectors.
        buttonTarget = target;
        previousSelector = previousAction;
        nextSelector = nextAction;
    }
    return self;
}

//  Value has changed
- (void)segmentedControlHandler:(IQSegmentedNextPrevious*)sender
{
    //  Switching to selected segmenteIndex.
    switch ([sender selectedSegmentIndex])
    {
            //  Previous selected.
        case 0:
        {
            //  Invoking selector.
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[buttonTarget class] instanceMethodSignatureForSelector:previousSelector]];
            invocation.target = buttonTarget;
            invocation.selector = previousSelector;
            [invocation invoke];
        }
            break;
            //  Next selected.
        case 1:
        {
            //  Invoking selector.
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[buttonTarget class] instanceMethodSignatureForSelector:nextSelector]];
            invocation.target = buttonTarget;
            invocation.selector = nextSelector;
            [invocation invoke];
        }
        default:
            break;
    }
}

@end
