//
//  TextInsetLabel.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/31/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "TextInsetLabel.h"

@implementation TextInsetLabel

- (void)drawTextInRect:(CGRect)rect
{
    UIEdgeInsets insets = {0, 5, 0, 5};
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
}

@end
