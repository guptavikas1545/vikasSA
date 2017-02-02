//
//  EditProfileViewController.m
//  StudentAcco
//
//  Created by MAG on 29/07/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "EditProfileViewController.h"
#import "MFSideMenu.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "UserDetail.h"
#import "ViewController.h"
#import "CustomTextFieldTableViewCell.h"
#import "GenderSelectionTableViewCell.h"
#import "TermConditionTableViewCell.h"
#import "ProfilePictureTableViewCell.h"
#import "ProfileImageTableViewCell.h"
#import "AppDelegate.h"
#import "BlankTableViewCell.h"
#import "SignUpButtonTableViewCell.h"

#pragma GCC diagnostic ignored "-Wundeclared-selector"
#define kCustomTextFieldTableViewCell @"customTextFieldTableViewCell"
#define kGenderSelectionTableViewCell @"genderSelectionTableViewCell"

#define kProfilePictureTableViewCell  @"profilePictureTableViewCell"
#define kProfileImageTableViewCell    @"profileImageTableViewCell"
#define kBlankTableViewCell           @"BlankTableViewCell"
#define kSignUpButtonTableViewCell    @"signUpButtonTableViewCell"

@interface EditProfileViewController ()<ConnectionDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource,UIGestureRecognizerDelegate>
{
    NSString *userType;
    NSString *userFirstName;
    NSString *userLastName;
    NSString *userMobile;
    NSString *userEmail;
    NSString *userPassword;
    NSString *userConfirmPassword;
    NSString *dob;
    NSString *gender;
    NSString *userStreet;
    NSString *userCity;
    NSString *userState;
    NSString *userCountry;
    NSString *addressline1;
    NSString *addressline2;
    NSString *userPincode;
    NSString *userEducation;
    NSData *imageData;
    NSString *requestFor,*otp;
    __weak IBOutlet UITableView *registrationTableView;
    
    NSArray *registrationFormList;

    NSString *genderSelection;
    NSArray *userTypeArray;
    NSArray *userEducationArray;
    NSMutableArray *userCityArray;
    NSMutableArray *userStateArray;
    NSMutableArray *userCountryArray;
    
    NSArray *pickerArray;
    UIPickerView *pickerView;
    NSIndexPath *selectedIndexPath;
    UIImage *profileImage;
    __weak IBOutlet UIView *termsConditionView;
    __weak IBOutlet UITextView *termsConditionTextView;
    
    // Date Picker
    __weak IBOutlet UIView *datePickerView;
    __weak IBOutlet UIDatePicker *datePicker;
    
    UserDetail *userDetail;
    
}
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePicture;
@end

@implementation EditProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
    
    userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];

    
    registrationFormList = @[@"Profile Image",@"User Type", @"First Name*", @"Last Name", @"10 Digit Mobile Number*", @"Email*",  @"Date of Birth*", @"Gender", @"Country*", @"State", @"City", @"Address", @"", @"Pincode", @"Education"];

//    registrationFormList = @[@"User Type", @"First Name", @"Last Name", @"Mobile Number", @"Email"];
//    
    userTypeArray = @[@"Student",@"Property Owner",@"Broker"];
    
    userEducationArray = @[@"Select Education",@"Post Graduate",@"Graduate",@"Intermediate",@"Matriculation"];
    
    userCountryArray = @[@" ",@"Select Country",@"India"].mutableCopy;
    userStateArray = @[@"Select State",@"Andaman and Nicobar Island",@"Andhra Pradesh",@"Assam",@"Bihar",@"Delhi"].mutableCopy;
    userCityArray = @[@"Select City",@"Central Delhi",@"East Delhi",@"New Delhi",@"North Delhi",@"South Delhi"].mutableCopy;
    
    userType = userDetail.usertype;
    userCountry = userDetail.country;
    userState =  userDetail.state;
    userCity =  userDetail.city;
    userEducation = userDetail.education;
    gender = userDetail.gender;
    //dob = userDetail.dob;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        if ([userDetail.dob length]!=0) {
            NSString *dateString = userDetail.dob;
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"dd-MM-yyyy"];
            
            NSDate *date = [format dateFromString:dateString];
            [format setDateFormat:@"yyyy-MM-dd"];
            NSString* finalDateString = [format stringFromDate:date];
            dob=finalDateString;

            
                    }
       
    }
    
