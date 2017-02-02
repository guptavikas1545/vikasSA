//
//  LoginAccountViewController.m
//  mobApp
//
//  Created by MAG  on 6/25/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "LoginAccountViewController.h"
#import "MFSideMenu.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "UserDetail.h"
#import "AppDelegate.h"
#import "ViewController.h"
#import "SignupViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
@interface LoginAccountViewController ()<ConnectionDelegate,UITextFieldDelegate>
{
    __weak IBOutlet UITextField *userEmailTextField;
    __weak IBOutlet UITextField *userPasswordTextField;
    NSString *emailId,*requestFor,*fName,*lNmae;
    NSURL *imgURL;
    FBSDKLoginButton *loginButton;
    UserDetail *userDetail;
}
@end

@implementation LoginAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userEmailTextField.delegate=self;
    userPasswordTextField.delegate=self;
    //    userEmailTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    //    userEmailTextField.layer.borderWidth=0.8;
    //    userPasswordTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    //    userPasswordTextField.layer.borderWidth=0.8;
    // Do any additional setup after loading the view.
    // UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(110, 11, 260, 25)];
//    loginButton = [[FBSDKLoginButton alloc] init];
//   
//    loginButton.center = self.view.center;
//  
//    [self.view addSubview:loginButton];
//    loginButton.hidden = YES;
    //NSString *accessToken = [FBSDKAccessToken currentAccessToken];
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(show:) name:SignUpNotification object:nil];
    userDetail=[[UserDetail alloc]init];
    [GIDSignIn sharedInstance].uiDelegate = self;
    
}

#pragma mark UITextField Delegate method
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}



- (IBAction)googleLogin:(id)sender {
      [[GIDSignIn sharedInstance] signIn];
        
}

-(void)show:(NSNotification *) notification
{
    
    NSLog(@"Data is....%@",[notification object]);
    SignupViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
    NSMutableDictionary *dic=[NSMutableDictionary new];
    dic=[notification object];
    obj.userSocialLoginData=dic;
    [self.navigationController pushViewController:obj animated:YES];
}
// Implement these methods only if the GIDSignInUIDelegate is not a subclass of
// UIViewController.

// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)fbLoginButton:(id)sender {
    AppDelegate *app=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    app.login = [[FBSDKLoginManager alloc] init];
    [FBSDKAccessToken currentAccessToken];
    
    [app.login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             if ([FBSDKAccessToken currentAccessToken]) {
                 [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{ @"fields" : @"id,name,picture.width(100).height(100),first_name,last_name,email"}]
                  startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                      if (!error) {
                          NSLog(@"fetched user:%@", result);
                        
                         fName=[result valueForKey:@"first_name"];
                         lNmae=[result valueForKey:@"last_name"];;
                         emailId=[result valueForKey:@"email"];
                          NSString *imageStringOfLoginUser = [[[result valueForKey:@"picture"] valueForKey:@"data"] valueForKey:@"url"];
                          NSURL *URL= [[NSURL alloc]initWithString:imageStringOfLoginUser];
                          imgURL = URL;
                        
                          
                          NSString *jsonRequest = [NSString stringWithFormat:@"{\"email\":\"%@\"}",emailId];
                          
                          NSLog(@"%@",jsonRequest);
                          NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,check_user_URL];
                          requestFor= check_user_URL;
                          URLConnection *connection=[[URLConnection alloc] init];
                          connection.delegate=self;
                          [connection getDataFromUrl:jsonRequest webService:urlString];
                          
                      }
                  }];
             }
           NSLog(@"Logged in");
         }
     }];
    
}

    
                    

- (IBAction)showRightMenuPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (IBAction)clickOnLogin:(id)sender {
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"username\":\"%@\",\"password\":\"%@\"}",userEmailTextField.text, userPasswordTextField.text];
    
    NSLog(@"%@",jsonRequest);
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Login_URL];
    requestFor= Login_URL;
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];
}

