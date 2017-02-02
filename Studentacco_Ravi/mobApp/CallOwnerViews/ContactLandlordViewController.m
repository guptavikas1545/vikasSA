//
//  ContactLandlordViewController.m
//  StudentAcco
//
//  Created by MAG on 14/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "ContactLandlordViewController.h"
#import "FilterViewController.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "UserDetail.h"
#import "AppDelegate.h"
#import "ContactInfoViewController.h"
#import "HeadingTableViewCell.h"
#import "PropertyImageViewTableViewCell.h"
#import "TextFieldTableViewCell.h"
#import "SubmitButtonTableViewCell.h"
#import "BlankTableViewCell.h"
#pragma GCC diagnostic ignored "-Wundeclared-selector"
#define kHeadingTableViewCell @"headingTableViewCell"
#define kPropertyImageViewTableViewCell @"propertyImageViewTableViewCell"
#define kTextFieldTableViewCell @"textFieldTableViewCell"
#define kSubmitButtonTableViewCell @"submitButtonTableViewCell"
#define kBlankTableViewCell @"BlankTableViewCell"
@interface ContactLandlordViewController ()<ConnectionDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSString *otp;
    NSString *insert_id,*caller_mobile;
    NSString *requestFor,*enquiryno;
    NSString *userName;
    NSString *userMobileNo;
    NSString *userEmail;
}
@end

@implementation ContactLandlordViewController
@synthesize contactLandlordTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    insert_id=[[NSString alloc]init];
    caller_mobile=[[NSString alloc]init];
    enquiryno=[[NSString alloc]init];
    
    
    userName=[[NSString alloc]init];
     userMobileNo=[[NSString alloc]init];
     userEmail=[[NSString alloc]init];
    
    otp=[[NSString alloc]init];
    [contactLandlordTableView registerNib:[UINib nibWithNibName:@"HeadingTableViewCell" bundle:nil] forCellReuseIdentifier:kHeadingTableViewCell];
    [contactLandlordTableView registerNib:[UINib nibWithNibName:@"PropertyImageViewTableViewCell" bundle:nil] forCellReuseIdentifier:kPropertyImageViewTableViewCell];
    [contactLandlordTableView registerNib:[UINib nibWithNibName:@"TextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:kTextFieldTableViewCell];
    [contactLandlordTableView registerNib:[UINib nibWithNibName:@"SubmitButtonTableViewCell" bundle:nil] forCellReuseIdentifier:kSubmitButtonTableViewCell];
    [contactLandlordTableView registerNib:[UINib nibWithNibName:@"BlankTableViewCell" bundle:nil] forCellReuseIdentifier:kBlankTableViewCell];
    
}
#pragma mark - UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows;
    if (section==0) {
        numberOfRows =2;
    }
    else
    {
        numberOfRows = 10;
    }
    return numberOfRows;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            height = 40.0f;
        }
        else
        {
            height = 205.0f;
        }
        
    }
    else
    {
        height = 44.0f;
    }
    return height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier1 = kHeadingTableViewCell;
    
    static NSString *cellIdentifier2 = kPropertyImageViewTableViewCell;
    
    static NSString *cellIdentifier3 = kTextFieldTableViewCell;
    
    static NSString *cellIdentifier4 = kSubmitButtonTableViewCell;
    
    static NSString *cellIdentifier5 = kBlankTableViewCell;
    
    UITableViewCell *cell = nil;

    if (indexPath.section==0) {
        if (indexPath.row==0) {
            HeadingTableViewCell *headingCell= (HeadingTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
            cell=headingCell;
        }
        else
        {
            PropertyImageViewTableViewCell *imageCell = (PropertyImageViewTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
            imageCell.activityLoader.hidden=NO;
             imageCell.activityLoader.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [imageCell.activityLoader startAnimating];
            
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_propertyDetail.imagename]];
            
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data) {
                        UIImage *image = [UIImage imageWithData:data];
                        if (image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                imageCell.activityLoader.hidden = YES;
                                imageCell.propertyImageView.image = image;
                            });
                        }
                    }
                }];
                [task resume];
            imageCell.ownerNameLabel.text=[NSString stringWithFormat:@"%@ (Property Owner)", _propertyDetail.manager_firstname];
            
            cell = imageCell;
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
        }
    }
    else
    {
        if (indexPath.row==3) {
            SubmitButtonTableViewCell *submitCell = (SubmitButtonTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier4 forIndexPath:indexPath];
            [submitCell.submitInfoButton addTarget:self action:@selector(clickOnSubmit) forControlEvents:UIControlEventTouchUpInside];
            cell = submitCell;
        }
        else if (indexPath.row==0 || indexPath.row==1 || indexPath.row==2)
        {
            
            TextFieldTableViewCell *textFieldCell = (TextFieldTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
            textFieldCell.userInputTextField.delegate = self;
            textFieldCell.userInputTextField.userInteractionEnabled = true;
            switch (indexPath.row) {
                case 0:
                    textFieldCell.userInputTextField.placeholder = @"Name*";                    textFieldCell.userInputTextField.text = userName;
                    break;
                case 1:
                    textFieldCell.userInputTextField.keyboardType = UIKeyboardTypePhonePad;
                textFieldCell.userInputTextField.placeholder = @"10 Digit mobile number*";
                    textFieldCell.userInputTextField.text = userMobileNo;
                    break;
                case 2:
                    textFieldCell.userInputTextField.keyboardType = UIKeyboardTypeEmailAddress;
                    textFieldCell.userInputTextField.placeholder = @"Email*";
                    textFieldCell.userInputTextField.text = userEmail;
                    break;
                default:
                    break;
            }
            cell = textFieldCell;
        }
        else
        {
            BlankTableViewCell *blankCell = (BlankTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier5 forIndexPath:indexPath];
            cell = blankCell;
            
        }}
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}


