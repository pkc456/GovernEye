//
//  BaseViewController.h
//  Cookie
//
//  Created by pradeep.chaudhary on 6/21/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "RMessageView.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong) User *userObject;

-(void)showAlert:(NSString *)message type:(RMessageType )messageType;

@end
