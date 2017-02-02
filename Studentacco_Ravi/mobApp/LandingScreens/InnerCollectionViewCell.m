//
//  InnerCollectionViewCell.m
//  mobApp
//
//  Created by MAG on 06/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "InnerCollectionViewCell.h"
@implementation InnerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self priceLabelAttribute];
}

-(void)priceLabelAttribute
{
    _priceLabel.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _priceLabel.layer.borderWidth = 0.8f;
}


@end
