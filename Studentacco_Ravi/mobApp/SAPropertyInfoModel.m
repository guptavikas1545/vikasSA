//
//  ClTDeviceiInfoModel.m
//  ClearTokenApp
//
//  Created by Ravi Patel on 15/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#import "SAPropertyInfoModel.h"
#import "Constant.h"

@implementation SAPropertyInfoModel

/**************************************************************************************
 //create the singleton instance of ClTDeviceiInfoModel class
 **************************************************************************************/


+(SAPropertyInfoModel*)sharedInstance{
    
    static SAPropertyInfoModel *sharedInstance = nil;
    static dispatch_once_t oncePedicate;
    dispatch_once(&oncePedicate, ^{
        
        sharedInstance = [[SAPropertyInfoModel alloc] init];
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
        _roomsAvailable =@"";
        
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
    
    NSMutableArray *tempPropertyListArray = [[NSMutableArray alloc]init];
    
    NSMutableArray *propertyListArray = [[NSMutableArray alloc]initWithArray:[responseDictionary valueForKey:@"property_list"]];
    
    for (SAPropertyInfoModel *propertyDetail in propertyListArray ){
        
        SAPropertyInfoModel *propertyInfoModel= [[SAPropertyInfoModel alloc]init];
        
        [propertyInfoModel setAddressLocality:[propertyDetail valueForKey:@"address_locality"]];
        [propertyInfoModel setAddressCity:[propertyDetail valueForKey:@"address_city"]];
        [propertyInfoModel setRent:[propertyDetail valueForKey:@"rent"]];
        [propertyInfoModel setFullImagePath:[propertyDetail valueForKey:@"full_image_path"]];
        
        [propertyInfoModel setDiscountPrice:[propertyDetail valueForKey:@"discount_price"]];
        
        [tempPropertyListArray addObject:propertyInfoModel];
    }
    return tempPropertyListArray;
}


-(NSMutableArray*)fillPropertyModelForBigSaving:(NSDictionary*)responseDictionary  {
    NSLog(@"FillDevice== %@",responseDictionary);
    NSMutableArray *tempPropetyListArray = [[NSMutableArray alloc]init];
    NSMutableArray *propertyListArray = [[NSMutableArray alloc]initWithArray:[responseDictionary valueForKey:@"property_list"]];
    
    for (SAPropertyInfoModel *propertyDetail in propertyListArray ){
        SAPropertyInfoModel *deviceiInfoModel= [[SAPropertyInfoModel alloc]init];
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
    
    for (SAPropertyInfoModel *propertyDetail in propertyListArray ){
        SAPropertyInfoModel *deviceiInfoModel= [[SAPropertyInfoModel alloc]init];
      
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


-(NSMutableArray*)fillPropertyModelForPopularProperties:(NSDictionary*)responseDictionary  {
    NSLog(@"FillDevice== %@",responseDictionary);
    NSMutableArray *tempPropetyListArray = [[NSMutableArray alloc]init];
    NSMutableArray *propertyListArray = [[NSMutableArray alloc]initWithArray:[responseDictionary valueForKey:@"property_list"]];
    
    for (SAPropertyInfoModel *propertyDetail in propertyListArray ){
        SAPropertyInfoModel *deviceiInfoModel= [[SAPropertyInfoModel alloc]init];
        
        [deviceiInfoModel setAddressLocality:[propertyDetail valueForKey:@"address_locality"]];
        [deviceiInfoModel setAddressCity:[propertyDetail valueForKey:@"address_city"]];
        [deviceiInfoModel setRent:[propertyDetail valueForKey:@"rent"]];
        [deviceiInfoModel setFullImagePath:[propertyDetail valueForKey:@"full_image_path"]];
        [deviceiInfoModel setDiscountPrice:[propertyDetail valueForKey:@"discount_price"]];
        
        [deviceiInfoModel setGpsLongitude:[propertyDetail valueForKey:@"gps_longitude"]];
        [deviceiInfoModel setGpsLattitude:[propertyDetail valueForKey:@"gps_lattitude"]];
          [deviceiInfoModel setRoomsAvailable:[propertyDetail valueForKey:@"rooms_available"]];
        
        [tempPropetyListArray addObject:deviceiInfoModel];
        
    }
    return tempPropetyListArray;
}



@end
