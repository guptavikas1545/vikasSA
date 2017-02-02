//
//  PropertyDetailCollectionViewCell.m
//  mobApp
//
//  Created by MAG on 13/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "PropertyDetailCollectionViewCell.h"

@implementation PropertyDetailCollectionViewCell
@synthesize topLayoutConstraint;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self priceLabelAttribute];
    
    // Initialization code
}
-(void)priceLabelAttribute
{
    _rentPriceLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _rentPriceLabel.layer.borderWidth = 0.8f;
    self.topLayoutConstraint.constant = [UIScreen mainScreen].bounds.size.width > 320.0f ? 36 : 45;
 
}
@end
