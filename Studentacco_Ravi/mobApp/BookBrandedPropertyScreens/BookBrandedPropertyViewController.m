//
//  BookBrandedPropertyViewController.m
//  Studentacco
//
//  Created by MAG on 15/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "BookBrandedPropertyViewController.h"
#import "PayU_iOS_CoreSDK.h"
#import "PUUIPaymentOptionVC.h"
#import "PUUIWrapperPayUSDK.h"
#import "PUSAHelperClass.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "PayUStatusViewController.h"
#import "AppDelegate.h"
static NSString * const verifyAPIStoryBoard = @"PUVAMainStoryBoard";
static NSString * const pUUIStoryBoard = @"PUUIMainStoryBoard";

#define     PAYUALERT(T,M)                                      dispatch_async(dispatch_get_main_queue(), ^{[[[UIAlertView alloc] initWithTitle:T message:M delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] show];});

@interface BookBrandedPropertyViewController ()<UITextFieldDelegate,NSURLConnectionDelegate>

{
    
    NSString *date,*transactionId,*requestFor,*transactionStatus;
    BOOL isSelected;
    __weak IBOutlet UIView *datePickerView;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UIView *datePickerView1;
    __weak IBOutlet UIDatePicker *datePicker1;
}
@property (nonatomic, strong) PayUModelPaymentParams *paymentParam;
@property (strong, nonatomic) PayUWebServiceResponse *webServiceResponse;


- (IBAction)CancelPicker1:(id)sender;

- (IBAction)DonePicker1:(id)sender;

@end

@implementation BookBrandedPropertyViewController
- (IBAction)backToPreviousView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _moveInTextField.delegate=self;
    _moveOutDateTextField.delegate=self;
    _firstNameTextField.delegate=self;
    _emailTextField.delegate =self;
    _mobileNumberTextField.delegate = self;
     datePickerView.hidden=YES;
    datePickerView1.hidden=YES;
    // Do any additional setup after loading the view.
//    [[NSNotificationCenter defaultCenter]
//     addObserver:selfselector:@selector(responseReceived:)
//     name:kPUUINotiPaymentResponse object:nil];
    
    self.paymentParam = [[PayUModelPaymentParams alloc] init];
  // Set the hashes here
    }

- (void)viewWillAppear:(BOOL)animated {
  [[self navigationController] setNavigationBarHidden:YES animated:YES];
}


