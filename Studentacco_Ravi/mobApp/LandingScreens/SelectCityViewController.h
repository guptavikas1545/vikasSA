//
//  SelectCityViewController.h
//  mobApp
//
//  Created by MAG  on 6/9/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
@protocol SelectCityDelegate <NSObject>

- (void)fetchSelectedCity :(NSString *)city;


@end

@interface SelectCityViewController : UIViewController<CLLocationManagerDelegate>
{
    NSMutableArray *array_list;
    NSMutableData *recived_serverData;
}

@property (weak, nonatomic) id <SelectCityDelegate> delegate;
@property(strong, nonatomic) NSString*address;
@end
