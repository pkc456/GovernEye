//
//  BaseViewController.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/21/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

//The use of this method is because of app delegate. We create instance of base view controller in app delegate.
-(instancetype)init{
    [self configureUserDataBaseObj];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureUserDataBaseObj];
}


#pragma mark - user object
- (void)configureUserDataBaseObj {
    self.userObject = [[CommonClass sharedInstance]getUserDetails];
}

-(void)updateUserModelObjectOnLogout{
    [self deleteCookies];
    self.userObject.usernameForProfileUrl = nil;
    [[CommonClass sharedInstance]saveUserDetailsWithUserObject:self.userObject];
}

-(BOOL)isUserObjectExist{
    if(self.userObject != nil && self.userObject.usernameForProfileUrl != nil){
        return true;
    }else{
        return false;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Cookies
-(void)saveCookies:(NSDictionary *)headers{
    //Cookies
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray                  *cookies;
    cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:[NSURL URLWithString:LOGIN_URL]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:cookies forURL:[NSURL URLWithString:LOGIN_URL] mainDocumentURL:nil];
    
}

-(void)deleteCookies{
    NSArray *cookieArray = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:LOGIN_URL]];
    
    for (NSHTTPCookie *cookie in cookieArray) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage]deleteCookie:cookie];
    }
}

#pragma mark - Alert
-(void)showAlert:(NSString *)message type:(RMessageType )messageType{
    [RMessage showNotificationWithTitle:@""
                               subtitle:message
                                   type:messageType
                         customTypeName:nil
                               callback:nil];
}


@end
