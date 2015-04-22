//
//  FindUsersViewController.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/9/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//
#import "FindUsersViewController.h"
#import "ContactViewController.h"
#import "User.h"
#import "MBProgressHUD.h"

@interface FindUsersViewController ()  <UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtFieldMeters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *users;
@property (strong, nonatomic) MBProgressHUD *indicatorView;
@property (strong, nonatomic) User *curUser;
@property (strong, nonatomic) UITapGestureRecognizer *tapToResignTextField;
@end

NSString * const CELL_ID = @"CELLID";

@implementation FindUsersViewController

#pragma mark - Lazy Loaded Properties
- (NSMutableArray *)users
{
    if(!_users)
    {
        _users = [NSMutableArray new];
    }
    
    return _users;
}

- (MBProgressHUD *)indicatorView
{
    if(!_indicatorView)
    {
        _indicatorView = [[MBProgressHUD alloc] initWithView:self.view.window];
        _indicatorView.dimBackground = YES;
        _indicatorView.removeFromSuperViewOnHide = YES;
    }
    
    return _indicatorView;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 44.0f;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //Start a session
    if (![SessionCache manager].token && FBSession.activeSession.state == FBSessionStateOpen)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [FacebookManager getUserInfo:^(User *curUser){
            self.curUser = curUser;
            
            //Start a session
            [self beginUserSession];
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

#pragma mark - Textfield Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(!self.tapToResignTextField)
    {
        //Dismiss the textview
        self.tapToResignTextField = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
        [self.view addGestureRecognizer:self.tapToResignTextField];
    }
    textField.keyboardType = UIKeyboardTypeNumberPad;
}

- (void)dismissKeyboard
{
    [self.txtFieldMeters resignFirstResponder];
    [self.view removeGestureRecognizer:self.tapToResignTextField];
    self.tapToResignTextField = nil;
}

#pragma mark - Tableview delegate/datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CELL_ID];
    
    if (self.users.count > indexPath.row)
    {
        cell.textLabel.text = [(User *)self.users[indexPath.row] userName];
        cell.detailTextLabel.text = [(User *)self.users[indexPath.row] locationText];
    }
    
    return cell;
}

#pragma mark Data Retrieval
- (void)beginUserSession
{
    [[UsersAPIClient sharedManager] beginUserSession:self.curUser completion:^{
        [[SessionCache manager] cacheUser:self.curUser];
        
        //Init sinch client
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [delegate sinchClientWithUserId:self.curUser.userID];
        
        //We've got an access token, now get the rest of the users
        [self getUsersAndReloadTableView];
    }];
}

- (void)getUsersAndReloadTableView
{
    //Get the users
    [[UsersAPIClient sharedManager] getRegisteredUsersWithMeters:self.txtFieldMeters.text.doubleValue completion:^(NSArray *users){
        self.users = [[users sortedArrayWithOptions:0 usingComparator:^NSComparisonResult(User *obj1, User *obj2){
            return [obj1.userName compare:obj2.userName options:NSCaseInsensitiveSearch];
        }] mutableCopy];
        
        //Logged in user will show up if you don't specify meters
        NSUInteger idxOfCurUser = -1;
        for (User *aUser in self.users)
        {
            if ([aUser.userID isEqualToString:self.curUser.userID])
            {
                idxOfCurUser = [self.users indexOfObject:aUser];
                break;
            }
        }
        if (idxOfCurUser != -1) [self.users removeObjectAtIndex:idxOfCurUser];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView reloadData];
    }];
    
}

- (IBAction)refreshNearbyUsers:(id)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self getUsersAndReloadTableView];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Contact"])
    {
        ContactViewController *contactVC = (ContactViewController *)segue.destinationViewController;
        contactVC.selectedUser = self.users[[self.tableView indexPathForSelectedRow].row];
    }
}
@end
