//
//  CommonWebViewController.h
//  Cookie
//
//  Created by pradeep.chaudhary on 6/19/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommonWebViewController : UIViewController
{
    
    __weak IBOutlet UIWebView *webview;
}

@property (nonatomic, strong)NSString *urlToLoad;
@property BOOL isDrawerEnabled;


@end
