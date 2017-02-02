//
//  PropertyDetailsViewController.m
//  mobApp
//
//  Created by MAG on 15/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "FullPropertyDetailsViewController.h"
#import "Property_DescriptionTableViewCell.h"
#import "Property_AmenitiesTableViewCell.h"
#import "Property_AttributesTableViewCell.h"
#import "HouseRulesTableViewCell.h"
#import "FilterViewController.h"
#import "ContactLandlordViewController.h"
#import "AppConstants.h"
#import "URLConnection.h"
#import "AmenitiesDetail.h"
#import "RoomDetail.h"
#import "HouseRuleDetail.h"
#import "Property_RoomDetailTableViewCell.h"
#import "MealsTableViewCell.h"
#import "PropertyDetail_MapTableViewCell.h"
#import "TitleTableViewCell.h"
#import "CalloutMapAnnotation.h"
#import "PropertyImageTableViewCell.h"
#import "ContactInfoViewController.h"
#import "UserDetail.h"
#import "PropertyDetailAdaptor.h"
#import "WishListDetail.h"
#import "ScheduleToVisitViewController.h"
#import "LoginAccountViewController.h"
#import "ScheduleToVisitWithoutLoginViewController.h"
#import "BookNowViewController.h"
#import "BookBrandedPropertyViewController.h"
@interface FullPropertyDetailsViewController ()
{
    NSMutableArray *roomDetailArray;
    NSMutableArray *amenitiesArray;
    NSMutableArray *houseRuleArray;
    NSMutableArray *propertyImageArray;
    NSMutableArray *filteredPropertyList;
    UserDetail *userDetail;
    NSString *requestFor;
    BOOL selected;
}

@end

@implementation FullPropertyDetailsViewController
@synthesize propertyDetailTableView,propertyName,wishListArray;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.wishListArray = [[NSMutableArray alloc] init];
    [propertyDetailTableView registerNib:[UINib nibWithNibName:@"Property_RoomDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"Property_RoomDetailTableViewCellId"];
    [propertyDetailTableView registerNib:[UINib nibWithNibName:@"Property_AmenitiesTableViewCell" bundle:nil] forCellReuseIdentifier:@"Property_AmenitiesTableViewCellID"];
    [propertyDetailTableView registerNib:[UINib nibWithNibName:@"Property_AttributesTableViewCell" bundle:nil] forCellReuseIdentifier:@"Property_AttributesTableViewCellID"];
    [propertyDetailTableView registerNib:[UINib nibWithNibName:@"HouseRulesTableViewCell" bundle:nil] forCellReuseIdentifier:@"HouseRulesTableViewCellId"];
    [propertyDetailTableView registerNib:[UINib nibWithNibName:@"MealsTableViewCell" bundle:nil] forCellReuseIdentifier:@"MealsTableViewCellId"];
    [propertyDetailTableView registerNib:[UINib nibWithNibName:@"PropertyDetail_MapTableViewCell" bundle:nil] forCellReuseIdentifier:@"PropertyDetail_MapTableViewCellId"];
     [propertyDetailTableView registerNib:[UINib nibWithNibName:@"TitleTableViewCell" bundle:nil] forCellReuseIdentifier:@"TitleTableViewCellId"];
   [propertyDetailTableView registerNib:[UINib nibWithNibName:@"PropertyImageTableViewCell" bundle:nil] forCellReuseIdentifier:@"propertyImageTableViewCell"];
  
    propertyDetailTableView.userInteractionEnabled = true;
   
    _wishButton.selected=NO;
    propertyName.text=_propertyDetail.property_name;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"PropertyDetail"]) {
        NSData *wishListData = [[NSUserDefaults standardUserDefaults] dataForKey:@"PropertyDetail"];
        wishListArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:wishListData];}
    
    for (int i=0; i<wishListArray.count; i++) {
        WishListDetail *wishList = wishListArray[i];
    if ([_propertyDetail.propertyid isEqualToString:wishList.propertyid]) {
        _wishButton.selected = YES;
        
        
    }}
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        if ([_propertyDetail.shortlist_property_id isEqualToString:_propertyDetail.propertyid]) {
            _wishButton.selected = YES;
        }}

//    if (selected) {
//        _wishButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wishlist-mouseover"]];
//    }
    roomDetailArray = [[NSMutableArray alloc]init];
    amenitiesArray = [[NSMutableArray alloc]init];
    houseRuleArray = [[NSMutableArray alloc]init];
    propertyImageArray = [[NSMutableArray alloc]init];
    _imageGalleryScrollView.minimumZoomScale = 0.5;
    _imageGalleryScrollView.maximumZoomScale = 6.0;
