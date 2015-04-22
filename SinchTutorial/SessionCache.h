//
//  SessionCache.h
//  SinchTutorial
//
//  Created by Jordan Morgan on 4/2/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class User;

@interface SessionCache : NSObject
@property (strong, nonatomic) NSMutableDictionary *cachedData;
@property (strong, nonatomic) NSString *token;

+ (SessionCache *)manager;

//Storing
- (void)cacheUser:(User *)user;
//Retreiving
- (User *)cachedUser;
@end
