//
//  UsersAPIClient.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 4/2/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "UsersAPIClient.h"
#import "User.h"
#import "SessionCache.h"
#import "SBJson4Writer.h"

static NSString * const baseURL = @"http://mobilesinch.bitslice.net/";

@implementation UsersAPIClient

#pragma mark - Initializers
+ (UsersAPIClient *)sharedManager
{
    static UsersAPIClient *client = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        client = [[self alloc] initWithBaseURL:[NSURL URLWithString:baseURL]];
    });
    
    return client;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (self)
    {
        self.responseSerializer = [AFJSONResponseSerializer serializer];
        self.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    
    return self;
}

#pragma mark - End Points
- (void)createUser:(User *)user completion:(void (^)())action
{
    //Start a session and get a token
    [self POST:@"users" parameters:[self getUserJSONParams:user] success:^(NSURLSessionDataTask *task, id response){
        if (action)action();
        NSLog(@"User added successfully.");
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        if (action)action();
        NSLog(@"ERROR: An error occured adding a user:%@", error.localizedDescription);
    }];

}

- (void)beginUserSession:(User *)user completion:(void (^)())action
{
    //Start a session and get a token
    [self POST:@"sessions" parameters:[self getUserJSONParams:user] success:^(NSURLSessionDataTask *task, id response){
        NSDictionary *data = (NSDictionary *)response;
        [SessionCache manager].token = data[@"token"];
        
        //Also need their profile picture
        [FacebookManager getUserProfileImage:^(NSData *data){
            user.userProfileImage = data ? [[UIImage alloc] initWithData:data] : [UIImage imageNamed:@"NoAvatar"];
        }];
        
        user.userID  = data[@"user_id"];
        
        if (action)action();
        NSLog(@"User session started successfully.");
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        if (action)action();
        NSLog(@"ERROR: An error occured while beginning a user session:%@", error.localizedDescription);
    }];
}

- (void)deleteUser:(User *)user completion:(void (^)())action
{
    [self DELETE:[NSString stringWithFormat:@"users/%@", user.userID] parameters:@{@"token":[SessionCache manager].token} success:^(NSURLSessionDataTask *task, id response){
        if (action)action();
        NSLog(@"User deleted successfully.");
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        if (action)action();
        NSLog(@"ERROR: An error occured while deleting a user:%@", error.localizedDescription);
    }];
}

- (void)getRegisteredUsersWithMeters:(double)meters completion:(void (^)(NSArray *users))action
{
    //If meters were supplied, send them. If not, get everyone.
    NSDictionary *params;
    if(meters > 0)
    {
        params = @{@"distance":[NSNumber numberWithDouble:meters], @"token":[SessionCache manager].token};
    }
    
    [self GET:@"users" parameters:params success:^(NSURLSessionDataTask *task, id response){
        //Get all the users
        NSDictionary *users = (NSDictionary *)response;
        NSMutableArray *usersArray = [NSMutableArray new];
        
        for (NSDictionary *userInfo in users)
        {
            User *aUser = [[User alloc] initFromServerJSON:userInfo];
            [usersArray addObject:aUser];
        }
        
        if (action) action(usersArray);
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"ERROR: An error occured while retrieving users:%@", error.localizedDescription);
    }];
}

#pragma mark - Utility Methods
- (NSDictionary *)getUserJSONParams:(User *)user
{
    //Location must be sent as a JSON string and not an object
    NSString *latitude = [[NSNumber numberWithDouble:user.userLocation.coordinate.latitude] stringValue];
    NSString *longitude = [[NSNumber numberWithDouble:user.userLocation.coordinate.latitude] stringValue];
    id location = [NSDictionary dictionaryWithObjectsAndKeys:latitude,@"lat",longitude,@"lon", nil];
    SBJson4Writer *jsonWriter = [SBJson4Writer new];
    NSString *locationString = [jsonWriter stringWithObject:location];
    
    //Add the params (currently Facebook SDK doesn't support phone # permissions - left param in if that changes)
    return  @{@"email":user.email, @"fbId":user.userID, @"gender": user.gender, @"location":locationString, @"mobile": @"", @"name":user.userName, @"locationText": (user.locationText.length > 0 ? user.locationText : @"")};
}
@end