//    _imageGalleryView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"back.jpg"]];
//
    _imageGalleryView.hidden =YES;
    
     filteredPropertyList = [[NSMutableArray alloc]init];
    [self fetchFullPropertyDetail];
    
}
- (void)showImageGalleryView {
    
//    UITapGestureRecognizer *tapOnce = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnce:)];
//    UITapGestureRecognizer *tapTwice = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTwice:)];
//    
//    // set number of taps required
//    tapOnce.numberOfTapsRequired = 1;
//    tapTwice.numberOfTapsRequired = 2;
//    
//    // stops tapOnce from overriding tapTwice
//    [tapOnce requireGestureRecognizerToFail:tapTwice];
//    
[(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    _imageGalleryScrollView.contentSize = CGSizeMake(_imageGalleryScrollView.frame.size.width * propertyImageArray.count, 180);
    
    
    int initialX = 0;
    for (int index = 0; index < propertyImageArray.count; index++)
    {
        
        _imageGalleryScrollView.pagingEnabled = YES;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[propertyImageArray objectAtIndex:index]]];
        
        UIImageView *propertyImg=[[UIImageView alloc]init];
        propertyImg.backgroundColor = [UIColor clearColor];
        propertyImg.userInteractionEnabled = YES;
        propertyImg.contentMode=UIViewContentModeScaleAspectFit;
        UIActivityIndicatorView *actvity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(initialX + _imageGalleryScrollView.bounds.size.width/2 - 40, _imageGalleryScrollView.bounds.size.height/2 - 40, 80, 80)];
        [propertyImg addSubview:actvity];
        actvity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [actvity startAnimating];
        //[propertyImg addGestureRecognizer:tapOnce];
        //[propertyImg addGestureRecognizer:tapTwice];
        
        propertyImg.frame=CGRectMake(initialX, 0, _imageGalleryScrollView.frame.size.width, _imageGalleryScrollView.frame.size.height);
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                         propertyImg.contentMode=UIViewContentModeScaleAspectFit;
                        propertyImg.image = image;
                        actvity.hidden = YES;
                        
                    });
                }
            }
        }];
        [task resume];
         [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
        initialX  = initialX + _imageGalleryScrollView.frame.size.width;
        [_imageGalleryScrollView addSubview:propertyImg];
                UISwipeGestureRecognizer *ges =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
        ges.direction = UISwipeGestureRecognizerDirectionDown;
        [_imageGalleryView addGestureRecognizer:ges];
        _imageGalleryView.hidden = NO;
    }
}
- (void)tapOnce:(UIGestureRecognizer *)gesture
{
  gesture.view.contentMode=UIViewContentModeScaleAspectFit;
}
- (void)tapTwice:(UIGestureRecognizer *)gesture
{
    gesture.view.contentMode=UIViewContentModeCenter;
   gesture.view.superview.contentMode=UIViewContentModeCenter;
    
}
//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    return _imageGalleryScrollView;
//}

- (void)fetchFullPropertyDetail {
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
    
    NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Property_Detail_URL];
    requestFor = Property_Detail_URL;
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"property_id\":\"%@\"}",_propertyDetail.propertyid];
    NSLog(@"%@",jsonRequest);
    URLConnection *connection=[[URLConnection alloc] init];
    connection.delegate=self;
    [connection getDataFromUrl:jsonRequest webService:urlString];
    
}

- (IBAction)moveToPreviousView:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)hideImageGallery:(id)sender {
    
    _imageGalleryView.hidden=YES;
}



#pragma mark - UITableView Delegate & Datasource
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *viewForHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
//    UILabel *headerLabel = [[UILabel alloc] initWithFrame: CGRectMake(30, 5, 150, 20)];
//    UIFont *labFont = [UIFont fontWithName: @"CircularStd-Book" size: 15.0];
//    [headerLabel setFont: labFont];
//    headerLabel.text=@"ROOM DETAILS";
//    headerLabel.textColor=[UIColor lightGrayColor];
//    [viewForHeader addSubview:headerLabel];
//    return viewForHeader;
//}

//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat height=0.0f;
//    if (section==0) {
//        height=20.0f;
//        return height;
//    }
//    return height;
//}