- (IBAction)clickOnForgotPassword:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Enter Your Email Id" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancelAction];
    
    UIAlertAction *submitButton=[UIAlertAction actionWithTitle:@"Submit"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                           
                                                           emailId=alert.textFields.firstObject.text;
                                                           NSLog(@"%@",emailId);
                                                           [self forgotPassword];
                                                           
                                                       }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Email Id";
        emailId=textField.text;
        textField.text=[NSString stringWithFormat:@"%@",emailId];
    }];
    
    [alert addAction:submitButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)forgotPassword
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"email\":\"%@\"}",emailId];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,forgot_Password_URL];
    requestFor=forgot_Password_URL;
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];
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
        if ([requestFor isEqualToString:Login_URL])
        {
            NSDictionary *userdetails = json[@"userdetails"];
            
          
            userDetail.userid = userdetails[@"userId"];
            if ([userDetail.userid isEqual:[NSNull null]])
            {
                userDetail.userid=@"";
            }
            userDetail.usertype = userdetails[@"userType"];
            if ([userDetail.usertype isEqual:[NSNull null]])
            {
                userDetail.usertype=@"";
            }
            userDetail.username = userdetails[@"username"];
            if ([userDetail.username isEqual:[NSNull null]])
            {
                userDetail.username=@"";
            }
            userDetail.firstname = userdetails[@"firstname"];
            if ([userDetail.firstname isEqual:[NSNull null]])
            {
                userDetail.firstname=@"";
            }
            userDetail.lastname = userdetails[@"lastName"];
            if ([userDetail.lastname isEqual:[NSNull null]])
            {
                userDetail.lastname=@"";
            }
            userDetail.email = userdetails[@"email"];
            if ([userDetail.email isEqual:[NSNull null]])
            {
                userDetail.email=@"";
            }
            
            
            userDetail.dob = userdetails[@"dob"];
            if ([userDetail.dob isEqual:[NSNull null]]) {
                userDetail.dob=@"";
            }
            if ([userDetail.dob length]!=0) {

            NSString *dateString = userdetails[@"dob"];
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *date = [format dateFromString:dateString];
            [format setDateFormat:@"dd-MM-yyyy"];
            NSString* finalDateString = [format stringFromDate:date];
                userDetail.dob=finalDateString;}
            userDetail.gender = userdetails[@"gender"];
            if ([userDetail.gender isEqual:[NSNull null]])
            {
                userDetail.gender=@"";
            }
            
            userDetail.mobile = userdetails[@"mobile_number"];
            if ([userDetail.mobile isEqual:[NSNull null]])
            {
                userDetail.mobile=@"";
            }
            userDetail.addressline1 = userdetails[@"addressline1"];
            if ([userDetail.addressline1 isEqual:[NSNull null]])
            {
                userDetail.addressline1=@"";
            }
            userDetail.addressline2 = userdetails[@"addressline2"];
            if ([userDetail.addressline2 isEqual:[NSNull null]])
            {
                userDetail.addressline2=@"";
            }
            userDetail.city = userdetails[@"city"];
            if ([userDetail.city isEqual:[NSNull null]])
            {
                userDetail.city=@"";
            }
            userDetail.state = userdetails[@"state"];
            if ([userDetail.state isEqual:[NSNull null]])
            {
                userDetail.state=@"";
            }
            userDetail.country = userdetails[@"country"];
            if ([userDetail.country isEqual:[NSNull null]])
            {
                userDetail.country=@"";
            }
            userDetail.pin = userdetails[@"pincode"];
            if ([userDetail.pin isEqual:[NSNull null]])
            {
                userDetail.pin=@"";
            }
            userDetail.education = userdetails[@"education"];
            if ([userDetail.education isEqual:[NSNull null]])
            {
                userDetail.education=@"";
            }
            userDetail.profile_picture = userdetails[@"profile_picture"];
            //            if ([userDetail.userImage isEqual:[NSNull null]])
            //            {
            //                userDetail.userImage=@"";
            //            }
            NSData *userEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userDetail];
            [[NSUserDefaults standardUserDefaults]setObject:userEncodedObject forKey:@"userData"];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:SideMenuUpdateNotification
                                                               object:nil];
        }
        else if ([requestFor isEqualToString:forgot_Password_URL])
        {
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
            NSString *alert=json[@"message"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Check Your Mail" message:alert preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
        }
        else if ([requestFor isEqualToString:check_user_URL]){
        //{[json[@"code"] integerValue] == 200)
//            userDetail.firstname=fName;
//            userDetail.lastname=lNmae;
//            userDetail.email=emailId;
//            userDetail.profile_picture=imgURL;
            //NSData *userEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userDetail];
            //[[NSUserDefaults standardUserDefaults]setObject:userEncodedObject forKey:@"userData"];
            NSMutableDictionary *userData = [NSMutableDictionary new];
            [userData setObject:fName forKey:@"FBFirstName"];
            [userData setObject:lNmae forKey:@"FBLastName"];
            [userData setObject:emailId forKey:@"FBMailID"];
            [userData setObject:imgURL forKey:@"FBImage"];
             SignupViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
            obj.userSocialLoginData=userData;
             [self.navigationController pushViewController:obj animated:YES];
            
        }
    }
    else if (([json[@"code"] integerValue] == 201) )
    {
        if ([requestFor isEqualToString:check_user_URL]) {
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
        else{
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"User Login fail" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        }}
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
}

- (void)connectionFailWithError:(NSError *)error
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    NSString *strErrorMsg = [error localizedDescription];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error !" message:strErrorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
- (IBAction)backToPreviousView:(id)sender {
    
    ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:obj animated:YES];
    
    }
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
