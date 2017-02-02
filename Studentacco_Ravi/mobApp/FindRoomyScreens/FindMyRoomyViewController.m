//
//  FindMyRoomyViewController.m
//  Studentacco
//
//  Created by MAG on 02/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "FindMyRoomyViewController.h"
#import "Find_RoomyTableViewCell.h"
#import "FindRoomyLocationTableViewCell.h"
#import "FindRoomyTextFieldTableViewCell.h"
#import "Find_MyroomyList.h"
#import "ViewController.h"
#import "URLConnection.h"
#import "AppConstants.h"
#import "AppDelegate.h"
#import "UserDetail.h"
@interface FindMyRoomyViewController ()<UITableViewDelegate,UITableViewDataSource,Find_RoomyTableViewCellDelegate,UITextFieldDelegate,NSURLConnectionDelegate,FindRoomyLocationTableViewCellDelegate,UITextViewDelegate>
{
    NSMutableArray *foodHabit,*smokingHabit,*myAcco,*autocompleteList;
    NSString *searchKey;
    NSMutableString *str;
    UserDetail *userDetail;
    NSString *requestFor;
    NSMutableString *aboutMe;
    __weak IBOutlet UITableView *autoCompleteTableView;
}
@end

@implementation FindMyRoomyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_findMyroomyTableView registerNib:[UINib nibWithNibName:@"Find_RoomyTableViewCell" bundle:nil] forCellReuseIdentifier:@"find_RoomyTableViewCell"];
    [_findMyroomyTableView registerNib:[UINib nibWithNibName:@"FindRoomyLocationTableViewCell" bundle:nil] forCellReuseIdentifier:@"findRoomyLocationTableViewCell"];
      [_findMyroomyTableView registerNib:[UINib nibWithNibName:@"FindRoomyTextFieldTableViewCell" bundle:nil] forCellReuseIdentifier:@"findRoomyTextFieldTableViewCell"];
    foodHabit=[NSMutableArray arrayWithObjects:@"Veg",@"Non-Veg",@" Don't Care", nil];
    smokingHabit=[NSMutableArray arrayWithObjects:@"Smoker",@"Non-Smoker",@"Don't Care", nil];
    myAcco=[NSMutableArray arrayWithObjects:@"Single",@"Double",@"Triple",@"Dorm",@"Don't Care",nil];
    _selectedFoodHabitIndexArray = [[NSMutableArray alloc]init];
    _selectedSmokngHabitIndexArray = [[NSMutableArray alloc]init];
    _selectedMyAccoIndexArray = [[NSMutableArray alloc]init];
    autocompleteList=[[NSMutableArray alloc]init];
    searchKey = [[NSString alloc]init];
    str= [[NSMutableString alloc]init];
    _localityArray = [[NSMutableArray alloc]init];
    autoCompleteTableView.hidden=YES;
     autoCompleteTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _findMyroomyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Do any additional setup after loading the view.
   userDetail = [[UserDetail alloc]init];
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
        userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        requestFor = [[NSString alloc]init];
        aboutMe = [[NSMutableString alloc]init];
    }
}

-(void)DeletedIndex:(NSIndexPath *)index
{
    [_localityArray removeObjectAtIndex:index.item];
}