- (IBAction)checkoutButtonAction:(id)sender {
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    if (_moveInTextField.text.length > 0 && _moveOutDateTextField.text.length > 0 && _firstNameTextField.text.length > 0 && _emailTextField.text.length > 0 && _mobileNumberTextField.text.length > 0)
    {
        
        if ([self validateMobieNumber:_mobileNumberTextField.text])
        {
            
            if([self validateEmail:_emailTextField.text])
            {

    self.paymentParam.key = @"4aptkE";
    self.paymentParam.amount = @"5000";
    self.paymentParam.productInfo = @"Property";
    self.paymentParam.firstName = _firstNameTextField.text;
    self.paymentParam.email = _emailTextField.text;
    self.paymentParam.userCredentials = @"super:Mag1234!";
    self.paymentParam.phoneNumber = _mobileNumberTextField.text;
    self.paymentParam.SURL = @"https://payu.herokuapp.com/success";
    self.paymentParam.FURL = @"https://payu.herokuapp.com/failure";
    self.paymentParam.udf1 = @"u1";
    self.paymentParam.udf2 = @"u2";
    self.paymentParam.udf3 = @"u3";
    self.paymentParam.udf4 = @"u4";
    self.paymentParam.udf5 = @"u5";
    self.paymentParam.transactionID = [PUSAHelperClass getTransactionIDWithLength:15];
      PayUModelHashes *hashes = [[PayUModelHashes alloc] init];
    _paymentParam.hashes = hashes;
    // Set the environment according to merchant key ENVIRONMENT_PRODUCTION for Production & ENVIRONMENT_MOBILETEST for mobiletest environment:key:- 4aptkE salt :-MwkfMU8G
    _paymentParam.environment = ENVIRONMENT_PRODUCTION;
    
    // Set this property if you want to give offer:
    //    _paymentParam.offerKey = @"";
    
    //Set this property if you want to get One Tap Cards:
    _paymentParam.OneTapTokenDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"Merchant_Hash1",@"CardToken1",
                                           @"Merchant_Hash2",@"CardToken2", nil];
    
    [self addPaymentResponseNotofication];
    PayUDontUseThisClass *obj = [PayUDontUseThisClass new];
    [obj getPayUHashesWithPaymentParam:self.paymentParam merchantSalt:@"MwkfMU8G" withCompletionBlock:^(PayUModelHashes *allHashes, PayUModelHashes *hashString, NSString *errorMessage) {
        [self callSDKWithHashes:allHashes withError:errorMessage];
    }];


//................................................................
//    [PUSAHelperClass generateHashFromServer:self.paymentParam withCompletionBlock:^(PayUModelHashes *hashes, NSString *errorString) {
//        [self callSDKWithHashes:hashes withError:errorString];
//    }];
 //...............................................................
    
    
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

    else
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Mandatory fields can not be empty." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];

}

-(void)addPaymentResponseNotofication{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(responseReceived:) name:kPUUINotiPaymentResponse object:nil];
    
}

-(void)responseReceived:(NSNotification *) notification{
    //    [self.navigationController popToRootViewControllerAnimated:NO];
    //    self.textFieldTransactionID.text = [PUSAHelperClass getTransactionIDWithLength:15];
    
    NSString *strConvertedRespone = [NSString stringWithFormat:@"%@",notification.object];
    NSLog(@"Response Received %@",strConvertedRespone);
    NSError *serializationError;
    id JSON = [NSJSONSerialization JSONObjectWithData:[strConvertedRespone dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&serializationError];
    if (serializationError == nil && notification.object) {
        NSLog(@"%@",JSON);
        NSString *status;
        transactionId = [JSON objectForKey:@"txnid"];
       if([[JSON objectForKey:@"status"] isEqualToString:@"success"])
       {
           status = @"success";
       }
        else
        {
          status = @"fail";
        }
         [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"email\":\"%@\",\"firstname\":\"%@\",\"prop_ID\":\"%@\",\"phone_no\":\"%@\",\"cost\":\"%@\",\"move_in\":\"%@\",\"move_out\":\"%@\",\"pay_status\":\"%@\"}",_emailTextField.text, _firstNameTextField.text,_propertyId,_mobileNumberTextField.text,@"2",_moveInTextField.text,_moveOutDateTextField.text,status];
        
        NSLog(@"jsonRequest #### %@",jsonRequest);
        
        NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,add_payment_details_URL];
        requestFor = add_payment_details_URL;
        URLConnection *connection=[[URLConnection alloc] init];
        connection.delegate=self;
        [connection getDataFromUrl:jsonRequest webService:urlString];

        
        
        
        if ([[JSON objectForKey:@"status"] isEqual:@"success"]) {
            transactionStatus = @"success";
           // [self.navigationController popViewControllerAnimated:YES];
//            NSString *Response = [NSString stringWithFormat:@"Thank you for your payment,Your Transaction ID is %@ We will be in touch shortly.",transactionId];
            
            NSString *merchant_hash = [JSON objectForKey:@"merchant_hash"];
            if ([[JSON objectForKey:@"card_token"] length] >1 && merchant_hash.length >1 && self.paymentParam) {
                NSLog(@"Saving merchant hash---->");
                [PUSAHelperClass saveOneTapTokenForMerchantKey:self.paymentParam.key withCardToken:[JSON objectForKey:@"card_token"] withUserCredential:self.paymentParam.userCredentials andMerchantHash:merchant_hash withCompletionBlock:^(NSString *message, NSString *errorString) {
                    if (errorString == nil) {
                        NSLog(@"Merchant Hash saved succesfully %@",message);
                    }
                    else{
                        NSLog(@"Error while saving merchant hash %@", errorString);
                    }
                }];
            }
            
        }
        else
        {
            transactionStatus = @"failed";
            //[self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        PAYUALERT(@"Response", strConvertedRespone);
        
    }
}

-(void)callSDKWithHashes:(PayUModelHashes *) allHashes withError:(NSString *) errorMessage{
    if (errorMessage == nil) {
        self.paymentParam.hashes = allHashes;
        //        if (self.switchForOneTap.on) {
        //            [PUSAHelperClass getOneTapTokenDictionaryFromServerWithPaymentParam:self.paymentParam CompletionBlock:^(NSDictionary *CardTokenAndOneTapToken, NSString *errorString) {
        //                if (errorMessage) {
        //                    PAYUALERT(@"Error", errorMessage);
        //                }
        //                else{
        //                    [self callSDKWithOneTap:CardTokenAndOneTapToken];
        //                }
        //            }];
        //        }
        //        else{
        [self callSDKWithOneTap:nil];
        //        }
    }
    else{
        PAYUALERT(@"Error", errorMessage);
    }
}


//- (NSData *) createSHA512:(NSString *)source {
//    
//    const char *s = [source cStringUsingEncoding:NSASCIIStringEncoding];
//    
//    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
//    
//    uint8_t digest[CC_SHA512_DIGEST_LENGTH] = {0};
//    
//    CC_SHA512(keyData.bytes, keyData.length, digest);
//    
//    NSData *output = [NSData dataWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
//    NSLog(@"out --------- %@",output);
//    return output;
//}
-(void) callSDKWithOneTap:(NSDictionary *)oneTapDict{
    
    self.paymentParam.OneTapTokenDictionary = oneTapDict;
    PayUWebServiceResponse *respo = [PayUWebServiceResponse new];
    self.webServiceResponse = [PayUWebServiceResponse new];
    [self.webServiceResponse getPayUPaymentRelatedDetailForMobileSDK:self.paymentParam withCompletionBlock:^(PayUModelPaymentRelatedDetail *paymentRelatedDetails, NSString *errorMessage, id extraParam) {
        
        if (errorMessage) {
            PAYUALERT(@"Error", errorMessage);
        }
        else{
            [respo callVASForMobileSDKWithPaymentParam:self.paymentParam];        //FORVAS
            
            //            if (_isStartBtnTapped) {
            UIStoryboard *stryBrd = [UIStoryboard storyboardWithName:pUUIStoryBoard bundle:nil];
            PUUIPaymentOptionVC * paymentOptionVC = [stryBrd instantiateViewControllerWithIdentifier:VC_IDENTIFIER_PAYMENT_OPTION];
            paymentOptionVC.paymentParam = self.paymentParam;
            paymentOptionVC.paymentRelatedDetail = paymentRelatedDetails;
            
            [[self navigationController] setNavigationBarHidden:NO animated:YES];
            [self.navigationController pushViewController:paymentOptionVC animated:true];
            //            }
        }
    }];
}



#pragma mark connectionDelegates .. .. .. .. .. ..

- (void)connectionFinishLoading:(NSMutableData *)receiveData
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    NSError* error;
    NSMutableDictionary* json;
    json = [NSJSONSerialization JSONObjectWithData:receiveData
                                           options:kNilOptions
                                             error:&error];
    NSLog(@"%@",json);
//       NSInteger number = [[json objectForKey:@"response_data"]integerValue];
//        NSLog(@"%ld",(long)number);
//    NSInteger t_id = number+10000;
//    transactionId = [NSString stringWithFormat: @"%ld", (long)t_id];
//    NSString *first = @"Thank you for your payment";
//    NSString *second =[NSString stringWithFormat:@"Your Transaction ID is %@",transactionId];
//    NSString *third = @" We will be in touch shortly.";
//    NSString *Response = [NSString stringWithFormat:@"%@,\n\n%@,\n\n%@", first,second,third];
//    NSLog(@"%@",Response);
    PayUStatusViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"payUStatusViewController"];

    if ([requestFor isEqualToString:add_payment_details_URL] && [transactionStatus isEqualToString:@"success"] )
    {
              // obj.status = Response;
        obj.prop_id = [NSString stringWithFormat:@"ACCO%@",_propertyId];
        obj.prop_name = _propertyName;
        obj.tran_id = transactionId;
        obj.isShow = @"yes";
        [self.navigationController pushViewController:obj animated:YES];
         //PAYUALERT(@"Success",Response );
        
    }
    else if ([requestFor isEqualToString:add_payment_details_URL] && [transactionStatus isEqualToString:@"failed"] )
    {
        NSString *first = @"Your transaction is failed";
        NSString *second = @"please try again.";
        NSString *Status = [NSString stringWithFormat:@"%@,\n\n%@",first,second];
        obj.isShow = @"no";
        obj.status=Status;
       

        [self.navigationController pushViewController:obj animated:YES];
        // PAYUALERT(@"Failed",status );
    }
    
   
}

