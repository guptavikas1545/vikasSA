#import "CalloutMapAnnotation.h"

@interface CalloutMapAnnotation()


@end

@implementation CalloutMapAnnotation

@synthesize latitude    = _latitude;
@synthesize longitude   = _longitude;
@synthesize image       = _image;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
             withImage:(UIImage*)pinImage {
	if (self = [super init]) {
		self.latitude = latitude;
		self.longitude = longitude;
        self.image = pinImage;
	}
	return self;
}
- (CLLocationCoordinate2D)coordinate {
	CLLocationCoordinate2D coordinate;
	coordinate.latitude = self.latitude;
	coordinate.longitude = self.longitude;
	return coordinate;
}



@end