-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else if (section==1) {
        return [roomDetailArray count]+1;
    }
    else{
        return 4;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 191.0f;
    if (indexPath.section==2)
    {
        if (indexPath.row==0) {
            CGFloat rowCount = ceil(amenitiesArray.count/2.0);
            height=50 + rowCount * 40;
        }
        else if (indexPath.row==1) {
            height=114.0f;
        }
        else if (indexPath.row==2) {
            height=87.0f;
        }
    }
    else if (indexPath.section==1)
    {
        if (indexPath.row==0) {
            height=60.0f;
        }
        else {
            RoomDetail *roomDetail = roomDetailArray[indexPath.row-1];
            NSArray *temp = [roomDetail.facility_available_for componentsSeparatedByString:@","];
            CGFloat rowCount = ceil(temp.count/3.0);
            if (rowCount==1 ) {
                rowCount=2;
                height=50 + rowCount * 40;
            }
            else if (rowCount==2)
            {
                height=60 + rowCount * 40;
            }
            else if (rowCount==0)
            {
                height=100;
            }
            
             //height=50 + rowCount * 40;
        }
    }
    else {
        height=191.0f;
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"TitleTableViewCellId";

    static NSString *cellIdentifier1 = @"Property_RoomDetailTableViewCellId";
    static NSString *cellIdentifier2 = @"Property_AmenitiesTableViewCellID";
    static NSString *cellIdentifier3 = @"HouseRulesTableViewCellId";
    static NSString *cellIdentifier4 = @"MealsTableViewCellId";
    static NSString *cellIdentifier5= @"PropertyDetail_MapTableViewCellId";
    static NSString *cellIdentifier6= @"propertyImageTableViewCell";
    UITableViewCell *reusableCell;
  
    if (indexPath.section==0)
    {
       
    
        PropertyImageTableViewCell *cell= (PropertyImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier6 forIndexPath:indexPath];
        cell.imageScrollView.pagingEnabled = YES;
        
        cell.imageScrollView.contentSize = CGSizeMake(cell.imageScrollView.frame.size.width * propertyImageArray.count, cell.imageScrollView.frame.size.height);
        
        
        int initialX = 0;
        for (int index = 0; index < propertyImageArray.count; index++)
        {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",[propertyImageArray objectAtIndex:index]]];
            
            UIImageView *propertyImg=[[UIImageView alloc]init];
            propertyImg.backgroundColor = [UIColor clearColor];
            
            UIActivityIndicatorView *actvity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(initialX + cell.imageScrollView.bounds.size.width/2 - 40, cell.imageScrollView.bounds.size.height/2 - 40, 80, 80)];
            
            actvity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            [actvity startAnimating];
            
            
            propertyImg.frame=CGRectMake(initialX, 0, cell.imageScrollView.frame.size.width, cell.imageScrollView.frame.size.height);
            
            NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data) {
                    UIImage *image = [UIImage imageWithData:data];
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            propertyImg.image = image;
                            actvity.hidden = YES;
                        });
                    }
                }
            }];
            [task resume];
            
            initialX  = initialX + cell.imageScrollView.frame.size.width;
           
 //...........Visit Now Button.............................//
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [btn setTitle:@"Visit Now" forState:UIControlStateNormal];
            [btn.titleLabel setFont:[UIFont systemFontOfSize:16]];
           
            btn.backgroundColor= [UIColor colorWithRed:0/255.0 green:173/255.0 blue:77/255.0 alpha:1.0f];;
           
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
          btn.titleLabel.font = [UIFont fontWithName:@"CircularStd-Bold" size:16];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat X = (cell.frame.size.width) - 90;
            CGFloat Y = (cell.frame.size.height) - 40;

            btn.frame = CGRectMake(X,Y, 90, 40);
     //.........................................................//
            
  //......................Book Now Button......................//
            
            
            UIButton *bookNow = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [bookNow setTitle:@"Book Now" forState:UIControlStateNormal];
            [bookNow.titleLabel setFont:[UIFont systemFontOfSize:16]];
            
            bookNow.backgroundColor= [UIColor colorWithRed:226/255.0 green:64/255.0 blue:70/255.0 alpha:1.0f];;
            
            [bookNow setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            bookNow.titleLabel.font = [UIFont fontWithName:@"CircularStd-Bold" size:16];
            bookNow.titleLabel.textAlignment = NSTextAlignmentCenter;
            CGFloat x = 0;
            CGFloat y = (cell.frame.size.height) - 40;
            
            bookNow.frame = CGRectMake(x,y, 90, 40);
            
//            [btn addTarget:self action:@selector(onClickHotSpotButton)   forControlEvents:UIControlEventTouchUpInside]; //it wasnt working
            
            
            [cell addSubview:bookNow];
            [cell addSubview:btn];
            [cell.imageScrollView addSubview:actvity];
            [cell.imageScrollView addSubview:propertyImg];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showGalleryView)];
            UITapGestureRecognizer *visit = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(scheduleVisit)];
            // prevents the scroll view from swallowing up the touch event of child buttons
            UITapGestureRecognizer *book = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bookNowAction)];
            [bookNow addGestureRecognizer:book];
            [btn addGestureRecognizer:visit];
            tapGesture.cancelsTouchesInView = NO;
            
            [cell.imageScrollView addGestureRecognizer:tapGesture];
            
