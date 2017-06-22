//
//  CommonClass.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/19/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "CommonClass.h"
#import "User.h"
#import "CommonWebViewController.h"

@implementation CommonClass

+ (CommonClass*) sharedInstance {
    static __strong CommonClass *utility = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        utility = [[self alloc] init];
    });
    
    return utility;
}

-(void)setValueToUserDefault:(NSString *)value andKey:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] setValue:value forKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(id)getValueToUserDefault:(NSString *)key{
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
}

-(void)deleteValueFromUserDefault:(NSString *)key{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


#pragma mark - user model object
-(void)saveUserDetails:(NSDictionary *)dic{
    User *user = [[User alloc]initWithHeaderDetails:dic];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KEY_USER_MODEL];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(void)saveUserDetailsWithUserObject:(User *)userObject{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userObject];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:KEY_USER_MODEL];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

-(User *)getUserDetails{
    NSData *userData =  [self getValueToUserDefault:KEY_USER_MODEL];
    if(userData ==nil){
        return nil;
    }else{
        User *user = [NSKeyedUnarchiver unarchiveObjectWithData:userData];
        return user;
    }
}

#pragma mark - Loader
-(void)showLoader:(UIView *)view{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showHUDAddedTo:view animated:YES];
    });
}

-(void)hideLoader:(UIView *)view{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:YES];
    });
}


#pragma mark - Main tab
-(UITabBarController *)getMainTabController{
    return [[UIStoryboard storyboardWithName:@"Home" bundle:nil] instantiateViewControllerWithIdentifier:@"MainTabController"];
}

-(UINavigationController *)getNavigationDrawerController{
    UINavigationController *navDrawer = [[UIStoryboard storyboardWithName:@"NavigationDrawer" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationDrawerNavViewController"];
    return navDrawer;
}

#pragma mark - Common web controller using xib
-(CommonWebViewController *)getCommonWebviewControllerFromXib:(NSString *)url
{
    //isDrawerEnabled is disabled by default in xib
    CommonWebViewController *webviewController = [[CommonWebViewController alloc]initWithNibName:@"CommonWebViewController" bundle:nil];
    webviewController.urlToLoad = url;
    return webviewController;
}

@end
