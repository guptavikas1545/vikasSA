//
//  FindRoomyListDetail.m
//  Studentacco
//
//  Created by MAG on 08/09/16.
//  Copyright © 2016 atul. All rights reserved.
//

#import "FindRoomyListDetail.h"

@implementation FindRoomyListDetail
- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.full_image_path forKey:@"full_image_path"];
    [encoder encodeObject:self.users_full_name forKey:@"users_full_name"];
    [encoder encodeObject:self.share_my_acco forKey:@"share_my_acco"];
    
    [encoder encodeObject:self.food_habits forKey:@"food_habits"];
    [encoder encodeObject:self.smoking_habits forKey:@"smoking_habits"];
    [encoder encodeObject:self.tell_us_about_yourself forKey:@"tell_us_about_yourself"];
}
- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.full_image_path = [decoder decodeObjectForKey:@"full_image_path"];
        self.users_full_name = [decoder decodeObjectForKey:@"users_full_name"];
        self.share_my_acco = [decoder decodeObjectForKey:@"share_my_acco"];
        
        self.food_habits = [decoder decodeObjectForKey:@"food_habits"];
        self.smoking_habits = [decoder decodeObjectForKey:@"smoking_habits"];
        self.tell_us_about_yourself = [decoder decodeObjectForKey:@"tell_us_about_yourself"];
    }
    return self;
}
@end
