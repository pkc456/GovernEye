//
//  NavigationDrawerViewController.h
//  Cookie
//
//  Created by pradeep.chaudhary on 6/19/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface NavigationDrawerViewController : BaseViewController
{
    
    __weak IBOutlet UITableView *tableviewSideMenu;
}
@end
