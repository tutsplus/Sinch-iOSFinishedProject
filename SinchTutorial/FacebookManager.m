//
//  FacebookManager.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/12/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//
#import "AppDelegate.h"
#import "FacebookManager.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookManager ()

@end

@implementation FacebookManager

+ (NSArray *)desiredUserPermissions
{
    return @[@"public_profile", @"email",@"user_location"];
}

+ (void)getUserProfileImage:(void (^)(NSData *))completion
{
    NSDictionary *params = @{
                             @"redirect": @NO,
                             @"height": @200,
                             @"width": @200,
                             @"type": @"normal",
                             };
    
    //Contact Facebook API
    [FBRequestConnection startWithGraphPath:@"/me/picture" parameters:params HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
        
        if(!error)
        {
            NSDictionary *dict = (NSDictionary*)result;
            NSURL *url = [NSURL URLWithString:dict[@"data"][@"url"]];
            NSData *data = [NSData dataWithContentsOfURL:url];
            if (completion)completion(data);
        }
        
    }];
}

+ (void)getUserInfo:(void(^)(User *user))completion;
{
    if (FBSession.activeSession.isOpen)
    {
        [FBRequestConnection startWithGraphPath:@"/me" parameters:nil HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error){
            
            if(!error)
            {
                User *curUser = [[User alloc] initFromFacebookJSON:(NSDictionary *)result];
                if (completion) completion(curUser);
            }
            else
            {
                NSLog(@"ERROR: Attempted to get user info from Facebook and an error occured:%@.", error.localizedDescription);
            }
            
        }];
    }
    else
    {
        NSLog(@"ERROR: Attempted to get user info from Facebook when a session was not active.");
    }
}
@end