//    NSString *dateString = dob;
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"yyyy-MM-dd"];
//    
//    NSDate *date = [format dateFromString:dateString];
//    [format setDateFormat:@"dd-MM-yyyy"];
//    NSString* finalDateString = [format stringFromDate:date];
//    userDetail.dob=finalDateString;
    
    
    
    [registrationTableView registerNib:[UINib nibWithNibName:@"ProfileImageTableViewCell" bundle:nil] forCellReuseIdentifier:kProfileImageTableViewCell];
    [registrationTableView registerNib:[UINib nibWithNibName:@"CustomTextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:kCustomTextFieldTableViewCell];
    [registrationTableView registerNib:[UINib nibWithNibName:@"GenderSelectionTableViewCell" bundle:nil] forCellReuseIdentifier:kGenderSelectionTableViewCell];
    
    [registrationTableView registerNib:[UINib nibWithNibName:@"SignUpButtonTableViewCell" bundle:nil] forCellReuseIdentifier:kSignUpButtonTableViewCell];
    [registrationTableView registerNib:[UINib nibWithNibName:@"ProfilePictureTableViewCell" bundle:nil] forCellReuseIdentifier:kProfilePictureTableViewCell];
    [registrationTableView registerNib:[UINib nibWithNibName:@"BlankTableViewCell" bundle:nil] forCellReuseIdentifier:kBlankTableViewCell];
    pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height,self.view.bounds.size.width, 200)];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.hidden = YES;
    pickerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:pickerView];
    
   
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",userDetail.profile_picture]];
    
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{

                    profileImage = image;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                    [registrationTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                });
            }
        }
    }];
    [task resume];
}




  - (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
}

- (IBAction)showRightMenuPressed:(id)sender {
    [self.menuContainerViewController toggleRightSideMenuCompletion:nil];
}

