//
//  User.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/20/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "User.h"

#define Key_Location @"Location"

@implementation User

//-(User *)initWithUserDetails:(NSDictionary *)dic{
//    self.username = [dic objectForKey:Key_User_Model_Username];
//    self.password = [dic objectForKey:Key_User_Model_Password];
//    return self;
//}


-(User *)initWithHeaderDetails:(NSDictionary *)dic{
    self.username = [dic objectForKey:Key_User_Model_Username];
    self.password = [dic objectForKey:Key_User_Model_Password];
    self.Location = [dic objectForKey:Key_Location];
    self.usernameForProfileUrl = [dic objectForKey:Key_Username_For_Profile_url];
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.username forKey:Key_User_Model_Username];
    [aCoder encodeObject:self.password forKey:Key_User_Model_Password];
    [aCoder encodeObject:self.Location forKey:Key_Location];
    [aCoder encodeObject:self.usernameForProfileUrl forKey:Key_Username_For_Profile_url];

}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self.username = [aDecoder decodeObjectForKey:Key_User_Model_Username];
    self.password = [aDecoder decodeObjectForKey:Key_User_Model_Password];
    self.Location = [aDecoder decodeObjectForKey:Key_Location];
    self.usernameForProfileUrl = [aDecoder decodeObjectForKey:Key_Username_For_Profile_url];
    return self;
}

@end
