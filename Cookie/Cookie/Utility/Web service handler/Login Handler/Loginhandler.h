//
//  Loginhandler.h
//  Cookie
//
//  Created by pradeep.chaudhary on 6/21/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Loginhandler : NSObject

-(void)callLoginService:(UIView *)view emailString:(NSString *)email passwordString:(NSString *)password completionHandler:(void (^)(NSInteger statusCode, NSDictionary *headerFields))success;

@end