//           // [cell.scheduleButton addTarget:self
//                                    action:@selector(scheduleButtonAction:)
//                          forControlEvents:UIControlEventTouchUpInside];
      
            
    }
        
        
        reusableCell = cell;
        
    }
    
    else if (indexPath.section==1) {
        if (indexPath.row==0) {
            TitleTableViewCell *cell= (TitleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//            NSString *code=_propertyDetail.property_code;
//            NSString *newStr = [code substringFromIndex:2];
           
            NSString *id= [NSString stringWithFormat:@"ACCO%@",_propertyDetail.propertyid];
            cell.accoIdLabel.text=id;
            NSMutableString *propertyAddress = [NSMutableString string];
            if (_propertyDetail.address_locality.length > 0) {
                [propertyAddress appendString:[NSString stringWithFormat:@"%@,",_propertyDetail.address_locality]];
            }
            if (_propertyDetail.address_street.length > 0) {
                [propertyAddress appendString:[NSString stringWithFormat:@" %@,",_propertyDetail.address_street]];
            }
            if (_propertyDetail.address_city.length > 0) {
                [propertyAddress appendString:[NSString stringWithFormat:@" %@,",_propertyDetail.address_city]];
            }
            if (_propertyDetail.address_state.length > 0) {
                [propertyAddress appendString:[NSString stringWithFormat:@" %@,",_propertyDetail.address_state]];
            }
            if (_propertyDetail.address_country.length > 0) {
                [propertyAddress appendString:[NSString stringWithFormat:@" %@",_propertyDetail.address_country]];
            }
            cell.addressLabel.text = propertyAddress;
           // [cell.scheduleButton addTarget:self
//                                      action:@selector(scheduleButtonAction:)
//                            forControlEvents:UIControlEventTouchUpInside];
            

            reusableCell = cell;
                    }
        else{
            Property_RoomDetailTableViewCell *cell = (Property_RoomDetailTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier1 forIndexPath:indexPath];
            RoomDetail *roomDetail = roomDetailArray[indexPath.row-1];
            if ([roomDetail.facility_typeid isEqualToString:@"1"]) {
                cell.occupancyTypeLabel.text=@"Single Occupancy/One Occupant";
            }
            else if ([roomDetail.facility_typeid isEqualToString:@"2"]) {
                cell.occupancyTypeLabel.text=@"Double Occupancy/Two Occupants";
            }
            else if ([roomDetail.facility_typeid isEqualToString:@"3"]) {
                cell.occupancyTypeLabel.text=@"Triple Occupancy/Three Occupants";
            }
            else if ([roomDetail.facility_typeid isEqualToString:@"4"]) {
                cell.occupancyTypeLabel.text=@"Dorm Occupancy/Dorm Occupants";
            }

            cell.rentLabel.text=roomDetail.rent;
            cell.depositLabel.text=roomDetail.security;
            
          
            [cell setUpRoomDetailsWithData: [roomDetail.facility_available_for componentsSeparatedByString:@","]];
            
            reusableCell = cell;
        }
    }
    
    else if (indexPath.section==2)
    {
        if (indexPath.row==0)
        {
            Property_AmenitiesTableViewCell *cell= (Property_AmenitiesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier2 forIndexPath:indexPath];
            [cell setUpAmenitiesDetailsWithData:amenitiesArray];
            reusableCell = cell;
        }
        else if (indexPath.row==1)
        {
            HouseRulesTableViewCell *cell= (HouseRulesTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier3 forIndexPath:indexPath];
            
            for (int i = 0; i < houseRuleArray.count; i++) {
                HouseRuleDetail *ruleDetail = houseRuleArray[i];
                switch ([ruleDetail.houseruleid integerValue]) {
                    case 1:
                        cell.smokingImageView.image = [UIImage imageNamed:@"check"];
                        break;
                    case 2:
                        cell.nonVegImageView.image = [UIImage imageNamed:@"check"];
                        break;
                    case 3:
                        cell.alcoholImageView.image = [UIImage imageNamed:@"check"];
                        break;
                    case 4:
                        cell.girlAllowedImageView.image = [UIImage imageNamed:@"check"];
                        break;
                    case 5:
                        cell.boysAllowedImageView.image = [UIImage imageNamed:@"check"];
                        break;
                    case 7:
                        cell.admissionImageView.image = [UIImage imageNamed:@"check"];
                        break;
                    default:
                        break;
                }
            }
            
            reusableCell = cell;
        }
        
        else if (indexPath.row==2)
        {
            MealsTableViewCell *cell= (MealsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier4 forIndexPath:indexPath];
            
            // Color type
            UIColor *lightColor = [UIColor lightGrayColor];
            UIColor *darkColor = [UIColor blackColor];
            
            cell.breakfastLabel.textColor = [_propertyDetail.breakfast isEqualToString:@"1"] ? darkColor: lightColor;
            cell.lunchLabel.textColor = [_propertyDetail.lunch isEqualToString:@"1"] ? darkColor: lightColor;
            cell.dinnerLabel.textColor = [_propertyDetail.dinner isEqualToString:@"1"] ? darkColor: lightColor;
            
            cell.breakfastImageView.image = [_propertyDetail.breakfast isEqualToString:@"1"] ? [UIImage imageNamed:@"check"] : [UIImage imageNamed:@"red_cross"];
            cell.lunchImageView.image = [_propertyDetail.lunch isEqualToString:@"1"] ? [UIImage imageNamed:@"check"] : [UIImage imageNamed:@"red_cross"];
            cell.dinnerImageView.image = [_propertyDetail.dinner isEqualToString:@"1"] ? [UIImage imageNamed:@"check"] : [UIImage imageNamed:@"red_cross"];
            
            cell.breakfastAmountLabel.hidden = [_propertyDetail.breakfast isEqualToString:@"1"] ? false: true;
            cell.lunchAmountLabel.hidden = [_propertyDetail.lunch isEqualToString:@"1"] ? false: true;
            cell.dinnerAmountLabel.hidden = [_propertyDetail.dinner isEqualToString:@"1"] ? false: true;
            
            cell.breakfastAmountLabel.text = [_propertyDetail.breakfast_amount isEqualToString:@""] ? @"(Included)": [NSString stringWithFormat:@"(₹%@)",_propertyDetail.breakfast_amount];
           

            cell.lunchAmountLabel.text = [_propertyDetail.lunch_amount isEqualToString:@""] ? @"(Included)": [NSString stringWithFormat:@"(₹%@)",_propertyDetail.lunch_amount];
            cell.dinnerAmountLabel.text = [_propertyDetail.dinner_amount isEqualToString:@""] ? @"(Included)": [NSString stringWithFormat:@"(₹%@)",_propertyDetail.dinner_amount];
            
            reusableCell = cell;
        }
        else {
            
            PropertyDetail_MapTableViewCell *cell=(PropertyDetail_MapTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier5 forIndexPath:indexPath];
            NSString *img;
            CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_propertyDetail.gps_lattitude floatValue], [_propertyDetail.gps_longitude floatValue]);
            if ([_propertyDetail.mark_as_branded isEqualToString:@"1"]) {
                img=@"map-view-branded";
            }
            else{
                img=@"map-pin";
            }
            cell.imgName=img;
            [cell loadMapData:coordinate];
            reusableCell = cell;
        }
    }
    return reusableCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
       [self showImageGalleryView];
    }
    
}
-(void)showGalleryView
{
    [self showImageGalleryView];

}


-(void)scheduleVisit
{

    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
    ScheduleToVisitViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"scheduleToVisitViewController"];
    obj.propertyID=_propertyDetail.propertyid;

    [self.navigationController pushViewController:obj animated:YES];
    }
     else
     {
         ScheduleToVisitWithoutLoginViewController *object = [self.storyboard instantiateViewControllerWithIdentifier:@"scheduleToVisitWithoutLoginViewController"];
         object.propertyID=_propertyDetail.propertyid;

         [self.navigationController pushViewController:object animated:YES];
     }
}


