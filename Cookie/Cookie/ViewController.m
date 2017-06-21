//
//  ViewController.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/16/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "ViewController.h"
#import "Loginhandler.h"
#import "CommonWebViewController.h"
#import "AppDelegate.h"
#import "NavigationDrawerViewController.h"
#import "User.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserDetails];
    [self setTiteOf];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setTiteOf{
    CGRect frame = CGRectMake(0, 0, 200, 40);
    
    UIView *viewHeader = [[UIView alloc]initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Splash"]];
    imageView.frame = frame;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [viewHeader addSubview:imageView];
    self.navigationItem.titleView = viewHeader;
}

-(void)getUserDetails{
    User *user = [[CommonClass sharedInstance]getUserDetails];
    if(user != nil){
        textfieldEmail.text = user.username;
    }
}

#pragma mark - IBActions
- (IBAction)btnSignInAction:(UIButton *)sender {
    if([self isValid]){
        [self callLoginWebService];
    }
}

- (IBAction)btnRememberAction:(UIButton *)sender {
    buttonRememberMe.selected = !sender.isSelected;
}

- (IBAction)btnSignUpAction:(UIButton *)sender {
    [self pushToWebView:SIGN_UP_URL];
}

- (IBAction)btnForgotPasswordAction:(UIButton *)sender {
    [self pushToWebView:FORGOT_URL];
}

#pragma mark - user defined
-(BOOL)isValid{
    if([textfieldEmail.text isEqualToString:@""]){
        [self showAlert:@"Enter username"];
        return false;
    }else if([textfieldPassword.text isEqualToString:@""]){
        [self showAlert:@"Enter password"];
        return false;
    }
    return true;
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
        
        AppDelegate *delegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
        delegate.window.rootViewController = drawerController;
    });

}

-(void)pushToWebView:(NSString *)url{
    CommonWebViewController *webviewController = [[CommonClass sharedInstance]getCommonWebviewController:url isDrawerEnable:false];
    [self.navigationController pushViewController:webviewController animated:YES];
}


-(void)callLoginWebService{
    Loginhandler *loginHandler = [[Loginhandler alloc]init];
    [loginHandler callLoginService:self.view
                       emailString:textfieldEmail.text
                    passwordString:textfieldPassword.text
                 completionHandler:^(NSInteger statusCode, NSDictionary *headerFields) {
                     if(statusCode == 200){
                         [self showAlert:@"Enter valid credentials"];
                     }else if (statusCode == 302){
                         [self saveCookieDataToUserModel:headerFields];
                         [self showHomeTabBarView];
                     }
                 }];
}

-(void)saveCookieDataToUserModel:(NSDictionary *)headers
{
    //Cookies
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
    NSArray                  *cookies;
    cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:headers forURL:[NSURL URLWithString:LOGIN_URL]];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:cookies forURL:[NSURL URLWithString:LOGIN_URL] mainDocumentURL:nil];
    
    //Saving user details + header fields
    NSMutableDictionary *data = [headers mutableCopy];
    [data setObject:textfieldEmail.text forKey:Key_Username_For_Profile_url];
    
    if(buttonRememberMe.selected){
        [data setObject:textfieldEmail.text forKey:Key_User_Model_Username];
        [data setObject:textfieldPassword.text forKey:Key_User_Model_Password];
    }
    
    [[CommonClass sharedInstance]saveUserDetails:data];        
}

-(void)showHomeTabBarView{
    dispatch_async(dispatch_get_main_queue(), ^{
        User *user = [[CommonClass sharedInstance]getUserDetails];
        NSString *homeUrl = [NSString stringWithFormat:@"%@%@%@",BASE_URL,user.Location,MOBILESITE];
        [self showTabBarHomeView:homeUrl];
    });
}

-(void)showAlert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:K_APP_NAME message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
}


@end
