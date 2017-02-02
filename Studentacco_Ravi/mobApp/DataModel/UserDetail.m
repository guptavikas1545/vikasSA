//
//  UserDetail.m
//  mobApp
//
//  Created by MAG  on 6/25/16.
//  Copyright © 2016 MAG. All rights reserved.
//

#import "UserDetail.h"

@implementation UserDetail

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.userid forKey:@"userid"];
    [encoder encodeObject:self.usertype forKey:@"usertype"];
    [encoder encodeObject:self.username forKey:@"username"];
    
    [encoder encodeObject:self.firstname forKey:@"firstname"];
    [encoder encodeObject:self.lastname forKey:@"lastname"];
    [encoder encodeObject:self.email forKey:@"email"];
    [encoder encodeObject:self.gender forKey:@"gender"];
    
    [encoder encodeObject:self.mobile forKey:@"mobile"];
    [encoder encodeObject:self.addressline1 forKey:@"addressline1"];
    [encoder encodeObject:self.addressline2 forKey:@"addressline2"];
    
    [encoder encodeObject:self.city forKey:@"city"];
    [encoder encodeObject:self.state forKey:@"state"];
    [encoder encodeObject:self.country forKey:@"country"];
    
    [encoder encodeObject:self.pin forKey:@"pin"];
    [encoder encodeObject:self.profile_picture forKey:@"profile_picture"];
    [encoder encodeObject:self.dob forKey:@"dob"];
    [encoder encodeObject:self.education forKey:@"education"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.userid = [decoder decodeObjectForKey:@"userid"];
        self.usertype = [decoder decodeObjectForKey:@"usertype"];
        self.username = [decoder decodeObjectForKey:@"username"];
        
        self.firstname = [decoder decodeObjectForKey:@"firstname"];
        self.lastname = [decoder decodeObjectForKey:@"lastname"];
        self.email = [decoder decodeObjectForKey:@"email"];
        self.gender = [decoder decodeObjectForKey:@"gender"];
        
        self.mobile = [decoder decodeObjectForKey:@"mobile"];
        self.addressline1 = [decoder decodeObjectForKey:@"addressline1"];
        self.addressline2 = [decoder decodeObjectForKey:@"addressline2"];
        
        self.city = [decoder decodeObjectForKey:@"city"];
        self.state = [decoder decodeObjectForKey:@"state"];
        self.country = [decoder decodeObjectForKey:@"country"];
        
        self.pin = [decoder decodeObjectForKey:@"pin"];
        self.profile_picture = [decoder decodeObjectForKey:@"profile_picture"];
        self.dob = [decoder decodeObjectForKey:@"dob"];
        self.education = [decoder decodeObjectForKey:@"education"];
    }
    return self;
}

@end