-(void)bookNowAction
{
//    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        if ([_propertyDetail.mark_as_branded isEqualToString:@"1"] ) {
            BookBrandedPropertyViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"bookBrandedPropertyViewController"];
            obj.propertyId = _propertyDetail.propertyid;
            NSMutableString *propertyAddress = [NSMutableString string];
            if (_propertyDetail.address_locality.length > 0) {
                [propertyAddress appendString:[NSString stringWithFormat:@"%@,",_propertyDetail.address_locality]];
            }
            if (_propertyDetail.address_street.length > 0) {
                [propertyAddress appendString:[NSString stringWithFormat:@" %@,",_propertyDetail.address_street]];
            }
            if (_propertyDetail.address_city.length > 0) {
                [propertyAddress appendString:[NSString stringWithFormat:@" %@,",_propertyDetail.address_city]];
            }
            if (_propertyDetail.address_state.length > 0) {
                [propertyAddress appendString:[NSString stringWithFormat:@" %@,",_propertyDetail.address_state]];
            }
            if (_propertyDetail.address_country.length > 0) {
                [propertyAddress appendString:[NSString stringWithFormat:@" %@",_propertyDetail.address_country]];
            }

            obj.propertyName = propertyAddress;
            [self.navigationController pushViewController:obj animated:YES];
            }
        else{
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
            NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
            
            userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
            NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,book_now_with_login_URL];

            NSString *jsonRequest = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"propertyid\":\"%@\"}",userDetail.userid,_propertyDetail.propertyid];
            NSLog(@"%@",jsonRequest);
            requestFor=book_now_with_login_URL;
            URLConnection *connection=[[URLConnection alloc] init];
            connection.delegate=self;
            [connection getDataFromUrl:jsonRequest webService:urlString];

//            
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Thank You! Your request has been successfully submitted" preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//                    }];
//                    [alertController addAction:cancelAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
        }

//            BookBrandedPropertyViewController *obj = [self.storyboard instantiateViewControllerWithIdentifier:@"bookBrandedPropertyViewController"];
//            obj.p_id = _propertyDetail.propertyid;
//            [self.navigationController pushViewController:obj animated:YES];
            
           
            else
            {
                BookNowViewController *object = [self.storyboard instantiateViewControllerWithIdentifier:@"bookNowViewController"];
                object.propertyID=_propertyDetail.propertyid;
                object.isBranded=_propertyDetail.mark_as_branded;
                [self.navigationController pushViewController:object animated:YES];
            }}
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Thank You! Your request has been successfully submitted" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//        }
//}
//    else{
//        BookNowViewController *object = [self.storyboard instantiateViewControllerWithIdentifier:@"bookNowViewController"];
//        object.propertyID=_propertyDetail.propertyid;
//        object.isBranded=_propertyDetail.mark_as_branded;
//        [self.navigationController pushViewController:object animated:YES];
//    }
}

//-(void)hideView

//{
//    [UIView transitionWithView:_imageGalleryView
//                      duration:0.4
//                       options:UIViewAnimationOptionTransitionCrossDissolve
//                    animations:^{
//                        _imageGalleryView.hidden = YES;
//                    }
//                    completion:NULL];
//}
-(void)swipe:(UISwipeGestureRecognizer *)swipeGes{
    if(swipeGes.direction == UISwipeGestureRecognizerDirectionUp){
        [UIView animateWithDuration:.5 animations:^{
         _imageGalleryView.hidden = YES;
        } completion:NULL];
    }
    else if (swipeGes.direction == UISwipeGestureRecognizerDirectionDown){
        [UIView animateWithDuration:.5 animations:^{
         _imageGalleryView.hidden = YES;
        } completion:NULL];
    }
}