- (void)connectionFailWithError:(NSError *)error
{
      NSString *strErrorMsg = [error localizedDescription];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error !" message:strErrorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark UITextField Delegate method

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag==100){
        
        [textField resignFirstResponder];
        [datePicker reloadInputViews];
        [self bringDatePickerView:@"CurrentTime"];
        datePickerView.hidden=NO;
        datePickerView1.hidden=YES;
        isSelected = YES;
    }
    else if (textField.tag==101)
    {
       
        if (date.length==0) {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Please select movein date first" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }
        else{
            [textField resignFirstResponder];
            [datePicker reloadInputViews];
            [self bringDatePickerView:@"SixMonthLater"];
            datePickerView.hidden=YES;
            datePickerView1.hidden=NO;
            isSelected = NO;
        }
        
    }
//    else if (textField.tag == 102 || textField.tag == 103)
//    {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:.3];
//        [UIView setAnimationBeginsFromCurrentState:TRUE];
//        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y -200., self.view.frame.size.width, self.view.frame.size.height);
//        
//        [UIView commitAnimations];
//
//    }
    else
    {
        
        datePickerView.hidden=YES;
        datePickerView1.hidden=YES;
    }
}
//-(void)textFieldDidEndEditing:(UITextField *)textField
//
//{
//
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:.3];
//    [UIView setAnimationBeginsFromCurrentState:TRUE];
//    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y +200., self.view.frame.size.width, self.view.frame.size.height);
//    
//}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return true;
}

