//
//  ScheduleToVisitWithoutLoginViewController.m
//  Studentacco
//
//  Created by MAG on 13/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "ScheduleToVisitWithoutLoginViewController.h"
#import "MiinuteCollectionViewCell.h"
#import "HoureTableViewCell.h"
#import "AppConstants.h"
#import "URLConnection.h"
#import "UserDetail.h"
#import "AppDelegate.h"
@interface ScheduleToVisitWithoutLoginViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSString *date,*requestFor,*otp;
    NSArray *houreArray,*minArray;

    __weak IBOutlet UIView *datePickerView;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UITableView *houreTableView;
    __weak IBOutlet UICollectionView *minCollectionView;
    UserDetail *userDetail;
}
@end

@implementation ScheduleToVisitWithoutLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _dateTextFiled.delegate = self;
    [super viewDidLoad];
    date=[[NSString alloc]init];
    datePickerView.hidden=YES;
    houreArray=@[@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"];
    minArray=@[@"00",@"15",@"30",@"45"];
    [houreTableView registerNib:[UINib nibWithNibName:@"HoureTableViewCell" bundle:nil] forCellReuseIdentifier:@"houreTableViewCell"];
    [minCollectionView registerNib:[UINib nibWithNibName:@"MiinuteCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"miinuteCollectionViewCell"];
    houreTableView.hidden=YES;
    _houreTextField.delegate=self;
    _minTextField.delegate=self;
    _dateTextFiled.delegate=self;
    _fNametextField.delegate=self;
    _lNameTextField.delegate=self;
    _emailTextField.delegate=self;
    _mobileNumberTextField.delegate=self;
    
    
    minCollectionView.hidden=YES;
    [minCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cvCell"];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
        userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
    }
}
- (IBAction)backToPreviousView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITextField Delegate method

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag==100) {
        [textField resignFirstResponder];
        [self bringDatePickerView];
        datePickerView.hidden=NO;
        houreTableView.hidden=YES;
        minCollectionView.hidden=YES;
        
    }
    else if (textField.tag==101)
    {
        [textField resignFirstResponder];
        houreTableView.hidden=NO;
        minCollectionView.hidden=YES;
        datePickerView.hidden=YES;
    }
    else if (textField.tag==102)
    {
        [textField resignFirstResponder];
        minCollectionView.hidden=NO;
        houreTableView.hidden=YES;
        datePickerView.hidden=YES;
    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string

{
    if (textField.tag==100 || textField.tag==101 || textField.tag==102) {
         [textField resignFirstResponder];
        }
   
   
    return  true;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}



#pragma mark - UITableView Delegate & Datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [houreArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier1 = @"houreTableViewCell";
    HoureTableViewCell *cell =(HoureTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
    cell.hrlabel.text=houreArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _houreTextField.text=houreArray[indexPath.row];
    houreTableView.hidden=YES;
}
#pragma mark - UICollectionView Delegate & Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [minArray count];
}
-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"miinuteCollectionViewCell";
    
    MiinuteCollectionViewCell *cell = (MiinuteCollectionViewCell*)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.minLable.text=minArray[indexPath.item];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    _minTextField.text=minArray[indexPath.item];
    minCollectionView.hidden=YES;
}


#pragma mark - Date Picker

- (void)bringDatePickerView
{
    [self.view endEditing:YES];
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
    [outputFormatter setDateFormat:@"dd-MM-yyyy"];
    date=[outputFormatter stringFromDate:datePicker.date];
    _dateTextFiled.text=date;
    datePickerView.hidden=YES;
    NSLog(@"%@",date);
    
}

- (IBAction)cancelSelected:(id)sender
{
    [UIView beginAnimations:@"START" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    datePickerView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
    [UIView commitAnimations];
    datePickerView.hidden=YES;
}


- (IBAction)scheduleButton:(id)sender {
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,schedule_a_Visit_without_login];
    if (_fNametextField.text.length > 0 && _lNameTextField.text.length > 0 && _mobileNumberTextField.text.length > 0 &&  _dateTextFiled.text.length > 0 && _houreTextField.text.length > 0 && _minTextField.text.length > 0 )
    {
        if([self validateEmail:_emailTextField.text])
        {
            
            if ([self validateMobieNumber:_mobileNumberTextField.text])
            {
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"date\":\"%@\",\"hr\":\"%@\",\"min\":\"%@\",\"firstname\":\"%@\",\"lastname\":\"%@\",\"mobile\":\"%@\",\"email\":\"%@\",\"propertyid\":\"%@\"}",_dateTextFiled.text,_houreTextField.text,_minTextField.text,_fNametextField.text,_lNameTextField.text,_mobileNumberTextField.text,_emailTextField.text,_propertyID];
        NSLog(@"%@",jsonRequest);
        requestFor=schedule_a_Visit_without_login;
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
            if ([requestFor isEqualToString: schedule_a_Visit_without_login]) {
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
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Thank You! Your request has been received and will be confirmed shortly" preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                    [self.navigationController popViewControllerAnimated:YES];
                    
                                }];
                                [alertController addAction:cancelAction];
                                [self presentViewController:alertController animated:YES completion:nil];
                   

                }
            }
            else if ([requestFor isEqualToString:verify_schedule_a_visit_without_login_otp])
            {
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Thank You! Your request has been received and will be confirmed shortly" preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
                                [self.navigationController popViewControllerAnimated:YES];
                
                            }];
                            [alertController addAction:cancelAction];
                            [self presentViewController:alertController animated:YES completion:nil];
                

            }
            
            
        }
        else if ([[json valueForKey:@"code"]isEqualToString:@"201"])
        
        {
            if ([requestFor isEqualToString:schedule_a_Visit_without_login])
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
            else if ([requestFor isEqualToString:verify_schedule_a_visit_without_login_otp])
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
    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,verify_schedule_a_visit_without_login_otp];
    requestFor=verify_schedule_a_visit_without_login_otp;
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
