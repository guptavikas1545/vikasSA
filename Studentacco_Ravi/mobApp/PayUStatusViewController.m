//
//  PayUStatusViewController.m
//  Studentacco
//
//  Created by MAG on 03/10/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "PayUStatusViewController.h"
#import "FullPropertyDetailsViewController.h"
@interface PayUStatusViewController ()

@property (weak, nonatomic) IBOutlet UITextView *statusResponceTextView;

@end

@implementation PayUStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [[self navigationController] setNavigationBarHidden:YES animated:YES];
     UIFont *textViewFont = [UIFont fontWithName: @"CircularStd-Book" size: 18.0];
    UIFont *labFont = [UIFont fontWithName: @"CircularStd-Book" size: 13.0];
    UIFont *bottomLabFont = [UIFont fontWithName: @"CircularStd-Book" size: 12.0];
    [_textLabel setFont:labFont];
    [_bottomLabel setFont:bottomLabFont];
    [_statusResponceTextView setFont:textViewFont];
    _statusResponceTextView.text = _status;
    _property_id.text = _prop_id;
    _property_name.text = _prop_name;
    _transaction_id.text = _tran_id;
    if ([_isShow isEqualToString:@"yes"]) {
        _statusResponceTextView.hidden = YES;
    }
    else if ([_isShow isEqualToString:@"no"])
    {
        _statusView.hidden=YES;
    }
    // Do any additional setup after loading the view.
}
- (IBAction)backToPreviousView:(id)sender {

     [self.navigationController popToViewController:[[self.navigationController viewControllers] objectAtIndex:1] animated:YES];
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
