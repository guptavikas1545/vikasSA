//
//  AmenitieCollectionViewCell.h
//  StudentAcco
//
//  Created by MAG on 7/24/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AmenitieCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectionImageView;
@property (weak, nonatomic) IBOutlet UIImageView *amenitieImageView;
@property (weak, nonatomic) IBOutlet UILabel *amenitieTitleLabel;

@end
