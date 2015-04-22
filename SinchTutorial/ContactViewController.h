//
//  ContactViewController.h
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/13/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class User;

@interface ContactViewController : UIViewController
@property (strong, nonatomic) User *selectedUser;
@end
