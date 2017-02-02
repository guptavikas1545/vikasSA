
#import <Foundation/Foundation.h>

@protocol ConnectionDelegate

@required

- (void)connectionFinishLoading:(NSMutableData *)receiveData;

- (void)connectionFailWithError:(NSError *)error;

@end

@interface URLConnection : NSObject 
{
    NSMutableData *receivedData;    
	NSURLConnection  *theConnection;
        
	id delegate;
}

@property (nonatomic, strong) id  delegate;

@property (nonatomic, strong) NSMutableData *receivedData;

- (void)getDataFromUrl:(NSString *)requestString webService:(NSString*)stringURL;


@end
