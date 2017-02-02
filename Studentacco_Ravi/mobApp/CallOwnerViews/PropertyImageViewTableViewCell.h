//
//  PropertyImageViewTableViewCell.h
//  Studentacco
//
//  Created by MAG on 25/08/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyImageViewTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *propertyImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;
@property (weak, nonatomic) IBOutlet UILabel *ownerNameLabel;

@end
