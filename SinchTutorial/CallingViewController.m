//
//  CallingViewController.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 4/11/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "CallingViewController.h"
#import "User.h"
#import "UIButton+Bootstrap.h"
#import <Sinch/Sinch.h>

@interface CallingViewController () <SINCallClientDelegate, SINCallDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblCallWith;
@property (weak, nonatomic) IBOutlet UILabel *lblCallStatus;
@property (weak, nonatomic) IBOutlet UIButton *btnAcceptOrCall;
@property (weak, nonatomic) IBOutlet UIButton *btnDeny;
@property (strong, nonatomic) id<SINCall> sinchCall;
@property (strong, nonatomic) AppDelegate *delegate;
@end

@implementation CallingViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //Assign this VC as Sinch's call delegate
    self.delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.delegate.client.callClient.delegate = self;
    
    //Set our button styles
    [self.btnAcceptOrCall successStyle];
    [self.btnDeny dangerStyle];
    
    //Set the Calling With label
    self.lblCallWith.text = [NSString stringWithFormat:@"%@ %@.", self.lblCallWith.text, self.selectedUser.userName];
}

#pragma mark - Initiate or Accept Call
- (IBAction)makeOAccepetCallFromSelectedUser:(UIButton *)sender
{
    if ([sender.titleLabel.text isEqualToString:@"Call"])
    {
        self.sinchCall = [self.delegate.client.callClient callUserWithId:self.selectedUser.userID];
        self.sinchCall.delegate = self;
        self.lblCallStatus.text = [NSString stringWithFormat:@"- calling %@ -", self.selectedUser.userName];
    }
    else
    {
        [self.sinchCall answer];
        self.lblCallStatus.text = [NSString stringWithFormat:@"- talking to %@ -", self.selectedUser.userName];
        [self.btnDeny setTitle:@"End" forState:UIControlStateNormal];
    }
}

#pragma mark - Deny or Hang Up Call
- (IBAction)rejectOrHangUpCallFromSelectedUser:(UIButton *)sender
{
    [self.sinchCall hangup];
    self.lblCallStatus.text = [NSString stringWithFormat:@"- call with %@ ended -", self.selectedUser.userName];
}


#pragma mark - SINCall/Client
- (void)client:(id<SINCallClient>)client didReceiveIncomingCall:(id<SINCall>)call
{
    self.sinchCall = call;
    self.sinchCall.delegate = self;
    self.lblCallStatus.text = [NSString stringWithFormat:@"- incoming call from %@ -", self.selectedUser.userName];
    [self.btnAcceptOrCall setTitle:@"Accept Call" forState:UIControlStateNormal];
    self.btnDeny.hidden = NO;
}

- (void)callDidEstablish:(id<SINCall>)call
{
    NSLog(@"Call connected.");
    self.btnDeny.hidden = NO;
    [self.btnDeny setTitle:@"Hang Up" forState:UIControlStateNormal];
    self.lblCallStatus.text = @"- call connected -";
    self.btnAcceptOrCall.hidden = YES;
}

- (void)callDidEnd:(id<SINCall>)call
{
    NSLog(@"Call finished");
    self.sinchCall = nil;
    self.lblCallStatus.text = @"- call ended -";
    self.btnDeny.hidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

- (void)callDidProgress:(id<SINCall>)call
{
    // In this method you can play ringing tone and update ui to display progress of call.
}
@end