- (void)clickOnUpdateProfile{
    [self.view endEditing:YES];
    NSString *str_Image_ToServer = @"";
    
    if (profileImage) {
        
        str_Image_ToServer =  [str_Image_ToServer stringByAppendingString:[self encodeToBase64String: profileImage]];
        
    }
    if (userDetail.firstname.length > 0 && userDetail.mobile.length > 0 && userDetail.email.length > 0  && userDetail.country.length > 0) {
        
//        if ([userConfirmPassword isEqualToString:userPassword])
//        {
            if ([self validateEmail:userDetail.email])
            {
                
                if([self validateMobieNumber:userDetail.mobile])
                {
//                    if (isAgreeTermsCondition)
//                    {
//                        if ([userDetail.mobile isEqualToString:userMobile]) {
                          [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
                        
                        NSString *jsonRequest = [NSString stringWithFormat:@"{\"userId\":\"%@\",\"userType\":\"%@\",\"firstname\":\"%@\",\"lastName\":\"%@\",\"mobile_number\":\"%@\",\"email\":\"%@\",\"dob\":\"%@\",\"gender\":\"%@\",\"street\":\"%@\",\"country\":\"%@\",\"state\":\"%@\",\"city\":\"%@\",\"pincode\":\"%@\",\"education\":\"%@\",\"profile_picture\":\"%@\"}",userDetail.userid,userDetail.usertype,userDetail.firstname, userDetail.lastname, userDetail.mobile, userDetail.email,dob,gender, userDetail.addressline1, userDetail.country, userDetail.state, userDetail.city, userDetail.pin, userDetail.education, str_Image_ToServer
                                                 ];
                        NSLog(@"%@",jsonRequest);
                        NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Update_profile_URL];
                        NSLog(@"%@",jsonRequest);
                        requestFor=Update_profile_URL;
                        URLConnection *connection=[[URLConnection alloc] init];
                        connection.delegate=self;
                        [connection getDataFromUrl:jsonRequest webService:urlString];
//                        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
                    }
//                        else{
//                            
//                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please verify your mobile number" preferredStyle:UIAlertControllerStyleAlert];
//                            
//                                        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                            
//                                        }];
//                                        [alert addAction:cancelAction];
//                            
//                                        UIAlertAction *submitButton=[UIAlertAction actionWithTitle:@"Submit"
//                                                                                             style:UIAlertActionStyleDefault
//                                                                                           handler:^(UIAlertAction * _Nonnull action) {
//                            
//                                                                                               otp=alert.textFields.firstObject.text;
//                                                                                               //                                                               otp=alert.textFields.lastObject.text;
//                                                                                               NSLog(@"%@",otp);
//                                                                                               [self verifyOtpNumber];
//                            
//                                                                                           }];
//                                        
//                                        
//                                        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                                            textField.placeholder = @"OTP Number";
//                                            otp=textField.text;
//                                            textField.text=[NSString stringWithFormat:@"%@",otp];
//                                        }];
//                                        [alert addAction:submitButton];
//                                        
//                                        [self presentViewController:alert animated:YES completion:nil];
//                            
//                            
//                            
//                        }
//                    }
                    
                                    
                else {
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Mobile Number is not valid." preferredStyle:UIAlertControllerStyleAlert];
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
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Mandatory fields can not be empty." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}


#pragma mark - UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = registrationFormList.count + 1;
    
    return numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier  = kProfileImageTableViewCell;
    static NSString *cellIdentifier1 = kCustomTextFieldTableViewCell;
    static NSString *cellIdentifier2 = kGenderSelectionTableViewCell;
    //static NSString *cellIdentifier3 = kTermConditionTableViewCell;
    static NSString *cellIdentifier4 = kBlankTableViewCell;
    static NSString *cellIdentifier3 = kSignUpButtonTableViewCell;

    UITableViewCell *cell = nil;
    
    if (indexPath.row == 7) {
        
        GenderSelectionTableViewCell *textFieldCell= (GenderSelectionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
        textFieldCell.titleNameLabel.text = registrationFormList[indexPath.row];
        
        [textFieldCell.maleSelectionButton addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventTouchUpInside];
        [textFieldCell.femaleSelectionButton addTarget:self action:@selector(selectGender:) forControlEvents:UIControlEventTouchUpInside];
        if ([gender isEqualToString:@"Male"])
        {
            [textFieldCell.maleSelectionButton setImage:[UIImage imageNamed:@"radio-button-checked.png"] forState:UIControlStateNormal];
            [textFieldCell.femaleSelectionButton setImage:[UIImage imageNamed:@"radio-button.png"] forState:UIControlStateNormal];
        }
        else if ([gender isEqualToString:@"Female"])
        {
            
            [textFieldCell.femaleSelectionButton setImage:[UIImage imageNamed:@"radio-button-checked.png"] forState:UIControlStateNormal];
            [textFieldCell.maleSelectionButton setImage:[UIImage imageNamed:@"radio-button.png"] forState:UIControlStateNormal];
        }
        else{
            [textFieldCell.femaleSelectionButton setImage:[UIImage imageNamed:@"radio-button.png"] forState:UIControlStateNormal];
            [textFieldCell.maleSelectionButton setImage:[UIImage imageNamed:@"radio-button.png"] forState:UIControlStateNormal];
        }
        
        cell = textFieldCell;
        
    }

    else if (indexPath.row==0)
    {
        ProfileImageTableViewCell *textFieldCell=(ProfileImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        textFieldCell.profileImageView.layer.cornerRadius = textFieldCell.profileImageView.frame.size.width / 2;
        textFieldCell.profileImageView.clipsToBounds = YES;
        textFieldCell.profileImageView.layer.masksToBounds = YES;
        
        //textFieldCell.profileImageView.image=profileImage;
        
        
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
            
            
            
            textFieldCell.activityLoader.hidden=YES;
            if (userDetail.profile_picture==nil) {
                textFieldCell.profileImageView.image=profileImage;
            }
            else{
                textFieldCell.activityLoader.hidden=YES;
                //textFieldCell.profileImageView.image = profileImage;}}
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",userDetail.profile_picture]];
                
                NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                    if (data) {
                        UIImage *image = [UIImage imageWithData:data];
                        if (image) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                textFieldCell.activityLoader.hidden = YES;
                                textFieldCell.profileImageView.image = profileImage;
                                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
                                [registrationTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                            });
                        }
                    }
                }];
                [task resume];

               // textFieldCell.profileImageView.image = profileImage;
            }}

        textFieldCell.profileImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture:)];
        
        tapGesture1.numberOfTapsRequired = 1;
        
        //[tapGesture1 setDelegate:self];
        
        [textFieldCell.profileImageView addGestureRecognizer:tapGesture1];
        cell=textFieldCell;
    }

    else  if (indexPath.row < registrationFormList.count){
        
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
            

//            NSString *dateString = userDetail.dob;
//            NSDateFormatter *format = [[NSDateFormatter alloc] init];
//            [format setDateFormat:@"yyyy-MM-dd"];
//            
//            NSDate *date = [format dateFromString:dateString];
//            [format setDateFormat:@"dd-MM-yyyy"];
//            NSString* finalDateString = [format stringFromDate:date];
            
            NSString *dateString = dob;
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setDateFormat:@"yyyy-MM-dd"];
            
            NSDate *date = [format dateFromString:dateString];
            [format setDateFormat:@"dd-MM-yyyy"];
            NSString* finalDateString = [format stringFromDate:date];
            userDetail.dob=finalDateString;

            
        CustomTextFieldTableViewCell *textFieldCell= (CustomTextFieldTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
        textFieldCell.userInputTextField.placeholder=registrationFormList[indexPath.row];

        textFieldCell.titleNameLabel.text = registrationFormList[indexPath.row];
        
        textFieldCell.userInputTextField.delegate = self;
        textFieldCell.userInputTextField.userInteractionEnabled = true;
        
        textFieldCell.astricLabel.hidden = YES;
        textFieldCell.dropDownImageView.hidden = YES;
        textFieldCell.userInputTextField.secureTextEntry=false;
               switch (indexPath.row) {
            case 1:
                       
       
                textFieldCell.userInputTextField.text=userDetail.usertype;
                       textFieldCell.userInputTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                       textFieldCell.userInputTextField.layer.borderWidth=0.8;
                break;
            case 2:
                        textFieldCell.userInputTextField.keyboardType=UIKeyboardTypeDefault;
                textFieldCell.userInputTextField.text=userDetail.firstname;
                break;
            case 3:
                        textFieldCell.userInputTextField.keyboardType=UIKeyboardTypeDefault;
                textFieldCell.userInputTextField.text=userDetail.lastname;
                break;
            case 4:
                      //
                textFieldCell.userInputTextField.text= userDetail.mobile;
                       textFieldCell.userInputTextField.keyboardType = UIKeyboardTypePhonePad;
                break;
            case 5:
                       
                textFieldCell.userInputTextField.text = userDetail.email;
                       textFieldCell.userInputTextField.keyboardType = UIKeyboardTypeEmailAddress;
                break;
            case 6:
                       textFieldCell.userInputTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                       textFieldCell.userInputTextField.layer.borderWidth=0.8;

                       textFieldCell.userInputTextField.text = userDetail.dob;
                     
                break;
//            case 7:
//                textFieldCell.userInputTextField.text = userGender;
//                break;
            case 8:
                       

                textFieldCell.userInputTextField.text=userDetail.country;
                       textFieldCell.userInputTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                       textFieldCell.userInputTextField.layer.borderWidth=0.8;
                break;
            case 9:
                       

                textFieldCell.userInputTextField.text=userDetail.state;
                       textFieldCell.userInputTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                       textFieldCell.userInputTextField.layer.borderWidth=0.8;
                break;
            case 10:
                       textFieldCell.userInputTextField.layer.borderWidth=0.8;
                       textFieldCell.userInputTextField.text=userDetail.city;
                       textFieldCell.userInputTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                       
                       
                break;
            case 11:
                        textFieldCell.userInputTextField.keyboardType=UIKeyboardTypeDefault;
                textFieldCell.userInputTextField.text=userDetail.addressline1;
                break;
            case 12:
                        textFieldCell.userInputTextField.keyboardType=UIKeyboardTypeDefault;
                textFieldCell.userInputTextField.text=userDetail.addressline2;
                break;
            case 13:
                       textFieldCell.userInputTextField.keyboardType=UIKeyboardTypeNumbersAndPunctuation;
                textFieldCell.userInputTextField.text= userDetail.pin;
                break;
            case 14:
                       textFieldCell.userInputTextField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
                       textFieldCell.userInputTextField.layer.borderWidth=0.8;

                textFieldCell.userInputTextField.text = userDetail.education;
                break;
            default:
                break;
        }
        
        if (indexPath.row == 1 || indexPath.row == 6 || indexPath.row == 8 || indexPath.row == 9 || indexPath.row == 10 || indexPath.row == 14) {
            textFieldCell.dropDownImageView.hidden = NO;
            textFieldCell.userInputTextField.userInteractionEnabled = false;
        }
        
        if (indexPath.row == 2 || indexPath.row == 4 || indexPath.row == 5 || indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 || indexPath.row == 10 ) {
            textFieldCell.astricLabel.hidden = NO;
        }
        cell = textFieldCell;
        }}
    else if (indexPath.row==15){
        SignUpButtonTableViewCell *textFieldCell= (SignUpButtonTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
        
        
        [textFieldCell.submitButton addTarget:self action:@selector(clickOnUpdateProfile) forControlEvents:UIControlEventTouchUpInside];
        cell = textFieldCell;
        

    }
  else
  {
      BlankTableViewCell *textFieldCell = (BlankTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier4 forIndexPath:indexPath];
      cell = textFieldCell;
      cell.userInteractionEnabled=NO;
      
  }
    
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 1:
            pickerArray = [NSArray arrayWithArray:userTypeArray];
            [self bringUpPickerViewWithRow:indexPath];
            break;
      
        case 6:
            pickerArray = [NSArray arrayWithArray:userTypeArray];
            [self bringDatePickerView:indexPath];
                     break;
        case 8:
            pickerArray = [NSArray arrayWithArray:userCountryArray];
            [self bringUpPickerViewWithRow:indexPath];
            break;
        case 9:
            pickerArray = [NSArray arrayWithArray:userStateArray];
            [self bringUpPickerViewWithRow:indexPath];
            break;
        case 10:
            pickerArray = [NSArray arrayWithArray:userCityArray];
            [self bringUpPickerViewWithRow:indexPath];
            break;
        case 14:
            pickerArray = [NSArray arrayWithArray:userEducationArray];
            [self bringUpPickerViewWithRow:indexPath];
            break;
//        case 15:
//            [self showTermCondition];
//            break;
        default:
            break;
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
        if ([requestFor isEqualToString:Update_profile_URL]) {
            NSDictionary *userdetails = json[@"user_details"];
            // UserDetail *userDetail = [[UserDetail alloc]init];
            userDetail.userid = userdetails[@"userid"];
            userDetail.usertype = userdetails[@"userType"];
            //userDetail.username = userdetails[@"username"];
            userDetail.firstname = userdetails[@"firstname"];
            userDetail.lastname = userdetails[@"lastName"];
            userDetail.email = userdetails[@"email"];
            userDetail.gender = userdetails[@"gender"];
            userDetail.mobile = userdetails[@"mobile_number"];
            userDetail.addressline1 = userdetails[@"street"];
            userDetail.addressline2 = userdetails[@"addressline2"];
            userDetail.city = userdetails[@"city"];
            userDetail.state = userdetails[@"state"];
            userDetail.country = userdetails[@"country"];
            userDetail.pin = userdetails[@"pincode"];
            userDetail.profile_picture = userdetails[@"profile_picture"];
            userDetail.dob = userdetails[@"dob"];
            userDetail.education = userdetails[@"education"];
            
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Congratulation" message:@"Your profile update successfully!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self callViewController];
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }

        
    }
}