#pragma Mark UITextField Delegate Method

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    TextFieldTableViewCell *textFieldRowCell = (TextFieldTableViewCell *) textField.superview.superview;
    NSIndexPath *indexPath = [contactLandlordTableView indexPathForCell:textFieldRowCell];
    
    switch (indexPath.row) {
        case 0:
            userName = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        case 1:
            
            userMobileNo = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        case 2:
            userEmail = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        default:
            break;
    }
    
    return true;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    
    return true;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}



//    ownerName.text=[NSString stringWithFormat:@"%@ (Property Owner)", propertyDetail.manager_firstname];
//   
//        _activityLoader.hidden = NO;
//    propertyImage.image = nil;
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",propertyDetail.imagename]];
//    
//    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        if (data) {
//            UIImage *image = [UIImage imageWithData:data];
//            if (image) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    _activityLoader.hidden = YES;
//                     propertyImage.image = image;
//                });
//            }
//        }
//    }];
//    [task resume];
//    _mobileNoTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    _mobileNoTextField.layer.borderWidth=0.8;
//    _userNameTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    _userNameTextField.layer.borderWidth=0.8;
//    _emailIdTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
//    _emailIdTextField.layer.borderWidth=0.8;
//    _mobileNoTextField.delegate=self;
//     _userNameTextField.delegate=self;
//     _emailIdTextField.delegate=self;
//    
//}

- (IBAction)backToPreviousView:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
    
}



-(void)clickOnSubmit {
//    userName=_userNameTextField.text;
//    userMobileNo=_mobileNoTextField.text;
//    userEmail=_emailIdTextField.text;
    
    NSLog(@"%@",userEmail);
    if (userName.length>0 && userMobileNo>0 && userEmail >0)
    {
     if ([self validateMobieNumber:userMobileNo])
     {
         if([self validateEmail:userEmail])
      
         {
            
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"caller_name\":\"%@\",\"caller_mobile\":\"%@\",\"caller_email\":\"%@\",\"owner_Property_id\":\"%@\"}",userName, userMobileNo, userEmail,_propertyDetail.propertyid];
        NSLog(@"jsonRequest #### %@",jsonRequest);
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Call_owner_URL];
    requestFor= Call_owner_URL;
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];
    }
            else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Email is not valid." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        else{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Mobile Number is not valid" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Mandatory fields can not be empty." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
        insert_id=json[@"insert_id"];
        enquiryno=json[@"enquiryno"];
        NSLog(@"%@",insert_id);
        if ([requestFor isEqualToString:Call_owner_URL]){
        if ([json[@"mobile_verify_status"] boolValue]==0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please verify your phone number" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:cancelAction];
            
            UIAlertAction *submitButton=[UIAlertAction actionWithTitle:@"Submit"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction * _Nonnull action) {
                                                                   
                                                                   otp=alert.textFields.firstObject.text;
                                                                   NSLog(@"%@",otp);
                                                                   [self verifyOtp];
                                                                   
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
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"enquiryno" message:enquiryno
//                                                      
//                                                                                  preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
//                }];
//                [alertController addAction:cancelAction];
//                [self presentViewController:alertController animated:YES completion:nil];
//
                ContactInfoViewController *contactInfo=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactInfoViewController"];
                contactInfo.contactEnquireNo=enquiryno;
                contactInfo.propertyDetail=_propertyDetail;
                contactInfo.callFrom=_select;
                [self.navigationController pushViewController:contactInfo animated:YES];
                

            }
        }
        
        else{
            ContactInfoViewController *contactInfo=[self.storyboard instantiateViewControllerWithIdentifier:@"ContactInfoViewController"];
            contactInfo.contactEnquireNo=json[@"enquiryno"];
            contactInfo.propertyDetail=_propertyDetail;
            [self.navigationController pushViewController:contactInfo animated:YES];
            

        }
        NSLog(@"Successfully");
        
    }
    else{
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"User Login fail" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];

    
    }

-(void)verifyOtp
{
    //[(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"insert_id\":\"%@\",\"caller_mobile\":\"%@\",\"otp\":\"%@\",\"owner_userid\":\"%@\",\"owner_Property_id\":\"%@\",\"property_details_page_link\":\"%@\"}",insert_id,userMobileNo,otp,_propertyDetail.userid,_propertyDetail.propertyid, _propertyDetail.website_url];
    NSLog(@"%@",jsonRequest);
    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,OtpVetify_URL];
    requestFor=OtpVetify_URL;
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];
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
#pragma Email Validatin Method
- (BOOL) validateEmail: (NSString *) candidate {
     NSLog(@"%@",userEmail);
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

#pragma Mobile Number Validatin Method
-(BOOL) validateMobieNumber:(NSString *) stringToBeTested {
    NSLog(@"%@",userMobileNo);
    
    
    NSString *mobileNumberRegex = @"[789][0-9]{9}";
    NSPredicate *mobileNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberRegex];
    
    return [mobileNumberTest evaluateWithObject:stringToBeTested];
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