#pragma mark - UITableView Delegate & Datasource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView.tag==100)
    {
        return 1;
    }
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag==100) {
        return autocompleteList.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.tag==100) {
        return 0;
    }
    return 50;
    
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.tag==100) {
        return NULL;
    }
    else
    {
        
        UIView *viewForHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 100)];
        viewForHeader.backgroundColor = [UIColor colorWithRed:231/255.0 green:232/255.0 blue:225/255.0 alpha:1.0f];
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 230, 40)];
        titleLabel.font=[UIFont fontWithName:@"CircularStd-Bold" size:17];
        titleLabel.textColor = [UIColor lightGrayColor
                                ];
        
        NSString *titleForHeader = @"";
        if (section == 0) {
            titleForHeader = @"Preferred Location";
        }
        else if (section==1) {
            titleForHeader = @"Preferred Food Habits";
        }
        else if (section==2)
        {
            titleForHeader=@"Preferred Smoking Habits";
        }
        else if (section==3)
        {
            titleForHeader=@"Share my acco";
        }
        else if (section==4)
        {
            titleForHeader=@"Tell us about yourself";
        }
        titleLabel.text = titleForHeader;
        
        
        [viewForHeader addSubview:titleLabel];
        
        return viewForHeader;
    }}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==100) {
        return 25;
    }
    else
    {
    if (indexPath.section==1) {
        return 100;
    }
    else if (indexPath.section==2){
        return 100;
    }
    else if (indexPath.section==3){
        return 150;
    }
    else if (indexPath.section==0)
    {
        return 75;
    }
          return 300;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier1 = @"findRoomyLocationTableViewCell";
     static NSString *MyIdentifier2 = @"find_RoomyTableViewCell";
    static NSString *MyIdentifier3 = @"findRoomyTextFieldTableViewCell";
      UITableViewCell *cell = nil;
    if (tableView.tag==100) {
        
        NSString *CellIdentifier = @"CellIdentifier";
        UITableViewCell *autoCompleteCell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (autoCompleteCell==nil) {
            autoCompleteCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier]
            ;    }
        autoCompleteCell.textLabel.font = [UIFont fontWithName:@"CircularStd-Book" size:15.0f];
        autoCompleteCell.textLabel.text=autocompleteList[indexPath.row];
        autoCompleteCell.textLabel.textColor = [UIColor blackColor];
        
        cell = autoCompleteCell;
        

    }
    else{
    if (indexPath.section==0) {
         FindRoomyLocationTableViewCell *locationCell = (FindRoomyLocationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier1];
          locationCell.locationTextBox.backgroundColor=[UIColor whiteColor];
        locationCell.locationTextBox.delegate=self;
        searchKey=locationCell.locationTextBox.text;
        [locationCell.localityCityName removeAllObjects];
        [locationCell.localityCityName addObjectsFromArray:_localityArray];
      
        
        [locationCell.selectedLocationCollectionView reloadData];
        locationCell.locationTextBox.text = @"";

        locationCell.delegate=self;
        cell=locationCell;
    }
   else if (indexPath.section==4){
       FindRoomyTextFieldTableViewCell *locationCell = (FindRoomyTextFieldTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier3];
       locationCell.aboutMeTextField.delegate=self;
      // aboutMe=locationCell.aboutMeTextField.text;
      
       cell=locationCell;
   }
    else
    {
    Find_RoomyTableViewCell *Cell = (Find_RoomyTableViewCell*)[tableView dequeueReusableCellWithIdentifier:MyIdentifier2];
    if (indexPath.section==1) {
        [Cell setUp:foodHabit withSelectedIndexes:_selectedFoodHabitIndexArray];
    }
    else if (indexPath.section==2){
        [Cell setUp:smokingHabit withSelectedIndexes:_selectedSmokngHabitIndexArray];
    }
    else if (indexPath.section==3){
        Cell.Selectedsection = @"yes";
           [Cell setUp:myAcco withSelectedIndexes:_selectedMyAccoIndexArray];
    }
        Cell.delegate=self;
    Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell= Cell;
    }
    
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    

    if (tableView.tag==100)
    {
        [_localityArray addObject:autocompleteList[indexPath.row]];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [_findMyroomyTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
      
        str = [[NSMutableString alloc]init];
        autoCompleteTableView.hidden=YES;
    }
  else
  {
      NSLog(@"hello");
  }
}


-(void)selectedIndexesArray:(NSIndexPath *)selectedIndex withSelectedCell:(id)findRoomyTableCell{
    Find_RoomyTableViewCell *filterCell = (Find_RoomyTableViewCell*)findRoomyTableCell;
    NSIndexPath *indexPath = [_findMyroomyTableView indexPathForCell:filterCell];
    if (indexPath.section == 1) {
        BOOL isPresent =  NO;
        for (int i= 0; i< _selectedFoodHabitIndexArray.count; i++) {
            NSIndexPath *tempIndex = _selectedFoodHabitIndexArray[i];
            if(tempIndex.item == selectedIndex.item && tempIndex.section == selectedIndex.section) {
                isPresent = YES;
                [_allAppliedFilters removeAllObjects];
                //[_allAppliedFilters addObject:foodHabit[selectedIndex.item]];
                [_selectedFoodHabitIndexArray removeAllObjects];
               // [_selectedFoodHabitIndexArray addObject:selectedIndex];
                break;
            }
        }
        if (!isPresent) {
            [_selectedFoodHabitIndexArray removeAllObjects];
            [_allAppliedFilters addObject:foodHabit[selectedIndex.item]];
            [_selectedFoodHabitIndexArray addObject:selectedIndex];
        }

        
    }
   else if (indexPath.section == 2) {
       BOOL isPresent =  NO;
       for (int i= 0; i< _selectedSmokngHabitIndexArray.count; i++) {
           NSIndexPath *tempIndex = _selectedSmokngHabitIndexArray[i];
           if(tempIndex.item == selectedIndex.item && tempIndex.section == selectedIndex.section) {
               isPresent = YES;
               [_allAppliedFilters removeAllObjects];
               //[_allAppliedFilters addObject:smokingHabit[selectedIndex.item]];
               [_selectedSmokngHabitIndexArray removeAllObjects];
               //[_selectedSmokngHabitIndexArray addObject:selectedIndex];
               break;
           }
       }
       if (!isPresent) {
           [_selectedSmokngHabitIndexArray removeAllObjects];
           [_allAppliedFilters addObject:smokingHabit[selectedIndex.item]];
           [_selectedSmokngHabitIndexArray addObject:selectedIndex];
       }
    }
   else if (indexPath.section == 3) {
       
//       if ([_selectedMyAccoIndexArray containsObject:myAcco[selectedIndex.item]]) {
//           [_selectedMyAccoIndexArray removeObjectAtIndex:selectedIndex.item];
//       }
//       else{
//           [_selectedMyAccoIndexArray addObject:myAcco[selectedIndex.item]];
//       }
       BOOL isPresent = NO;
       
       for (int i= 0; i< _selectedMyAccoIndexArray.count; i++) {
           NSIndexPath *tempIndex = _selectedMyAccoIndexArray[i];
           if(tempIndex.item == selectedIndex.item && tempIndex.section == selectedIndex.section) {
               isPresent = YES;
               [_allAppliedFilters removeObject:myAcco[selectedIndex.item]];
               [_selectedMyAccoIndexArray removeObjectAtIndex:i];
               break;
           }
       }
       if (!isPresent) {
           [_allAppliedFilters addObject:myAcco[selectedIndex.item]];
           [_selectedMyAccoIndexArray addObject:selectedIndex];
       }

       
       
       
       
       
//       BOOL isPresent = NO;
//       
//       for (int i= 0; i< _selectedMyAccoIndexArray.count; i++) {
//           //NSIndexPath *tempIndex = _selectedMyAccoIndexArray[i];
//            if ([_selectedMyAccoIndexArray containsObject:myAcco[selectedIndex.item]]) {
//               isPresent = YES;
//                [_selectedMyAccoIndexArray removeObject:myAcco[selectedIndex.item]];
//               [_selectedMyAccoIndexArray removeObjectAtIndex:i];
//               break;
//           }
//       }
//       if (!isPresent) {
//           [_selectedMyAccoIndexArray addObject:myAcco[selectedIndex.item]];
//           //[_selectedMyAccoIndexArray addObject:selectedIndex];
//       }
    }
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (self.lastContentOffset > scrollView.contentOffset.y)
//    {
//        NSLog(@"Scrolling Up");
//    }
     if (self.lastContentOffset < scrollView.contentOffset.y)
    {
        autoCompleteTableView.hidden=YES;
       // [self.delegate selected];
        NSLog(@"Scrolling Down");
    }
    
    self.lastContentOffset = scrollView.contentOffset.y;
}



#pragma mark UITextView Delegate method

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    if (text.length==0) {
        if ([aboutMe length] > 0)
        {
            [aboutMe deleteCharactersInRange:NSMakeRange([aboutMe length]-1, 1)];}
    }
    
  
    [aboutMe appendString:[NSString stringWithFormat:@"%@",text]];
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        
       
        return FALSE;
    }
   
    return TRUE;
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}


