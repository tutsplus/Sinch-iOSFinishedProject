//
//  LoginViewController.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/9/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "LoginViewController.h"
#import "User.h"
#import <FacebookSDK/FacebookSDK.h>
#import <CoreLocation/CoreLocation.h>

@interface LoginViewController () <FBLoginViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *vwFBLogIn;
@property (weak, nonatomic) IBOutlet UILabel *lblLogin;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *userLocation;

@end

@implementation LoginViewController

#pragma mark - Lazy Loaded Props
- (CLLocationManager *)locationManager
{
    if(!_locationManager)
    {
        _locationManager = [CLLocationManager new];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
        _locationManager.distanceFilter = 1609; //One mile
        _locationManager.delegate = self;
    }
    
    return _locationManager;
}

#pragma mark - View Lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //Facebook delegate
    self.vwFBLogIn.delegate = self;
    self.vwFBLogIn.readPermissions = [FacebookManager desiredUserPermissions];

    //Request location
    if ([CLLocationManager locationServicesEnabled])
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
    }
}

#pragma mark - CLLocation Delegate
//Check to see if they denied location services
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Failed to get location:\n\n%@", error.localizedDescription);
}

//Actual update of the location
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    //Store user location
    self.userLocation = newLocation;
}

#pragma mark - User Caching/API
- (void)registerUser:(User *)curUser
{
    //Contact API to add user
    [[UsersAPIClient sharedManager] createUser:curUser completion:^{
        // Delay execution for 2 seconds before heading back to tab bar
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self performSegueWithIdentifier:@"ToTabBar" sender:nil];
        });
    }];
}

#pragma mark - Facebook Login Info
// Called when user information has been fetched
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    self.lblLogin.text = [NSString stringWithFormat:@"%@ logged in succesfully!",user.name];
    self.vwFBLogIn.alpha = 0.5f;
    self.vwFBLogIn.userInteractionEnabled = NO;
    
    User *curUser = [[User alloc] initFromFacebookJSON:(NSDictionary *)user];
    curUser.userLocation = self.userLocation;
    
    //Store locally
    [[SessionCache manager] cacheUser:curUser];
    
    //Store user on the server
    [self registerUser:curUser];
}

// Logged-in user experience
- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    self.lblLogin.text = @"You're logged in!";
}

// Logged-out user experience
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
   
    self.lblLogin.text= @"Login to continue!";
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    NSString *alertMessage, *alertTitle;
    
    // If the user performs an action outside of you app to recover,
    // the SDK provides a message, you just need to surface it.
    // This handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error])
    {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
    {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
    {
        NSLog(@"user cancelled login");
    }
    else
    {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }

    if (alertMessage)
    {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                message:alertMessage
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //Going to the main view controller, which is the tab bar
}


@end
