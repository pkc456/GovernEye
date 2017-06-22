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





//////////////*******************************/////////////////

            //1. On logout, Location will be deleted.
            //2. On Auto login at app delete, Location will be checked.


//////////////*******************************/////////////////
@end
