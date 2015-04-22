//
//  ContactViewController.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/13/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "ContactViewController.h"
#import "CallingViewController.h"
#import "UserAvatar.h"
#import "UIButton+Bootstrap.h"
#import "User.h"
#import "MessagingViewController.h"

@interface ContactViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnCall;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblSelectedUserName;
@property (weak, nonatomic) IBOutlet UserAvatar *imgUserProfile;
@property (strong, nonatomic) AppDelegate *delegate;
@property (strong, nonatomic) id<SINCall> sinchCall;
@end

@implementation ContactViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.btnCall primaryStyle];
    [self.btnMessage primaryStyle];

    User *curUser = [[SessionCache manager] cachedUser];
    self.lblUserName.text = curUser.userName;
    self.lblSelectedUserName.text = self.selectedUser.userName;
    self.imgUserProfile.image = curUser.userProfileImage;
}

#pragma mark - Contact User
- (IBAction)startChat:(id)sender
{
    [self performSegueWithIdentifier:@"Messaging" sender:self];
}

- (IBAction)startCall:(id)sender
{
    [self performSegueWithIdentifier:@"Call" sender:self];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"Messaging"])
    {
        MessagingViewController *messagingVC = (MessagingViewController *)segue.destinationViewController;
        messagingVC.selectedUser = self.selectedUser;
    }
    else
    {
        CallingViewController *callVC = (CallingViewController *)segue.destinationViewController;
        callVC.selectedUser = self.selectedUser;
    }
}


@end
