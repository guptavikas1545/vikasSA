//
//  ClTDeviceiInfoModel.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "ClTDeviceiInfoModel.h"
#import "Constant.h"

@implementation ClTDeviceiInfoModel

/**************************************************************************************
 //create the singleton instance of ClTDeviceiInfoModel class
 **************************************************************************************/


+(ClTDeviceiInfoModel*)sharedInstance{
    
    static ClTDeviceiInfoModel *sharedInstance = nil;
    static dispatch_once_t oncePedicate;
    dispatch_once(&oncePedicate, ^{
        
        sharedInstance = [[ClTDeviceiInfoModel alloc] init];
    });
    return sharedInstance;
}






/**************************************************************************************
 //Default initialize ClTDeviceiInfoModel class with it's property set to nil value
 **************************************************************************************/
-(id)init
{
    
    self=[super init];
    //check current class exist
    if (self) {
        
        
        _addressLocality=@"";
        _addressCity=@"";
        _rent=@"";
        _fullImagePath=@"";
        _discountPrice =0;
        _gpsLattitude=@"";
        _gpsLongitude=@"";
        
        _propertyCount=0;
        
        //      _stringCurrentStatus=@"";
        //        _stringDeviceId=@"";
        //        _numberFee=0;
        //        _stringLatitude=@"";
        //        _stringLocation=@"";
        //        _stringLongitude=@"";
        //        _stringMaxIncrements=@"";
        //        _stringOwnerID=@"";
        //        _stringType=@"";
        //        _stringUnits=@"";
        //        _stringZone=@"";
        
    }
    
    return self;
}

-(NSMutableArray*)fillDeviceInfoModel:(NSDictionary*)responseDictionary  {
    
    NSLog(@"FillDevice== %@",responseDictionary);
    
    NSMutableArray *tempPropetyListArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *propertyListArray = [[NSMutableArray alloc]initWithArray:[responseDictionary valueForKey:@"property_list"]];
    
    for (ClTDeviceiInfoModel *propertyDetail in propertyListArray ){
        
        ClTDeviceiInfoModel *deviceiInfoModel= [[ClTDeviceiInfoModel alloc]init];
        
        [deviceiInfoModel setAddressLocality:[propertyDetail valueForKey:@"address_locality"]];
        [deviceiInfoModel setAddressCity:[propertyDetail valueForKey:@"address_city"]];
        [deviceiInfoModel setRent:[propertyDetail valueForKey:@"rent"]];
        [deviceiInfoModel setFullImagePath:[propertyDetail valueForKey:@"full_image_path"]];
        
        [deviceiInfoModel setDiscountPrice:[propertyDetail valueForKey:@"discount_price"]];
        
        [tempPropetyListArray addObject:deviceiInfoModel];
    }
    return tempPropetyListArray;
}


-(NSMutableArray*)fillPropertyModelForBigSaving:(NSDictionary*)responseDictionary  {
    NSLog(@"FillDevice== %@",responseDictionary);
    NSMutableArray *tempPropetyListArray = [[NSMutableArray alloc]init];
    NSMutableArray *propertyListArray = [[NSMutableArray alloc]initWithArray:[responseDictionary valueForKey:@"property_list"]];
    
    for (ClTDeviceiInfoModel *propertyDetail in propertyListArray ){
        ClTDeviceiInfoModel *deviceiInfoModel= [[ClTDeviceiInfoModel alloc]init];
        NSLog(@"discount_price=%@", [propertyDetail valueForKey:@"discount_price"]);
        if ([[propertyDetail valueForKey:@"discount_price"] doubleValue] >0){
            [deviceiInfoModel setAddressLocality:[propertyDetail valueForKey:@"address_locality"]];
            [deviceiInfoModel setAddressCity:[propertyDetail valueForKey:@"address_city"]];
            [deviceiInfoModel setRent:[propertyDetail valueForKey:@"rent"]];
            [deviceiInfoModel setFullImagePath:[propertyDetail valueForKey:@"full_image_path"]];
            [deviceiInfoModel setDiscountPrice:[propertyDetail valueForKey:@"discount_price"]];
            [tempPropetyListArray addObject:deviceiInfoModel];
        }
    }
    return tempPropetyListArray;
}

-(NSMutableArray*)fillPropertyModelNearByProperty:(NSDictionary*)responseDictionary  {
    NSLog(@"FillDevice== %@",responseDictionary);
    NSMutableArray *tempPropetyListArray = [[NSMutableArray alloc]init];
    NSMutableArray *propertyListArray = [[NSMutableArray alloc]initWithArray:[responseDictionary valueForKey:@"property_list"]];
    
    for (ClTDeviceiInfoModel *propertyDetail in propertyListArray ){
        ClTDeviceiInfoModel *deviceiInfoModel= [[ClTDeviceiInfoModel alloc]init];
      
            [deviceiInfoModel setAddressLocality:[propertyDetail valueForKey:@"address_locality"]];
            [deviceiInfoModel setAddressCity:[propertyDetail valueForKey:@"address_city"]];
            [deviceiInfoModel setRent:[propertyDetail valueForKey:@"rent"]];
            [deviceiInfoModel setFullImagePath:[propertyDetail valueForKey:@"full_image_path"]];
            [deviceiInfoModel setDiscountPrice:[propertyDetail valueForKey:@"discount_price"]];
            
            [deviceiInfoModel setGpsLongitude:[propertyDetail valueForKey:@"gps_longitude"]];
            [deviceiInfoModel setGpsLattitude:[propertyDetail valueForKey:@"gps_lattitude"]];
            
            [tempPropetyListArray addObject:deviceiInfoModel];

    }
    return tempPropetyListArray;
}





@end
