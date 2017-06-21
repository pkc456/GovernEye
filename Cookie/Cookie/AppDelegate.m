//
//  AppDelegate.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/16/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "AppDelegate.h"
#import "CommonWebViewController.h"
#import "User.h"
#import "Loginhandler.h"

@interface AppDelegate ()
{
    dispatch_semaphore_t semaphore;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [self autoLogin];
    
    
    User *user = [[CommonClass sharedInstance]getUserDetails];
    if(user != nil && user.username != nil){
        [self showHomeTabBarView];
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - autologin
-(void)autoLogin{
    semaphore = dispatch_semaphore_create(0);
    
   
    
    User *user = [[CommonClass sharedInstance]getUserDetails];
    if(user != nil && user.username != nil){
        [self callLoginWebService:user.username passwordString:user.password];
    }else{
        dispatch_semaphore_signal(semaphore);
    }
    
    
    while (dispatch_semaphore_wait(semaphore, DISPATCH_TIME_NOW)) { //2
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:100]];
    }
    
}

-(void)callLoginWebService:(NSString *)username passwordString:(NSString *)password{
    
    Loginhandler *loginHandler = [[Loginhandler alloc]init];
    [loginHandler callLoginService:self.window.rootViewController.view
                       emailString:username
                    passwordString:password
                 completionHandler:^(NSInteger statusCode, NSDictionary *headerFields) {
                     if(statusCode == 200){
                         dispatch_semaphore_signal(semaphore);
                     }else if (statusCode == 302){
                         [self saveCookieDataToUserModel:headerFields usernameString:username passwordString:password];
                         dispatch_semaphore_signal(semaphore);
                     }
                 }];
}

-(void)saveCookieDataToUserModel:(NSDictionary *)headers usernameString:(NSString *)username passwordString:(NSString *)password
{
    //Cookies
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray                  *cookies;
    cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:[NSURL URLWithString:LOGIN_URL]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:cookies forURL:[NSURL URLWithString:LOGIN_URL] mainDocumentURL:nil];
    
    //Saving user details + header fields
    NSMutableDictionary *data = [headers mutableCopy];
    [data setObject:username forKey:Key_Username_For_Profile_url];
    [data setObject:username forKey:Key_User_Model_Username];
    [data setObject:password forKey:Key_User_Model_Password];
    
    [[CommonClass sharedInstance]saveUserDetails:data];
}

#pragma mark - tab b ar view
-(void)showHomeTabBarView{
    dispatch_async(dispatch_get_main_queue(), ^{
        User *user = [[CommonClass sharedInstance]getUserDetails];
        NSString *homeUrl = [NSString stringWithFormat:@"%@%@%@",BASE_URL,user.Location,MOBILESITE];
        [self showTabBarHomeView:homeUrl];
    });
}

-(void)showTabBarHomeView:(NSString *)url{
    dispatch_async(dispatch_get_main_queue(), ^{
        //Center
        UITabBarController *tabController = (UITabBarController *) [[CommonClass sharedInstance]getMainTabController];
        UINavigationController *webNavController = (UINavigationController *) [tabController.viewControllers firstObject];
        CommonWebViewController *web = (CommonWebViewController *) webNavController.viewControllers.firstObject;
        web.urlToLoad = url;
        web.isDrawerEnabled = true;
        
        //left
        UINavigationController *navDrawer = [[CommonClass sharedInstance] getNavigationDrawerController];
        
        //Main drawer
        MMDrawerController * drawerController = [[MMDrawerController alloc]
                                                 initWithCenterViewController:tabController
                                                 leftDrawerViewController:navDrawer
                                                 rightDrawerViewController:nil];
        
        [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        
        self.window.rootViewController = drawerController;
    });
    
}

@end
