//
//  NavigationDrawerViewController.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/19/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "NavigationDrawerViewController.h"
#import "AppDelegate.h"
#import "CommonWebViewController.h"
#import "User.h"

@interface NavigationDrawerViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NavigationDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableviewSideMenu dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *text = @"";
    switch (indexPath.row) {
        case 0:
            text = @"Home";
            break;
        case 1:
            text = @"My Feed";
            break;
        case 2:
            text = @"User Profile";
            break;
        case 3:
            text = @"User Settings";
            break;
        case 4:
            text = @"Logout";
            break;
        default:
            break;
    }
    cell.textLabel.text = text;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self closeDrawer];
    switch (indexPath.row) {
        case 0: //Home
        {
            User *user = [[CommonClass sharedInstance]getUserDetails];
            NSString *homeUrl = [NSString stringWithFormat:@"%@%@%@",BASE_URL,user.Location,MOBILESITE];
            [self showWebScreenWithUrl:homeUrl];
            break;
        }
        case 1:
        {
            break;
        }
        case 2: //User Profile
        {
            User *user = [[CommonClass sharedInstance]getUserDetails];
            NSString *url = [NSString stringWithFormat:@"%@%@%@",USER_PROFILE_URL,user.usernameForProfileUrl,MOBILESITE];
            [self showWebScreenWithUrl:url];
            break;
        }
        case 3: //User settings
        {
            [self showWebScreenWithUrl:USER_SETTING_URL];
            break;
        }
        case 4:
        {
            [self showLoginScreen];
            break;
        }
            
        default:
            break;
    }
    

}

-(void)closeDrawer{
    [self.mm_drawerController closeDrawerAnimated:true completion:nil];
}

-(void)showWebScreenWithUrl:(NSString *)urlString{
    dispatch_async(dispatch_get_main_queue(), ^{
        //Center
        CommonWebViewController *web = [[CommonWebViewController alloc]initWithNibName:@"CommonWebViewController" bundle:nil];
        web.urlToLoad = urlString;
        web.isDrawerEnabled = true;
        UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:web];
        navController.navigationBar.translucent = false;
        
        //left
        UINavigationController *navDrawer = [self getNavigationController];
        
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
}

-(void)showLoginScreen{
    dispatch_async(dispatch_get_main_queue(), ^{        
        UINavigationController *navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewControllerNavController"];
        
        AppDelegate *delegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
        delegate.window.rootViewController = navController;
    });
}

-(UINavigationController *)getNavigationController{
    UINavigationController *navDrawer = [[UIStoryboard storyboardWithName:@"NavigationDrawer" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationDrawerNavViewController"];
    return navDrawer;
}

@end
