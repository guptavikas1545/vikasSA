//
//  AppDelegate.m
//  mobApp
//
//  Created by MAG on 06/06/16.
//  Copyright © 2016 MAG. All rights reserved.m
//

#import "AppDelegate.h"
#import "MFSideMenu.h"
#import "ViewController.h"
#import "MFSideMenuContainerViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UserDetail.h"
#import "MFSideMenu.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "SignupViewController.h"
#import "IQKeyboardManager.h"
//#import <GoogleSignIn/GoogleSignIn.h>

@interface AppDelegate ()
{
    UIView *blankView;
    NSThread * _thread;
    NSString *emailId,*requestFor,*fName,*lNmae;
    NSURL *imgURL;
    UserDetail *userDetail;
}
@end

@implementation AppDelegate
@synthesize login;
//- (BOOL)application:(UIApplication *)application
//didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    
//    
//    // Add any custom logic here.
//    return YES;
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
    return handled;
}
//- (BOOL)application:(UIApplication *)app
//            openURL:(NSURL *)url
//            options:(NSDictionary *)options {
//    return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[IQKeyboardManager sharedManager] setEnable:YES];
//    
//    [[IQKeyboardManager sharedManager] setKeyboardDistanceFromTextField:15];
//    //Enabling autoToolbar behaviour. If It is set to NO. You have to manually create IQToolbar for keyboard.
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
//    
//    //Setting toolbar behavious to IQAutoToolbarBySubviews. Set it to IQAutoToolbarByTag to manage previous/next according to UITextField's tag property in increasing order.
//    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarBySubviews];
//    
//    //Resign textField if touched outside of UITextField/UITextView.
//    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
//    
//    //Giving permission to modify TextView's frame
//    [[IQKeyboardManager sharedManager] setCanAdjustTextView:YES];
//    
//    //Show TextField placeholder texts on autoToolbar
//    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:YES];
    
    
    
    //[NSThread sleepForTimeInterval:1.0];
    
    // commented by Ravi
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)self.window.rootViewController;
//    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
//    UIViewController *rightSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rightSideMenuViewController"];
//    
//    [container setRightMenuViewController:rightSideMenuViewController];
//    [container setCenterViewController:navigationController];
    //***//
    
    blankView = [[UIView alloc]init];
    
    blankView.frame = CGRectMake(0, 0, self.window.bounds.size.width, self.window.bounds.size.height);
    
    blankView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UIActivityIndicatorView *actvity;
    actvity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(blankView.bounds.size.width/2 - 40, blankView.bounds.size.height/2 - 40, 80, 80)];
    actvity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [actvity startAnimating];
    [blankView addSubview:actvity];
    
    [self.window addSubview:blankView];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    NSError* configureError;
   // [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    [GIDSignIn sharedInstance].clientID = @"316681672816-rd6thehlem4a7ei2pebj1dk4ahuglp76.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;
    return YES;

    // Override point for customization after application launch.
}
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
  
    // Perform any operations on signed in user here.
                   // For client-side use only!
   // NSString *idToken = user.authentication.idToken; // Safe to send to the server
 
    fName = user.profile.givenName;
    lNmae= user.profile.familyName;
    emailId = user.profile.email;
    imgURL = [user.profile imageURLWithDimension:200];
    if ([emailId length]!=0) {
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"email\":\"%@\"}",emailId];
        
        NSLog(@"jsonRequest #### %@",jsonRequest);
        NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,check_user_URL];
        URLConnection *connection=[[URLConnection alloc] init];
        connection.delegate=self;
        [connection getDataFromUrl:jsonRequest webService:urlString];
    }
    
   
   
   }

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}
-(void) showProgress
{
    @synchronized(self)
    {
        if ([[NSThread currentThread] isCancelled]) return;
        
        [_thread cancel]; // Cell! Stop what you were doing!
        _thread = nil;
        
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(setVisible:) object:@"NO"];
        [_thread start];
    }
}

-(void) setVisible:(NSString*) visibility
{
    BOOL x = [visibility boolValue];
    [self.window bringSubviewToFront:blankView];
    blankView.hidden=x;
}

-(void) hideProgress
{
    @synchronized(self)
    {
        if ([[NSThread currentThread] isCancelled]) return;
        
        [_thread cancel]; // Cell! Stop what you were doing!
        _thread = nil;
        
        _thread = [[NSThread alloc] initWithTarget:self selector:@selector(setVisible:) object:@"YES"];
        [_thread start];
    }
}


#pragma mark connectionDelegates .. .. .. .. .. ..

- (void)connectionFinishLoading:(NSMutableData *)receiveData
{
    NSError* error;
    NSMutableDictionary* json;
    json = [NSJSONSerialization JSONObjectWithData:receiveData
                                           options:kNilOptions
                                             error:&error];
    NSLog(@"%@",json);
    if ([json[@"code"] integerValue] == 200) {

        NSMutableDictionary *userData = [NSMutableDictionary new];
        [userData setObject:fName forKey:@"FBFirstName"];
        [userData setObject:lNmae forKey:@"FBLastName"];
        [userData setObject:emailId forKey:@"FBMailID"];
        

        [[NSNotificationCenter defaultCenter]postNotificationName:SignUpNotification
                                                           object:userData];
    }
    else
    {
        userDetail = [[UserDetail alloc]init];
        NSDictionary *dic=[json valueForKey:@"user_details"];
        userDetail.firstname=fName;
        userDetail.lastname=lNmae;
        userDetail.email=emailId;
        userDetail.userid=[dic valueForKey:@"userID"];
        userDetail.profile_picture=imgURL;
        NSData *userEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userDetail];
        [[NSUserDefaults standardUserDefaults]setObject:userEncodedObject forKey:@"userData"];
        [[NSNotificationCenter defaultCenter]postNotificationName:SideMenuUpdateNotification
                                                           object:nil];
        

    }
}

- (void)connectionFailWithError:(NSError *)error
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    NSString *strErrorMsg = [error localizedDescription];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error !" message:strErrorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];

}



- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"touchStatusBarClick" object:nil];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.MAG.mobApp" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"mobApp" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"mobApp.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}




#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}




@end
