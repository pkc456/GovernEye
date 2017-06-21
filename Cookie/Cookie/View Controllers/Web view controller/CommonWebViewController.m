//
//  CommonWebViewController.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/19/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "CommonWebViewController.h"
#import "MMDrawerBarButtonItem.h"

@interface CommonWebViewController () <UIWebViewDelegate>

@end

@implementation CommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUrlVariable];
    [self setupLeftMenuButton];
    [self setUIElements];
    [self loadWebView];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    //po self.tabBarController.tabBar.selectedItem.title        //To get selected tab index when it is clicked. This can be used in loading a different url when tab bar item is cliked
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - User defined methods

-(void)setUpUrlVariable{
    //Set the default url in case of tab bar

    if(self.tabBarController != nil){
        
        if([self.urlToLoad isEqualToString:@""] || self.urlToLoad == nil){
            switch (self.tabBarController.selectedIndex) {
                case 0:
                {                    
                    NSString *homeUrl = [NSString stringWithFormat:@"%@%@%@",BASE_URL,self.userObject.Location,MOBILESITE];
                    self.urlToLoad = homeUrl;
                    break;
                }
                case 1:
                {
                    NSString *profileUrl = [NSString stringWithFormat:@"%@%@%@",USER_PROFILE_URL,self.userObject.usernameForProfileUrl,MOBILESITE];
                    self.urlToLoad = profileUrl;
                    break;
                }
                case 2:
                {
                    self.urlToLoad = BOOKMARK_URL;
                    break;
                }
                    
                default:
                    break;
            }
        }
    }
}

-(void)setUIElements{
    CGRect frame = CGRectMake(0, 0, 200, 40);
    
    UIView *viewHeader = [[UIView alloc]initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Splash"]];
    imageView.frame = frame;
    imageView.contentMode = UIViewContentModeScaleToFill;
    [viewHeader addSubview:imageView];
    self.navigationItem.titleView = viewHeader;
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
}

-(void)setupLeftMenuButton{
    if(self.isDrawerEnabled == true){
        MMDrawerBarButtonItem * leftDrawerButton = [[MMDrawerBarButtonItem alloc] initWithTarget:self action:@selector(leftDrawerButtonPress:)];
        [self.navigationItem setLeftBarButtonItem:leftDrawerButton];
    }
}

-(void)leftDrawerButtonPress:(id)sender{
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
}

-(void)loadWebView{
    if([self.urlToLoad isEqualToString:@""] || self.urlToLoad == nil){
        NSAssert(false, @"PLEASE PROVIDE urlToLoad VARIABLE");
    }else{
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.urlToLoad]];
        [webview loadRequest:request];
    }
}

#pragma mark - IBACtions
- (IBAction)btnNotificationAction:(UIBarButtonItem *)sender {
    CommonWebViewController *webviewController = [[CommonClass sharedInstance]getCommonWebviewControllerFromXib:NOTIFICATION_URL];
    [self.navigationController pushViewController:webviewController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    [[CommonClass sharedInstance] showLoader:self.view];
    return true;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[CommonClass sharedInstance] hideLoader:self.view];

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[CommonClass sharedInstance] hideLoader:self.view];
}


@end