#pragma mark UITextField Delegate method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
      textField.backgroundColor=[UIColor whiteColor];
    NSLog(@"textFieldShouldBeginEditing");
    UITextPosition *beginning = [textField beginningOfDocument];
    [textField setSelectedTextRange:[textField textRangeFromPosition:beginning
                                                          toPosition:beginning]];      return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldDidBeginEditing");
 }
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if (textField.tag==100) {
        textField.backgroundColor=[UIColor whiteColor];
        if (string.length==0) {
            if ([str length] > 0)
            {
                [str deleteCharactersInRange:NSMakeRange([str length]-1, 1)];}
        }
        
        searchKey = string;
        [str appendString:[NSString stringWithFormat:@"%@",string]];
        if (str.length==0) {
            autoCompleteTableView.hidden=YES;
        }
        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"preferenceName"];
        if (savedValue.length==0) {
            savedValue=@"New Delhi";
        }
        NSLog(@"%@",savedValue);
        
//        NSString *savedValue = [[NSUserDefaults standardUserDefaults]
//                                stringForKey:@"preferenceName"];
     //  NSString *state = @"New Delhi";
        NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,autosuggest_URL];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"searchkey\":\"%@\",\"state_name\":\"%@\"}", str,savedValue];
        requestFor = autosuggest_URL;
        NSLog(@"%@",jsonRequest);
        URLConnection *connection=[[URLConnection alloc] init];
        connection.delegate=self;
        [connection getDataFromUrl:jsonRequest webService:urlString];    }
   
    return YES;
  }
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    NSLog(@"textFieldShouldClear:");
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    NSLog(@"textFieldShouldReturn:");
   
        [textField resignFirstResponder];
    
    return YES;
}

