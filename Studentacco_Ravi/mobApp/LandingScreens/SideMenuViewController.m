//
//  SideMenuViewController.m
//  mobApp
//
//  Created by MAG on 08/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "SideMenuViewController.h"
#import "MFSideMenu.h"
#import "ViewController.h"
#import "SideMenuTableViewCell.h"
#import "LoginAccountViewController.h"
#import "SignupViewController.h"
#import "AppConstants.h"
#import "UserDetail.h"
#import "ListAndMapViewController.h"
#import "WishListViewController.h"
#import "EditProfileViewController.h"
#import "FindMyRoomyViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"

@interface SideMenuViewController ()
{
    NSMutableArray *menuIcon, *menuTitle;
    IBOutlet UITableView *sideMenuTableView;
    
}
@end

@implementation SideMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [FBSDKAccessToken currentAccessToken];
    menuIcon=[NSMutableArray arrayWithObjects:@"contacted",@"wishlist",@"account",@"setting",@"  ",@"  ",@"  ",@"  ",@"  ", nil];
    
    menuTitle=[NSMutableArray arrayWithObjects:@"Home",@"Wishlist",@"About Us",@"Why Verify?",@"        List With Us",@"        Privacy Policy",@"        Terms",@"        Contact Us", nil];
    
    [sideMenuTableView registerNib:[UINib nibWithNibName:@"SideMenuTableViewCell" bundle:nil] forCellReuseIdentifier:@"SideMenuCell"];
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(updateTableData) name:SideMenuUpdateNotification object:nil];
    [GIDSignIn sharedInstance].uiDelegate = self;
}

#pragma mark - Notification Received
- (void)updateTableData {
    [sideMenuTableView reloadData];
    
    [self performSelector:@selector(actionForSelectedIndex)
               withObject:nil afterDelay:0.5];
}

- (void)actionForSelectedIndex {
    [self tableView:sideMenuTableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tapTableHeader:(UIGestureRecognizer*)gesture {
    EditProfileViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"EditProfileViewController"];
    
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:obj];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"Section %ld", (long)section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger numberOfRows = 1;
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        if (section==0) {
            numberOfRows = 7;
        }
    }
    else if (section==0) {
        numberOfRows = 10;
    }
    return numberOfRows;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        if (section==0) {
            return 140;
        }
        else {
            return 0;
        }
    }
    return 0;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *viewForSectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 140)];
    UIView *viewForCommonSectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40)];
    viewForCommonSectionHeader.backgroundColor = [UIColor colorWithRed: 47/255.0 green:59/255.0 blue:137/255.0 alpha:1.0f];
    viewForSectionHeader.backgroundColor = [UIColor colorWithRed:47/255.0 green:59/255.0 blue:137/255.0 alpha:1.0f];
    UIImageView *userImage=[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 70, 70)];
    userImage.layer.cornerRadius = userImage.frame.size.height /2;
    
    UIImageView *userProfilePic=[[UIImageView alloc]initWithFrame:CGRectMake(30, 20, 70, 70)];
    userProfilePic.layer.cornerRadius = userProfilePic.frame.size.height /2;
    userProfilePic.layer.masksToBounds = YES;
    UITapGestureRecognizer *tapHeaderGesture = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                               action:@selector(tapTableHeader:)];
    
    
    UILabel *userName = [[UILabel alloc]initWithFrame:CGRectMake(110, 20, 155, 70)];
    userName.font=[UIFont fontWithName:@"CircularStd-Book" size:24];
    userName.textColor = [UIColor whiteColor];
    userName.numberOfLines = 0;
    userName.lineBreakMode = NSLineBreakByWordWrapping;
    
    if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
        
        NSData *userData = [[NSUserDefaults standardUserDefaults] dataForKey:@"userData"];
        
        UserDetail *userDetail = (UserDetail *)[NSKeyedUnarchiver unarchiveObjectWithData:userData];
        
        userName.text=[NSString stringWithFormat:@"%@ %@",userDetail.firstname, userDetail.lastname];
        
        [userImage setImage:[UIImage imageNamed:@"user-profileCircle.png"]];
        
        [viewForSectionHeader addSubview:userName];
        [viewForSectionHeader addSubview:userImage];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",userDetail.profile_picture]];
        
        [viewForSectionHeader addSubview:userProfilePic];

        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                            userProfilePic.image = image;
                    });
                }
            }
        }];
        [task resume];

        if (section==0) {
            
            [viewForSectionHeader addGestureRecognizer:tapHeaderGesture];
            return viewForSectionHeader;
            
        }
        return viewForCommonSectionHeader;
    }
    else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"SideMenuCell";
    static NSString *cellIdentifier1 = @"CommonCell";
    sideMenuTableView.separatorColor = [UIColor clearColor];
    UITableViewCell *cell = nil;
    
    if (indexPath.section==0) {
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
            SideMenuTableViewCell *sideMenuCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
            sideMenuCell.textLabel.font=[UIFont fontWithName:@"CircularStd-Book" size:16];
            sideMenuCell.textLabel.textColor=[UIColor whiteColor];
            sideMenuCell.textLabel.text=menuTitle[indexPath.row]; // sideMenuTitle
            sideMenuCell.imageView.image=[UIImage imageNamed:menuIcon[indexPath.row]]; // sideMenuIcon
            
            cell = sideMenuCell;

        }
        else {
            UITableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
            commonCell.backgroundColor=[UIColor colorWithRed:47/255.0 green:59/255.0 blue:137/255.0 alpha:1.0f];
             commonCell.textLabel.font=[UIFont fontWithName:@"CircularStd-Book" size:16];
            if (indexPath.row == 0) {
               
                commonCell.textLabel.text=@"Home";
            }
            else if (indexPath.row == 1) {
                commonCell.textLabel.text=@"Sign In";
            }
            else if (indexPath.row == 2) {
                commonCell.textLabel.text=@"Sign Up";
            }
            else if (indexPath.row == 3) {
                commonCell.textLabel.text=@"Wish List";
            }
            else if (indexPath.row == 4) {
                commonCell.textLabel.text=@"About Us";
            }
            else if (indexPath.row == 5) {
                commonCell.textLabel.text=@"Why Verify?";
            }
            else if (indexPath.row == 6) {
                commonCell.textLabel.text=@"List With Us";
            }
            else if (indexPath.row == 7) {
                commonCell.textLabel.text=@"Privacy Policy";
            }
            else if (indexPath.row == 8) {
                commonCell.textLabel.text=@"Terms";
            }
            else if (indexPath.row == 9) {
                commonCell.textLabel.text=@"Contact Us";
            }

            
            commonCell.textLabel.textColor=[UIColor whiteColor];
            UIView * selectedBackgroundView = [[UIView alloc] init];
            [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:65/255.0 green:97/255.0 blue:169/255.0 alpha:1.0f]];
            [commonCell setSelectedBackgroundView:selectedBackgroundView];
            cell = commonCell;
        }
    }
    else {
        UITableViewCell *commonCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        commonCell.backgroundColor=[UIColor colorWithRed:47/255.0 green:59/255.0 blue:137/255.0 alpha:1.0f];
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
            commonCell.textLabel.font=[UIFont fontWithName:@"CircularStd-Book" size:16];
            commonCell.textLabel.text=@"        LogOut";
        }
