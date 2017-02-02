//
//  AppDelegate.h
//  mobApp
//
//  Created by MAG on 06/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
//#import <GIDSignIn/GIDSignIn.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) FBSDKLoginManager *login;

@property (weak, nonatomic) UIViewController *paymentOptionVC;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void) showProgress;
-(void) hideProgress;

//-(void) fbLogin;
//-(void) fbLogout;
@end