- (IBAction)backToPreviousView:(id)sender {
    
    ViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self .navigationController pushViewController:obj animated:NO];

}
- (IBAction)findButtonAction:(id)sender {
    
    NSString *preferredFood;
    NSString *preferredHabit;
    NSString *shareMyAcco;
    NSMutableArray *acco = [[NSMutableArray alloc]init];
    NSString *location = [_localityArray componentsJoinedByString:@","];
    if (location == nil) {
        location = @"";
    }
    for (int i=0; i<_selectedFoodHabitIndexArray.count; i++) {
        NSIndexPath *indexPtah = _selectedFoodHabitIndexArray [i];
        preferredFood = foodHabit[indexPtah.item];
       }
    if (preferredFood == nil) {
        preferredFood = @"";
    }
    
    
    for (int i=0; i<_selectedSmokngHabitIndexArray.count; i++) {

    NSIndexPath *indexPtah1 = _selectedSmokngHabitIndexArray[i];
    preferredHabit = smokingHabit[indexPtah1.item];
        }
    if (preferredHabit == nil) {
        preferredHabit = @"";
    }

    
     for (int i=0; i<_selectedMyAccoIndexArray.count; i++)
     {
         NSIndexPath *indexpath2 = _selectedMyAccoIndexArray[i];
         [acco addObject:myAcco[indexpath2.item]];
        // acco = myAcco[indexpath2.item];
        shareMyAcco =[acco componentsJoinedByString:@","];
     }
   // NSString *shareMyAcco = [_selectedMyAccoIndexArray componentsJoinedByString:@","];
    if (shareMyAcco == nil) {
        shareMyAcco = @"";
    }
    
        NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Find_My_Roomy_URL];
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"userId\":\"%@\",\"food_habits\":\"%@\",\"smoking_habits\":\"%@\",\"share_my_acco\":\"%@\",\"preferred_location_hidden\":\"%@\",\"tell_us_about_yourself\":\"%@\"}",userDetail.userid,preferredFood,preferredHabit,shareMyAcco,location,aboutMe];
    requestFor = Find_My_Roomy_URL;

    NSLog(@"%@",jsonRequest);
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
   
    if ([json[@"code"] integerValue] == 200) {
        if ([requestFor isEqualToString:autosuggest_URL]){
            NSLog(@"%@",json);

    autocompleteList=json[@"localityList"];
    autoCompleteTableView.hidden=NO;
    if (autocompleteList.count==0) {
        autoCompleteTableView.hidden=YES;
    }
    autoCompleteTableView.delegate=self;
    autoCompleteTableView.dataSource=self;
    [autoCompleteTableView reloadData];
        }
        else{
                Find_MyroomyList *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"find_MyroomyList"];
                            NSLog(@"%@",json);
//            NSMutableArray *property_listArray = [json valueForKey:@"property_list"];
            obj.roomyPropertyListArray = [json valueForKey:@"property_list"];
            NSLog(@"%lu",(unsigned long)obj.roomyPropertyListArray.count);
            [self.navigationController pushViewController:obj animated:YES];

            
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
