//
//  User.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/18/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initFromFacebookJSON:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.userID = data[@"id"];
        self.userName = data[@"name"];
        self.email = data[@"email"];
        self.gender = data[@"gender"];
        self.locationText = data[@"location"][@"name"];
    }
    
    return self;
}

- (instancetype)initFromServerJSON:(NSDictionary *)data
{
    self = [super init];
    
    if (self)
    {
        self.userID = data[@"_id"][@"$id"];
        self.userName = data[@"name"];
        self.email = data[@"email"];
        self.gender = data[@"gender"];
        
        CLLocationDegrees lat = ((NSString *)data[@"location"][@"coordinates"][0]).doubleValue;
        CLLocationDegrees lon = ((NSString *)data[@"location"][@"coordinates"][1]).doubleValue;
        CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lon];
        self.userLocation = location;
        //Locationtext is optional
        if(data[@"locationText"] != [NSNull null]) self.locationText = data[@"locationText"];
    }
    
    return self;
}

@end
