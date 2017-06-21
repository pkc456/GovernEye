//
//  Loginhandler.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/21/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "Loginhandler.h"
#import <AFNetworking/AFNetworking.h>

@implementation Loginhandler


-(void)callLoginService:(UIView *)view emailString:(NSString *)email passwordString:(NSString *)password completionHandler:(void (^)(NSInteger statusCode, NSDictionary *headerFields))success
{
    [[CommonClass sharedInstance] showLoader:view];
    NSString *postParams = [NSString stringWithFormat:@"email=%@&password=%@",email,password];
    NSData *data = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *myRequest = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:LOGIN_URL]];
    [myRequest setHTTPMethod:@"POST"];
    [myRequest setHTTPBody:data];
    
    
    AFHTTPRequestOperation *uploadOperation = [[AFHTTPRequestOperation alloc] initWithRequest:myRequest];
    [uploadOperation start];
    [uploadOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id response) {
        [[CommonClass sharedInstance] hideLoader:view];
//        NSLog(@"Request: %@", [operation.request description]);
          success(operation.response.statusCode, nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [[CommonClass sharedInstance] hideLoader:view];
        NSLog(@"error in login handler: %@",error.localizedDescription);
        success(0, nil);
    }];
    
    [uploadOperation setRedirectResponseBlock:^NSURLRequest *(NSURLConnection *connection, NSURLRequest *request, NSURLResponse *redirectResponse) {
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) redirectResponse;
        
        NSInteger statusCode = httpResponse.statusCode;
        if(statusCode == 302){
            request = nil;
            success(httpResponse.statusCode, httpResponse.allHeaderFields);
        }
        
        return request;
    }];
}

@end
