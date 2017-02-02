//
//  LoginAccountViewController.h
//  mobApp
//
//  Created by MAG  on 6/25/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
@interface LoginAccountViewController : UIViewController <GIDSignInUIDelegate>
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@end