- (IBAction)addToWishList:(id)sender {
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
        
        userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        if ([_propertyDetail.shortlist_property_id isEqualToString:@""]) {
            _propertyDetail.shortlist_property_id = _propertyDetail.propertyid;
            _wishButton.backgroundColor=[UIColor colorWithPatternImage:
                                         [UIImage imageNamed:@"wishlist-border"]];
            selected=NO;
        }
        else {
            _propertyDetail.shortlist_property_id = @"";
            _wishButton.backgroundColor=[UIColor colorWithPatternImage:
                                         [UIImage imageNamed:@"wishlist-mouseover"]];
            selected=YES;
            
        }
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
        
        NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Add_To_WishList_URL];
        
        NSString *jsonRequest = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"property_id\":\"%@\"}",userDetail.userid, _propertyDetail.propertyid];
        NSLog(@"%@",jsonRequest);
        requestFor = Add_To_WishList_URL;
        URLConnection *connection=[[URLConnection alloc] init];
        connection.delegate=self;
        [connection getDataFromUrl:jsonRequest webService:urlString];
    }
    else{
    
    WishListDetail *wishListDetail = [[WishListDetail alloc]init];
    
    wishListDetail.shortlist_property_id = _propertyDetail.shortlist_property_id;
    wishListDetail.propertyid = _propertyDetail.propertyid;
    wishListDetail.userid = _propertyDetail.userid;
    wishListDetail.property_code = _propertyDetail.property_code;
    wishListDetail.property_name = _propertyDetail.property_name;
    wishListDetail.address_houseno = _propertyDetail.address_houseno;
    wishListDetail.address_galino = _propertyDetail.address_galino;
    wishListDetail.address_locality = _propertyDetail.address_locality;
    wishListDetail.address_street = _propertyDetail.address_street;
    wishListDetail.address_sector = _propertyDetail.address_sector;
    wishListDetail.address_landmark = _propertyDetail.address_landmark;
    wishListDetail.address_city = _propertyDetail.address_city;
    wishListDetail.address_state = _propertyDetail.address_state;
    wishListDetail.address_country = _propertyDetail.address_country;
    wishListDetail.address_pin = _propertyDetail.address_pin;
    wishListDetail.gps_lattitude = _propertyDetail.gps_lattitude;
    wishListDetail.gps_longitude = _propertyDetail.gps_longitude;
    wishListDetail.accommodation_type = _propertyDetail.accommodation_type;
    wishListDetail.manager_firstname = _propertyDetail.manager_firstname;
    wishListDetail.manager_lastname = _propertyDetail.manager_lastname;
    wishListDetail.manager_gender = _propertyDetail.manager_gender;
    wishListDetail.manager_mobile = _propertyDetail.manager_mobile;
    wishListDetail.phone = _propertyDetail.phone;
    wishListDetail.website_url = _propertyDetail.website_url;
    wishListDetail.property_type = _propertyDetail.property_type;
    wishListDetail.property_type_other = _propertyDetail.property_type_other;
    wishListDetail.facility_available_for = _propertyDetail.facility_available_for;
    wishListDetail.food_served = _propertyDetail.food_served;
    wishListDetail.food_included = _propertyDetail.food_included;
    wishListDetail.breakfast = _propertyDetail.breakfast;
    wishListDetail.lunch = _propertyDetail.lunch;
    wishListDetail.dinner = _propertyDetail.dinner;
    wishListDetail.breakfast_amount = _propertyDetail.breakfast_amount;
    wishListDetail.lunch_amount = _propertyDetail.lunch_amount;
    wishListDetail.dinner_amount = _propertyDetail.dinner_amount;
    wishListDetail.property_verified = _propertyDetail.property_verified;
    wishListDetail.date_verified = _propertyDetail.date_verified;
    wishListDetail.proprety_by = _propertyDetail.proprety_by;
    wishListDetail.draft = _propertyDetail.draft;
    wishListDetail.active = _propertyDetail.active;
    wishListDetail.archive = _propertyDetail.archive;
    wishListDetail.deleted = _propertyDetail.deleted;
    wishListDetail.created_by = _propertyDetail.created_by;
    wishListDetail.created_date = _propertyDetail.created_date;
    wishListDetail.updated_by = _propertyDetail.updated_by;
    wishListDetail.updated_date = _propertyDetail.updated_date;
    wishListDetail.updated_by = _propertyDetail.updated_by;
    wishListDetail.updated_date = _propertyDetail.updated_date;
    wishListDetail.verified = _propertyDetail.verified;
    wishListDetail.enquiryno = _propertyDetail.enquiryno;
    wishListDetail.title = _propertyDetail.title;
    wishListDetail.keyword = _propertyDetail.keyword;
    wishListDetail.property_description = _propertyDetail.property_description;
    wishListDetail.studentacco_id = _propertyDetail.studentacco_id;
    wishListDetail.total_student_for_college = _propertyDetail.total_student_for_college;
    wishListDetail.total_boys_for_college = _propertyDetail.total_boys_for_college;
    wishListDetail.total_girls_for_college = _propertyDetail.total_girls_for_college;
    wishListDetail.total_seats_for_hostel = _propertyDetail.total_seats_for_hostel;
    wishListDetail.total_boys_for_hostel = _propertyDetail.total_boys_for_hostel;
    wishListDetail.total_girls_for_hostel = _propertyDetail.total_girls_for_hostel;
    wishListDetail.pg_entrytime = _propertyDetail.pg_entrytime;
    wishListDetail.noof_beds = _propertyDetail.noof_beds;
    wishListDetail.mark_as_branded = _propertyDetail.mark_as_branded;
    wishListDetail.show_on_home = _propertyDetail.show_on_home;
    wishListDetail.form_date = _propertyDetail.form_date;
    wishListDetail.to_date = _propertyDetail.to_date;
    wishListDetail.total_view = _propertyDetail.total_view;
    wishListDetail.sold_out = _propertyDetail.sold_out;
    wishListDetail.rooms_available = _propertyDetail.rooms_available;
    wishListDetail.imagename = _propertyDetail.imagename;
    wishListDetail.facility_typeid = _propertyDetail.facility_typeid;
    wishListDetail.facility = _propertyDetail.facility;
    wishListDetail.rent = _propertyDetail.rent;
    wishListDetail.occupancy = _propertyDetail.occupancy;
    
    
    BOOL isPresent = NO;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"PropertyDetail"]) {
        NSData *wishListData = [[NSUserDefaults standardUserDefaults] dataForKey:@"PropertyDetail"];
        wishListArray = [[NSMutableArray alloc]init];
        wishListArray = (NSMutableArray *)[NSKeyedUnarchiver unarchiveObjectWithData:wishListData];}
    for(int i= 0; i< wishListArray.count; i++)
    {
       _wishButton.selected=NO;
        WishListDetail *p = wishListArray[i];
        
        
        if (wishListDetail.propertyid==p.propertyid) {
            isPresent=YES;
            _wishButton.selected=NO;
            [wishListArray removeObjectAtIndex:i];
            NSData *propertyEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:wishListArray];
          
            
            [[NSUserDefaults standardUserDefaults]setObject:propertyEncodedObject forKey:@"PropertyDetail"];
            break;
        }
    }
    if (isPresent==NO) {
       _wishButton.selected=YES;
        
        [wishListArray addObject:wishListDetail];
        NSData *propertyEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:wishListArray];
        [[NSUserDefaults standardUserDefaults]setObject:propertyEncodedObject forKey:@"PropertyDetail"];
        
    }}
//    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
//        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
    