-(void)callViewController
{
    NSData *userEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:userDetail];
    [[NSUserDefaults standardUserDefaults]setObject:userEncodedObject forKey:@"userData"];
    [[NSNotificationCenter defaultCenter]postNotificationName:SideMenuUpdateNotification
                                                       object:nil];
}

- (void)connectionFailWithError:(NSError *)error
{
    NSString *strErrorMsg = [error localizedDescription];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error !" message:strErrorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
}




- (void)takePhotoFromCamera {
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Device has no camera" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self presentViewController:picker animated:YES completion:NULL];
    }
}

//-(void)chooseImageClicked:(UIButton*)sender
- (void) tapGesture: (id)sender

{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *photoGalleryButton = [UIAlertAction actionWithTitle:@"Photo Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self presentViewController:picker animated:YES completion:NULL];
       
    }];
    UIAlertAction *cameraButton = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self takePhotoFromCamera];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [actionSheet addAction:cameraButton];
    [actionSheet addAction:photoGalleryButton];
    [actionSheet addAction:cancelAction];
     
    
    [self presentViewController:actionSheet animated:YES completion:nil];
   
}

-(void)selectGender:(UIButton*)sender
{
    [self.view endEditing:YES];
    
    NSIndexPath *indexPath = [registrationTableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    [sender setBackgroundImage:[UIImage imageNamed:@"radio-button.png"] forState:UIControlStateSelected];
    if ([sender tag] == 1001) {
        [sender setBackgroundImage:[UIImage imageNamed:@"radio-button-checked.png"] forState:UIControlStateSelected];
        
        
        gender=@"Male";
    }
    else if([sender tag] == 1002)
    {
        [sender setBackgroundImage:[UIImage imageNamed:@"radio-button-checked.png"] forState:UIControlStateSelected];
        gender=@"Female";
    }
    else
    {
        gender=@" ";
        [sender setBackgroundImage:[UIImage imageNamed:@"radio-button.png"] forState:UIControlStateSelected];
    }
    [registrationTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}


#pragma mark - Image Picker Controller delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    
    imageData = UIImagePNGRepresentation(chosenImage);
    profileImage = [UIImage imageWithData:UIImagePNGRepresentation(chosenImage)];
   
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [registrationTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
   
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
}
- (NSString *)encodeToBase64String:(UIImage *)image {
    
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self hidePickerView];
    CGPoint origin = textField.frame.origin;
    CGPoint point = [textField.superview convertPoint:origin toView:registrationTableView];
    
    NSIndexPath * indexPath = [registrationTableView indexPathForRowAtPoint:point];
    
    [registrationTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    //    CustomTextFieldTableViewCell *textFieldRowCell = (CustomTextFieldTableViewCell *) textField.superview.superview;
    //    NSIndexPath *indexPath = [registrationTableView indexPathForCell:textFieldRowCell];
    //
    //    switch (indexPath.row) {
    //        case 1:
    //            userFirstName = textField.text;
    //            break;
    //        case 2:
    //            userLastName = textField.text;
    //            break;
    //        case 3:
    //            userMobile = textField.text;
    //            break;
    //        case 4:
    //            userEmail = textField.text;
    //            break;
    //        case 5:
    //            userPassword = textField.text;
    //            break;
    //        case 6:
    //            userConfirmPassword = textField.text;
    //            break;
    //        case 13:
    //            addressline1 = textField.text;
    //            break;
    //        case 14:
    //            addressline2 = textField.text;
    //            break;
    //        case 15:
    //            userPincode = textField.text;
    //            break;
    //        default:
    //            break;
    //    }
    return true;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    CustomTextFieldTableViewCell *textFieldRowCell = (CustomTextFieldTableViewCell *) textField.superview.superview;
    NSIndexPath *indexPath = [registrationTableView indexPathForCell:textFieldRowCell];
    
    switch (indexPath.row) {
        case 2:
            userDetail.firstname = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        case 3:
            userDetail.lastname = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        case 4:
         
            userDetail.mobile = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        case 5:
            userDetail.email = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
//        case 6:
//            userPassword = [NSString stringWithFormat:@"%@%@",textField.text,string];
//            break;
//        case 7:
//            userConfirmPassword = [NSString stringWithFormat:@"%@%@",textField.text,string];
//            break;
        case 11:
            userDetail.addressline1 = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        case 12:
            userDetail.addressline2 = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        case 13:
            userDetail.pin = [NSString stringWithFormat:@"%@%@",textField.text,string];
            break;
        default:
            break;
    }
    
    return true;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat size;
    size=70.0f;
    if (indexPath.row==0) {
        size=138.0f;
    }
    else if (indexPath.row==7)
    {
        size=91.0f;
    }
    return size;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}

#pragma mark - UIPickerView Delegate

- (void)bringUpPickerViewWithRow:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
    [self cancelSelected:nil];
    selectedIndexPath = indexPath;
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         pickerView.hidden = NO;
                         pickerView.frame=CGRectMake(0, self.view.bounds.size.height-180, self.view.bounds.size.width, 222);
                         [pickerView reloadAllComponents];
                         
                     } completion:nil];
}

