//
//  ViewController.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/16/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
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
    [self pushToWebView:SIGN_UP_URL isNavigationDrawerEnabled:false];
}

- (IBAction)btnForgotPasswordAction:(UIButton *)sender {
    [self pushToWebView:FORGOT_URL isNavigationDrawerEnabled:false];
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

-(void)pushToWebView:(NSString *)url isNavigationDrawerEnabled:(BOOL)isDrawerEnable{
    CommonWebViewController *webviewController = [[CommonWebViewController alloc]initWithNibName:@"CommonWebViewController" bundle:nil];
    webviewController.urlToLoad = url;
    webviewController.isDrawerEnabled = isDrawerEnable;
    
    if(isDrawerEnable == true){
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //Center
            UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:webviewController];
            navController.navigationBar.translucent = false;
            
            //left
            UINavigationController *navDrawer = [[UIStoryboard storyboardWithName:@"NavigationDrawer" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationDrawerNavViewController"];
            
            //Main drawer
            MMDrawerController * drawerController = [[MMDrawerController alloc]
                                                     initWithCenterViewController:navController
                                                     leftDrawerViewController:navDrawer
                                                     rightDrawerViewController:nil];
            
            [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
            [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
            
            AppDelegate *delegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
            delegate.window.rootViewController = drawerController;
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:webviewController animated:YES];
        });
    }
}


-(void)callLoginWebService{
    [[CommonClass sharedInstance] showLoader:self.view];
    NSString *postParams = [NSString stringWithFormat:@"email=%@&password=%@",textfieldEmail.text,textfieldPassword.text];
    NSData *data = [postParams dataUsingEncoding:NSUTF8StringEncoding];

    NSMutableURLRequest *myRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:LOGIN_URL]];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody:data];
    
    
    AFHTTPRequestOperation *uploadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    [uploadOperation start];
    [uploadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        NSLog(@"Request: %@", [operation.request description]);
        NSLog(@"CODE: %li",(long)operation.response.statusCode);
//        NSLog(@"Response: %@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        
        if(operation.response.statusCode == 200){
            [self showAlert:@"Enter valid credentials"];
        }
        [[CommonClass sharedInstance] hideLoader:self.view];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CommonClass sharedInstance] hideLoader:self.view];
        NSLog(@"error: %@",error);
    }];
    
    [uploadOperation setRedirectResponseBlock:^NSURLRequest *(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) redirectResponse;
        NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);
        
        NSInteger statusCode = httpResponse.statusCode;
        if(statusCode == 302){
            request = nil;
            NSLog(@"Header field%@",httpResponse.allHeaderFields);
            
            //Cookies
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];
            NSArray                  *cookies;
            cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:[NSURL URLWithString:LOGIN_URL]];
            [[NSHTTPCookieStorage sharedHTTPCookieStorage]setCookies:cookies forURL:[NSURL URLWithString:LOGIN_URL] mainDocumentURL:nil];
              
            
            //Saving user details + header fields
            NSMutableDictionary *data = [httpResponse.allHeaderFields mutableCopy];
            [data setObject:textfieldEmail.text forKey:Key_Username_For_Profile_url];
            
            if(buttonRememberMe.selected){
                [data setObject:textfieldEmail.text forKey:Key_User_Model_Username];
                [data setObject:textfieldPassword.text forKey:Key_User_Model_Password];
            }
            
          [[CommonClass sharedInstance]saveUserDetails:data];            
            
            User *user = [[CommonClass sharedInstance]getUserDetails];
            NSString *homeUrl = [NSString stringWithFormat:@"%@%@%@",BASE_URL,user.Location,MOBILESITE];
            [self pushToWebView:homeUrl isNavigationDrawerEnabled:true];
        }
        
        
        return request;
    }];
}

-(void)showAlert:(NSString *)message{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:K_APP_NAME message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:true completion:nil];
}


@end
