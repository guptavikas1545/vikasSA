//
//  ScheduleToVisitViewController.m
//  Studentacco
//
//  Created by MAG on 30/08/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "ScheduleToVisitViewController.h"
#import "MiinuteCollectionViewCell.h"
#import "HoureTableViewCell.h"
#import "AppConstants.h"
#import "URLConnection.h"
#import "UserDetail.h"
@interface ScheduleToVisitViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    
    // Date Picker
    NSString *date;
    NSArray *houreArray,*minArray;
    UserDetail *userDetail;
    __weak IBOutlet UIView *datePickerView;
    __weak IBOutlet UIDatePicker *datePicker;
    __weak IBOutlet UITableView *houreTableView;
    __weak IBOutlet UICollectionView *minCollectionView;
   }
@end

@implementation ScheduleToVisitViewController
@synthesize dateField,hrField,minField;
- (void)viewDidLoad {
    dateField.delegate = self;
    [super viewDidLoad];
    date=[[NSString alloc]init];
    datePickerView.hidden=YES;
    houreArray=@[@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20"];
    minArray=@[@"00",@"15",@"30",@"45"];
    [houreTableView registerNib:[UINib nibWithNibName:@"HoureTableViewCell" bundle:nil] forCellReuseIdentifier:@"houreTableViewCell"];
    [minCollectionView registerNib:[UINib nibWithNibName:@"MiinuteCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"miinuteCollectionViewCell"];
    houreTableView.hidden=YES;
    hrField.delegate=self;
    minField.delegate=self;
    dateField.delegate=self;
    minCollectionView.hidden=YES;
    [minCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cvCell"];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
        userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        
    }

    // Do any additional setup after loading the view.
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
    [textField resignFirstResponder];
    return  YES;
}
- (IBAction)backToPreviousView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES ];
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
    hrField.text=houreArray[indexPath.row];
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
    minField.text=minArray[indexPath.item];
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
    dateField.text=date;
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
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,scheduleVisit_URL];
     if (dateField.text.length > 0 &&hrField.text.length > 0 && minField.text.length > 0 )
     {
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"date\":\"%@\",\"hr\":\"%@\",\"min\":\"%@\",\"owner_Property_id\":\"%@\",\"visiter_userid\":\"%@\"}",dateField.text,hrField.text,minField.text,_propertyID,userDetail.userid];
    NSLog(@"%@",jsonRequest);
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];
     }
     else{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Mandatory fields can not be empty." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
         [self presentViewController:alertController animated:YES completion:nil];}
}


#pragma mark NSURL Connection Delegate method

- (void)connectionFinishLoading:(NSMutableData *)receiveData
{
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
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Thank You! Your request has been received and will be confirmed shortly" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