#pragma mark - Date Picker

- (void)bringDatePickerView:(NSString *)comingFrom
{
    [self.view endEditing:YES];

    if ([comingFrom isEqualToString:@"CurrentTime"]) {
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *currentDate = [NSDate date];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        
        [comps setDay:2];
        NSDate *minDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
        [comps setMonth:6];
        NSDate *maxDate = [gregorian dateByAddingComponents:comps toDate:currentDate  options:0];
        datePicker.maximumDate = maxDate;
        datePicker.minimumDate = minDate;
        
        
        datePicker.datePickerMode=UIDatePickerModeDate;
        datePickerView.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
        
        [UIView beginAnimations:@"START" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.6];
        
        datePickerView.frame=CGRectMake(0, self.view.bounds.size.height-180, self.view.bounds.size.width, 222);
        [UIView commitAnimations];
       
    }else if([comingFrom isEqualToString:@"SixMonthLater"]){
        
        NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSLog(@"date is...%@",date);
        NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
        [outputFormatter setDateFormat:@"dd-MM-yyyy"];
        NSString *currentTime=[NSString stringWithFormat:@"%@",_moveInTextField.text];
        NSDate *currentDate = [outputFormatter dateFromString:currentTime];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setMonth:6];
        NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
        [datePicker1 setMinimumDate:minDate];
        datePicker1.datePickerMode=UIDatePickerModeDate;
        datePickerView1.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
        
        [UIView beginAnimations:@"START" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.6];
        
        datePickerView1.frame=CGRectMake(0, self.view.bounds.size.height-180, self.view.bounds.size.width, 222);
        [UIView commitAnimations];
    }
    
    
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
    //_dateTextFiled.text=date;
//    if (isSelected==YES) {
        _moveInTextField.text=date;
//    }
//    else{
//        _moveOutDateTextField.text=date;
//    }
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
        
#pragma mark Email and Mobile Number Validation
        
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

- (IBAction)CancelPicker1:(id)sender {
    
    [UIView beginAnimations:@"START" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    datePickerView1.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
    [UIView commitAnimations];
    datePickerView1.hidden=YES;
}

- (IBAction)DonePicker1:(id)sender {
    
    [UIView beginAnimations:@"START" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.6];
    
    datePickerView1.frame=CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 222);
    [UIView commitAnimations];
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:@"dd-MM-yyyy"];
    date=[outputFormatter stringFromDate:datePicker1.date];
    _moveOutDateTextField.text=date;
    datePickerView1.hidden=YES;
    NSLog(@"%@",date);
}
@end
