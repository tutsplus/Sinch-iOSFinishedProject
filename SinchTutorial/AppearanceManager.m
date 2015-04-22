//
//  AppearanceManager.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/12/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "AppearanceManager.h"
#import "UIColor+Utils.h"

@implementation AppearanceManager
+ (void)setAppWideThemeForControls
{
    //Global tint
    UIColor *tintColor = [UIColor colorFromHexString:@"63029C"];
    
    NSDictionary *textAttributes = @{NSFontAttributeName :[UIFont fontWithName:@"Avenir" size:16.0f], NSForegroundColorAttributeName :[UIColor whiteColor]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    [[UINavigationBar appearance] setBarTintColor:tintColor];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[[[UIApplication sharedApplication] delegate] window] setTintColor:tintColor];
    //Back buttons too
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
}
@end
