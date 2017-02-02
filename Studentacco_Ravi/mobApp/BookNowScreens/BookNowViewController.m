//
//  BookNowViewController.m
//  Studentacco
//
//  Created by atul on 14/09/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "BookNowViewController.h"
#import "AppConstants.h"
#import "URLConnection.h"
#import "UserDetail.h"
#import "AppDelegate.h"
#import "BookBrandedPropertyViewController.h"
@interface BookNowViewController ()<UITextFieldDelegate>
{
    NSString *requestFor,*otp;
}
@end

@implementation BookNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _fNameTextField.delegate=self;
    _lNameTextField.delegate=self;
    _mobileNumberTextField.delegate=self;
    _emailTextField.delegate=self;
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)backToPreviousView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextField Delegate method

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}



- (IBAction)bookNowButtonAction:(id)sender {
      NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,book_now_without_login];
    if (_fNameTextField.text.length > 0 && _lNameTextField.text.length > 0 && _mobileNumberTextField.text.length > 0)
    {
        if([self validateEmail:_emailTextField.text])
        {
            
            if ([self validateMobieNumber:_mobileNumberTextField.text])
            {

    NSString *jsonRequest = [NSString stringWithFormat:@"{\"firstname\":\"%@\",\"lastname\":\"%@\",\"mobile\":\"%@\",\"email\":\"%@\",\"propertyid\":\"%@\"}",_fNameTextField.text,_lNameTextField.text,_mobileNumberTextField.text,_emailTextField.text,_propertyID];
    NSLog(@"%@",jsonRequest);
    requestFor=book_now_without_login;
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];

}
            else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Mobile Number is not valid" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        else{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Email is not valid." preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
    }
    
    else{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Mandatory fields can not be empty." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


            
#pragma mark validation method
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(BOOL) validateMobieNumber:(NSString *) stringToBeTested {
    
    NSString *mobileNumberRegex = @"[789][0-9]{9}";
    NSPredicate *mobileNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberRegex];
    
    return [mobileNumberTest evaluateWithObject:stringToBeTested];
}



#pragma mark NSURL Connection Delegate method

- (void)connectionFinishLoading:(NSMutableData *)receiveData
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    NSError* error;
    NSMutableDictionary* json;
    json = [NSJSONSerialization JSONObjectWithData:receiveData
                                           options:kNilOptions
                                             error:&error];
    NSLog(@"%@",json);
    if (json==nil)
    {
                NSLog(@"not found data");
    }
    else
    {
        if([[json valueForKey:@"code"]isEqualToString:@"200"])
        {
            if ([requestFor isEqualToString: book_now_without_login]) {
                if ([[json valueForKey:@"message"]isEqualToString:@"success"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please verify your mobile number" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:cancelAction];
                    
                    UIAlertAction *submitButton=[UIAlertAction actionWithTitle:@"Submit"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                                           
                                                                           otp=alert.textFields.firstObject.text;
                                                                           //                                                               otp=alert.textFields.lastObject.text;
                                                                           NSLog(@"%@",otp);
                                                                           [self verifyOtpNumber];
                                                                           
                                                                       }];
                    
                    
                    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = @"OTP Number";
                        otp=textField.text;
                        textField.text=[NSString stringWithFormat:@"%@",otp];
                    }];
                    [alert addAction:submitButton];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else
                {
                    //if ([_isBranded isEqualToString:@"1"]) {
//                        BookBrandedPropertyViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"bookBrandedPropertyViewController"];
//                        [self.navigationController pushViewController:obj animated:YES];
                    //}
//                    else{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Thank You! Your request has been successfully submitted" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }];
                    [alertController addAction:cancelAction];
                    [self presentViewController:alertController animated:YES completion:nil];
                 
//                    }}
                }}
            else if ([requestFor isEqualToString:varify_book_now_otp])
            {
//                if ([_isBranded isEqualToString:@"1"]) {
//                    BookBrandedPropertyViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"bookBrandedPropertyViewController"];
//                    [self.navigationController pushViewController:obj animated:YES];
                
                //}
//                else{
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Thank You! Your request has been successfully submitted" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
                    [self.navigationController popViewControllerAnimated:YES];
                    
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
                
               // }
            }
            
            
        }
        else if ([[json valueForKey:@"code"]isEqualToString:@"201"])
            
        {
            if ([requestFor isEqualToString:book_now_without_login])
            {
                if ([[json valueForKey:@"message"]isEqualToString:@"Not verified"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please verify your mobile number" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:cancelAction];
                    
                    UIAlertAction *submitButton=[UIAlertAction actionWithTitle:@"Submit"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction * _Nonnull action) {
                                                                           
                                                                           otp=alert.textFields.firstObject.text;
                                                                           //                                                               otp=alert.textFields.lastObject.text;
                                                                           NSLog(@"%@",otp);
                                                                           [self verifyOtpNumber];
                                                                           
                                                                       }];
                    
                    
                    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
                        textField.placeholder = @"OTP Number";
                        otp=textField.text;
                        textField.text=[NSString stringWithFormat:@"%@",otp];
                    }];
                    [alert addAction:submitButton];
                    [self presentViewController:alert animated:YES completion:nil];
                    
                    
                }
            }
            else if ([requestFor isEqualToString:varify_book_now_otp])
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Not entered valid otp" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
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
    [self presentViewController:alertController animated:YES completion:nil];
}


-(void)verifyOtpNumber
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"otp\":\"%@\"}",otp];
    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,varify_book_now_otp];
    requestFor=varify_book_now_otp;
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
