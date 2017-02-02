//
//  UserDetail.h
//  mobApp
//
//  Created by MAG  on 6/25/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserDetail : NSObject
/*
 {"userid":"1374","usertype":"Property Owner","username":"nvn4425@gmail.com","firstname":"Naveen","lastname":"kumar","email":"nvn4425@gmail.com","mobile":"9540489990","addressline1":"asdf","addressline2":"testing","city":"New Delhi","state":"Delhi","country":"India","pin":"123213","active":"1","userImage":"http:\/\/www.studentacco.com\/uploads\/users\/Koala.jpg"
 */
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *usertype;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *firstname;
@property (nonatomic, strong) NSString *lastname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *addressline1;
@property (nonatomic, strong) NSString *addressline2;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *pin;
@property (nonatomic, strong) NSURL    *profile_picture;
@property (nonatomic, strong) NSString *dob;
@property (nonatomic, strong) NSString *education;
@end
