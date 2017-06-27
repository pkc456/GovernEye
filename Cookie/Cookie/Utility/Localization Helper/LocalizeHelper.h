//
//  LocalizeHelper.h
//  Cookie
//
//  Created by pradeep.chaudhary on 6/22/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface LocalizeHelper : NSObject

+ (LocalizeHelper*) sharedLocalSystem;

- (NSString*) localizedStringForKey:(NSString*) key;
- (void) setLanguage:(NSString*) lang;

@end
