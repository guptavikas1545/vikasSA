//
//  ContactLandlordViewController.h
//  StudentAcco
//
//  Created by MAG on 14/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishListDetail.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"
@interface ContactLandlordViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *contactLandlordTableView;


//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;
//@property (weak, nonatomic) IBOutlet UIImageView *propertyImage;
@property (nonatomic, strong)WishListDetail *propertyDetail;
//@property (weak, nonatomic) IBOutlet UILabel *ownerName;
//@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
//@property (weak, nonatomic) IBOutlet UITextField *mobileNoTextField;
//@property (weak, nonatomic) IBOutlet UITextField *emailIdTextField;
@property (nonatomic,strong)NSString *select;
@end
