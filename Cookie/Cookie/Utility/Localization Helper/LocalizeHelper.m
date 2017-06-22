//
//  LocalizeHelper.m
//  Cookie
//
//  Created by pradeep.chaudhary on 6/22/17.
//  Copyright © 2017 pradeep.chaudhary. All rights reserved.
//

#import "LocalizeHelper.h"

static LocalizeHelper* SingleLocalSystem = nil;

// Pardeep Bundle (not the main bundle!)
static NSBundle* myBundle = nil;


@implementation LocalizeHelper

+ (LocalizeHelper*) sharedLocalSystem {

    if (SingleLocalSystem == nil) {
        SingleLocalSystem = [[LocalizeHelper alloc] init];
    }
    return SingleLocalSystem;
}


- (id) init {
    self = [super init];
    if (self) {
        myBundle = [NSBundle mainBundle];
    }
    return self;
}


- (NSString*) localizedStringForKey:(NSString*) key {
    return [myBundle localizedStringForKey:key value:@"" table:nil];
}


- (void) setLanguage:(NSString*) lang {
    
    // path to this languages bundle
    NSString *path = [[NSBundle mainBundle] pathForResource:lang ofType:@"lproj"];
    if (path == nil) {
        // there is no bundle for that language
        // use main bundle instead
        myBundle = [NSBundle mainBundle];
    } else {
        
        // use this bundle as my bundle from now on:
        myBundle = [NSBundle bundleWithPath:path];
        
        // to be absolutely shure (this is probably unnecessary):
        if (myBundle == nil) {
            myBundle = [NSBundle mainBundle];
        }
    }
}


@end
