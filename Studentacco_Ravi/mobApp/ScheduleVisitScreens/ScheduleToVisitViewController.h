//
//  ScheduleToVisitViewController.h
//  Studentacco
//
//  Created by MAG on 30/08/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface ScheduleToVisitViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *hrField;
@property (weak, nonatomic) IBOutlet UITextField *minField;
@property (nonatomic,strong)NSString *propertyID;

@end
