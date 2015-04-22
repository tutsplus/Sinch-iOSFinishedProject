//
//  AccountViewControllerViewController.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/9/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "AccountViewController.h"
#import "UserAvatar.h"
#import "UIButton+Bootstrap.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>

@interface AccountViewController () <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnInbox;
@property (weak, nonatomic) IBOutlet FBLoginView *vwFBLogIn;
@property (weak, nonatomic) IBOutlet UIImageView *imgBackground;
@property (weak, nonatomic) IBOutlet UserAvatar *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblLoggedInAs;
@end

@implementation AccountViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    User *curUser = [[SessionCache manager] cachedUser];
    self.lblLoggedInAs.text = curUser.userName;
    self.imgAvatar.image = curUser.userProfileImage;
    [self.btnInbox primaryStyle];
}

- (IBAction)goToInbox:(UIButton *)sender
{
    //TODO: Maybe do this?
}

#pragma mark - Facebook Delegate
// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Username"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"ToSignIn" sender:self];
    });
}
@end
