//
//  ContactInfoViewController.m
//  Studentacco
//
//  Created by MAG on 02/08/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "ContactInfoViewController.h"
#import "ContactLandlordViewController.h"
#import "AppDelegate.h"
@interface ContactInfoViewController ()

@end

@implementation ContactInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   _propertyOwnerNameLabel.text=[NSString stringWithFormat:@"%@ (Property Owner)", _propertyDetail.manager_firstname];
   
    if ([_propertyDetail.enquiryno isEqual:[NSNull null]] || [_propertyDetail.enquiryno isEqualToString:@" "] ) {
        _propertyDetail.enquiryno = @"";
    }

    _enquireNoLabel.text=[NSString stringWithFormat:@"Phone No:%@", _propertyDetail.enquiryno];
    
    _activityLoader.hidden = NO;
    [_activityLoader startAnimating];
    _propertyImageView.image = nil;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",_propertyDetail.imagename]];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _activityLoader.hidden = YES;
                    _propertyImageView.image = image;
                });
            }
        }
    }];
    [task resume];

    // Do any additional setup after loading the view.
}
- (IBAction)backToPreviousView:(id)sender {
       if ([_selected isEqualToString:@"yes"]) {
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:0] animated:YES];
    }
    else if ([_callFrom isEqualToString:@"yes"])
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else{
        [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];}
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
