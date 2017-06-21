//
//  CommonClass.h
//  Cookie
//
//  Created by pradeep.chaudhary on 6/19/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;

@interface CommonClass : NSObject

+ (CommonClass*) sharedInstance;

-(void)setValueToUserDefault:(NSString *)value andKey:(NSString *)key;
-(id)getValueToUserDefault:(NSString *)key;
-(void)deleteValueFromUserDefault:(NSString *)key;

-(void)showLoader:(UIView *)view;
-(void)hideLoader:(UIView *)view;

-(void)saveUserDetails:(NSDictionary *)dic;
-(User *)getUserDetails;

-(UITabBarController *)getMainTabController;
-(UINavigationController *)getNavigationDrawerController;
@end
