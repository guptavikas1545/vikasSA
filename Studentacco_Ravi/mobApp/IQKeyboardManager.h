//
// KeyboardManager.h

#import <Foundation/NSObject.h>
#import <CoreGraphics/CGBase.h>

#import "IQKeyboardManagerConstants.h"

@interface IQKeyboardManager : NSObject

/*!
    @method sharedManager
 
    @return Returns the default singleton instance.
 */
+ (IQKeyboardManager*)sharedManager;

/*!
	@property keyboardDistanceFromTextField

	@abstract To set keyboard distance from textField. can't be less than zero. Default is 10.0.
 */
@property(nonatomic, assign) CGFloat keyboardDistanceFromTextField;

/*!
	@property enable

	@abstract enable/disable the keyboard manager. Default is NO.
 */
@property(nonatomic, assign, getter = isEnabled) BOOL enable;

/*!
    @property enableAutoToolbar

    @abstract Automatic add the IQToolbar functionality. Default is NO.
 */
@property(nonatomic, assign, getter = isEnableAutoToolbar) BOOL enableAutoToolbar;

/*!
    @property canAdjustTextView

    @abstract Adjust textView's frame when it is too big in height. Default is NO.
 */
@property(nonatomic, assign) BOOL canAdjustTextView;

/*!
    @property resignOnTouchOutside

    @abstract Resigns Keyboard on touching outside of UITextField/View. Default is NO.
 */
@property(nonatomic, assign) BOOL shouldResignOnTouchOutside;

/*!
    @property shouldShowTextFieldPlaceholder

    @abstract If YES, then it add the textField's placeholder text on IQToolbar. Default is NO.
 */
@property(nonatomic, assign) BOOL shouldShowTextFieldPlaceholder;

/*!
	@property toolbarManageStyle

	@abstract AutoToolbar managing behaviour. Default is IQAutoToolbarBySubviews.
 */
@property(nonatomic, assign) IQAutoToolbarManageBehaviour toolbarManageBehaviour;

/*!
	@method resignFirstResponder
 
	@abstract Resigns currently first responder field.
 */
- (void)resignFirstResponder;

/*!
    @method init
 
    @abstract Should create only one instance of class. Should not call init.
 */
- (id)init	__attribute__((unavailable("init is not available in IQKeyboardManager, Use sharedManager")));

/*!
    @method init
 
    @abstract Should create only one instance of class. Should not call new.
 */
+ (id)new	__attribute__((unavailable("new is not available in IQKeyboardManager, Use sharedManager")));


@end




