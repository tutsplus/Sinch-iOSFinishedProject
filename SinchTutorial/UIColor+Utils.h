//
//  UIColor+Utils.h
//  HaloTimer
//
//  Created by Jordan Morgan on 1/6/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Utils)
/** Returns an instance of a UIColor whose RGB values are set from a hexidecimal string. */
+ (instancetype)colorFromHexString:(NSString *)hexString;
/** Default background color */
+ (instancetype)defaultPrimaryColor;
@end