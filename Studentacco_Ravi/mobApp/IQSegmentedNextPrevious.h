//
//  IQSegmentedNextPrevious.h


#import <UIKit/UISegmentedControl.h>

/*!
    @class IQSegmentedNextPrevious
 
    @since iOS (5.0 and iOS 6.0)
 
    @abstract Custom SegmentedControl for Previous/Next button.
 */
@interface IQSegmentedNextPrevious : UISegmentedControl

/*!
    @method initWithTarget:previousAction:nextAction:
 
    @abstract initialization function for IQSegmentedNextPrevious.
 
    @param target: Target object for selector. Usually 'self'.
 
    @param previousAction: Previous button action name. Usually 'previousAction:(IQSegmentedNextPrevious*)segmentedControl'.
 
    @param nextAction: Next button action name. Usually 'nextAction:(IQSegmentedNextPrevious*)segmentedControl'.
 */
- (id)initWithTarget:(id)target previousAction:(SEL)previousAction nextAction:(SEL)nextAction;

/*!
    @method init
 
    @abstract initWithTarget:previousAction:nextAction should be used.
 */
- (id)init	__attribute__((unavailable("init is not available, should use initWithTarget:previousAction:nextAction instead")));

/*!
    @method init
 
    @abstract initWithTarget:previousAction:nextAction should be used.
 */
+ (id)new	__attribute__((unavailable("new is not available, should use initWithTarget:previousAction:nextAction instead")));

@end

