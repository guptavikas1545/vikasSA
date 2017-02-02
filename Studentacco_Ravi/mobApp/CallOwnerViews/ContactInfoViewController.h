//
//  ContactInfoViewController.h
//  Studentacco
//
//  Created by MAG on 02/08/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishListDetail.h"
@interface ContactInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *propertyImageView;
@property (weak, nonatomic) IBOutlet UILabel *propertyOwnerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *enquireNoLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;
@property (weak, nonatomic) NSString *contactEnquireNo;
@property (nonatomic, strong)WishListDetail *propertyDetail;
@property (nonatomic, strong)NSString *selected;
@property (nonatomic, strong)NSString *callFrom;
@end
