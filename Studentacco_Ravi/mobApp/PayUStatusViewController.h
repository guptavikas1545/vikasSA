//
//  PayUStatusViewController.h
//  Studentacco
//
//  Created by MAG on 03/10/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayUStatusViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *property_id;
@property (weak, nonatomic) IBOutlet UILabel *property_name;
@property (weak, nonatomic) IBOutlet UILabel *transaction_id;
@property(nonatomic,strong)NSString *status,*prop_id,*prop_name,*tran_id;
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (nonatomic,strong)NSString *isShow;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;
@end
