//
//  BaseViewController.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/21/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUserDataBaseObj];
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)configureUserDataBaseObj {
    self.userObject = [[CommonClass sharedInstance]getUserDetails];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)showAlert:(NSString *)message type:(RMessageType )messageType{
    [RMessage showNotificationWithTitle:@""
                               subtitle:message
                                   type:messageType
                         customTypeName:nil
                               callback:nil];
}
@end
