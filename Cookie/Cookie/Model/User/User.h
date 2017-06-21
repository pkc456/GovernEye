//
//  User.h
//  Cookie
//
//  Created by pradeep.chaudhary on 6/20/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject <NSCoding>

@property (nonatomic, strong)NSString *username;
@property (nonatomic, strong)NSString *password;

//-(User *)initWithUserDetails:(NSDictionary *)dic;


//Header values

@property (nonatomic, strong)NSString *Location;
@property (nonatomic, strong)NSString *usernameForProfileUrl;

-(User *)initWithHeaderDetails:(NSDictionary *)dic;
//
//Accept-Ranges
//Cache-Control
//Connection
//Content-Encoding
//Content-Length
//Content-Type

@end
