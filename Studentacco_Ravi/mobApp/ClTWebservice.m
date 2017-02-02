//
//  ClTWebservice.m
//
//
//  Created by Chetu on 12/05/15.
//  Copyright (c) 2015 Chetu. All rights reserved.
//

#import "ClTWebservice.h"
#import "NSURLRequest+ClTWebservice.h"
//#import "ClTLoadingActivity.h"
#import "ClTUtility.h"
@implementation ClTWebservice

//*******************************************
// SHARED INSTANCE
//*******************************************


+(ClTWebservice*)sharedInstance{
    
    static ClTWebservice *sharedInstance = nil;
    static dispatch_once_t oncePedicate;
    dispatch_once(&oncePedicate, ^{
        
        sharedInstance = [[ClTWebservice alloc] init];
    });
    return sharedInstance;
}

- (void)callWebserviceWithServiceIdentifier:(ServiceIdentifier)serviceIdentifier params:(NSMutableDictionary *)params requestType:(RequestType)requestType Oncompletion:(OnSuccess)successBlock OnFailure:(OnFailure)failureBlock nullResponse:(OnNullResponse)nullResponse{
    
    //check the network status
    if ([ClTUtility  checkNetworkStatus] == NO) {
        nullResponse();
        return;
    }
    
    // [self startNetworkActivityIndicator:serviceIdentifier];
    
    NSMutableURLRequest *finalRequest = nil;
    
    
    
    finalRequest = [[[NSURLRequest alloc] init] getCompleteRequestWithServiceName:[self getServicePAth:serviceIdentifier] params:params type:requestType];
    
    [NSURLConnection sendAsynchronousRequest:finalRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        //        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
               
        //check the error
        if(error != nil) {
            
            
            failureBlock(error);
        }
        else
        {
            //check the data that data instance is not NULL
            if (data) {
                
                NSError *error;
                
                NSMutableDictionary *response;
              //  NSString *responseToken = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                
                //compare the serviceIdentifier with kGetDeviceInfo
               // if (serviceIdentifier==kGetDeviceInfo) {
                    
                    response = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
                    
        //        }
                //copmare the serviceIdentifier with kGetDeviceToken, kGetPin or kGetVerify
//                if (serviceIdentifier==kGetDeviceToken||serviceIdentifier==kGetPin || serviceIdentifier==kGetVerify ) {
//                    response=[[NSMutableDictionary alloc]initWithObjectsAndKeys:responseToken,kResponse, nil];
//                   
//
//                }
            
                //check that response instance is type of NSDictionary class
                if ([response isKindOfClass:[NSDictionary class]] )  {
                    
                    successBlock(response);
                }
                //check NULL responce
                if (!response){
                    nullResponse();
                }
                else{
                    response=nil;
                }
                
            }  else {
                
                nullResponse();
            }
        }
    }];
}

-(void)startNetworkActivityIndicator:(ServiceIdentifier)serviceIdentifier {
    //        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    
    
    
}


-(NSString *)getServicePAth:(ServiceIdentifier)serviceIdentifier {
    switch (serviceIdentifier) {
        case kGetBrandedRooms:
            return @"home_page_property.php";
            break;
        case   kGetBigSaving:
            return @"home_page_big_saving.php";
            break;
        case kPostNearByProperty:
            return @"near_by_property.php";
            break;
        case kGetPopularPropeties:
            return @"popular_properties.php";
            break;
        default:
            return @"";
            break;
    }
}


@end