//        userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
//        if ([_propertyDetail.shortlist_property_id isEqualToString:@""]) {
//            _propertyDetail.shortlist_property_id = _propertyDetail.propertyid;
//            _wishButton.backgroundColor=[UIColor colorWithPatternImage:
//            [UIImage imageNamed:@"wishlist-border"]];
//            selected=NO;
//        }
//        else {
//            _propertyDetail.shortlist_property_id = @"";
//            _wishButton.backgroundColor=[UIColor colorWithPatternImage:
//            [UIImage imageNamed:@"wishlist-mouseover"]];
//            selected=YES;
//            
//        }
//        [(AppDelegate *)[[UIApplication sharedApplication] delegate] showProgress];
//        
//        NSString *urlString=[NSString stringWithFormat:@"%@%@",Base_URL,Add_To_WishList_URL];
//        
//        NSString *jsonRequest = [NSString stringWithFormat:@"{\"user_id\":\"%@\",\"property_id\":\"%@\"}",userDetail.userid, _propertyDetail.propertyid];
//        NSLog(@"%@",jsonRequest);
//        //requestFor = Add_To_WishList_URL;
//        URLConnection *connection=[[URLConnection alloc] init];
//        connection.delegate=self;
//        [connection getDataFromUrl:jsonRequest webService:urlString];
//    }
//    else{
//        NSString *alert=@"Please Login";
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:alert preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//        }];
//        [alertController addAction:cancelAction];
//        [self presentViewController:alertController animated:YES completion:nil];
//        
//        
//        
//        
//    }
//

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callOwner:(id)sender {
    
    //    NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"tel://%@",propertyDetail.manager_mobile]];
    //
    //    if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
    //        [[UIApplication sharedApplication] openURL:phoneUrl];
    //    }
    //    else {
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert!" message:@"Call facility is not available!!!" preferredStyle:UIAlertControllerStyleAlert];
    //        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //
    //        }];
    //        [alertController addAction:cancelAction];
    //        [self presentViewController:alertController animated:YES completion:nil];
    //  }
    
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"])
    {
        ContactInfoViewController *obj =[self.storyboard instantiateViewControllerWithIdentifier:@"ContactInfoViewController"];
        obj.contactEnquireNo=_propertyDetail.enquiryno;
        obj.propertyDetail = _propertyDetail;
        [self.navigationController pushViewController:obj animated:YES];
        
    }
    else
    {
        ContactLandlordViewController *contactLandlord = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactLandlordViewController"];
        contactLandlord.propertyDetail= _propertyDetail;
        
        
        [self.navigationController pushViewController:contactLandlord animated:YES];
    }
}






