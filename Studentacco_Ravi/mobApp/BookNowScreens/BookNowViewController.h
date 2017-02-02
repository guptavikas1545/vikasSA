//
//  BookNowViewController.h
//  Studentacco
//
//  Created by MAG on 14/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface BookNowViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *fNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic,strong)NSString *propertyID;
@property (nonatomic, strong)NSString *isBranded;
@end
