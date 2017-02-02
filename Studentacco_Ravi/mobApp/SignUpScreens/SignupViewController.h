//
//  SignupViewController.h
//  StudentAcco
//
//  Created by MAG  on 6/27/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <GoogleSignIn/GoogleSignIn.h>
@interface SignupViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate,GIDSignInUIDelegate>
@property(nonatomic,strong) NSMutableDictionary *userSocialLoginData;
@end
