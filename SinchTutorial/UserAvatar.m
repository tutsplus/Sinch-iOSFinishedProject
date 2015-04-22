//
//  UserAvatar.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/13/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "UserAvatar.h"
#import "UIColor+Utils.h"
@implementation UserAvatar

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.layer.cornerRadius = 64;
        self.layer.borderColor = [UIColor colorFromHexString:@"BE90D4"].CGColor;
        self.layer.borderWidth = 3;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

@end
