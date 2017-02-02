//
//  ScheduleToVisitWithoutLoginViewController.h
//  Studentacco
//
//  Created by MAG on 13/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface ScheduleToVisitWithoutLoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *fNametextField;
@property (weak, nonatomic) IBOutlet UITextField *lNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mobileNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *dateTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *houreTextField;
@property (weak, nonatomic) IBOutlet UITextField *minTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (nonatomic,strong)NSString *propertyID;

@end
