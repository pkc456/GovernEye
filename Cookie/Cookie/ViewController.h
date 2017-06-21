//
//  ViewController.h
//  Cookie
//
//  Created by pradeep.chaudhary on 6/16/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
{
    
    __weak IBOutlet UIWebView *webview;
    __weak IBOutlet UITextField *textfieldEmail;
    
    __weak IBOutlet UIButton *buttonRememberMe;
    __weak IBOutlet UITextField *textfieldPassword;
    
}

@end

