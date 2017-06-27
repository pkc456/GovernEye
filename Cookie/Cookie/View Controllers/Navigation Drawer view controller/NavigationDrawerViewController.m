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

@interface NavigationDrawerViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation NavigationDrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrayItems = [[NSArray alloc]initWithObjects:[self getLocalizedStringForKey:@"Home"],
                  [self getLocalizedStringForKey:@"User Profile"],
                  [self getLocalizedStringForKey:@"User Settings"],
                  [self getLocalizedStringForKey:@"Logout"],
                nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrayItems.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableviewSideMenu dequeueReusableCellWithIdentifier:@"cell"];
    if(cell == nil){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    NSString *text = arrayItems[indexPath.row];
    cell.textLabel.text = text;
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self closeDrawer];
    switch (indexPath.row) {
        case 0: //Home
        {
            NSString *homeUrl = [NSString stringWithFormat:@"%@%@%@",BASE_URL,self.userObject.Location,MOBILESITE];
            [self showWebScreenWithUrl:homeUrl selectedTabToShow:indexPath.row];
            break;
        }
        case 1: //User Profile
        {
            NSString *url = [NSString stringWithFormat:@"%@%@%@",USER_PROFILE_URL,self.userObject.usernameForProfileUrl,MOBILESITE];
            [self showWebScreenWithUrl:url selectedTabToShow:1];
            break;
        }
        case 2: //User settings
        {
            [self showWebScreenWithUrl:USER_SETTING_URL selectedTabToShow:0];
            break;
        }
        case 3:
        {
            [self updateUserModelObjectOnLogout];
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

-(void)showWebScreenWithUrl:(NSString *)urlString selectedTabToShow:(NSUInteger)selectedTabIndex{
    dispatch_async(dispatch_get_main_queue(), ^{
        //Center
        UITabBarController *tabController = (UITabBarController *) [[CommonClass sharedInstance]getMainTabController];
        
        tabController.selectedIndex = selectedTabIndex;
        UINavigationController *webNavController = (UINavigationController *) [tabController.viewControllers objectAtIndex:selectedTabIndex];
        CommonWebViewController *web = (CommonWebViewController *) webNavController.viewControllers.firstObject;        
        web.urlToLoad = urlString;
        
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

-(void)showLoginScreen{
        UINavigationController *navController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ViewControllerNavController"];
        
        AppDelegate *delegate = (AppDelegate*) [[UIApplication sharedApplication]delegate];
        delegate.window.rootViewController = navController;
}

@end
