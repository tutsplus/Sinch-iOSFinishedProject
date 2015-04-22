//
//  SinchTutTabBarViewController.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/11/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "SinchTutTabBarViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface SinchTutTabBarViewController ()

@end

@implementation SinchTutTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkForUserSession];
}

#pragma mark - Check Session
- (void)checkForUserSession
{
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state != FBSessionStateOpen)
    {
        //User needs to log in
        [self performSegueWithIdentifier:@"SignIn" sender:nil];
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //doNothing();
}

- (IBAction)unwindToTabBar:(UIStoryboardSegue *)unwindSegue
{
    
}

@end
