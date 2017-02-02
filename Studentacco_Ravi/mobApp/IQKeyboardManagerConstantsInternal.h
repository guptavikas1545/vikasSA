//
//  IQKeyboardManagerConstantsInternal.h

#ifndef IQKeyboardManagerConstantsInternal_h
#define IQKeyboardManagerConstantsInternal_h

#define IQ_IS_IOS7_OR_GREATER (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1)

/*!
    @discussion To load categories in the current file loadable without using "-load-all" flag. When we try to create framework or library the compilers skips linking files that contain only categories. So user this macro to add a dummy class, which causes the linker to add the file. You will also need to add "-ObjC" to the "Other Linker Flags" build setting in any project that uses the framework.
 
    @param UNIQUE_NAME A globally unique name.
 */
#define IQ_LoadCategory(UNIQUE_NAME) @interface FORCELOAD_##UNIQUE_NAME :NSObject @end @implementation FORCELOAD_##UNIQUE_NAME @end

#endif
