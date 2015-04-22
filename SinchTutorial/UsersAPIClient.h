//
//  UsersAPIClient.h
//  SinchTutorial
//
//  Created by Jordan Morgan on 4/2/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "AFHTTPSessionManager.h"
@class User;

@interface UsersAPIClient : AFHTTPSessionManager
+ (UsersAPIClient *)sharedManager;
- (void)createUser:(User *)user completion:(void (^)())action;
- (void)beginUserSession:(User *)user completion:(void (^)())action;
- (void)deleteUser:(User *)user completion:(void (^)())action;
- (void)getRegisteredUsersWithMeters:(double)meters completion:(void (^)(NSArray *users))action;
@end
