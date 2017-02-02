#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CalloutMapAnnotation : NSObject <MKAnnotation> {
	CLLocationDegrees _latitude;
	CLLocationDegrees _longitude;
    UIImage * _image;
}

@property (nonatomic) CLLocationDegrees latitude;
@property (nonatomic) CLLocationDegrees longitude;
@property (nonatomic) UIImage * image;

- (id)initWithLatitude:(CLLocationDegrees)latitude
		  andLongitude:(CLLocationDegrees)longitude
             withImage:(UIImage*)pinImage;

@end
