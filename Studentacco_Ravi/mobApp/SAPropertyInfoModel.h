//
//  ClTDeviceiInfoModel.h
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SAPropertyInfoModel : NSObject

// use in branded API
@property (strong,nonatomic) NSString *addressLocality;
@property (strong,nonatomic) NSString *addressCity;
@property (strong,nonatomic) NSString *rent;
@property (strong,nonatomic) NSString *fullImagePath;
// use in big Saving API
@property (strong,nonatomic) NSNumber *discountPrice;
// use in near by property API
@property (strong,nonatomic) NSString *gpsLattitude;
@property (strong,nonatomic) NSString  *gpsLongitude;
@property (strong,nonatomic) NSNumber *propertyCount;
// use in Popular propeties API
@property (strong, nonatomic) NSString *roomsAvailable;


//@property (strong,nonatomic) NSString *stringCurrentStatus;
//@property (strong,nonatomic) NSString *stringDeviceId;
//@property (strong,nonatomic) NSNumber *numberFee;
//@property (strong,nonatomic) NSString *stringIncrements;
//@property (strong,nonatomic) NSString *stringLatitude;
//@property (strong,nonatomic) NSString *stringLocation;
//@property (strong,nonatomic) NSString *stringLongitude;
//@property (strong,nonatomic) NSString *stringMaxIncrements;
//@property (strong,nonatomic) NSString *stringOwnerID;
//@property (strong,nonatomic) NSString *stringPhotoFile;
//@property (strong,nonatomic) NSString *stringType;
//@property (strong,nonatomic) NSString *stringUnits;
//@property (strong,nonatomic) NSString *stringZone;


+(SAPropertyInfoModel*)sharedInstance;

-(SAPropertyInfoModel*)fillDeviceInfoModel:(NSDictionary*)responseDictionary;
-(SAPropertyInfoModel*)fillPropertyModelForBigSaving:(NSDictionary*)responseDictionary;
-(SAPropertyInfoModel*)fillPropertyModelNearByProperty:(NSDictionary*)responseDictionary;
-(SAPropertyInfoModel*)fillPropertyModelForPopularProperties:(NSDictionary*)responseDictionary;
@end
