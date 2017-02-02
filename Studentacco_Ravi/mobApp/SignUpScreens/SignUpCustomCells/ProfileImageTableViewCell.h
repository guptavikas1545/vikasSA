//
//  ProfileImageTableViewCell.h
//  Studentacco
//
//  Created by MAG on 03/08/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;

@end
