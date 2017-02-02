//
//  PropertyDetailCollectionViewCell.h
//  mobApp
//
//  Created by MAG on 13/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyDetailCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *propertyImageView;

@property (weak, nonatomic) IBOutlet UILabel *propertyAddress;
@property (weak, nonatomic) IBOutlet UILabel *propertyName;

@property (weak, nonatomic) IBOutlet UIButton *wishButton;
@property (weak, nonatomic) IBOutlet UILabel *rentPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *rentLabel;

@property (weak, nonatomic) IBOutlet UILabel *breakfastLabel;
@property (weak, nonatomic) IBOutlet UILabel *lunchLabel;
@property (weak, nonatomic) IBOutlet UILabel *dinnerLabel;


@property (weak, nonatomic) IBOutlet UILabel *singleOccupancy;
@property (weak, nonatomic) IBOutlet UILabel *doubleOccupancy;
@property (weak, nonatomic) IBOutlet UILabel *tripleOccupancy;
@property (weak, nonatomic) IBOutlet UILabel *dormOccupancy;

@property (weak, nonatomic) IBOutlet UILabel *firstAmenities;
@property (weak, nonatomic) IBOutlet UILabel *secondAmenities;
@property (weak, nonatomic) IBOutlet UILabel *thirdAmenities;
@property (weak, nonatomic) IBOutlet UIImageView *firstAmenitiesImage;
@property (weak, nonatomic) IBOutlet UIImageView *secondAmenitiesImage;
@property (weak, nonatomic) IBOutlet UIImageView *thirdAmenitiesImage;

@property (weak, nonatomic) IBOutlet UIButton *callOwnerButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityLoader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;



@end
