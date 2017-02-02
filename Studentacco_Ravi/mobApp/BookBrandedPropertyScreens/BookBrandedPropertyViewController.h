//
//  BookBrandedPropertyViewController.h
//  Studentacco
//
//  Created by MAG on 15/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BookBrandedPropertyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *moveInTextField;
@property (weak, nonatomic) IBOutlet UITextField *moveOutDateTextField;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic, strong) NSDictionary *hashDict;
@property (nonatomic, strong) NSString *propertyId;
@property (nonatomic, strong) NSString *propertyName;
@end
