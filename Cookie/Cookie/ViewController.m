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
//#import "NavigationDrawerViewController.h"

#import "LoginCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getUserDetails];
    [self setTiteOf];
    [self setLocalizedStringOnUIElements];
    // Do any additional setup after loading the view, typically from a nib.
    
    arrayLanguage = [[NSArray alloc]initWithObjects:@"मराठी",@"नेपाली",@"ଓଡ଼ିଆ",@"ਪੰਜਾਬੀ",@"संस्कृत",@"தமிழ்",@"తెలుగు",@"മലയാളം",@"English",@"অসমীয়া",@"हिन्दी",@"ગુજરાતી",@"বাঙালি",@"Bodo",@"Dogri",@"ಕನ್ನಡ",@"Kashmiri",@"Konkani",@"اردو",nil];
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


-(void)setLocalizedStringOnUIElements{
    //https://stackoverflow.com/a/39071660/988169       //To prevent UIButton's title flashing
//    [UIView performWithoutAnimation:^{
    //        [buttonForgotPassword layoutIfNeeded];
    //        [buttonSignIn layoutIfNeeded];
    //        [buttonSignUp layoutIfNeeded];
    //    }];
    
        [buttonForgotPassword setTitle:[self getLocalizedStringForKey:@"Forgot Password"]
                              forState:UIControlStateNormal];
        [buttonSignIn setTitle:[self getLocalizedStringForKey:@"SIGN IN"]
                      forState:UIControlStateNormal];
        [buttonSignUp setTitle:[self getLocalizedStringForKey:@"Create an Account"]
                      forState:UIControlStateNormal];
        
        textfieldEmail.placeholder = [self getLocalizedStringForKey:@"Username"];
        textfieldPassword.placeholder = [self getLocalizedStringForKey:@"Password"];
}


-(void)getUserDetails{
    if(self.userObject != nil){
        textfieldEmail.text = self.userObject.username;
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

- (IBAction)btnHindiAction:(UIButton *)sender {
    [self setDefaultLanguageOfApp:LANGUAGE_HINDI];
    [self setLocalizedStringOnUIElements];
}

- (IBAction)btnEnglishAction:(UIButton *)sender {
    [self setDefaultLanguageOfApp:LANGUAGE_ENGLISH];
    [self setLocalizedStringOnUIElements];
}


#pragma mark - user defined
-(BOOL)isValid{
    if([textfieldEmail.text isEqualToString:@""]){
        [self showAlert:[self getLocalizedStringForKey:@"Enter username"] type:RMessageTypeError];
        return false;
    }else if([textfieldPassword.text isEqualToString:@""]){
        [self showAlert:[self getLocalizedStringForKey:@"Enter password"] type:RMessageTypeError];
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
    CommonWebViewController *webviewController = [[CommonClass sharedInstance]getCommonWebviewControllerFromXib:url];
    [self.navigationController pushViewController:webviewController animated:YES];
}


-(void)callLoginWebService{
    Loginhandler *loginHandler = [[Loginhandler alloc]init];
    [loginHandler callLoginService:self.view
                       emailString:textfieldEmail.text
                    passwordString:textfieldPassword.text
                 completionHandler:^(NSInteger statusCode, NSDictionary *headerFields) {
                     if(statusCode == 200){
                         [self showAlert:[self getLocalizedStringForKey:@"Enter valid credentials"] type:RMessageTypeError];
                     }else if (statusCode == 302){
                         [self saveCookieDataToUserModel:headerFields];
                         [self showHomeTabBarView];
                     }
                 }];
}

-(void)saveCookieDataToUserModel:(NSDictionary *)headers
{
    [self saveCookies:headers];        
    
    //Saving user details + header fields
    NSMutableDictionary *data = [headers mutableCopy];
    [data setObject:textfieldEmail.text forKey:Key_Username_For_Profile_url];
    
    if(buttonRememberMe.selected){
        [data setObject:textfieldEmail.text forKey:Key_User_Model_Username];
        [data setObject:textfieldPassword.text forKey:Key_User_Model_Password];
    }
    
    [[CommonClass sharedInstance]saveUserDetails:data];
    self.userObject = [[CommonClass sharedInstance]getUserDetails];
}

-(void)showHomeTabBarView{
    NSString *homeUrl = [NSString stringWithFormat:@"%@%@%@",BASE_URL,self.userObject.Location,MOBILESITE];
    [self showTabBarHomeView:homeUrl];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return true;
}
#pragma mark - Collection view delegates and datasource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return arrayLanguage.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    LoginCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.layer.borderColor = [[UIColor lightGrayColor]CGColor];
    cell.layer.borderWidth = 1.0f;
    cell.layer.cornerRadius = 3.0f;
    
    cell.labelName.text = arrayLanguage[indexPath.row];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LoginCollectionViewCell *myCell =  (LoginCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    
    //NSLog(@"%@",myCell.labelName.font);
    CGRect  sizeFromString = [self getTextHeightFromString:arrayLanguage[indexPath.row] ViewWidth:myCell.frame.size.width WithPading:0 Font:[UIFont systemFontOfSize:14.0]];
    
    return CGSizeMake(sizeFromString.size.width, sizeFromString.size.height);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:             //मराठी
        {
            break;
        }
        case 1:             //नेपाली
        {
            break;
        }
        case 2:             //ଓଡ଼ିଆ
        {
            break;
        }
        case 3:             //ਪੰਜਾਬੀ
        {
            break;
        }
        case 4:             //संस्कृत
        {
            break;
        }
        case 5:             //தமிழ்
        {
            break;
        }
        case 6:             //తెలుగు
        {
            break;
        }
        case 7:             //മലയാളം
        {
            break;
        }
        case 8:             //English
        {
            [self setDefaultLanguageOfApp:LANGUAGE_ENGLISH];
            break;
        }
        case 9:             //অসমীয়া
        {
            break;
        }
        case 10:             //हिन्दी
        {
            [self setDefaultLanguageOfApp:LANGUAGE_HINDI];
            break;
        }
        case 11:             //ગુજરાતી
        {
            break;
        }
        case 12:             //বাঙালি
        {
            break;
        }
        case 13:             //Bodo
        {
            break;
        }
        case 14:             //Dogri
        {
            break;
        }
        case 15:             //ಕನ್ನಡ
        {
            break;
        }
        case 16:             //Kashmiri
        {
            break;
        }
        case 17:             //Konkani
        {
            break;
        }
        case 18:             //اردو
        {
            break;
        }
        default:
            break;
    }
    
    [self setLocalizedStringOnUIElements];
//    NSLog(@"%ld",(long)indexPath.row);
}


- (CGRect)getTextHeightFromString:(NSString *)text ViewWidth:(CGFloat)width WithPading:(CGFloat)pading Font:(UIFont *)font
{
    NSDictionary *attributes = @{NSFontAttributeName: font};
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:attributes
                                     context:nil];
    
    //Adding horizontal and vertical Padding
    rect.size.width += 10;
    rect.size.height += 5;
    return rect;
}

@end
