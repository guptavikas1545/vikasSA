//
//  InnerCollectionViewCell.h
//  mobApp
//
//  Created by MAG on 06/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
@interface InnerCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *property_nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *property_addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;


@end
