//
//  RecipientTableViewCell.m
//  SinchTutorial
//
//  Created by Jordan Morgan on 3/31/15.
//  Copyright (c) 2015 Jordan Morgan. All rights reserved.
//

#import "RecipientTableViewCell.h"
#import "TextInsetLabel.h"

@implementation RecipientTableViewCell

- (void)awakeFromNib
{
    // Initialization code
    self.message.layer.cornerRadius = 4.0f;
    self.message.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
