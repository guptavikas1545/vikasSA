//
//  Constant.h
//  webServicesExample
//
//  Created by Ravi Patel on 12/05/15.
//  Copyright (c) 2015 ClearToken. All rights reserved.
//

#ifndef webServicesExample_Constant_h
#define webServicesExample_Constant_h
#import "AppDelegate.h"

//RequestType constant use for identify the request type is post or get
typedef enum RequestType{
    kPost,
    kGet
}RequestType;


// ServiceIdentifier constant used to identify the which method requested to web service.
typedef enum ServiceIdentifier
{
    
    kGetBigSaving,
    kGetBrandedRooms,
    kPostNearByProperty,
    kGetPopularPropeties,
    
    
    kGetDeviceInfo,
    kGetDeviceToken,
    kGetPin,
    kGetVerify
}ServiceIdentifier;

//ErrorType constant used for check the error type during the web service request
typedef enum ErrorType{
    kNetworkNotFound,
    kParameterNotProper,
}ErrorType;


//BluetoothStatus constant tell that centrall device bluetooth On or Off.
typedef enum BluetoothStatus{
    kOn,
    kOFF,
}BluetoothStatus;


//TokenWriteStatus constant tell that information about given token successfully write on device or faild
typedef enum TokenWriteStatus{
    kSuccessTokenWrite,
    kFailTokenWrite,
}TokenWriteStatus;


// BLEConnectionStatus constant is used for connection status of BLE device to Mobile device(central device)
typedef enum BLEConnectionStatus{
    kStatusDisconnected,
    kStatusConnectedFailed,
    kStatusConnected
}BLEConnectionStatus;



// declare the key and value which is used in string format
#define kPhoneNumber @"PhoneNumber"
#define kInfo @"info"
#define kPhone @"phone"
#define kDevice @"device"
#define kfee @"fee"
#define kRequestsms @"requestsms"
#define kFunc @"func"
#define kResponse @"response"
#define kVerifysms @"verifysms"
#define kCode @"code"
#define kFunc @"func"
#define kCurrentStatus @"CurrentStatus"
#define kDeviceId @"DeviceId"
#define kFee @"Fee"
#define kIncrements @"Increments"
#define kLatitude @"Latitude"
#define kLocation @"Location"
#define kLongitude @"Longitude"
#define kMaxIncrements @"MaxIncrements"
#define kOwnerID @"OwnerID"
#define kPhotoFile @"PhotoFile"
#define kType @"Type"
#define kUnits @"Units"
#define kZone @"Zone"
#define kImageURL @"http://www.cleartoken.com/appicons/%@.png"
#define BASE_URL @"http://www.studentacco.com/webservices/"
#define DUUID @"c9cab9b8-3abf-4043-a5af-9ad00c6074d5"
#define NullResponceMessage @"Network not available, please check your internet settings."

//declare the APPDelegate singlton instance
#define APP_DELEGATE  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

// This is debug log. It's used palce of NSLog and it's only excute on debug mode
#if DEBUG
#define DEBUGLog(format, ...) NSLog((@"%s:%d %s " format), \
strrchr ("/" __FILE__, '/') + 1, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#else
#define DEBUGLog(format, ...)
#endif

#endif
