//
//  IQKeyboardManagerConstants.h

#ifndef IQKeyboardManagerConstants_h
#define IQKeyboardManagerConstants_h

/* Set IQKEYBOARDMANAGER_DEBUG=1 in preprocessor macros under build settings to enable debugging.*/
#if !IQKEYBOARDMANAGER_DEBUG
#define NSLog(...)
#endif


/*!
    @enum IQAutoToolbarManageBehaviour
 
    @abstract AutoToolbar manage settings.
 
    @const IQAutoToolbarBySubviews Creates Toolbar according to subview's hirarchy of Textfield's in view.
 
    @const IQAutoToolbarByTag Creates Toolbar according to tag property of TextField's.
 */
typedef enum IQAutoToolbarManageBehaviour
{
	IQAutoToolbarBySubviews,
	IQAutoToolbarByTag,
	
}IQAutoToolbarManageBehaviour;

#endif


/*
 
 /---------------------------------------------------------------------------------------------------\
 \---------------------------------------------------------------------------------------------------/
 |                                   iOS NSNotification Mechanism                                    |
 /---------------------------------------------------------------------------------------------------\
 \---------------------------------------------------------------------------------------------------/
 
 1) Begin Editing:-         When TextField begin editing.
 2) End Editing:-           When TextField end editing.
 3) Switch TextField:-      When Keyboard Switch from a TextField to another TextField.
 3) Orientation Change:-    When Device Orientation Change.
 
 
 ----------------------------------------------------------------------------------------------------------------------------------------------
 =============
 UITextField
 =============
 
 Begin Editing                                Begin Editing
 --------------------------------------------           ----------------------------------           ---------------------------------
 |UITextFieldTextDidBeginEditingNotification| --------> | UIKeyboardWillShowNotification | --------> | UIKeyboardDidShowNotification |
 --------------------------------------------           ----------------------------------           ---------------------------------
 ^                  Switch TextField             ^               Switch TextField
 |                                               |
 |                                               |
 | Switch TextField                              | Orientation Change
 |                                               |
 |                                               |
 |                                               |
 --------------------------------------------           ----------------------------------           ---------------------------------
 | UITextFieldTextDidEndEditingNotification | <-------- | UIKeyboardWillHideNotification | --------> | UIKeyboardDidHideNotification |
 --------------------------------------------           ----------------------------------           ---------------------------------
 |                    End Editing                                                             ^
 |                                                                                            |
 |--------------------End Editing-------------------------------------------------------------|
 
 
 ----------------------------------------------------------------------------------------------------------------------------------------------
 =============
 UITextView
 =============
 |-------------------Switch TextView--------------------------------------------------------------|
 | |------------------Begin Editing-------------------------------------------------------------| |
 | |                                                                                            | |
 v |                  Begin Editing                               Switch TextView               v |
 --------------------------------------------           ----------------------------------           ---------------------------------
 | UITextViewTextDidBeginEditingNotification| <-------- | UIKeyboardWillShowNotification | --------> | UIKeyboardDidShowNotification |
 --------------------------------------------           ----------------------------------           ---------------------------------
 ^
 |
 |------------------------Switch TextView--------|
 |                                               | Orientation Change
 |                                               |
 |                                               |
 |                                               |
 --------------------------------------------           ----------------------------------           ---------------------------------
 | UITextViewTextDidEndEditingNotification  | <-------- | UIKeyboardWillHideNotification |           | UIKeyboardDidHideNotification |
 --------------------------------------------           ----------------------------------           ---------------------------------
 |                    End Editing                                                             ^
 |                                                                                            |
 |--------------------End Editing-------------------------------------------------------------|
 
 
 ----------------------------------------------------------------------------------------------------------------------------------------------
 
 /---------------------------------------------------------------------------------------------------\
 \---------------------------------------------------------------------------------------------------/
 */
