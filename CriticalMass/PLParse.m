//
//  PLParse.m
//  CriticalMaps
//
//  Created by Norman Sander on 14.09.15.
//  Copyright © 2015 Pokus Labs. All rights reserved.
//

#import "PLParse.h"
#import <Parse/Parse.h>

@implementation PLParse
+ (void)setupParse {
    // Enable storing and querying data from Local Datastore. Remove this line if you don't want to
    // use Local Datastore features or want to use cachePolicy.
    [Parse enableLocalDatastore];
    [Parse setApplicationId:@"EnYQ8ovquhE2e5pgjln8XWt1lU5rD4VddJgr01on"
                  clientKey:@"JcmKjiSY5beFVX9mk51VV5qkVWl3KgEnQyG2lYCI"];
    
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}
@end