//        else {
//            commonCell.textLabel.font=[UIFont fontWithName:@"CircularStd-Medium" size:18];
//            commonCell.textLabel.text=@"Contact Us";
//        }
        
        commonCell.textLabel.textColor=[UIColor whiteColor];
        UIView * selectedBackgroundView = [[UIView alloc] init];
        [selectedBackgroundView setBackgroundColor:[UIColor colorWithRed:65/255.0 green:97/255.0 blue:169/255.0 alpha:1.0f]];
        [commonCell setSelectedBackgroundView:selectedBackgroundView];
        cell = commonCell;
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath;
{
    return 35.0f;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark -
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        if(indexPath.row == 1) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"]) {
//                if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"IsFirstVisit"]isEqualToString:@"YES"]) {
//                    
//                    [[NSUserDefaults standardUserDefaults]setValue:@"YES" forKey:@"IsFirstVisit"];
//                    
//                    UIViewController *demoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                    
//                    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//                    NSArray *controllers = [NSArray arrayWithObject:demoViewController];
//                    navigationController.viewControllers = controllers;
//                    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
//                }
//                else {
//                    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//                    if (![navigationController.viewControllers.lastObject isKindOfClass:[WishListViewController class]]) {
                        WishListViewController *wishListViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"WishListViewController"];
                
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSArray *controllers = [NSArray arrayWithObject:wishListViewController];
                navigationController.viewControllers = controllers;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                
                    
                    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
                }
           
            else {
                LoginAccountViewController *demoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginAccountViewController"];
                
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSArray *controllers = [NSArray arrayWithObject:demoViewController];
                navigationController.viewControllers = controllers;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
        }
        else if (indexPath.row==0) {
            if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"])
            {
                UIViewController *demoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSArray *controllers = [NSArray arrayWithObject:demoViewController];
                navigationController.viewControllers = controllers;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
            
    else{
        UIViewController *demoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
        
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:demoViewController];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            }
        }
       else if (indexPath.row==2)
       {
           if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"])
           {
//               FindMyRoomyViewController *object = [self.storyboard instantiateViewControllerWithIdentifier:@"findMyRoomyViewController"];
//               
//               UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//               NSArray *controllers = [NSArray arrayWithObject:object];
//               navigationController.viewControllers = controllers;
//               [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
               UIViewController *demoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
               
               UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
               NSArray *controllers = [NSArray arrayWithObject:demoViewController];
               navigationController.viewControllers = controllers;
               [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

           }
    else{
           SignupViewController *obj=[self.storyboard instantiateViewControllerWithIdentifier:@"SignupViewController"];
           
           UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
           NSArray *controllers = [NSArray arrayWithObject:obj];
           navigationController.viewControllers = controllers;
           [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
           }
       }
    else if (indexPath.row==3)
    {
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"])
        {
            UIViewController *demoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:demoViewController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        else
        {
            WishListViewController *wishListViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"WishListViewController"];
            
            UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
            NSArray *controllers = [NSArray arrayWithObject:wishListViewController];
            navigationController.viewControllers = controllers;
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
            
            
            [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
  
    }}
    
    
    
    else {
        if([[NSUserDefaults standardUserDefaults]objectForKey:@"userData"])
        {
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userData"];

              if ([FBSDKAccessToken currentAccessToken]) {
           [FBSDKAccessToken setCurrentAccessToken:nil];
                  [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me/permissions" parameters:nil
                                                     HTTPMethod:@"DELETE"] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                      }];

        }
             [[GIDSignIn sharedInstance] signOut];
            [[NSUserDefaults standardUserDefaults]setValue:@"NO" forKey:@"IsFirstVisit"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"PropertyDetail"];
            [self updateTableData];
        }
        else {
                 UIViewController *demoViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSArray *controllers = [NSArray arrayWithObject:demoViewController];
                navigationController.viewControllers = controllers;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
    }
       }

@end
