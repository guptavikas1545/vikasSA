//
//  TitleTableViewCell.h
//  StudentAcco
//
//  Created by MAG on 22/07/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TitleTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *accoIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *scheduleButton;

@end
