//
//  SessionCache.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 4/2/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "SessionCache.h"
#import "User.h"
#import "UsersAPIClient.h"

//Keys
static NSString * const USER = @"user";

@implementation SessionCache
+ (SessionCache *)manager
{
    static SessionCache *manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [SessionCache new];
        manager.cachedData = [NSMutableDictionary new];
    });
    
    return manager;
}
#pragma mark - Storing
- (void)cacheUser:(User *)user
{
    self.cachedData[USER] = user;
}

#pragma mark - Retrieving
- (User *)cachedUser
{
    return self.cachedData[USER];
}
@end
