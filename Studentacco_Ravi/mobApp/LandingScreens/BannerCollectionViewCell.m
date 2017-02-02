//
//  BannerCollectionViewCell.m
//  mobApp
//
//  Created by MAG on 08/06/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "BannerCollectionViewCell.h"

@implementation BannerCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITextField *txfSearchField = [_seachBar valueForKey:@"_searchField"];
    [txfSearchField setBackgroundColor:[UIColor whiteColor]];
    [txfSearchField setBorderStyle:UITextBorderStyleLine];
    [txfSearchField setFont:[UIFont fontWithName:@"CircularStd-Book" size:15.0f]];
    txfSearchField.layer.borderColor = [UIColor clearColor].CGColor;
}

@end
