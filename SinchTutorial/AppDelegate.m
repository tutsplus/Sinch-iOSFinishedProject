//
//  AppDelegate.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/9/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "SessionCache.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    [AppearanceManager setAppWideThemeForControls];
    [FBLoginView class];
    
    //DEBUG CODE - set this to YES if you want to clear Facebook's token information to force a login.
    BOOL debugging = NO;
    
    if(debugging)
    {
        [[FBSession new] closeAndClearTokenInformation];
    }
    //END DEBUG CODE

    
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded)
    {
        // If there's one, just open the session silently
        [FBSession openActiveSessionWithReadPermissions:[FacebookManager desiredUserPermissions]
                                           allowLoginUI:NO
                                      completionHandler:nil];
        
    }
    
    return YES;
}

#pragma mark - Sinch
- (void)sinchClientWithUserId:(NSString *)userId
{
    if (!_client)
    {
        _client = [Sinch clientWithApplicationKey:@"c94e1876-2a60-4168-b068-20e982af0cb8"
                                applicationSecret:@"zuxYbgF8OkOVHREnwccnDQ=="
                                  environmentHost:@"sandbox.sinch.com"
                                           userId:userId];
        _client.delegate = self;
        
        [_client setSupportCalling:YES];
        [_client setSupportMessaging:YES];
        [_client start];
        [_client startListeningOnActiveConnection];
    }
}

- (void)clientDidStart:(id<SINClient>)client
{
    NSLog(@"Sinch client started successfully (version: %@)", [Sinch version]);
}

- (void)clientDidFail:(id<SINClient>)client error:(NSError *)error
{
    NSLog(@"Sinch client error: %@", [error localizedDescription]);
}

- (void)client:(id<SINClient>)client logMessage:(NSString *)message area:(NSString *)area severity:(SINLogSeverity)severity timestamp:(NSDate *)timestamp
{
    if (severity == SINLogSeverityCritical)
    {
        NSLog(@"%@", message);
    }
}

#pragma mark - Facebook
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([[url scheme] hasPrefix:@"fb"])
    {
        return [FBSession.activeSession handleOpenURL:url];
    }
    else
    {
        return NO;
    }
}
@end
