//
//  PLParse.m
//  CriticalMaps
//
//  Created by Norman Sander on 14.09.15.
//  Copyright © 2015 Pokus Labs. All rights reserved.
//

#import "PLParse.h"
#import <Parse/Parse.h>
#import <Keys/CriticalmapsKeys.h>

@implementation PLParse
+ (void)setupParse {
    // Enable storing and querying data from Local Datastore. Remove this line if you don't want to
    // use Local Datastore features or want to use cachePolicy.
    [Parse enableLocalDatastore];
    CriticalmapsKeys *keyStore = [[CriticalmapsKeys alloc]init];
    [Parse setApplicationId:keyStore.parseApplicationId
                  clientKey:keyStore.parseClientKey];
    
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
}
@end