- (void)hidePickerView
{
    [UIView animateWithDuration:1.0f
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         pickerView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
                         
                     } completion:^(BOOL finished) {
                         
                         pickerView.hidden = YES;
                     }];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [self hidePickerView];
    NSLog(@"row selected:%ld", (long)row);
    switch (selectedIndexPath.row) {
        case 1:
            userDetail.usertype = pickerArray[row];
            break;
        case 8:
            userDetail.country = pickerArray[row];
            break;
        case 9:
            userDetail.state = pickerArray[row];
            break;
        case 10:
            userDetail.city = pickerArray[row];
            break;
        case 14:
            userDetail.education = pickerArray[row];
            break;
        default:
            break;
    }
    [registrationTableView reloadRowsAtIndexPaths:@[selectedIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerArray[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerArray.count;
}

#pragma mark - Date Picker

- (void)bringDatePickerView:(NSIndexPath*)indexPath
{
    [self.view endEditing:YES];
    [self hidePickerView];
    selectedIndexPath = indexPath;
    
    datePicker.datePickerMode=UIDatePickerModeDate;
    datePickerView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
    
    [UIView beginAnimations:@"START" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    
    datePickerView.frame=CGRectMake(0, self.view.bounds.size.height-180, self.view.bounds.size.width, 222);
    [UIView commitAnimations];
}


- (IBAction)doneSelected:(id)sender {
    
    [UIView beginAnimations:@"START" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    
    datePickerView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
    [UIView commitAnimations];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"yyyy-MM-dd"];
    dob=[outputFormatter stringFromDate:datePicker.date];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:6 inSection:0];
    [registrationTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];

    
}

- (IBAction)cancelSelected:(id)sender
{
    [UIView beginAnimations:@"START" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    
    datePickerView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
    [UIView commitAnimations];
}
- (BOOL) validateEmail: (NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:candidate];
}

-(BOOL) validateMobieNumber:(NSString *) stringToBeTested {
    NSLog(@"%@",userMobile);
    
    
    NSString *mobileNumberRegex = @"[789][0-9]{9}";
    NSPredicate *mobileNumberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobileNumberRegex];
    
    return [mobileNumberTest evaluateWithObject:stringToBeTested];
}
- (IBAction)backToPreviousView:(id)sender {
    ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self .navigationController pushViewController:obj animated:YES];
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
