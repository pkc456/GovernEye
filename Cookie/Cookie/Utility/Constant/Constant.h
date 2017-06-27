//
//  Constant.h
//  Cookie
//
//  Created by pradeep.chaudhary on 6/19/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#ifndef Constant_h
#define Constant_h

//#define BASE_URL  @"http://test.kelltontech.net/citinetpro49"
//#define BASE_URL  @"http://dev.governeye.com/login"
#define BASE_URL  @"http://dev.governeye.com"
#define MOBILESITE @"?mobile=2"

#define LOGIN_URL BASE_URL @"/login" MOBILESITE
//#define HOME_URL BASE_URL "/members/home" MOBILESITE  //This url is dynamic now
#define FORGOT_URL BASE_URL "/user/auth/forgot" MOBILESITE
#define SIGN_UP_URL BASE_URL "/signup" MOBILESITE
#define NOTIFICATION_URL BASE_URL "/activity/notifications" MOBILESITE
#define BOOKMARK_URL BASE_URL "/bookmark/view" MOBILESITE

//Langugage keys. http://www.loc.gov/standards/iso639-2/php/English_list.php
#pragma mark - Localization keys
#define KLANGUAGE_STORE_KEY  @"LangaugeBundleKey"
#define LANGUAGE_HINDI @"hi"
#define LANGUAGE_ENGLISH @"en"

//Links related to navigaiton drawer
#define LOGOUT_URL BASE_URL "/logout"
#define USER_SETTING_URL BASE_URL "/members/settings/general" MOBILESITE
#define USER_PROFILE_URL BASE_URL "/profile/"   //Don't append mobile site here


//USER DEFAULT KEYS
#define KEY_USER_MODEL @"user_model"
#define Key_Username_For_Profile_url @"Key_Username_For_Profile_url"

//MODEL
#define Key_User_Model_Username @"Username"
#define Key_User_Model_Password @"Password"


//Alerts, common
#define K_APP_NAME @"Governeye"


#endif /* Constant_h */
