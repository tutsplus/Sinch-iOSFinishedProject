//
//  User.h
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/18/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) NSString *userName;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *locationText;
@property (strong, nonatomic) CLLocation *userLocation;
//Not kept on the server
@property (strong, nonatomic) UIImage *userProfileImage;

- (instancetype)initFromFacebookJSON:(NSDictionary *)data;
- (instancetype)initFromServerJSON:(NSDictionary *)data;
@end
