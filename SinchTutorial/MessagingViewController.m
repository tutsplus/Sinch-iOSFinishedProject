//
//  MessagingViewController.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/31/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "MessagingViewController.h"
#import "UsersTableViewCell.h"
#import "RecipientTableViewCell.h"
#import "TextInsetLabel.h"
#import "User.h"
#import <Sinch/Sinch.h>

typedef NS_ENUM(int, MessageDirection)
{
    Incoming,
    Outgoing
};

@interface MessagingViewController () <UITableViewDataSource, UITableViewDataSource, UITextFieldDelegate, SINMessageClientDelegate>
@property (strong, nonatomic) NSMutableArray *messages;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMessage;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messagingBottomConstraint;
@property (strong, nonatomic) id<SINMessageClient> sinchMessageClient;
@end

static NSString * CELL_ID_RECIPIENT = @"RecipientCell";
static NSString * CELL_ID_USER = @"UserCell";

@implementation MessagingViewController

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Init our array to hold chat messages
    self.messages = [NSMutableArray new];
    
    //Tableview Setup
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 66.0f;
    
    //Textfield Setup
    [self textFieldSetup];
    
    //Setup Sinch message client
    self.sinchMessageClient = [((AppDelegate *)[[UIApplication sharedApplication] delegate]).client messageClient];
    self.sinchMessageClient.delegate = self;
}

#pragma mark - Textfield Delegate & Helpers
- (void)textFieldSetup
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UITapGestureRecognizer *tap;
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

- (void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyboardFrameEnd = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.messagingBottomConstraint.constant = keyboardFrameEnd.size.height - 48;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
    
    [self scrollToBottom];
}

- (void)keyboardWillBeHidden:(NSNotification *)note
{
    self.messagingBottomConstraint.constant = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
 
}

- (void)dismissKeyboard
{
    [self.messageTextField resignFirstResponder];
    [self scrollToBottom];
}

- (void)scrollToBottom
{
    //Scroll to bottom
    if (self.messages.count > 0)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.messages.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Table View Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return self.messages.count;
    return self.messages.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    id<SINMessage> message = [self.messages[indexPath.row] firstObject];
    MessageDirection direction = (MessageDirection)[[self.messages[indexPath.row] lastObject] intValue];
    
    if (direction == Incoming)
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_ID_RECIPIENT];
        ((RecipientTableViewCell *)cell).message.text = message.text;
    }
    else
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_ID_USER];
        ((UsersTableViewCell *)cell).message.text = message.text;
    }
    
    return cell;
}

#pragma mark - Sending Message
- (IBAction)sendMessage:(id)sender
{
    [self dismissKeyboard];
    SINOutgoingMessage *outgoingMessage = [SINOutgoingMessage messageWithRecipient:self.selectedUser.userID text:self.messageTextField.text];
    [self.sinchMessageClient sendMessage:outgoingMessage];
}

#pragma mark SINMessageClient
// Receiving an incoming message.
- (void)messageClient:(id<SINMessageClient>)messageClient didReceiveIncomingMessage:(id<SINMessage>)message
{
    NSLog(@"Received a message");
    [self.messages addObject:@[message, @(Incoming)]];
    [self.tableView reloadData];
}

// Finish sending a message
- (void)messageSent:(id<SINMessage>)message recipientId:(NSString *)recipientId
{
    NSLog(@"Finished sending a message");
    self.messageTextField.text = @"";
    [self.messages addObject:@[message, @(Outgoing)]];
    [self.tableView reloadData];
}

// Failed to send a message
- (void)messageFailed:(id<SINMessage>)message info:(id<SINMessageFailureInfo>)messageFailureInfo
{
    NSLog(@"Failed to send a message:%@", messageFailureInfo.error.localizedDescription);
}

-(void)messageDelivered:(id<SINMessageDeliveryInfo>)info
{
    NSLog(@"Message was delivered");
}

- (void)message:(id<SINMessage>)message shouldSendPushNotifications:(NSArray *)pushPairs
{
    NSLog(@"Recipient not online.\nShould notify recipient using push (not implemented in this tutorial).\nPlease refer to the documentation.");
}
@end