#pragma mark NSURL Connection Delegate Method

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
            if ([requestFor isEqualToString:Property_Detail_URL]) {
                
         
            if ([json objectForKey:@"room_details"] && ![[json objectForKey:@"room_details"] isEqual:[NSNull null]]) {
                NSArray *roomDetailListArray = [json objectForKey:@"room_details"];
                
                for (int index = 0; index < roomDetailListArray.count; index++) {
                    
                    NSDictionary *dict = roomDetailListArray[index];
                    RoomDetail *roomDetail = [[RoomDetail alloc]init];
                    
                    roomDetail.facility_typeid = dict[@"facility_typeid"];
                    if ([roomDetail.facility_typeid isEqual:[NSNull null]]) {
                        roomDetail.facility_typeid = @"";
                    }
                    roomDetail.propertyid = dict[@"propertyid"];
                    if ([roomDetail.propertyid isEqual:[NSNull null]]) {
                        roomDetail.propertyid = @"";
                    }
                    roomDetail.allowed = dict[@"allowed"];
                    if ([roomDetail.allowed isEqual:[NSNull null]]) {
                        roomDetail.allowed = @"";
                    }
//                    roomDetail.facility_available_for = dict[@"facility_available_for"];
//                    if ([roomDetail.facility_available_for isEqual:[NSNull null]]) {
//                        roomDetail.facility_available_for = @"";
//                    }
                    
                  
                    
                    // TODO : remove this code as web service resolved
                    NSString *tempFacility = dict[@"facility_available_for"];
                    if ([tempFacility isEqual:[NSNull null]] ||[tempFacility isEqualToString:@""]) {
                         roomDetail.facility_available_for = nil;
                    }
                    else {
                        NSString *lastString = [tempFacility substringFromIndex:[tempFacility length] - 1];
                        if ([lastString isEqualToString:@","]) {
                            tempFacility = [tempFacility substringWithRange:NSMakeRange(0,[tempFacility length] - 1)];
                        }
                        roomDetail.facility_available_for = tempFacility;
                    }
                    // ----------------------------------------------
                    
                    roomDetail.rent = dict[@"rent"];
                    if ([roomDetail.rent isEqual:[NSNull null]]) {
                        roomDetail.rent = @"0";
                    }
                    NSString *formatted = [NSNumberFormatter localizedStringFromNumber:@([roomDetail.rent integerValue]) numberStyle:NSNumberFormatterCurrencyStyle];
                    formatted =[formatted substringFromIndex:1];
                    if (formatted.length >= 4) {
                        formatted = [formatted substringWithRange:NSMakeRange(0,[formatted length] - 3)];
                    }
                    
                    roomDetail.rent = formatted;
                    
                    roomDetail.security = dict[@"security"];
                    if ([roomDetail.security isEqual:[NSNull null]]) {
                        roomDetail.security = @"0";
                    }
                    NSString *formattedSecurity = [NSNumberFormatter localizedStringFromNumber:@([roomDetail.security integerValue]) numberStyle:NSNumberFormatterCurrencyStyle];
                    formattedSecurity =[formattedSecurity substringFromIndex:1];
                    if (formattedSecurity.length >= 4) {
                        formattedSecurity = [formattedSecurity substringWithRange:NSMakeRange(0,[formattedSecurity length] - 3)];
                    }
                    
                    roomDetail.security = formattedSecurity;
                    [roomDetailArray addObject:roomDetail];
                    
                    NSDictionary *attribute1 = @{NSForegroundColorAttributeName:[UIColor blackColor],
                                                 NSFontAttributeName:[UIFont fontWithName:@"CircularStd-Medium" size:18.0f]};
                    NSDictionary *attribute2 = @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                                 NSFontAttributeName:[UIFont fontWithName:@"CircularStd-Medium" size:13.0f]};
                    
                    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] init];
                    NSAttributedString *str1 = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"₹%@",roomDetail.rent] attributes:attribute1];
                    
                    NSAttributedString *str2 = [[NSAttributedString alloc]initWithString:@" onwards" attributes:attribute2];
                    
                    [string appendAttributedString:str1];
                    [string appendAttributedString:str2];
                    
                    [_rentButton setAttributedTitle:string forState:UIControlStateNormal];
                    
                }
                
            }
            
            if ([json objectForKey:@"amenities_details"] && ![[json objectForKey:@"amenities_details"] isEqual:[NSNull null]]) {
                NSArray *amenitiesListArray = [json objectForKey:@"amenities_details"];
                for (int index = 0; index < amenitiesListArray.count; index++) {
                    
                    NSDictionary *dict = amenitiesListArray[index];
                    AmenitiesDetail *amenitiesDetail = [[AmenitiesDetail alloc]init];
                    
                    amenitiesDetail.included = dict[@"included"];
                    if ([amenitiesDetail.included isEqual:[NSNull null]]) {
                        continue;
                    }
                    
                    amenitiesDetail.cfacilityid = dict[@"cfacilityid"];
                    if ([amenitiesDetail.cfacilityid isEqual:[NSNull null]]) {
                        amenitiesDetail.cfacilityid = @"";
                    }
                    amenitiesDetail.propertyid = dict[@"propertyid"];
                    if ([amenitiesDetail.propertyid isEqual:[NSNull null]]) {
                        amenitiesDetail.propertyid = @"";
                    }
                    amenitiesDetail.cfacility = dict[@"cfacility"];
                    if ([amenitiesDetail.cfacility isEqual:[NSNull null]]) {
                        amenitiesDetail.cfacility = @"";
                    }
                    amenitiesDetail.provided = dict[@"provided"];
                    if ([amenitiesDetail.provided isEqual:[NSNull null]]) {
                        amenitiesDetail.provided = @"";
                    }
                    amenitiesDetail.included = dict[@"included"];
                    if ([amenitiesDetail.included isEqual:[NSNull null]]) {
                        amenitiesDetail.included = @"";
                    }
                    amenitiesDetail.charges = dict[@"charges"];
                    if ([amenitiesDetail.charges isEqual:[NSNull null]]) {
                        amenitiesDetail.charges = @"";
                    }
                    
                    [amenitiesArray addObject:amenitiesDetail];
                }
            }
            
            if ([json objectForKey:@"property_houserule_details"] && ![[json objectForKey:@"property_houserule_details"] isEqual:[NSNull null]]) {
                NSArray *houseRuleListArray = [json objectForKey:@"property_houserule_details"];
                
                for (int index = 0; index < houseRuleListArray.count; index++) {
                    
                    NSDictionary *dict = houseRuleListArray[index];
                    HouseRuleDetail *houseRuleDetail = [[HouseRuleDetail alloc]init];
                    
                    houseRuleDetail.houseruleid = dict[@"houseruleid"];
                    if ([houseRuleDetail.houseruleid isEqual:[NSNull null]]) {
                        houseRuleDetail.houseruleid = @"";
                    }
                    houseRuleDetail.propertyid = dict[@"propertyid"];
                    if ([houseRuleDetail.propertyid isEqual:[NSNull null]]) {
                        houseRuleDetail.propertyid = @"";
                    }
                    houseRuleDetail.houserule = dict[@"houserule"];
                    if ([houseRuleDetail.houserule isEqual:[NSNull null]]) {
                        houseRuleDetail.houserule = @"";
                    }
                    [houseRuleArray addObject:houseRuleDetail];
                }
                
            }
            
            if ([json objectForKey:@"propertyimages_details"] && ![[json objectForKey:@"propertyimages_details"] isEqual:[NSNull null]]) {
                NSArray *propertyImageListArray = [json objectForKey:@"propertyimages_details"];
                
                for (int index = 0; index < propertyImageListArray.count; index++)
                {
                    NSDictionary *dict = propertyImageListArray[index];
                    [propertyImageArray addObject:dict[@"full_image_path"]];
                }
               
            }
            
            [propertyDetailTableView reloadData];
            //[self showView];
        }
        else if ([requestFor isEqualToString:Add_To_WishList_URL])
        {
            if ([[json valueForKey:@"response_data"] isEqualToString:@"added"]) {
                _wishButton.selected=YES;
            }
            else if ([[json valueForKey:@"response_data"] isEqualToString:@"removed"])
            {
                _wishButton.selected = NO;
                 _wishButton.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wishlist-border"]];
            }
        }
            else if ([requestFor isEqualToString:book_now_with_login_URL])
            {
                                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"Thank You! Your request has been successfully submitted" preferredStyle:UIAlertControllerStyleAlert];
                                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                                    }];
                                    [alertController addAction:cancelAction];
                                    [self presentViewController:alertController animated:YES completion:nil];
            }
        }
        else if ([[json valueForKey:@"code"]isEqualToString:@"201"])
        {
            if([requestFor isEqualToString:book_now_with_login_URL])
            {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Alert !" message:@"User information does not exist." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alertController addAction:cancelAction];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }

    }
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
}

- (void)connectionFailWithError:(NSError *)error {
    
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] hideProgress];
    NSString *strErrorMsg = [error localizedDescription];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Network Error !" message:strErrorMsg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
