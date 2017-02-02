//
//  PropertyImageTableViewCell.h
//  StudentAcco
//
//  Created by atul on 27/07/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PropertyImageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;
@property (weak, nonatomic) IBOutlet UIImageView *propertyImg;

@end
