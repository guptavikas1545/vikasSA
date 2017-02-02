
#import "URLConnection.h" 


@implementation URLConnection


@synthesize receivedData;
@synthesize delegate;

//@synthesize delegate;


#pragma mark - Get Data From Server Method

/*
    --------------------------------------------------------------------------------------------
    This method gets the query string URL to make a request and then initiate NSURLConnection with that request.
    --------------------------------------------------------------------------------------------
*/

- (void)getDataFromUrl:(NSString *)requestString webService:(NSString*)stringURL
{
    // Allocate and initialize an NSURLConnection with the given request and delegate. The asynchronous URL load process is started as part of this method.
    
    NSData *postData = [requestString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    NSLog(@"%lu",(unsigned long)[postData length]);
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:stringURL] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:300];
    
    
    if (requestString) {
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"tapplication/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
    }
    else
    {
        [request setHTTPMethod:@"GET"];
    }
    
    theConnection = [NSURLConnection connectionWithRequest:request delegate:self];
    
	if (theConnection) {
        receivedData = [[NSMutableData alloc] init];
	}
}


#pragma mark - Connection delegate Methods

/*
    --------------------------------------------------------------------------------------------
    This method gives the delegate an opportunity to inspect the NSCachedURLResponse that will be stored in the cache, and modify it if necessary.
    --------------------------------------------------------------------------------------------
*/

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse  {
	return nil;
}


/*
    --------------------------------------------------------------------------------------------
    This method is called when the URL loading system has received sufficient load data to construct a NSURLResponse object.
    --------------------------------------------------------------------------------------------
*/

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}


/*
    --------------------------------------------------------------------------------------------
    This method is called to deliver the content of a URL load.
    --------------------------------------------------------------------------------------------
*/

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];	
}


/*
    --------------------------------------------------------------------------------------------
    This method is called when an NSURLConnection has finished loading successfully.
    --------------------------------------------------------------------------------------------
*/

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {    
	theConnection = nil;
    NSString *str = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
    
    [delegate connectionFinishLoading:receivedData];
}


/*
    --------------------------------------------------------------------------------------------
    This method is called when an NSURLConnection has failed to load successfully.
    --------------------------------------------------------------------------------------------
*/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	theConnection = nil;
    receivedData = nil;  
    
	[delegate connectionFailWithError:error];
}

@end