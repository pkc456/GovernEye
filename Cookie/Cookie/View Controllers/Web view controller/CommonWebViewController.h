//
//  CommonWebViewController.h
//  Cookie
//
//  Created by pradeep.chaudhary on 6/19/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface CommonWebViewController : BaseViewController
{
    
    __weak IBOutlet UIWebView *webview;
}

@property (nonatomic, strong)NSString *urlToLoad;

@property IBInspectable BOOL isDrawerEnabled;

@end


////////////**************************************////////////


//      The class is used in xib and Home.storyboard
    
//      Use this view controller when user is signed out. Drawer is disable in xib


////////////**************************************////////////
