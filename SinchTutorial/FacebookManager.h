//
//  FacebookManager.h
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/12/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//
@class User;
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookManager : NSObject
+ (NSArray *)desiredUserPermissions;
+ (void)getUserProfileImage:(void (^)(NSData *data))completion;
+ (void)getUserInfo:(void(^)(User *user))completion;
@end
